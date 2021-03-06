/*
 * Copyright (c) 2020 Brian Callahan <bcallah@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef __linux__
	.section ".note.openbsd.ident", "a"
	.p2align 2
	.long	0x8
	.long	0x4
	.long	0x1
	.asciz	"OpenBSD"
	.long	0x0

	.text
	.globl	_start
_start:
	callq	main
	movl	$1, %eax
	xorl	%edi, %edi
	syscall
	.size	_start,.-_start

	.globl	_syscall
_syscall:
	movq	%rdi, %rax
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	movq	%rcx, %rdx
	movq	%r8, %rcx
	movq	%r9, %r8
	syscall
	retq
	.size	_syscall,.-_syscall

#else
#ifdef __amd64__

.globl _start
.globl _syscall

.text
_start:
	call    main
	mov     $60, %rax
	xor     %rdi, %rdi
	syscall

_syscall:
	test    %al, %al
	mov     %rdi, %rax
	mov     %rsi, %rdi
	mov     %rdx, %rsi
	mov     %rcx, %rdx
	mov     %r8, %r10
	mov     %r9, %r8
	je done
	pop     %r9
done:
	syscall
	ret

#elif defined(__aarch64__)

.globl _start
.globl _syscall

.text
_start:
	bl      main
	mov     x0, #0
	mov     w8, #93
	svc     #0

_syscall:
	mov     x8, x0
	mov     x0, x1
	mov     x1, x2
	mov     x2, x3
	mov     x3, x4
	mov     x4, x5
	mov     x5, x6
	svc     #0
	ret

#endif // __aarch64__
#endif // __linux__
