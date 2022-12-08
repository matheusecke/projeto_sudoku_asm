title MATHEUS ECKE MEDEIROS RA: 22004797

.model small

    LIMPA_TELA MACRO
        ; limpa tela
        MOV AL, 03H
        MOV AH, 00H
        INT 10H
        ENDM

    PRINT_CHAR MACRO
        ; print de char
        MOV AH, 02
        INT 21H
        ENDM

    PRINT_STRING MACRO
        ; print de string
        MOV AH, 09
        INT 21H
        ENDM

    INPUT_CHAR MACRO
        ; le um char
        MOV AH, 01
        INT 21H
        ENDM

    PULA_LINHA MACRO
        ; pula linha 1 vez
        MOV DL, 0AH
        PRINT_CHAR
        ENDM

    PULA_2_LINHA MACRO
        ; pula linha 2 vezes
        MOV DL, 0AH
        PRINT_CHAR
        INT 21H
        ENDM

    ESPACO MACRO
        ; da um espaco
        MOV DL, ' '
        PRINT_CHAR
        ENDM
    
    TAB MACRO
        ; da um TAB
        MOV DL, ' '
        PRINT_CHAR
        INT 21H
        INT 21H
        ENDM

    VERIFICA_ENTER MACRO

        CMP AL, 13
        JE ENCERRAR
        ENDM

.data
    linha           DB      '================================================================================$'
    sudoku          DB      '                                     SUDOKU                                     $'
    texto1          DB      '       > COMPLETE OS QUADRANTES E LINHAS COM OS NUMEROS 1-9                     $'
    texto2          DB      '       > NAO REPITA UM MESMO NUMERO EM UMA LINHA OU QUADRANTE                   $'
    texto3          DB      '       > NA SELECAO DA COLUNA DIGITE AS LETRAS EM LETRA MAIUSCULA!              $'
    texto4          DB      '       > PRESSIONE <ENTER> A QUALQUER MOMENTO PARA ENCERRAR O JOGO                   $'
    texto5          DB      '                  | PRESSIONE QUALQUER TECLA PARA CONTINUAR |                   $'
    texto6          DB      '   > ESCOLHA A LINHA:  $'
    texto7          DB      '   > ESCOLHA A COLUNA: $'
    texto8          DB      '   > NUMERO (1-9):     $'
    colunasudoku    DB      '       A   B   C   D   E   F   G   H   I                                        $'
    linhasudoku     DB      ?
    salvabx         DW      ?
    salvasi         DW      ?

    matriz  DB  35H,33H,30H,30H,37H,30H,30H,30H,30H     ; 1  0     
            DB  36H,30H,30H,31H,39H,35H,30H,30H,30H     ; 2  9     
            DB  30H,39H,38H,30H,30H,30H,30H,36H,30H     ; 3  18    
            DB  38H,30H,30H,30H,36H,30H,30H,30H,33H     ; 4  27    
            DB  34H,30H,30H,38H,30H,33H,30H,30H,31H     ; 5  36    
            DB  37H,30H,30H,30H,32H,30H,30H,30H,36H     ; 6  45    
            DB  30H,36H,30H,30H,30H,30H,32H,38H,30H     ; 7  54    
            DB  30H,30H,30H,34H,31H,39H,30H,30H,35H     ; 8  63    
            DB  30H,30H,30H,30H,38H,30H,30H,37H,39H     ; 9  72    

.code

    MAIN PROC

        MOV AX, @DATA
        MOV DS, AX

        CALL INICIO
        REPETE:
        CALL JOGO
        CALL RESPOSTA
        JMP REPETE

        FIM:
        CALL FIM_PROGRAMA

    MAIN ENDP

    JOGO PROC
        
        LIMPA_TELA
        PULA_LINHA
        MOV BX, 0
        MOV SI, 0
        MOV linhasudoku, 30H
        LEA DX, colunasudoku
        PRINT_STRING
        PULA_LINHA

        MOV CX, 9
        PROXIMA_LINHA:
            PULA_LINHA
            ESPACO
            INC linhasudoku
            MOV DL, linhasudoku
            PRINT_CHAR
            MOV DL, ')'
            PRINT_CHAR
            TAB
            ESPACO

            MOV DH, 9
            PROXIMA_COLUNA:
                CMP matriz[BX][SI], 30H
                JNE NAO_VAZIO
                MOV DL, ' '
                PRINT_CHAR
                JMP VAZIO
                NAO_VAZIO:
                MOV DL, matriz[BX][SI]
                PRINT_CHAR

                VAZIO:
                TAB
                INC SI
                DEC DH
                JNZ PROXIMA_COLUNA
        LOOP PROXIMA_LINHA

        RET

    JOGO ENDP

    RESPOSTA PROC

        PULA_2_LINHA
        PULA_LINHA
        LEA DX, texto6
        PRINT_STRING
        INPUT_CHAR
        VERIFICA_ENTER
        SUB AL, 31H
        XOR AH, AH
        MOV CH, 9
        MUL CH
        MOV salvabx, AX
        PULA_LINHA

        LEA DX, texto7
        PRINT_STRING
        INPUT_CHAR
        VERIFICA_ENTER
        SUB AL, 41H
        XOR AH, AH
        MOV salvasi, AX
        PULA_LINHA

        LEA DX, texto8
        PRINT_STRING
        INPUT_CHAR
        VERIFICA_ENTER
        MOV BX, salvabx
        MOV SI, salvasi
        MOV matriz[BX][SI], AL
        JMP RETORNA

        ENCERRAR:
        JMP FIM
        RETORNA:
        RET

    RESPOSTA ENDP

    INICIO PROC

        LIMPA_TELA
        PULA_LINHA

        LEA DX, linha
        PRINT_STRING
        PULA_LINHA
        LEA DX, sudoku
        PRINT_STRING
        PULA_2_LINHA
        LEA DX, texto1
        PRINT_STRING
        LEA DX, texto2
        PRINT_STRING
        LEA DX, texto3
        PRINT_STRING
        PULA_2_LINHA
        LEA DX, texto4
        PRINT_STRING
        PULA_2_LINHA
        LEA DX, LINHA
        PRINT_STRING
        INPUT_CHAR

        RET

    INICIO ENDP

    FIM_PROGRAMA PROC

        PULA_2_LINHA
        MOV AH, 4CH
        INT 21H

    FIM_PROGRAMA ENDP

end MAIN