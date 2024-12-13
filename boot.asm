; boot.asm - A simple bootloader with keyboard input

BITS 16              ; 16-bit code for legacy BIOS boot
ORG 0x7C00           ; BIOS loads the bootloader here in memory

start:
    ; Print welcome message
    mov ah, 0x0E      ; BIOS teletype function (print character)
    mov si, msg       ; Load the address of the welcome message

print_loop:
    lodsb             ; Load byte at [SI] into AL and increment SI
    cmp al, 0         ; Check if end of string (null terminator)
    je read_input     ; Jump to 'read_input' if AL == 0
    int 0x10          ; Call BIOS interrupt to print the character
    jmp print_loop    ; Repeat

read_input:
    ; Prompt for keyboard input
    mov si, prompt    ; Load the address of the prompt message

prompt_loop:
    lodsb             ; Load byte at [SI] into AL and increment SI
    cmp al, 0         ; Check if end of string (null terminator)
    je wait_key       ; Jump to 'wait_key' if AL == 0
    int 0x10          ; Call BIOS interrupt to print the character
    jmp prompt_loop   ; Repeat

wait_key:
    ; Wait for and read a key press
    xor ah, ah        ; BIOS function 0x16, AH=0 waits for keypress
    int 0x16          ; Call BIOS interrupt to get key
    mov ah, 0x0E      ; BIOS teletype function to print the character
    int 0x10          ; Print the key to the screen

done:
    hlt               ; Halt CPU

msg db "Welcome to my OS!", 0 ; Welcome message
prompt db "Press a key: ", 0  ; Prompt message

TIMES 510-($-$$) db 0         ; Pad to 510 bytes
dw 0xAA55                     ; Boot sector signature
