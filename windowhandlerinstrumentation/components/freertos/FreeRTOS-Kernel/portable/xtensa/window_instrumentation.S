/*
* author: Kai lehniger
*/

// can be used for all configuration parameters
#define NONE 				0

// available SHADOW_STACK_ACCESS values
#define CONSTANT 			11
#define LITERAL_DIRECT		12
#define LITERAL_INDIRECT	13
#define COMPRESSED_DIRECT	14
#define COMPRESSED_INDIRECT	15
#define COUNT_OVERFLOWS		91
#define COUNT_UNDERFLOWS	92

// available STACK_ACCESS values
#define REGULAR 			101
#define LOAD_AND_COMPARE 	102

////////////////////////////SHADOW_STACK_ACCESS//////////////////////////////////////////////////


#if SHADOW_STACK_ACCESS==CONSTANT

	#define SCRATCH_A2 							/* shadow stack pointer */

	.macro shadow_stack_store sp
		addmi	a2, \sp,   0					/* simulate offset to shadow stack */
	    s32e    a0,  a2, -16					/* save return address to shadow stack */
	.endm

	.macro shadow_stack_load sp
		addmi	a2, \sp,   0					/* simulate offset to shadow stack */
	    l32e    a0,  a2, -16					/* restore return address from shadow stack */
	.endm

#elif SHADOW_STACK_ACCESS==LITERAL_DIRECT

	#define SCRATCH_A2 							/* temp register */
	#define SCRATCH_A3 							/* shadow stack pointer */

	#define USE_SHADOW_STACK_DATA
		.macro shadow_stack_data
		.literal_position
		.align 4
		.literal __shadow_stack_offset, 0
	.endm

	.macro shadow_stack_store sp
	    l32r	a2, __shadow_stack_offset 		/* load shadow stack offset */
		sub		a3, \sp,  a2					/* simulate offset to shadow stack */
	    s32e    a0,  a3, -16     				/* save return address to shadow stack */
	.endm

	.macro shadow_stack_load sp
	    l32r	a2, __shadow_stack_offset 		/* load shadow stack offset */
		sub		a3, \sp,  a2					/* simulate offset to shadow stack */
	    l32e    a0,  a3, -16     				/* restore return address from shadow stack */
	.endm

#elif SHADOW_STACK_ACCESS==LITERAL_INDIRECT

	#define SCRATCH_A2 							/* temp register */
	#define SCRATCH_A3 							/* shadow stack pointer */

	#define USE_SHADOW_STACK_DATA
	.macro shadow_stack_data
		.extern __shadow_stack_offset
		.literal_position
		.align 4
		.literal __shadow_stack_offset_ptr, __shadow_stack_offset
	.endm

	.macro shadow_stack_store sp
		l32r	a2, __shadow_stack_offset_ptr	/* load pointer to shadow stack offset */
		l32i.n	a2,  a2,   0					/* load shadow stack offset */
		sub		a3, \sp,  a2					/* simulate offset to shadow stack */
		s32e	a0,  a3, -16					/* save return address to shadow stack */
	.endm

	.macro shadow_stack_load sp
		l32r	a2, __shadow_stack_offset_ptr	/* load pointer to shadow stack offset */
		l32i.n	a2,  a2,   0					/* load shadow stack offset */
		sub		a3, \sp,  a2					/* simulate offset to shadow stack */
		l32e	a0,  a3, -16					/* restore return address from shadow stack */
	.endm

#elif SHADOW_STACK_ACCESS==COMPRESSED_DIRECT

	#define SCRATCH_A2 							/* temp register */
	#define SCRATCH_A3 							/* shadow stack pointer */
	#define LARGE_WINDOW_HANDLERS

	#define USE_SHADOW_STACK_DATA
	.macro shadow_stack_data
		.literal_position
		.align 4
		.literal __shadow_stack_base, 0
		.literal __stack_base, 0
	.endm

	.macro shadow_stack_store sp
		l32r	a2, __stack_base				/* load stack base */
		sub		a3, \sp,  a2					/* get relative offset in stack */
		srli	a3,  a3,   0					/* simulate >> 2 compression */
		l32r	a2, __shadow_stack_base			/* load shadow stack base */
		add.n	a3,  a3,  a2					/* add shadow stack base to compressed offset */
		s32e	a0,  a3, -16					/* save return address to shadow stack */
	.endm

	.macro shadow_stack_load sp
		l32r	a2, __stack_base				/* load stack base */
		sub		a3, \sp,  a2					/* get relative offset in stack */
		srli	a3,  a3,   0					/* simulate >> 2 compression */
		l32r	a2, __shadow_stack_base			/* load shadow stack base */
		add.n	a3,  a3,  a2					/* add shadow stack base to compressed offset */
		l32e	a0,  a3, -16					/* restore return address from shadow stack */
	.endm

#elif SHADOW_STACK_ACCESS==COMPRESSED_INDIRECT

	#define SCRATCH_A2 							/* temp register */
	#define SCRATCH_A3 							/* shadow stack pointer */
	#define LARGE_WINDOW_HANDLERS

	#define USE_SHADOW_STACK_DATA
	.macro shadow_stack_data
		.extern __shadow_stack_base
		.extern __stack_base
		.literal_position
		.align 4
		.literal __shadow_stack_base_ptr, __shadow_stack_base
		.literal __stack_base_ptr, __stack_base
	.endm

	.macro shadow_stack_store sp
		l32r	a2, __stack_base_ptr			/* load stack base pointer */
		l32i.n	a2,  a2,   0					/* load stack base */
		sub		a3, \sp,  a2					/* get relative offset in stack */
		srli	a3,  a3,   0					/* simulate >> 2 compression */
		l32r	a2, __shadow_stack_base_ptr		/* load shadow stack base pointer */
		l32i.n	a2,  a2,   0					/* load shadow stack base */
		add.n	a3,  a3,  a2					/* add shadow stack base to compressed offset */
		s32e	a0,  a3, -16					/* save return address to shadow stack */
	.endm

	.macro shadow_stack_load sp
		l32r	a2, __stack_base_ptr			/* load stack base pointer */
		l32i.n	a2,  a2,   0					/* load stack base */
		sub		a3, \sp,  a2					/* get relative offset in stack */
		srli	a3,  a3,   0					/* simulate >> 2 compression */
		l32r	a2, __shadow_stack_base_ptr		/* load shadow stack base pointer */
		l32i.n	a2,  a2,   0					/* load shadow stack base */
		add.n	a3,  a3,  a2					/* add shadow stack base to compressed offset */
		l32e	a0,  a3, -16					/* restore return address from shadow stack */
	.endm

#elif SHADOW_STACK_ACCESS==COUNT_OVERFLOWS

	#define SCRATCH_A2
	#define SCRATCH_A3

	#define USE_SHADOW_STACK_DATA
	.macro shadow_stack_data
		.extern __window_counter
		.literal_position
		.align 4
		.literal __window_counter_ptr, __window_counter
	.endm

	.macro shadow_stack_store sp
		l32r	a2, __window_counter_ptr		/* load pointer to counter variable */
		l32i.n	a3, a2, 0						/* load current counter value */
		addi.n	a3, a3, 1						/* increment counter value */
		s32i.n	a3, a2, 0						/* store counter value */
	.endm

	.macro shadow_stack_load sp
	.endm

#elif SHADOW_STACK_ACCESS==COUNT_UNDERFLOWS

	#define SCRATCH_A2
	#define SCRATCH_A3

	#define USE_SHADOW_STACK_DATA
	.macro shadow_stack_data
		.extern __window_counter
		.literal_position
		.align 4
		.literal __window_counter_ptr, __window_counter
	.endm

	.macro shadow_stack_store sp
	.endm

	.macro shadow_stack_load sp
		l32r	a2, __window_counter_ptr		/* load pointer to counter variable */
		l32i.n	a3, a2, 0						/* load current counter value */
		addi.n	a3, a3, 1						/* increment counter value */
		s32i.n	a3, a2, 0						/* store counter value */
	.endm

#else

	.macro shadow_stack_store sp
	.endm

	.macro shadow_stack_load sp
	.endm

#endif

///////////////////////////////////STACK_ACCESS///////////////////////////////////////////////////////

#if STACK_ACCESS==REGULAR

	.macro stack_store sp
	s32e	a0, \sp, -16	/* save return address to stack */
	.endm

	.macro stack_load sp
	l32e	a0, \sp, -16	/* restore return address from stack */
	.endm

#elif STACK_ACCESS==LOAD_AND_COMPARE

	#define SCRATCH_A2

	.macro stack_store sp
	s32e	a0, \sp, -16	/* save return address to stack */
	.endm

	.macro stack_load sp
	l32e	a2, \sp, -16	/* load return address from regular stack */
	beq		a0, a2, lsr\@	/* compare return addresses */
	movi.n	a0,  0			/* set return address to 0 in case of a missmatch */
	lsr\@:
	.endm

#else

	.macro stack_store sp
	.endm

	.macro stack_load sp
	.endm

#endif

////////////////////////////////HELPERS///////////////////////////////////////////

.macro store_scratches sp
#ifdef SCRATCH_A2
	s32e    a2, \sp,  -8
#endif
#ifdef SCRATCH_A3
    s32e    a3, \sp,  -4
#endif
.endm

.macro store_non_scratches sp
#ifndef SCRATCH_A2
	s32e    a2, \sp,  -8
#endif
#ifndef SCRATCH_A3
    s32e    a3, \sp,  -4
#endif
.endm

