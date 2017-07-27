
# Obtains the OS type, either 'Darwin' (OS X) or 'Linux'
UNAME_S:=$(shell uname -s)
# Macros for timing compilation
ifeq ($(UNAME_S),Darwin)
	CUR_TIME = awk 'BEGIN{srand(); print srand()}'
	TIME_FILE = $(dir $@).$(notdir $@)_time
	START_TIME = $(CUR_TIME) > $(TIME_FILE)
	END_TIME = read st < $(TIME_FILE) ; \
		$(RM) $(TIME_FILE) ; \
		st=$$((`$(CUR_TIME)` - $$st)) ; \
		echo $$st
else
	TIME_FILE = $(dir $@).$(notdir $@)_time
	START_TIME = date '+%s' > $(TIME_FILE)
	END_TIME = read st < $(TIME_FILE) ; \
		$(RM) $(TIME_FILE) ; \
		st=$$((`date '+%s'` - $$st - 86400)) ; \
		echo `date -u -d @$$st '+%H:%M:%S'`
endif

.PHONY: default help clean defualt_app _prepare_dir

default: defualt_app

help:
	@echo "Usage: make <help>|<clean>"
	@echo "  help       display this help menu"
	@echo "  clean      cleanup project"

clean:
	(cd objs; rm -rf src )

defualt_app: _prepare_dir
	@echo "build the program!  $*"
	@$(START_TIME)
	$(MAKE) -f objs/Makefile defualt_app --no-print-directory
	@echo -n "Total build time: "
	@$(END_TIME)

app-%: _prepare_dir
	@echo "build the program! $*"
	@$(START_TIME)
	$(MAKE) -f objs/Makefile $* --no-print-directory
	@echo -n "Total build time: "
	@$(END_TIME)

print-%: _prepare_dir
	$(MAKE) -f objs/Makefile print-$*

_prepare_dir:
	@mkdir -p objs


