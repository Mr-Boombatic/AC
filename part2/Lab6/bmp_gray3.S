.data
  rmul:
    .single 0.30, 0.30, 0.30, 0.30
  bmul:
    .single 0.11, 0.11, 0.11, 0.11
  gmul:
    .single 0.59, 0.59, 0.59, 0.59
  red:
    .single 0.00, 0.00, 0.00, 0.00
  blue:
    .single 0.00, 0.00, 0.00, 0.00
  green:
    .single 0.00, 0.00, 0.00, 0.00
  res:
    .single 0.00, 0.00, 0.00, 0.00

.text
    .global bmpGrayscaleSSE

bmpGrayscaleSSE:
    push %ebp
    mov %esp, %ebp

    sub $0x24, %esp

    pusha

    /* Obtain picture dimensions */

    mov 0x10(%ebp), %eax
    mov 0x14(%eax), %eax
    mov %eax, -0xc(%ebp)                # -0xc(%ebp) <- w = header->width
    mov 0x10(%ebp), %eax
    mov 0x18(%eax), %eax
    mov %eax, -0x8(%ebp)                # -0x8(%ebp) <- h = header->heigth
    mov -0x8(%ebp), %eax
    imul -0xc(%ebp), %eax
    movl %eax, -0x4(%ebp)               # -0x4(%ebp) <- size = h*w
	shll $2, %eax
    movl %eax, -0x24(%ebp)              # -0x24(%ebp) <- 4 * size

    /* Load grayscale multipliers */

    movups rmul, %xmm7
    movups gmul, %xmm6
    movups bmul, %xmm5

  /****
   * For each row (i = 0 ... height - 1) compute row offset and
   * process it
   */

    movl $0x0, -0x10(%ebp)               # i = 0
    jmp cmp_i

  next_i:
    movl -0x10(%ebp), %edx               # %edx <- i
    imul -0xc(%ebp), %edx                # %edx <- i * w
    movl %edx, -0x20(%ebp)               # -0x20(%ebp) <- i * w

  /****
   * For each four-element group of column pixels (j = 0 ... width / 4 - 1)
   * compute source and destination base adresses and grayscale group
   */

    movl $0x0, -0x14(%ebp)
    jmp cmp_j

  next_j:
    movl -0x20(%ebp), %edx              # %edx <- i * w
    movl -0x14(%ebp), %eax              # %eax <- j
    leal (%edx, %eax, 4), %edx          # %edx <- i * w + j * 4
    shll $2, %edx                       # %edx <- (i * w + j * 4) * sizeof(single)
    movl 0x8(%ebp), %eax                # %eax <- bmpSrc
    leal (%eax, %edx, 1), %esi          # %esi <- bmpSrc[i * w + j * 4]
    movl 0xc(%ebp), %eax                # %eax <- bmpDst
    leal (%eax, %edx, 1), %edi          # %edi <- bmpDst[i * w + j * 4]

  /****
   * For each pixel in a group (k = 0 ... 4) move
   * RGB data to four-component vectors
   */

    movl   $0x0, %ecx
    jmp    cmp_k

  next_k:
    movl %esi, %edx
    movl (%edx, %ecx, 4), %eax
    movl %eax, blue(, %ecx, 4)          # blue[k] <- bmpSrc[i * w + j * 4 + k]
    addl -0x24(%ebp), %edx              # %edx <- bmpSrc[size + i * w + j * 4]
    movl (%edx, %ecx, 4), %eax
    movl %eax, green(, %ecx, 4)         # green[k] <- bmpSrc[size + i * w + j * 4 + k]
    addl -0x24(%ebp), %edx              # %edx <- bmpSrc[2 * size + i * w + j * 4]
    movl (%edx, %ecx, 4), %eax
    movl %eax, red(, %ecx, 4)           # red[k] = bmpSrc[2 * size + i * w + j * 4 + k]

    addl $0x1, %ecx                     # k++

  cmp_k:
    cmpl $0x3, %ecx                     # k = 3 ?
    jbe next_k

  /*
   * End-of-cycle move to vectors (k)
   ****/

  /****
   * For each pixel in a group (k = 0 ... 4) compute
   * res[k] = bmul[k] * blue[k] + gmul[k] * green[k] + rmul[k] * red[k];
   */

    movups red, %xmm0
    movups green, %xmm1
    movups blue, %xmm2
    mulps %xmm7, %xmm0
    mulps %xmm6, %xmm1
    mulps %xmm5, %xmm2
    addps %xmm2, %xmm1
    addps %xmm1, %xmm0
    movups %xmm0, res

  /*
   * End-of-computation
   ****/

  /****
   * For each pixel in a group (t = 0 ... 4) move computed gray levels
   * of four pixels to destination picture data
   */

    movl   $0x0, %ecx
    jmp    cmp_k_2

  next_k_2:

    movl  %edi, %ebx
    movl res(, %ecx, 4), %eax
    movl %eax, (%ebx, %ecx, 4)
    addl -0x24(%ebp), %ebx
    movl %eax, (%ebx, %ecx, 4)
    addl -0x24(%ebp), %ebx
    movl %eax, (%ebx, %ecx, 4)

    addl $0x1, %ecx

  cmp_k_2:
    cmpl $0x3, %ecx
    jbe next_k_2

  /*
   * End-of-cycle move to destination picture (t)
   *****/

    addl $0x1, -0x14(%ebp)

  cmp_j:
    mov -0xc(%ebp),%eax
    shr $0x2,%eax
    cmp -0x14(%ebp),%eax
    ja next_j


  # MY CODE
  process_tail:

    movl -0x20(%ebp), %edx              # %edx <- i * w
    movl -0x14(%ebp), %eax              # %eax <- j = w / 4
    leal (%edx, %eax, 4), %edx          # %edx <- i * w + j * 4
    shll $2, %edx                       # %edx <- (i * w + j * 4) * sizeof(single)
    movl 0x8(%ebp), %eax                # %eax <- bmpSrc
    leal (%eax, %edx, 1), %esi          # %esi <- bmpSrc[i * w + j * 4]
    movl 0xc(%ebp), %eax                # %eax <- bmpDst
    leal (%eax, %edx, 1), %edi          # %edi <- bmpDst[i * w + j * 4]

    movl  $0x0, %ecx
    jmp cmp_k_tail

  next_k_tail:
    movl %esi, %edx
    movl (%edx, %ecx, 4), %eax
    movl %eax, blue(, %ecx, 4)          # blue[k] <- bmpSrc[i * w + j * 4 + k]
    addl -0x24(%ebp), %edx              # %edx <- bmpSrc[size + i * w + j * 4]
    movl (%edx, %ecx, 4), %eax
    movl %eax, green(, %ecx, 4)         # green[k] <- bmpSrc[size + i * w + j * 4 + k]
    addl -0x24(%ebp), %edx              # %edx <- bmpSrc[2 * size + i * w + j * 4]
    movl (%edx, %ecx, 4), %eax
    movl %eax, red(, %ecx, 4)           # red[k] = bmpSrc[2 * size + i * w + j * 4 + k]

    addl $0x1, %ecx                     # k++

  cmp_k_tail:
    movl -0xc(%ebp), %eax
    movl  $0, %edx

    movl $4, %ebx
    idivl %ebx

    cmpl %edx, %ecx                     # compare k with (width % 4 - 1)
    jbe next_k_tail

    movups red, %xmm0
    movups green, %xmm1
    movups blue, %xmm2
    mulps %xmm7, %xmm0
    mulps %xmm6, %xmm1
    mulps %xmm5, %xmm2
    addps %xmm2, %xmm1
    addps %xmm1, %xmm0
    movups %xmm0, res

    movl   $0x0, %ecx
    jmp    cmp_k_tail_2

  next_k_tail_2:

    movl  %edi, %ebx
    movl res(, %ecx, 4), %eax
    movl %eax, (%ebx, %ecx, 4)
    addl -0x24(%ebp), %ebx
    movl %eax, (%ebx, %ecx, 4)
    addl -0x24(%ebp), %ebx
    movl %eax, (%ebx, %ecx, 4)

    addl $0x1, %ecx

  cmp_k_tail_2:

    movl -0xc(%ebp), %eax
    movl  $0, %edx

    movl $4, %ebx
    idivl %ebx

    cmpl %edx, %ecx                 # compare k with (width % 4 - 1)
    jbe next_k_tail_2
  #END OF MY CODE   

  /*
   * End-of-cycle groups processing (j)
   *****/

    addl $0x1,-0x10(%ebp)
  cmp_i:
    movl -0x10(%ebp),%eax
    cmpl -0x8(%ebp),%eax
    jb next_i

  /*
   * End-of-cycle rows processing (i)
   *****/

    popa

    leave
    ret

