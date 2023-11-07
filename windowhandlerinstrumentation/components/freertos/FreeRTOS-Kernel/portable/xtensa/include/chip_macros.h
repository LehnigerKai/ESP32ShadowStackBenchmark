/****************************************************************************
 * Adapted by:
 *
 *   Author: Kai Lehniger
 *
 * Adapted from use in NuttX by:
 *
 *   Copyright (C) 2016 Gregory Nutt. All rights reserved.
 *   Author: Gregory Nutt <gnutt@nuttx.org>
 *
 * Derives from logic originally provided by Cadence Design Systems Inc.
 *
 *   Copyright (c) 2006-2015 Cadence Design Systems Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 ****************************************************************************/

#ifndef __ARCH_XTENSA_SRC_ESP32_CHIP_MACROS_H
#define __ARCH_XTENSA_SRC_ESP32_CHIP_MACROS_H

#include "esp32_pid.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/* This is the name of the section containing the Xtensa low level handlers
 * that is used by the board linker scripts.
 */

#define HANDLER_SECTION .iram1

/****************************************************************************
 * Assembly Language Macros
 ****************************************************************************/

/****************************************************************************
 * Name: get_prev_pid
 *
 * Description:
 *   Retrieve PID information from interruptee.
 *
 * Entry Conditions:
 *   level  - Interrupt level
 *   out    - Temporary and output register
 *
 * Exit Conditions:
 *   PID value to be returned will be written to "out" register.
 *
 ****************************************************************************/


    .macro get_prev_pid level out
    movi    \out, PIDCTRL_FROM_1_REG + (\level - 1) * 0x4
    l32i    \out, \out, 0
    extui   \out, \out, 0, 3
    .endm


/****************************************************************************
 * Name: set_next_pid
 *
 * Description:
 *   Configure the PID Controller for the new execution context.
 *
 * Entry Conditions:
 *   in     - PID to be set
 *   tmp    - Temporary register
 *
 * Exit Conditions:
 *   Register "in" has been trashed.
 *
 ****************************************************************************/


    .macro set_next_pid in tmp
    movi    \tmp, PIDCTRL_PID_NEW_REG
    s32i    \in, \tmp, 0           /* Set new PID */

    movi    \tmp, PIDCTRL_PID_DELAY_REG
    movi    \in, 0x0
    s32i    \in, \tmp, 0           /* Set delay (cycles) for PID change */

    movi    \tmp, PIDCTRL_PID_CONFIRM_REG
    movi    \in, 0x1
    s32i    \in, \tmp, 0           /* Confirm change to the new PID */
    .endm

#endif /* __ARCH_XTENSA_SRC_ESP32_CHIP_MACROS_H */
