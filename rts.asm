; Caelis Chaos ZX v0.1

BARRACKS EQU 0x27
ENEMY_BARRACKS EQU 0xA7
FORTRESS EQU 0x2B
ENEMY_FORTRESS EQU 0xAB
GRUNT EQU 0x2C
ENEMY_GRUNT EQU 0xAC

ORG 16393

			; addr	name
DB 0		; 16393	VERSN
DW 0		; 16394	E_PPC
DW dfile	; 16396	D_FILE
DW dfile+1	; 16398	DF_CC
DW vars		; 16400	VARS
DW 0		; 16402 DEST
DW eline	; 16404 E_LINE
DW 0		; 16406	CH_ADD
DW 0		; 16408	X_PTR
DW eline+1	; 16410 STKBOT
DW eline+1	; 16412	STKEND
DB 0		; 16414 BERG
DW 16477	; 16415 MEM
DB 0		; 16417 N/A
DB 2		; 16418 DF_SZ
DW 0		; 16419	S_TOP	
DW 0xFFFF 	; 16421 LAST_K
DB 0xFF		; 16423
DB 55	 	; 16424 MARGIN
DW basic	; 16425 NXTLIN
DW 0		; 16427 OLDPPC
DB 0		; 16429 FLAGX
DW 0		; 16430 STRLEN
DW 0		; 16432 T_ADDR
DW 0		; 16434 SEED
DW 0xFFFF	; 16436 FRAMES
DB 0		; 16438 COORDS
DB 0		; 16439 
DB 0xBC		; 16440 PR_CC
DB 33		; 16441 S_POSN
DB 24		; 16442
DB 0x40		; 16443 CDFLAG
DEFS 32, 0		
DB 0x76		; 16444 PRBUFF
DEFS 30, 0	; 16477 MEMBOT
DW 0

basic: 
	DB 0, 1
	DW l1end - l1start
	
l1start:
	
	DB 0xEA ; Start of the code
	
game_loop:
		
	load_screen:
		LD HL, dfile
	
	update_loop:
	
		call random
		
		INC HL
		LD A, (vars)
		CP (HL)
		JR Z, wait_start
		
		LD A, (HL)
		grunt:
			CP GRUNT
			JR NZ, enemy_grunt
			INC HL
			LD A, (HL)
			DEC HL
			CP ENEMY_GRUNT
			JR Z, fight
			CP 0				; OR A uses 1 less byte
			JR NZ, update_loop
			LD (HL), 0
			INC HL
			LD (HL), GRUNT
			JR update_loop
		enemy_grunt:
			CP ENEMY_GRUNT
			JR NZ, barracks
			DEC HL
			LD A, (HL)
			INC HL
			CP 0
			JR NZ, update_loop
			LD (HL), 0
			DEC HL
			LD (HL), ENEMY_GRUNT
			JR update_loop
		barracks:
			CP BARRACKS
			JR NZ, enemy_barracks
			;LD (HL), ENEMY_BARRACKS
			JR update_loop
		enemy_barracks:
			CP ENEMY_BARRACKS
			JR NZ, fortress
			;LD (HL), BARRACKS
			JR update_loop
		fortress:
			CP FORTRESS
			JR NZ, enemy_fortress
			;LD (HL), ENEMY_FORTRESS
			JR update_loop
		enemy_fortress:
			CP ENEMY_FORTRESS
			JR NZ, no_building
			;LD (HL), FORTRESS
		no_building:
			JR update_loop
			
	fight:
		call random
		CP 128
		JR Z, tie
		JR C, player_grunt_wins
		JR NC, enemy_grunt_wins
	
	tie:
		LD (HL), 0
		INC HL
		LD (HL), 0
		JR update_loop
	
	player_grunt_wins:
		INC HL
		LD (HL), 0
		JR update_loop
	
	enemy_grunt_wins:
		LD (HL), 0
		JR update_loop
	

; WAIT for 15 frames
wait_start:
	LD HL, prog_vars	
	LD B, 15

wait_loop:
	inner_wait_loop:	
		LD A, (16436)
		CP (HL)
		LD (prog_vars), A
		JR Z, inner_wait_loop
	DJNZ wait_loop
	JR game_loop
	
random:
	LD A, (prog_vars+1)
	SRL A
	JR NC, skip_xor
	XOR 0xB8
skip_xor:
	LD (prog_vars+1), A	
	ret

prog_vars:	
	DB 0x0	; Frames copy	
	DB 0x15 ; Random byte
	DB 0x76 ; End of the code
	

	
	
l1end:
	DB 0, 2
	DW dfile - l2start
	
l2start:
	DB 0xF9
	DB 0xD4
	DB 0xC5		; VAL
	DB 0x0B		; "
	DB 0x1D		; 1
	DB 0x22		; 6
	DB 0x21		; 5
	DB 0x1D		; 1
	DB 0x20		; 4
	DB 0x0B		; "
	DB 0x76		; Line terminator
	
	
dfile:
	DB 0x76
	DB 0x1C, 0x76	; Gold
	
	
	; Upper lane
	upper_lane:
		DB 0, BARRACKS, GRUNT
		DEFS 24, 0
		DB ENEMY_GRUNT, ENEMY_BARRACKS, 0x76
	
	; Fortress lane
	fortress_lane:
		DB FORTRESS
		DEFS 28, 0
		DB ENEMY_FORTRESS, 0x76
	
	; Lower lane
	lower_lane:
		DB 0, BARRACKS, GRUNT
		DEFS 24, 0
		DB ENEMY_GRUNT, ENEMY_BARRACKS, 0x76
	
	DEFS 20, 0x76

vars:
	DB 0x80
	
eline:



