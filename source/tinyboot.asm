;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                        ;;
;;       "tinyboot" bootloader v1.0 by xrc2 (c) 2023      ;;
;;                      MIT license                       ;;
;;                                                        ;;
;;                    How to compile:                     ;;
;;                    ~~~~~~~~~~~~~~~                     ;;
;;   nasm 8086/tinyboot.asm -f bin -o 8086/tinyboot.bin   ;;
;;                                                        ;;
;;                       Features:                        ;;
;;                       ~~~~~~~~~                        ;;
;;                                                        ;;
;; - Loads data from the disk at a specific address into  ;;
;;   memory.                                              ;;
;;                                                        ;;
;; - Supports i8086/i8088 CPUs.                           ;;
;;                                                        ;;
;; - Is indeed very tiny indeed.                          ;;
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

ORG 7C00H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Boot sector starts here ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov ah, 0xE
mov al, 'T'
int 10H

int 12H

mov ah, 0xE
mov al, 'I'
int 10H

cmp ax, 7600H
ja error

mov ah, 0xE
mov al, 'N'
int 10H

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
jnc error

mov ah, 0xE
mov al, 'Y'
int 10H

jmp KernelAddr:KernelOffset

;;;;;;;;;;;;;;;;;;;;;;
;; Hang the machine ;;
;;;;;;;;;;;;;;;;;;;;;;

error:
  jmp $
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fill free space with zeroes ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

times 510 - ($ - $$) db 0

;;;;;;;;;;;;;;;;;;;;;;;;
;; Make disk bootable ;;
;;;;;;;;;;;;;;;;;;;;;;;;

dw 0xaa55

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Boot sector ends here ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;