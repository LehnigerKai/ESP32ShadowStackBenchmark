
#include "security.h"
#include "xtensa_rtos.h"
#include "esp32_pid.h"

.align 4
.literal_position

/* Register assignment
 * There are four misc registers.
 * Two are used to store state of the current execution context and two can be used as spill registers
 */
#if STORAGE == STORAGE_MEMORY
	.extern state0
	.extern state1
#elif STORAGE == STORAGE_REG
	#define state0 misc3
	#define state1 misc2
#else
#error "Undefined value for STORAGE"
#endif
#define SPILL0 misc1
#define SPILL1 misc0

/* Macro to load task state data.
 * Implementation depends on where data is stored.
 * What type of data is available needs to be defined
 * for each method separately.
 */
#if STORAGE == STORAGE_MEMORY
	.macro get_val	r1, r2, val
		getcoreid	\r2				// coreID <- getcoreid()
		movi		\r1, \val		// &val <- mem
		addx4		\r1, \r2, \r1	// &val += coreID
		l32i.n		\r1, \r1,   0	// val <- mem[&val]
	.endm
#elif STORAGE == STORAGE_REG
	.macro get_val	r1, x,  val
		rsr			\r1, \val
	.endm
#else
#error "Undefined value for STORAGE"
#endif

/* Macros to use to return from different window handlers.
 * This is either a normal return or a redirection to one of
 * the hooks in case the window handlers were invoked in a
 * privileged mode.
 * Code was taken from: https://github.com/apache/nuttx/blob/master/arch/xtensa/src/esp32/esp32_window_hooks.S
 */
#if PRIVILEGED == PRIVILEGED_ON
	.macro get_prev_pid level out
    	movi    \out, PIDCTRL_FROM_1_REG + (\level - 1) * 0x4
    	l32i    \out, \out, 0
    	extui   \out, \out, 0, 3
	.endm

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

	.macro rfwo4
		wsr 	a0, misc0
		wsr 	a1, misc1

		/* Restore PID to the same value prior to the exception */

		get_prev_pid 2 a0
		set_next_pid a0 a1

		rsr 	a0, misc0
		rsr 	a1, misc1
		rfwo				/* rotates back to call[i] position */
	.endm

	.macro rfwo8
		wsr 	a0, misc0
		wsr 	a1, misc1

		/* Restore PID to the same value prior to the exception */

		get_prev_pid 5 a0
		set_next_pid a0 a1

		rsr 	a0, misc0
		rsr 	a1, misc1
		rfwo				/* rotates back to call[i] position */
	.endm

	.macro rfwu4
		wsr 	a0, misc0
		wsr 	a1, misc1

		/* Restore PID to the same value prior to the exception */

		get_prev_pid 4 a0
		set_next_pid a0 a1

		rsr 	a0, misc0
		rsr 	a1, misc1
		rfwu
	.endm

	.macro rfwu8
		wsr 	a0, misc0
		wsr 	a1, misc1

		/* Restore PID to the same value prior to the exception */

		get_prev_pid 6 a0
		set_next_pid a0 a1

		rsr 	a0, misc0
		rsr 	a1, misc1
		rfwu
	.endm
#elif PRIVILEGED == PRIVILEGED_OFF
	.macro rfwo4
		rfwo
	.endm
	.macro rfwo8
		rfwo
	.endm
	.macro rfwu4
		rfwu
	.endm
	.macro rfwu8
		rfwu
	.endm
#else
#error "Undefined value for PRIVILEGED"
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////

#if OVERWRITE_WINDOW4
.global __WindowOverflow4
.global __WindowUnderflow4
#endif
.global __WindowOverflow8
.global __WindowUnderflow8

_e:
	ill

/* Implementation of protection methods.
 * For each method the needed additional state, overflow and underflow handlers are defined.
 */
#if METHOD == METHOD_DEFAULT || METHOD == METHOD_PRINT_REPEAT_FACTOR

// nothing to do, use original implementation

#elif METHOD == METHOD_SHADOW || METHOD == METHOD_SHADOW_SIZE
	// offset to shadow stack
	#define OFF state0

	__WindowOverflow8:
	    // store BSA without a0
		s32e	a1, a9, -12 // mem[$\color{javagreen}SP_{i+1}$ - 12] $\color{javagreen}\leftarrow$ a1
		s32e	a2, a9,  -8 // mem[$\color{javagreen}SP_{i+1}$ - 8] $\color{javagreen}\leftarrow$ a2
		s32e	a3, a9,  -4 // mem[$\color{javagreen}SP_{i+1}$ - 4] $\color{javagreen}\leftarrow$ a3
		// store a0 in shadow stack
		get_val	a2, a3, OFF // offset  $\color{javagreen}\leftarrow$ get_val()
		sub		a3, a9,  a2 // $\color{javagreen}SSP_{i+1}$ = $\color{javagreen}SP_{i+1}$ - offset
		s32e	a0, a3, -16 // mem[$\color{javagreen}SSP_{i+1}$ - 16] $\color{javagreen}\leftarrow$ a0

		l32e	a0, a1, -12 // $\color{javagreen}SP_{i-1}$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_i$ - 12]
		// store ESA
		s32e	a4, a0, -32 // mem[$\color{javagreen}SP_{i-1}$ - 32] $\color{javagreen}\leftarrow$ a4
		s32e	a5, a0, -28 // mem[$\color{javagreen}SP_{i-1}$ - 28] $\color{javagreen}\leftarrow$ a5
		s32e	a6, a0, -24 // mem[$\color{javagreen}SP_{i-1}$ - 24] $\color{javagreen}\leftarrow$ a6
		s32e	a7, a0, -20	// mem[$\color{javagreen}SP_{i-1}$ - 20] $\color{javagreen}\leftarrow$ a7
		rfwo8

	__WindowUnderflow8:
	    get_val a0, a1, OFF // offset $\color{javagreen}\leftarrow$ get_val()
	    sub     a0, a9,  a0 // $\color{javagreen}SSP_{i+1}$ = $\color{javagreen}SP_{i+1}$ - offset
	    // restore BSA
		l32e    a0, a0, -16 // a0 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i+1}$ - 16]
		l32e    a1, a9, -12 // a1 | $\color{javagreen}SP_i$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i+1}$ - 12]
		l32e    a2, a9,  -8 // a2 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i+1}$ - 8]
		l32e    a3, a9,  -4 // a3 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i+1}$ - 4]

		l32e    a7, a1, -12 // $\color{javagreen}SP_{i-1}$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_i$ - 12]
		// restore ESA
		l32e    a4, a7, -32 // a4 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 32]
		l32e    a5, a7, -28 // a5 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 28]
		l32e    a6, a7, -24 // a6 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 24]
		l32e    a7, a7, -20 // a7 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 20]
		rfwu8

	__WindowOverflow4:
		s32e	a1, a5, -12
		s32e	a2, a5,  -8
		s32e	a3, a5,  -4
		get_val	a3, a2, OFF
		sub 	a3, a5,  a3
		s32e	a0, a3, -16
		rfwo4

	__WindowUnderflow4:
		get_val	a3, a2, OFF
		sub		a3, a5,  a3
		l32e	a0, a3, -16
		l32e	a1, a5, -12
		l32e	a2, a5,  -8
		l32e	a3, a5,  -4
		rfwu4

#elif METHOD == METHOD_AREA || METHOD == METHOD_AREA_SIZE
	// offset to shadow stack
	#define OFF state0

	__WindowOverflow8:
	    // calculate shadow stack pointers
	    wsr     a7, SPILL0
	    wsr     a6, SPILL1
	    get_val a7, a6, OFF // offset $\color{javagreen}\leftarrow$ get_val
	    sub     a6, a9,  a7 // $\color{javagreen}SSP_{i+1}$ = $\color{javagreen}SP_{i+1}$ - offset
	    sub     a1, a1,  a7 // $\color{javagreen}SSP_i$ = $\color{javagreen}SP_i$ - offset
	    // store BSA
		s32e	a0, a6, -16 // mem[$\color{javagreen}SSP_{i+1}$ - 16] $\color{javagreen}\leftarrow$ a0
		s32e	a1, a6, -12 // mem[$\color{javagreen}SSP_{i+1}$ - 12] $\color{javagreen}\leftarrow$ $\color{javagreen}SSP_i$
		s32e	a2, a6,  -8 // mem[$\color{javagreen}SSP_{i+1}$ - 8] $\color{javagreen}\leftarrow$ a2
		s32e	a3, a6,  -4 // mem[$\color{javagreen}SSP_{i+1}$ - 4] $\color{javagreen}\leftarrow$ a3

	    rsr     a6, SPILL1
	    rsr     a7, SPILL0
		l32e	a0, a1, -12 // $\color{javagreen}SSP_{i-1}$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_i$ - 12]
		// store ESA
		s32e	a4, a0, -32 // mem[$\color{javagreen}SSP_{i-1}$ - 32] $\color{javagreen}\leftarrow$ a4
		s32e	a5, a0, -28 // mem[$\color{javagreen}SSP_{i-1}$ - 28] $\color{javagreen}\leftarrow$ a5
		s32e	a6, a0, -24 // mem[$\color{javagreen}SSP_{i-1}$ - 24] $\color{javagreen}\leftarrow$ a6
		s32e	a7, a0, -20	// mem[$\color{javagreen}SSP_{i-1}$ - 20] $\color{javagreen}\leftarrow$ a7
		rfwo8

	__WindowUnderflow8:
	    get_val a6, a7, OFF // offset $\color{javagreen}\leftarrow$ get_val
	    sub     a3, a9,  a6 // $\color{javagreen}SSP_{i+1}$ = $\color{javagreen}SP_{i+1}$ - offset
	    // restore BSA
		l32e    a0, a3, -16 // a0 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i+1}$ - 16]
		l32e    a1, a3, -12 // $\color{javagreen}SSP_i$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i+1}$ - 12]
		l32e    a2, a3,  -8 // a2 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i+1}$ - 8]
		l32e    a3, a3,  -4 // a3 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i+1}$ - 4]

		l32e    a7, a1, -12 // $\color{javagreen}SSP_{i-1}$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_i$ - 12]
		add     a1, a1,  a6 // a1 | $\color{javagreen}SP_i$ = $\color{javagreen}SSP_i$ + offset
		// restore ESA
		l32e    a4, a7, -32 // a4 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i-1}$ - 32]
		l32e    a5, a7, -28 // a5 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i-1}$ - 28]
		l32e    a6, a7, -24 // a6 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i-1}$ - 24]
		l32e    a7, a7, -20 // a7 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i-1}$ - 20]
		rfwu8

	__WindowOverflow4:
		wsr		a3, SPILL0
		wsr		a2, SPILL1
		get_val	a3, a2, OFF
		sub		a2, a5,  a3
		sub		a1, a1,  a3
	    s32e    a0, a2, -16     /* save a0 to call[j+1]'s stack frame */
	    s32e    a1, a2, -12     /* save a1 to call[j+1]'s stack frame */
	    rsr		a0, SPILL1
	    rsr		a1, SPILL0
	    s32e    a0, a2,  -8     /* save a2 to call[j+1]'s stack frame */
	    s32e    a1, a2,  -4     /* save a3 to call[j+1]'s stack frame */
	    rfwo4                    /* rotates back to call[i] position */

	__WindowUnderflow4:
		get_val	a2, a3, OFF
		sub		a3, a5,  a2
	    l32e    a0, a3, -16     /* restore a0 from call[i+1]'s stack frame */
	    l32e    a1, a3, -12     /* restore a1 from call[i+1]'s stack frame */
	    add		a1, a1,  a2
	    l32e    a2, a3,  -8     /* restore a2 from call[i+1]'s stack frame */
	    l32e    a3, a3,  -4     /* restore a3 from call[i+1]'s stack frame */
	    rfwu4



#elif METHOD == METHOD_COUNT

	#define FLG state0

	.extern __window_counter
	.align 4
	.literal __window_counter_ptr, __window_counter

	.macro inc_counter
		get_val a2, a3, FLG
		beqz	a2, _end\@
		l32r	a2, __window_counter_ptr
		l32i.n	a3, a2,   0
		addi.n	a3, a3,   1
		s32i.n	a3, a2,   0
	_end\@:
	.endm

	__WindowOverflow8:
		s32e    a0, a9, -16
		l32e    a0, a1, -12
	    s32e    a1, a9, -12
	    s32e    a2, a9,  -8
	 	s32e    a3, a9,  -4
	    s32e    a4, a0, -32
	 	s32e    a5, a0, -28
		s32e    a6, a0, -24
		s32e    a7, a0, -20
		inc_counter
		rfwo8

	__WindowUnderflow8:
		inc_counter
		l32e    a0, a9, -16
		l32e    a1, a9, -12
	    l32e    a2, a9,  -8
	    l32e	a7, a1, -12
	    l32e    a3, a9,  -4
	    l32e    a4, a7, -32
	    l32e    a5, a7, -28
	    l32e    a6, a7, -24
	    l32e    a7, a7, -20
		rfwu8

	__WindowOverflow4:
		s32e    a0, a5, -16
    	s32e    a1, a5, -12
    	s32e    a2, a5,  -8
    	s32e    a3, a5,  -4
    	inc_counter
    	rfwo4

    __WindowUnderflow4:
    	inc_counter
    	l32e	a0, a5, -16
    	l32e	a1, a5, -12
    	l32e	a2, a5,  -8
    	l32e	a3, a5,  -4
    	rfwu4

#elif METHOD == METHOD_COMPRESS || METHOD == METHOD_COMPRESS_SIZE

	// end of stack
	#define EOS state0
	// end of shadow stack
	#define ESS	state1

	__WindowOverflow8:
	    // store BSA without a0
		s32e	a1, a9, -12 // mem[$\color{javagreen}SP_{i+1}$ - 12] $\color{javagreen}\leftarrow$ a1
		s32e	a2, a9,  -8 // mem[$\color{javagreen}SP_{i+1}$ - 8] $\color{javagreen}\leftarrow$ a2
		s32e	a3, a9,  -4 // mem[$\color{javagreen}SP_{i+1}$ - 4] $\color{javagreen}\leftarrow$ a3
		l32e	a3, a1, -12 // $\color{javagreen}SP_{i-1}$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_i$ - 12]
		// store ESA
		s32e	a4, a3, -32 // mem[$\color{javagreen}SP_{i-1}$ - 32] $\color{javagreen}\leftarrow$ a4
		s32e	a5, a3, -28 // mem[$\color{javagreen}SP_{i-1}$ - 28] $\color{javagreen}\leftarrow$ a5
		s32e	a6, a3, -24 // mem[$\color{javagreen}SP_{i-1}$ - 24] $\color{javagreen}\leftarrow$ a6
		s32e	a7, a3, -20	// mem[$\color{javagreen}SP_{i-1}$ - 20] $\color{javagreen}\leftarrow$ a7
		// calculate ssp
		get_val	a2, a3, EOS
		beqz	a2, _l1
		sub		a2, a2,  a9
		srli	a2, a2,   2
		get_val	a3, a1, ESS
		sub		a3, a3,  a2
		// store a0 in shadow stack
		s32e	a0, a3, -16 // mem[$\color{javagreen}SSP_{i+1}$ - 16] $\color{javagreen}\leftarrow$ a0
		rfwo8
	_l1:
		s32e	a0, a9, -16
		rfwo8

	__WindowUnderflow8:
		// calculate ssp
		get_val	a2, a3, EOS
		beqz	a2, _l2
		sub		a2, a2,  a9
		srli	a2, a2,   2
		get_val	a0, a1, ESS
		sub		a0, a0,  a2
		j		_l3
	_l2:
		mov.n	a0, a9
	_l3:
	    // restore BSA
		l32e    a0, a0, -16 // a0 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SSP_{i+1}$ - 16]
		l32e    a1, a9, -12 // a1 | $\color{javagreen}SP_i$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i+1}$ - 12]
		l32e    a2, a9,  -8 // a2 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i+1}$ - 8]
		l32e    a3, a9,  -4 // a3 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i+1}$ - 4]

		l32e    a7, a1, -12 // $\color{javagreen}SP_{i-1}$ $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_i$ - 12]
		// restore ESA
		l32e    a4, a7, -32 // a4 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 32]
		l32e    a5, a7, -28 // a5 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 28]
		l32e    a6, a7, -24 // a6 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 24]
		l32e    a7, a7, -20 // a7 $\color{javagreen}\leftarrow$ mem[$\color{javagreen}SP_{i-1}$ - 20]
		rfwu8

	__WindowOverflow4:
		s32e	a1, a5, -12
		s32e	a2, a5,  -8
		s32e	a3, a5,  -4
		get_val	a2, a3, EOS
		beqz	a2, _l4
		sub		a2, a2,  a5
		srli	a2, a2,   2
		get_val	a3, a1, ESS
		sub		a3, a3,  a2
		s32e	a0, a3, -16
		rfwo4
	_l4:
		s32e	a0, a5, -16
		rfwo4

	__WindowUnderflow4:
		get_val	a2, a3, EOS
		beqz	a2, _l5
		sub		a2, a2,  a5
		srli	a2, a2,   2
		get_val	a0, a1, ESS
		sub		a0, a0,  a2
		l32e	a0, a0, -16
		l32e	a1, a5, -12
		l32e	a2, a5,  -8
		l32e	a3, a5,  -4
		rfwu4
	_l5:
		l32e	a0, a5, -16
		l32e	a1, a5, -12
		l32e	a2, a5,  -8
		l32e	a3, a5,  -4
		rfwu4

#else
#error "Undefined value for METHOD"
#endif
