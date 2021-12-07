org #4000
run main

bagon_8x8: 
	db #88, #f8, #fe, #ff, #bb, #15, #4a, #04, #11, #f1, #f7, #ff, #dd, #8a, #25, #02
carril_4x4:
	db #5f, #40, #60, #50
start_key:
	db #2f
reset_key:
	db #32

;; -------------------------------------------------------------
;; [FUNCION] render_sprite_8x8: dibuja sprite apuntado por DE donde apunta HL
;; -------------------------------------------------------------
render_sprite_8x8:
	push bc ;; guardamos el valor antiguo de bc en el stack
	push de ;; guardamos el valor antiguo de de en el stack
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
	dec hl ;; reinicio hl a posicion inicial
	dec hl
	ld a, #10
	pop de ;; volvemos a setear de como estaba antes de llamar a la funcion
	pop bc ;; volvemos a setear bc como estaba antes de llamar a la funcion
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] render_clear_8x8 borra sprite 8x8 donde apunta HL
;; -------------------------------------------------------------
render_clear_8x8:
	push bc ;; guardamos el valor antiguo de bc en el stack
	ld b, #2 ;; loop de 2 externo separa sprite en primera y segunda midad
render_clear_8x8_external_loop:
	ld c, #8 ;; loop de 8 interno
render_clear_8x8_internal_loop:
	ld (hl), #00
	ld a, #08
	add a, h
	ld h, a
	dec c
	jr nz, render_clear_8x8_internal_loop ;; fin loop interno
	ld a, h
	sub a, #40
	ld h, a
	inc hl
	dec b
	jr nz, render_clear_8x8_external_loop ;; fin loop externo
	dec hl ;; reinicio hl a posicion inicial
	dec hl
	pop bc ;; volvemos a setear bc como estaba antes de llamar a la funcion
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] render_sprite_4x4: dibuja sprite apuntado por DE donde apunta HL
;; -------------------------------------------------------------
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
	ld a, h
	sub a, #20
	ld h, a ;; reinicia hl a su posicion inicial
	ld a, #04
render_sprite_4x4_reset_de:
	dec de
	dec a
	jp nz, render_sprite_4x4_reset_de
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] render_bagon animation
;; -------------------------------------------------------------
;; [1]: args hl con la direccion de memoria de video
render_bagon_animation: 
	push hl ;; guardar estado de antigua hl
	ld de, bagon_8x8 ;; sprite 8x8 que se va a dibujar
	ld b, #14
bagon_animation_loop:
	call render_sprite_8x8
	ld c, #18
wait_loop: ;; retraso de (0,0033 * 32) segundos
	halt
	dec c
	jr nz, wait_loop
	call render_clear_8x8
	inc hl
	inc hl
	dec b
	jr nz, bagon_animation_loop
	pop hl ;; recupera estado antiguo de hl
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; main program
;; -------------------------------------------------------------
main:
;; render todos los carriles
	ld hl, #c3c0 ;; posicion de memoria de video donde dibujar sprite
	ld de, carril_4x4 ; sprite 4x4 que se va a dibujar
;; [LOOP] loop que cubre el ancho de la pantalla con vias
	ld b, #50
carril_loop:
	call render_sprite_4x4
	ld de, carril_4x4
	inc hl
	dec b
	jr nz, carril_loop ;; [FIN LOOP]

get_input:
	ld hl, #c370 
	ld de, bagon_8x8
	call render_sprite_8x8 ;; render initial bagon

	ld a, (start_key) ;; si z == 0 el carrito se movera, sino se acaba el programa
	call #bb1e ;; KM_TEST_KEY
	jp z, get_input	;; loop infinito hasta que presionemos start e inicia animacion

	ld hl, #c370 ;; posicion de memoria de video donde dibujar sprite
	call render_bagon_animation

fin_animacion:
	ld a, (reset_key) ;; si z == 0 el carrito se movera, sino se acaba el programa
	call #bb1e ;; KM_TEST_KEY
	jp nz, get_input ;; loop infinito hasta que presionemos reset
	jp fin_animacion








