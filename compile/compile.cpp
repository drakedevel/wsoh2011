#include <err.h>

#include "jsapi.h"
#include "jsscript.h"
#include "jscompartment.h"

using namespace js;

struct FunctionInfo {
    FunctionInfo(){}
    FunctionInfo(const FunctionInfo& other) : atom(other.atom), script(other.script) {
        for (jsbytecode **i = other.insnMap.begin(); i != other.insnMap.end(); i++)
            JS_ASSERT(insnMap.append(*i));
        for (jsbytecode **i = other.insns.begin(); i != other.insns.end(); i++)
            JS_ASSERT(insns.append(*i));
    }
    JSAtom *atom;
    JSScript *script;
    Vector<jsbytecode *, 0, SystemAllocPolicy> insnMap;
    Vector<jsbytecode *, 0, SystemAllocPolicy> insns;
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

static uint32 offset = 0;
static FILE *jsopFile;
static FILE *funtabFile;

static Vector<FunctionInfo, 0, SystemAllocPolicy> functions;

static void PreprocessFunction(JSContext *cx, FunctionInfo &fun, JSFunction *jsfun, JSScript *s)
{
    // Populate maps
    for (jsbytecode *pc = s->code; pc != s->code + s->length; ) {
        fun.script = s;
        if (jsfun)
            fun.atom = jsfun->atom;
        else
            fun.atom = NULL;
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
}

static void EmitFunction(JSContext *cx, FunctionInfo &fun)
{
    // Emit instructions
    JSScript *s = fun.script;
    for (jsbytecode *pc = s->code; pc < s->code + s->length; ) {
        offset++;
        if (*pc == JSOP_DEFFUN)
            goto fuckyou;
        fprintf(jsopFile, "%02x", *pc);
        switch (js_CodeSpec[*pc].format & JOF_TYPEMASK) {
        case JOF_BYTE:
            switch (*pc) {
            case JSOP_ZERO:
            case JSOP_FALSE:
                fprintf(jsopFile, "0100000000\n");
                break;

            case JSOP_ONE:
            case JSOP_TRUE:
                fprintf(jsopFile, "0100000001\n");
                break;

            case JSOP_PUSH:
            case JSOP_VOID:
            case JSOP_NULL:
            default:
                fprintf(jsopFile, "0000000000\n");
                break;
            }
            break;
        case JOF_JUMP: {
            int16_t new_target = 0;
            jsbytecode* target = pc + GET_JUMP_OFFSET(pc);
            if (target > pc)
                for (jsbytecode *i = pc; i < target; i += js_CodeSpec[*i].length, new_target++);
            else
                for (jsbytecode *i = target; i < pc; i += js_CodeSpec[*i].length, new_target--);
            fprintf(jsopFile, "000000%04hx\n", new_target);
            break;
        }
        case JOF_ATOM: {
            if (*pc == JSOP_DOUBLE)
                errx(2, "JSOP_DOUBLE");
            JSAtom *atom;
            GET_ATOM_FROM_BYTECODE(s, pc, 0, atom);
            FunctionInfo *found = NULL;
            for (FunctionInfo *other = functions.begin(); other != functions.end(); other++) {
                if (other->atom == atom) {
                    found = other;
                    break;
                }
            }
            if (!found)
                errx(2, "Unknown (or non-function atom");

            fprintf(jsopFile, "00%08d\n", found - functions.begin());
            break;
        }
        case JOF_INT8:
            fprintf(jsopFile, "01%08x\n", GET_INT8(pc));
            break;
        case JOF_UINT16:
            fprintf(jsopFile, "010000%04x\n", GET_UINT16(pc));
            break;
        case JOF_INT32:
            fprintf(jsopFile, "01%08x\n", GET_INT32(pc));
            break;
        case JOF_UINT24:
            fprintf(jsopFile, "0100%06x\n", GET_UINT24(pc));
            break;
        case JOF_QARG:
            fprintf(jsopFile, "000000%04x\n", GET_ARGNO(pc));
            break;
        case JOF_OBJECT:
            errx(2, "Objects are not supported.");
            break;
        default:
            errx(2, "Unknown opcode (%hhu) format encountered: %d", *pc, js_CodeSpec[*pc].format & JOF_TYPEMASK);
        }
    fuckyou:
        pc += js_CodeSpec[*pc].length;
    }
}

int main(int argc, char **argv)
{
    if (argc < 4)
        errx(1, "Usage: compile <in:script> <out:jsops> <out:offs>");

    jsopFile = fopen(argv[2], "w+");
    if (!jsopFile)
        err(1, "Could not open jsops file");
    funtabFile = fopen(argv[3], "w+");
    if (!funtabFile)
        err(1, "Could not open funtab file");

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

    if (!functions.append(FunctionInfo()))
        errx(1, "OOM");
    PreprocessFunction(cx, functions.back(), NULL, script);
    for (size_t i = 0; i < script->objects()->length; i++) {
        JSObject *o = script->objects()->vector[i];
        if (o->isFunction()) {
            JSFunction *fun = (JSFunction *)o;
            if (fun->isInterpreted()) {
                if (!functions.append(FunctionInfo()))
                    errx(1, "OOM");
                PreprocessFunction(cx, functions.back(), fun, fun->script());
            }
        }
    }

    for (FunctionInfo *f = functions.begin(); f != functions.end(); f++) {
        fprintf(funtabFile, "%08x\n", offset);
        EmitFunction(cx, *f);
    }

    return 0;
}
