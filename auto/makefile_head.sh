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
LIBS =
# General compiler flags
COMPILE_FLAGS = -std=c99 -Wall -Wextra -g
CXX_COMPILE_FLAGS = -std=c++11 -Wall -Wextra -g
# Additional release-specific flags
RCOMPILE_FLAGS = -D NDEBUG
# Additional debug-specific flags
DCOMPILE_FLAGS = -D DEBUG

# General linker settings
LINK_FLAGS =
# Additional release-specific linker settings
RLINK_FLAGS =
# Additional debug-specific linker settings
DLINK_FLAGS =
# Destination directory, like a jail or mounted system
DESTDIR = /
# Install path (bin/ is appended automatically)
INSTALL_PREFIX = usr/local
#### END PROJECT SETTINGS ####


ALL_INCLUDES=
ALL_OBJECTS=
ALL_DEPS=

print-%: ; @echo \$*=\$(\$*)
SHELL = /bin/bash
# Clear built-in rules
.SUFFIXES:

# Append pkg-config specific libraries if need be
ifneq (\$(LIBS),)
	COMPILE_FLAGS += \$(shell pkg-config --cflags \$(LIBS))
	LINK_FLAGS += \$(shell pkg-config --libs \$(LIBS))
endif

export V := false
export CMD_PREFIX := @
ifeq (\$(V),true)
	CMD_PREFIX :=
endif

release: export CFLAGS := \$(CFLAGS) \$(COMPILE_FLAGS) \$(RCOMPILE_FLAGS)
release: export LDFLAGS := \$(LDFLAGS) \$(LINK_FLAGS) \$(RLINK_FLAGS)
release: export CXXFLAGS := \$(CXXFLAGS) \$(CXX_COMPILE_FLAGS) \$(RCOMPILE_FLAGS)

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

.PHONY: release
release: dirs
ifeq (\$(USE_VERSION), true)
	@echo "Beginning release build v\$(VERSION_STRING)"
else
	@echo "Beginning release build"
endif
	@\$(START_TIME)
	@\$(MAKE) all --no-print-directory
	@echo -n "Total build time: "
	@\$(END_TIME)
.PHONY: dirs
dirs:
	@echo "Creating directories"
	@mkdir -p \$(dir \$(ALL_OBJECTS))
.PHONY: clean
clean:
	@echo "Deleting directories"
	@\$(RM) -r ${GLOBAL_OBJS_DIR}

END

