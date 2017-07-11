
#include <stdio.h>
#include "func_trace.h"

int main(int argc, char const *argv[])
{
    (void)argc; (void)argv;

    EN_FUNCTION_TRACE;
	printf("hello, world\n");
	return 0;
}
