;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                        ;;
;;       "tinyboot" bootloader v1.0 by xrc2 (c) 2023      ;;
;;                      MIT license                       ;;
;;                                                        ;;
;;                    How to compile:                     ;;
;;                    ~~~~~~~~~~~~~~~                     ;;
;; nasm source/tinyboot.asm -f bin -o source/tinyboot.bin ;;
;;                                                        ;;
;;                       Features:                        ;;
;;                       ~~~~~~~~~                        ;;
;;                                                        ;;
;; - Loads data from the disk at a specific address into  ;;
;;   memory.                                              ;;
;;                                                        ;;
;; - Supports i8086/i8088 CPUs.                           ;;
;;                                                        ;;
;; - It is very tiny indeed.                              ;;
;;                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BITS 16

CPU 8086

%ifndef SECTORNUM
  %define SECTORNUM 40H
%endif
%ifnum SECTORNUM
%else
  %error "SECTORNUM isn't a number"
%endif
SectorNum               equ     SECTORNUM

%ifndef KERNELADDR
  %define KERNELADDR 800H
%endif
%ifnum KERNELADDR
%else
  %error "KERNELADDR isn't a number"
%endif
KernelAddr              equ     KERNELADDR

%ifndef KERNELOFFSET
  %define KERNELOFFSET 0
%endif
%ifnum KERNELOFFSET
%else
  %error "KERNELOFFSET isn't a number"
%endif
KernelOffset            equ     KERNELOFFSET

%macro PRINT 1
  mov al, %1
  mov ah, 0xE
  int 10H
%endmacro

ORG 7C00H

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of bootsector ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

PRINT 'T'
int 12H

PRINT 'I'
cmp ax, 7600H
ja $

PRINT 'N'
mov al, SectorNum
mov ah, 2H
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, 80h
mov bx, KernelAddr
mov es, bx
mov bx, KernelOffset
int 13H
jnc $

PRINT 'Y'
jmp KernelAddr:KernelOffset
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fill free space with zeroes ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

times 510 - ($ - $$) db 0

;;;;;;;;;;;;;;;;;;;;;;;;
;; Make disk bootable ;;
;;;;;;;;;;;;;;;;;;;;;;;;

dw 0xAA55

;;;;;;;;;;;;;;;;;;;;;;;
;; End of bootsector ;;
;;;;;;;;;;;;;;;;;;;;;;;