#!/bin/bash
# params:
# $GLOBAL_OBJS_DIR the objs directory. ie. objs
# $GLOBAL_MAKEFILE the makefile name. ie. Makefile
# $MODULE_ID the id of module. ie. MAIN
# $MODULE_SRC_DIR array the module src dir . ie. src/main
# $MODULE_DEPENDS array, the denpend MODULEs id. ie. (MAIN)
# $MODULE_INCLUDES_DIR array, the depend 3rdpart library includes. ie. (objs/xxx/include)
# $Module_INC_LIBS  array

FILE=${GLOBAL_OBJS_DIR}/${GLOBAL_MAKEFILE}

echo "# the ${MODULE_ID} module start." >> ${FILE}

# 头文件包含文件夹
echo -n "${MODULE_ID}_MODULE_INCS = " >> ${FILE}
# 处理src文件夹头文件
for item in ${MODULE_DEPENDS[*]}; do
    DEP_INCS_NAME="${item}_MODULE_INCS"
    echo -n "\$(${DEP_INCS_NAME}) " >> ${FILE}
done

for item in ${MODULE_SRC_DIR[*]}; do
    echo -n "-I ${item} " >>${FILE}
done

for item in ${MODULE_INCLUDES_DIR[*]}; do
    echo -n "-I ${item} " >> ${FILE}
done
echo -n $(pkg-config --cflags ${PKG_CONFIG_LIBS[@]} 2>/dev/null ) >>${FILE}
echo "" >> ${FILE};
echo "ALL_INCLUDES+=\$(${MODULE_ID}_MODULE_INCS)  " >> ${FILE}


# OBJS  DEPS
MODULE_OBJS=()
MODULE_ENTRANCES_OBJS=()
SOURCES="$(find ${MODULE_SRC_DIR[@]} -name *.${SRC_EXT}  2>/dev/null -printf '%T@\t%p\n'| sort -u  | sort  -k 1nr | cut -f2- )"
CXX_SOURCES="$(find ${MODULE_SRC_DIR[@]} -name *.${CXX_SRC_EXT}  2>/dev/null -printf '%T@\t%p\n'| sort -u  | sort  -k 1nr | cut -f2- )"
MODULE_FILES=("${SOURCES} ${CXX_SOURCES}")

for item in ${MODULE_FILES[*]}; do
    OBJ_FILE="${GLOBAL_OBJS_DIR}/${item%%.*}.o"
    flag_entrance=NO
    for entrance in ${MODULE_ENTRANCES_FILES[*]};do
        file_basename=$(basename ${item})
        if [ ${file_basename} = ${entrance}  ]; then
            flag_entrance=YES
            MODULE_ENTRANCES_OBJS="${MODULE_ENTRANCES_OBJS[@]} ${OBJ_FILE}"
            break
        fi
    done

    if [ ${flag_entrance} = NO ];then
        MODULE_OBJS="${MODULE_OBJS[@]} ${OBJ_FILE}"
    fi
    DEPS_FILE="${GLOBAL_OBJS_DIR}/${item%%.*}.d"
    MODULE_DEPS="${MODULE_DEPS[@]} ${DEPS_FILE}"
done

echo "${MODULE_ID}_MODULE_OBJS=${MODULE_OBJS[@]}" >> ${FILE}
echo "${MODULE_ID}_MODULE_ENTRANCES_OBJS=${MODULE_ENTRANCES_OBJS[@]}" >> ${FILE}
echo "${MODULE_ID}_MODULE_DEPS=\$(${MODULE_ID}_MODULE_OBJS:.o=.d) \$(${MODULE_ID}_MODULE_ENTRANCES_OBJS:.o=.d)  " >> ${FILE}
echo "ALL_OBJECTS+=\$(${MODULE_ID}_MODULE_OBJS) \$(${MODULE_ID}_MODULE_ENTRANCES_OBJS) " >> ${FILE}
echo "ALL_DEPS+=\$(${MODULE_ID}_MODULE_DEPS)" >> ${FILE}
echo "# the ${MODULE_ID} module end." >> ${FILE}
echo "" >> ${FILE};

# Makefile
echo -n "generate module ${MODULE_ID} ok"; echo '!';
