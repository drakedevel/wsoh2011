#include <err.h>

#include "jsapi.h"
#include "jsscript.h"
#include "jscompartment.h"

using namespace js;

struct FunctionInfo {
    FunctionInfo(JSContext *cx) : cx(cx), insnMap(cx), insns(cx) { }
    FunctionInfo(const FunctionInfo &other) : cx(other.cx), insnMap(other.cx), insns(other.cx) { /* XXX No copying here! */ }
    JSContext *cx;
    Vector<jsbytecode *, 0, TempAllocPolicy> insnMap;
    Vector<jsbytecode *, 0, TempAllocPolicy> insns;
};

static JSClass dummy_class = {
    "jdummy",
    JSCLASS_GLOBAL_FLAGS,
    JS_PropertyStub,  JS_PropertyStub,
    JS_PropertyStub,  JS_StrictPropertyStub,
    JS_EnumerateStub, JS_ResolveStub,
    JS_ConvertStub,   NULL,
    JSCLASS_NO_OPTIONAL_MEMBERS
};

JSBool Subsume(JSPrincipals *a, JSPrincipals *b)
{
    return JS_TRUE;
}

JSPrincipals trustedPrincipals = {
    (char *)"a",
    NULL,
    NULL,
    1,
    NULL,
    Subsume
};

static void ProcessFunction(FunctionInfo &fun, JSScript *s)
{
    // Populate maps
    for (jsbytecode *pc = s->code; pc != s->code + s->length; ) {
        if (js_CodeSpec[*pc].length == -1)
            errx(1, "Found variable length op, aborting");
        if (!fun.insns.append(pc) || !fun.insnMap.append(pc))
            errx(1, "OOM");
        for (size_t i = 1; i < js_CodeSpec[*pc].length; i++) {
            if (!fun.insnMap.append(NULL))
                errx(1, "OOM");
        }
        pc += js_CodeSpec[*pc].length;
    }

    // Emit instructions
    for (jsbytecode *pc = s->code; pc != s->code + s->length; ) {
        printf("%02x", *pc);
        switch (js_CodeSpec[*pc].format & JOF_TYPEMASK) {
        case JOF_BYTE:
            switch (*pc) {
            case JSOP_ZERO:
            case JSOP_FALSE:
                printf("0100000000\n");
                break;

            case JSOP_ONE:
            case JSOP_TRUE:
                printf("0100000001\n");
                break;

            case JSOP_PUSH:
            case JSOP_VOID:
            case JSOP_NULL:
            default:
                printf("0000000000\n");
                break;
            }
            break;
        case JOF_JUMP: 
            errx(2, "Jump op");
            break;
        case JOF_ATOM:
            errx(2, "Atoms are not supported.");
            break;
        case JOF_INT8:
            printf("01%08x\n", (int)(*(signed char *)(pc + 1)));
            break;
        case JOF_UINT16:
            errx(2, "16-bit immediates are not supported.");
            break;
        case JOF_QARG:
            errx(2, "Argument op");
            break;
        case JOF_OBJECT:
            errx(2, "Objects are not supported.");
            break;
        default:
            errx(2, "Unknown opcode format encountered: %d", js_CodeSpec[*pc].format & JOF_TYPEMASK);
        }

        pc += js_CodeSpec[*pc].length;
    }
}

int main(int argc, char **argv)
{
    if (argc < 2)
        errx(1, "Usage: compile <script>");

    JSRuntime *runtime = JS_NewRuntime(160 * 1024 * 1024);
    if (!runtime)
        errx(1, "Failed to create runtime");

    JS_SetTrustedPrincipals(runtime, &trustedPrincipals);

    JSContext *cx = JS_NewContext(runtime, 8192);
    if (!cx)
        errx(1, "Failed to create context");

    JSObject *global = JS_NewCompartmentAndGlobalObject(cx, &dummy_class, NULL);
    if (!global)
        errx(1, "Failed to create global object");

    JSAutoEnterCompartment ac;
    if (!ac.enter(cx,global))
        errx(1, "Failed to enter compartment");

    JSObject *scriptObj = JS_CompileFile(cx, global, argv[1]);
    if (!scriptObj)
        errx(1, "Failed to compile script");
    JSScript *script = scriptObj->getScript();


    Vector<FunctionInfo, 0, SystemAllocPolicy> functions;
    if (!functions.append(FunctionInfo(cx)))
        errx(1, "OOM");
    ProcessFunction(functions.back(), script);
    /*
    for (size_t i = 0; i < script->objects()->length; i++) {
        JSObject *o = script->objects()->vector[i];
        if (o->isFunction()) {
            JSFunction *fun = (JSFunction *)o;
            if (fun->isInterpreted()) {
                if (!functions.append(FunctionInfo(cx)))
                    errx(1, "OOM");
                ProcessFunction(functions.back(), fun->script());
            }
        }
    }
    */

    return 0;
}
