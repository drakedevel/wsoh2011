#include <err.h>

#include "jsapi.h"
#include "jsscript.h"
#include "jscompartment.h"

int main(int argc, char **argv)
{
    if (argc < 2)
        errx(1, "Usage: compile <script>");

    JSRuntime *runtime = JS_NewRuntime(16 * 1024 * 1024);
    if (!runtime)
        errx(1, "Failed to create runtime");

    JSContext *cx = JS_NewContext(runtime, 4096);
    if (!cx)
        errx(1, "Failed to create context");

    return 0;
}
