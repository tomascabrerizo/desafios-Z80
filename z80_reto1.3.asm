bagon_8x8: 
	db #88, #f8, #fe, #ff, #bb, #15, #4a, #04, #11, #f1, #f7, #ff, #bb, #15, #4a, #04
carril_4x4:
	db #5f, #40, #60, #50

org #4000
run main

main:
;; [ATTRIBUTOS]
	ld hl, #c370
	ld de, bagon_8x8
;; [FUNCION] render_sprite_8x8: dibuja sprite apuntado por DE donde apunta HL
	ld b, #2 ;; loop de 2 externo separa sprite en primera y segunda midad
	ld c, #8 ;; loop de 8 interno

	ld a, (de)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	inc de
	dec c
	jr nz, $-#8 ;; fin loop interno
	
	ld a, h
	sub a, #40
	ld h, a
	inc hl
	dec b
	jr nz, $-#12 ;; fin loop externo
;; [FIN FUNCION]

;; [ATTRIBUTOS]
	ld hl, #c3c0
	ld de, carril_4x4
;; [LOOP] loop exterior que cubre el ancho de la pantalla con vias
	ld b, #50
;; [FUNCION] render_sprite_4x4: dibuja sprite apuntado por DE donde apunta HL
	ld c, #4
	
	ld a, (de)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	inc de
	dec c
	jr nz, $-#8
;; [FIN FUNCION]
	ld de, carril_4x4
	ld a, h
	sub a, #20
	ld h, a
	inc hl
	dec b
	jr nz, $-#15
;; [FIN LOOP]
	jr $
