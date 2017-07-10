#!/bin/bash
FILE=${GLOBAL_OBJS_DIR}/${GLOBAL_MAKEFILE}
cat << END > ${GLOBAL_OBJS_DIR}/${GLOBAL_MAKEFILE}

#### PROJECT SETTINGS ####
# The name of the executable to be created
# Compiler use
CC ?= ${CC}
CXX ?= ${CXX}
LINK ?= ${LINK}
AR ?=  ${AR}

# Extension of source files used in the project
SRC_EXT = ${SRC_EXT}
CXX_SRC_EXT = ${CXX_SRC_EXT}

# Space-separated pkg-config libraries used by this project
PKG_CONFIG_LIBS = ${PKG_CONFIG_LIBS}
# General compiler flags
COMPILE_FLAGS = ${COMPILE_FLAGS}
CXX_COMPILE_FLAGS = ${CXX_COMPILE_FLAGS}
# General linker settings
LINK_FLAGS = ${LINK_FLAGS}

ALL_INCLUDES=
ALL_OBJECTS=
ALL_DEPS=

print-%: ; @echo \$*=\$(\$*)
SHELL = /bin/bash
# Clear built-in rules
.SUFFIXES:

# Append pkg-config specific libraries if need be
ifneq (\$(LIBS),)
	COMPILE_FLAGS += \$(shell pkg-config --cflags \$(PKG-CONFIG-LIBS))
	LINK_FLAGS += \$(shell pkg-config --libs \$(PKG-CONFIG-LIBS))
endif

export V := false
export CMD_PREFIX := @
ifeq (\$(V),true)
	CMD_PREFIX :=
endif

export CFLAGS := \$(CFLAGS) \$(COMPILE_FLAGS)
export LDFLAGS := \$(LDFLAGS) \$(LINK_FLAGS)
export CXXFLAGS := \$(CXXFLAGS) \$(CXX_COMPILE_FLAGS)

# Macros for timing compilation
ifeq (\$(UNAME_S),Darwin)
	CUR_TIME = awk 'BEGIN{srand(); print srand()}'
	TIME_FILE = \$(dir \$@).\$(notdir \$@)_time
	START_TIME = \$(CUR_TIME) > \$(TIME_FILE)
	END_TIME = read st < \$(TIME_FILE) ; \\
		\$(RM) \$(TIME_FILE) ; \\
		st=\$\$((\`\$(CUR_TIME)\` - \$\$st)) ; \\
		echo \$\$st
else
	TIME_FILE = \$(dir \$@).\$(notdir \$@)_time
	START_TIME = date '+%s' > \$(TIME_FILE)
	END_TIME = read st < \$(TIME_FILE) ; \\
		\$(RM) \$(TIME_FILE) ; \\
		st=\$\$((\`date '+%s'\` - \$\$st - 86400)) ; \\
		echo \`date -u -d @\$\$st '+%H:%M:%S'\`
endif

.PHONY: dirs
dirs:
	@echo "Creating directories"
	@mkdir -p \$(dir \$(ALL_OBJECTS))
.PHONY: clean
clean:
	@echo "Deleting directories"
	@\$(RM) -r ${GLOBAL_OBJS_DIR}

END

