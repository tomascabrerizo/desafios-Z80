org #4000
run main

bagon_8x8 : db #88, #f8, #fe, #ff, #bb, #15, #4a, #04, #11, #f1, #f7, #ff, #dd, #8a, #25, #02
barril_8x8: db #99, #6f, #9f, #ff, #6f, #9f, #f9, #60, #00, #00, #00, #00, #00, #00, #00, #00

exp1_8x8  : db #80, #74, #72, #71, #71, #72, #74, #80, #10, #e2, #e4, #e8, #e8, #e4, #e2, #10
exp2_8x8  : db #f8, #f5, #d1, #e6, #e6, #d1, #f5, #f8, #f1, #fa, #b8, #76, #76, #b8, #fa, #f1
exp3_8x8  : db #77, #aa, #cc, #88, #88, #cc, #aa, #77, #ee, #55, #33, #11, #11, #33, #55, #ee

carril_4x4: db #5f, #40, #60, #50

start_key: db #2f
reset_key: db #32

barril_offset_p: db #28
bagon_last_p: db #00
player_p: dw #c370

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
	push de ;; guardamos el valor antiguo de de en el stack
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
	pop de ;; volvemos a setear de como estaba antes de llamar a la funcion
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] render_explotion animation
;; [1]: args hl con la direccion de memoria de video
;; [modifies]: registro c
;; -------------------------------------------------------------
render_expotion_animation:
	ld de, exp1_8x8
	call render_sprite_8x8
	ld c, #20
	exp_wait_loop_1: ;; retraso de (0,0033 * 24) segundos
		halt
		dec c
	jr nz, exp_wait_loop_1
	ld de, exp2_8x8
	call render_sprite_8x8
	ld c, #20
	exp_wait_loop_2: ;; retraso de (0,0033 * 24) segundos
		halt
		dec c
	jr nz, exp_wait_loop_2
	ld de, exp3_8x8
	call render_sprite_8x8
	ld c, #20
	exp_wait_loop_3: ;; retraso de (0,0033 * 24) segundos
		halt
		dec c
	jr nz, exp_wait_loop_3
	call render_clear_8x8
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] render_bagon animation
;; [1]: args hl con la direccion de memoria de video
;; -------------------------------------------------------------
render_bagon_animation: 
	push hl ;; guardar estado de antigua hl
	ld de, bagon_8x8 ;; sprite 8x8 que se va a dibujar
	ld a, (barril_offset_p)
	;;sub a, #2 ;; restamos dos a A ya que el carro debe detenerse una posicion antes que el barril
	ld b, a
	bagon_animation_loop:
		call render_sprite_8x8
		ld c, #08
		wait_loop: ;; retraso de (0,0033 * 24) segundos
			halt
			dec c
		jr nz, wait_loop
		call render_clear_8x8
		
		push hl
		ld a, (start_key) ;; si z == 0 el carrito se movera, sino se acaba el programa
		call #bb1e ;; KM_TEST_KEY
		pop hl
		jr nz, end_bagon_animation
	
		inc hl
		inc hl
		dec b ;; decrementamos 2 veces b porque avazamos de a 8 pixeles no de a 4
		dec b
	jr nz, bagon_animation_loop
	end_bagon_animation:
		call l_set_last_bagon_position
		pop hl ;; recupera estado antiguo de hl
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : hl_get_barril_position
;; [description]: calcula posicion del barril se debe y la guarda en HL
;; [out]        : HL con la posicion
;; -------------------------------------------------------------
hl_get_barril_position:
	ld hl, #c370
	ld a, (barril_offset_p)
	add a, l
	ld l, a
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : hl_get_last_bagon_position
;; [description]: calcula posicion donde el bagon se detuvo la guarda en HL
;; [out]        : HL con la posicion
;; -------------------------------------------------------------
hl_get_last_bagon_position:
	ld h, #c3
	ld a, (bagon_last_p)
	ld l, a
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : set_last_bagon_position
;; [description]: guarda en (bagon_last_p) la posicion en el registo L
;; [modifies]   : register a
;; -------------------------------------------------------------
l_set_last_bagon_position:
	ld a, l
	ld (bagon_last_p), a
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : a_set_barril_count_x2
;; [description]: devulve el numero de barriles x2 que hay que dibujar 
;;		  dependiendo de la posicion del primer barril
;; [modifies]   : register b 
;; [out]        : A con la cantidad de barriles a dibujar
;; -------------------------------------------------------------
a_get_barril_count_x2:
	ld a, (barril_offset_p)
	ld b, a
	ld a, #50 ;; (max barril count) * 2
	sub a, b
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : move_player
;; [description]: mueve el jugador una posicion
;; [input]      : registro b con la direccion 1 derecha, -1 izquiera
;; [modifies]   : hl, de, a
;; -------------------------------------------------------------
move_player:
	ld hl, (player_p)
	ld a, l
	add a, b ;; calculamos la nueva posicion y la guardamos en a
	sub a, #6f
	jr z, end_move_player ;; si la nueva posicion esta fuera de la pantalla terminamos la funcion
	ld a, #08
	player_speed_loop:
		halt
		dec a
	jr nz, player_speed_loop
	call render_clear_8x8 ;; clear old player pos
	ld a, l
	add a, b ;; calculamos la nueva posicion y la guardamos en a
	ld l, a
	ld (player_p), hl ;; guardamos la nueva posicion del jugador
	ld de, bagon_8x8 ;; cargamos el sprite del player
	call render_sprite_8x8
	end_move_player:
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

	init_animation:
		ld de, bagon_8x8 
		ld hl, #c370
		call render_sprite_8x8 ;; render initial bagon
	
		call hl_get_last_bagon_position 
		call render_clear_8x8 ;; clear last bagon

		ld de, barril_8x8 
		call hl_get_barril_position
		call a_get_barril_count_x2
		ld b, a
		barril_loop:
			call render_sprite_8x8
			inc hl
			inc hl
			dec b ;; decrementamos 2 a A ya que el numero de barriles se encuntra mult por 2
			dec b
		jr nz, barril_loop
		ld hl, (player_p)
		ld de, bagon_8x8
		call render_sprite_8x8
		get_input:
			ld a, #1b
			call #bb1e ;; KM_TEST_KEY
		jr nz, move_right ;; pulsamos P
			ld a, #22
			call #bb1e ;; KM_TEST_KEY
		jr nz, move_left ;; pulsamos o
		jp get_input ;; si no pulsamos nada volvemos a chequear
		move_right:
			ld b, #01
			call move_player
			jp get_input
		move_left:
			ld b, #ff
			call move_player
			jp get_input