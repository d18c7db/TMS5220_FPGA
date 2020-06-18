  
// license:BSD-3-Clause
// copyright-holders:Aaron Giles
/***************************************************************************
    emu.h
    Core header file to be included by most files.
    NOTE: The contents of this file are designed to meet the needs of
    drivers and devices. In addition to this file, you will also need
    to include the headers of any CPUs or other devices that are required.
    If you find yourself needing something outside of this file in a
    driver or device, think carefully about what you are doing.
***************************************************************************/

#ifndef __EMU_H__
#define __EMU_H__

#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <cstring>
#include <vector>

typedef uint32_t UINT32;
typedef int32_t INT32;
typedef uint16_t UINT16;
typedef int16_t INT16;
typedef uint8_t UINT8;
typedef int8_t INT8;
typedef unsigned char u8;

#define logerror printf

#define READ_LINE_MEMBER(name)              int  name()
#define WRITE_LINE_MEMBER(name)             void name( int state)
#define LOGMASKED(mask, ...) do { if (VERBOSE & (mask)) (printf)(__VA_ARGS__); } while (false)

//#define FIFO_SIZE 16

#include <tms5220.h>

#endif // __EMU_H__
