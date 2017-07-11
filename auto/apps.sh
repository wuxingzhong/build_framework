#!/bin/bash

FILE=${GLOBAL_OBJS_DIR}/${GLOBAL_MAKEFILE}

APP_TARGET="${GLOBAL_OBJS_DIR}/${APP_NAME}"

echo "generate app ${APP_NAME} depends...";
echo "# build ${APP_TARGET} start. " >> ${FILE}
echo ".PYTHON: ${BUILD_KEY}" >> ${FILE}
echo "${BUILD_KEY}: dirs ${APP_TARGET}" >> ${FILE}

cat << END >> ${FILE}
	@\$(START_TIME)
	@echo -n "Total build time: "
	@\$(END_TIME)
END

echo -n "${APP_TARGET}: " >> ${FILE}
for item in ${APP_DEPENDS[*]}; do
	echo -n " \$(${item}_MODULE_OBJS)" >> ${FILE}
done

for item in ${APP_MAIN_ENTRANCES[*]}; do
	echo -n " \$(${item}_MODULE_ENTRANCES_OBJS)" >> ${FILE}
done
echo "" >> ${FILE}

echo "generate app ${APP_NAME} link...";


echo -n "	\$(LINK) \$(LDFLAGS) " >> ${FILE}
for item in ${APP_INC_LIBS[*]};do
	echo -n "${item} " >> ${FILE}
done

echo "\$^ ${APP_LINK_OPTIONS} -o \$@ " >> ${FILE}

echo "# build ${APP_TARGET} end. " >> ${FILE}

echo -n "generate app ${APP_NAME} ok"; echo '!';
