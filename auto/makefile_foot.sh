#!/bin/bash
FILE=${GLOBAL_OBJS_DIR}/${GLOBAL_MAKEFILE}
cat << END >> ${GLOBAL_OBJS_DIR}/${GLOBAL_MAKEFILE}

-include \$(ALL_DEPS)

${GLOBAL_OBJS_DIR}/%.o: %.\$(SRC_EXT)
	@echo "Compiling: \$< -> \$@"
	\$(CMD_PREFIX)\$(CC) \$(CFLAGS) \$(ALL_INCLUDES) -MP -MMD -c \$< -o \$@


${GLOBAL_OBJS_DIR}/%.o: %.\$(CXX_SRC_EXT)
	@echo "Compiling: \$< -> \$@"
	\$(CMD_PREFIX)\$(CXX) \$(CXXFLAGS) \$(ALL_INCLUDES) -MP -MMD -c \$< -o \$@

END

