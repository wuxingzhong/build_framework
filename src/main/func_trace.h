/*
* @Author: wuxingzhong
* @Date:   2017-06-26 14:28:25
* @Email:  330332812@qq.com
* @copyright:          sunniwell
* @Last Modified by:   wuxingzhong
* @Last Modified time: 2017-06-26 14:31:44
*/

#ifndef __FUNC_TRACE_H
#define __FUNC_TRACE_H

#include <stdio.h>

//利用一个结构的构造和析构函数进行函数跟踪
struct __func_trace_struct
{
public:
    //函数名称
    const char *func_name_;
    //文件名称
    const char *file_name_;
    //文件的行号，行号是函数体内部的位置，不是函数声明的起始位置，但这又何妨
    int         file_line_;
public:

    //利用构造函数显示进入函数的输出
    __func_trace_struct(const char *func_name,const char *file_name,int file_line):
        func_name_(func_name),
        file_name_(file_name),
        file_line_(file_line)
    {
        printf("%s entry, %s:%u \n",func_name_,file_name_,file_line_);
    }
    //利用析构函数显示进入函数的输出
    ~__func_trace_struct()
    {
        printf("%s exit, %s:%u \n",func_name_,file_name_,file_line_);
    }

};

//---------------------

// EN_FUNCTION_TRACE宏用于跟踪函数的进出
//请在函数的开始使用ZEN_FUNCTION_TRACE这个宏，后面必须加分号
#ifndef EN_FUNCTION_TRACE
#ifdef WIN32
        #define EN_FUNCTION_TRACE        __func_trace_struct ____tmp_func_trace_(__FUNCTION__,__FILE__,__LINE__)
    #else //GCC
        #define EN_FUNCTION_TRACE        __func_trace_struct ____tmp_func_trace_(__PRETTY_FUNCTION__,__FILE__,__LINE__)
    #endif
#endif //#ifndef EN_FUNCTION_TRACE

#endif /*__FUNC_TRACE_H */