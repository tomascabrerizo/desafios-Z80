org #4000
run main

bagon_8x8: 
	db #88, #f8, #fe, #ff, #bb, #15, #4a, #04, #11, #f1, #f7, #ff, #dd, #8a, #25, #02
carril_4x4:
	db #5f, #40, #60, #50

;; [FUNCION] render_sprite_8x8: dibuja sprite apuntado por DE donde apunta HL
render_sprite_8x8:
	ld b, #2 ;; loop de 2 externo separa sprite en primera y segunda midad
render_sprite_8x8_external_loop:
	ld c, #8 ;; loop de 8 interno
render_sprite_8x8_internal_loop:
	ld a, (de)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	inc de
	dec c
	jr nz, render_sprite_8x8_internal_loop ;; fin loop interno
	
	ld a, h
	sub a, #40
	ld h, a
	inc hl
	dec b
	jr nz, render_sprite_8x8_external_loop ;; fin loop externo
	ret
;; [FIN FUNCION]

;; [FUNCION] render_sprite_4x4: dibuja sprite apuntado por DE donde apunta HL
render_sprite_4x4:
	ld c, #4
render_sprite_4x4_loop:
	ld a, (de)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	inc de
	dec c
	jr nz, render_sprite_4x4_loop
	ret
;; [FIN FUNCION]

main:
	ld hl, #c3c0 ;; posicion de memoria de video donde dibujar sprite
	ld de, carril_4x4 ; sprite 4x4 que se va a dibujar
;; [LOOP] loop que cubre el ancho de la pantalla con vias
	ld b, #50
carril_loop:
	call render_sprite_4x4
	ld de, carril_4x4
	ld a, h
	sub a, #20
	ld h, a
	inc hl
	dec b
	jr nz, carril_loop ;; [FIN LOOP]
	
	ld hl, #c370 ;; posicion de memoria de video donde dibujar sprite
	ld de, bagon_8x8 ;; sprite 8x8 que se va a dibujar
	call render_sprite_8x8

	jr $