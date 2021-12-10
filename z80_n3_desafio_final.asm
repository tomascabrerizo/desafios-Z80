org #4000
run main

barril_4_8x4: db #99, #6f, #9f, #ff, #6f, #9f, #f9, #60
barril_3_8x4: db #11, #00, #99, #bb, #6f, #9f, #f9, #60
barril_2_8x4: db #00, #00, #99, #11, #4c, #8a, #f9, #60
barril_1_8x4: db #00, #00, #00, #00, #00, #00, #54, #60
barril_5_8x4: db #00, #00, #00, #00, #00, #00, #00, #00

door_8x4  : db #06, #6f, #ff, #ff, #f3, #fb, #ff, #ff
key_8x4   : db #60, #90, #60, #20, #20, #60, #20, #e0

player_8x4_l: db #77, #9f, #1d, #1f, #57, #70, #27, #55
player_8x4_r: db #ee, #9f, #8b, #8f, #ae, #e0, #49, #aa

player_atk_8x4_l: db #ff, #17, #1d, #71, #02, #b8, #fe, #11
player_atk_8x4_r: db #ff, #8e, #8b, #e8, #04, #d1, #f7, #88

exp1_8x8: db #80, #74, #72, #71, #71, #72, #74, #80, #10, #e2, #e4, #e8, #e8, #e4, #e2, #10
exp2_8x8: db #f8, #f5, #d1, #e6, #e6, #d1, #f5, #f8, #f1, #fa, #b8, #76, #76, #b8, #fa, #f1
exp3_8x8: db #77, #aa, #cc, #88, #88, #cc, #aa, #77, #ee, #55, #33, #11, #11, #33, #55, #ee

carril_4x4: db #5f, #40, #60, #50

start_key: db #2f
reset_key: db #32

carril_p   : dw #c3c0

player_p    : dw #c388
player_atk_d: db #01 ;; 1 = right, -1 = left 

barril_1_p : dw #04b8 ;; H guarda las vidas y L la posicion
barril_2_p : dw #0478 ;; H guarda las vidas y L la posicion
barril_3_p : dw #04bf ;; H guarda las vidas y L la posicion
barril_4_p : dw #047f ;; H guarda las vidas y L la posicion

;; -------------------------------------------------------------
;; [FUNCION] delay_loop: retarda el juegos con el valor guardado en el registro A
;; -------------------------------------------------------------
delay:
	halt
	dec a
jr nz, delay
	ret
;; [FIN FUNCION]

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
	pop de ;; volvemos a setear de como estaba antes de llamar a la funcion
	pop bc ;; volvemos a setear bc como estaba antes de llamar a la funcion
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] render_sprite_8x4: dibuja sprite apuntado por DE donde apunta HL
;; -------------------------------------------------------------
render_sprite_8x4:
	push bc ;; guardamos el valor antiguo de bc en el stack
	push de ;; guardamos el valor antiguo de de en el stack
	ld b, #8 ;; loop de 8 interno
	render_sprite_8x4_loop:
		ld a, (de)
		ld (hl), a
		ld a, #08
		add a, h
		ld h, a
		inc de
		dec b
	jr nz, render_sprite_8x4_loop ;; fin loop interno
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
;; [FUNCION] render_clear_8x4: orra sprite 8x4 donde apunta HL
;; -------------------------------------------------------------
render_clear_8x4:
	push hl ;; guardamos el valor antiguo de hl en el stack
	push bc ;; guardamos el valor antiguo de bc en el stack
	ld b, #8 ;; loop de 8 interno
	render_clear_8x4_loop:
		ld (hl), #00
		ld a, #08
		add a, h
		ld h, a
		dec b
	jr nz, render_clear_8x4_loop ;; fin loop interno
	pop bc ;; volvemos a setear bc como estaba antes de llamar a la funcion
	pop hl ;; volvemos a setear hl como estaba antes de llamar a la funcion
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
;; [FUNCION] game_render_floor
;; [desc]    : render the game floor    
;; [modifies]: register DE, HL, B
;; -------------------------------------------------------------
game_render_floor:
	ld hl, (carril_p) ;; posicion de memoria de video donde dibujar sprite
	ld de, carril_4x4 ; sprite 4x4 que se va a dibujar
	;; [LOOP] loop que cubre el ancho de la pantalla con vias
	ld b, #50
	carril_loop:
		call render_sprite_4x4
		ld de, carril_4x4
		inc hl
		dec b
	jr nz, carril_loop ;; [FIN LOOP]
	ret
;; [FIN FUNCIO]

;; -------------------------------------------------------------
;; [FUNCION] game_render_player_r
;; [desc]    : renderiza al jugador en su posicion conrrespondiente    
;; [modifies]: register DE, HL, B
;; -------------------------------------------------------------
game_render_player_r:
	ld hl, (player_p) ;; posicion de memoria de video donde dibujar sprite
	ld de, player_8x4_r ; sprite 4x4 que se va a dibujar
	call render_sprite_8x4
	ret
;; [FIN FUNCIO]

;; -------------------------------------------------------------
;; [FUNCION] game_render_enemy
;; [desc]    : renderiza al enemigo en su posicion y con su vida, 
;;             se debe cargar en HL
;; [modifies]: register A, B
;; -------------------------------------------------------------
game_render_enemy:
	push hl ;; save enemy position and life
	ld a, l ;; guardamos la posicion en a
	ld b, h ;; guardamos las vidas en b
	ld hl, (player_p)
	ld l, a
	
	enemy_4:
		ld a, b
		sub a, #4
		jr nz, enemy_3
		ld de, barril_4_8x4
		call render_sprite_8x4
	enemy_3:
		ld a, b
		sub a, #3
		jr nz, enemy_2
		ld de, barril_3_8x4
		call render_sprite_8x4
	enemy_2:
		ld a, b
		sub a, #2
		jr nz, enemy_1
		ld de, barril_2_8x4
		call render_sprite_8x4
	enemy_1:
		ld a, b
		sub a, #1
		jr nz, enemy_5
		ld de, barril_1_8x4
		call render_sprite_8x4
	enemy_5:
		ld de, barril_5_8x4
		call render_sprite_8x4

	pop hl ;; get the position and life in hl
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] game_render_player_l
;; [desc]    : renderiza al jugador en su posicion conrrespondiente    
;; [modifies]: register DE, HL, B
;; -------------------------------------------------------------
game_render_player_l:
	ld hl, (player_p) ;; posicion de memoria de video donde dibujar sprite
	ld de, player_8x4_l ; sprite 4x4 que se va a dibujar
	call render_sprite_8x4
	ret
;; [FIN FUNCIO]

;; -------------------------------------------------------------
;; [FUNCION]: is_position_free
;; [input]  : registro A con posicion a testear 
;; [modifies]: registro B
;; -------------------------------------------------------------
is_position_free:
	push hl ;; save old HL state
	ld b, a
	
	collision_barril_1:
		ld hl, (barril_1_p)
		sub a, l;; test collision con barril
		jr z, have_life
	collision_barril_2:
		ld a, b
		ld hl, (barril_2_p)
		sub a, l;; test collision con barril
		jr z, have_life
	collision_barril_3:
		ld a, b
		ld hl, (barril_3_p)
		sub a, l;; test collision con barril
		jr z, have_life
	collision_barril_4:
		ld a, b
		ld hl, (barril_4_p)
		sub a, l;; test collision con barril
		jr z, have_life
	no_barril_collision:
		jr end_position_free
	
	have_life:
		ld a, h
		sub a, #0
		jr z, no_collision
		jr collision
		
	collision:
		ld a, #1
		dec a
		jr end_position_free	
	
	no_collision:
		ld a, #0
		inc a

	end_position_free:
		pop hl ;; get old HL state
	ret
;; [FIN FUNCION]


;; -------------------------------------------------------------
;; [FUNCION]    : game_move_player_r
;; [description]: mueve el jugador una posicion a la derecha
;; [modifies]   : hl, de, a
;; -------------------------------------------------------------
game_move_player_r:
	ld hl, (player_p)
	ld a, l
	inc a ;; get player next position
	call is_position_free
	jr z, end_move_right

	ld a, #0c
	call delay
	call render_clear_8x4 ;; borrar posicion del jugador anterior
	inc hl
	ld (player_p), hl
	call game_render_player_r ;; render player en su nueva posicion
	end_move_right:
		ld a, #01
		ld (player_atk_d), a ;; set la direccion de ataque a right
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : game_move_player_l
;; [description]: mueve el jugador una posicion a la izquierda
;; [modifies]   : hl, de, a
;; --------------------------------------------------------------
game_move_player_l:
	ld hl, (player_p)
	ld a, l
	dec a ;; get player next position
	call is_position_free
	jr z, end_move_left

	ld a, #0c
	call delay
	ld hl, (player_p)
	call render_clear_8x4 ;; borrar posicion de jugador anterior
	dec hl
	ld (player_p), hl
	call game_render_player_l ;; render player en su nueva posicion
	end_move_left:
		ld a, #ff
		ld (player_atk_d), a ;; set la direccion de ataque a left
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]: attak_if_enemy
;; [input]  : intenta atacar si hay un enemigo en la posicion de A
;; [modifies]: registro B
;; -------------------------------------------------------------
attack_if_enemy:
	push hl ;; save old HL state
	ld b, a
	attck_barril_1:
		ld hl, (barril_1_p)
		sub a, l;; test collision con barril
		jr nz, attck_barril_2
		ld a, h
		sub a, #0
		jp z, end_attak_if_enemy
		dec a
		ld (barril_1_p + 1), a
		ld h, a
		call game_render_enemy
	attck_barril_2:
		ld a, b
		ld hl, (barril_2_p)
		sub a, l;; test collision con barril
		jr nz, attck_barril_3
		ld a, h
		sub a, #0
		jp z, end_attak_if_enemy
		dec a
		ld (barril_2_p + 1), a
		ld h, a
		call game_render_enemy
	attck_barril_3:
		ld a, b
		ld hl, (barril_3_p)
		sub a, l;; test collision con barril
		jr nz, attck_barril_4
		ld a, h
		sub a, #0
		jp z, end_attak_if_enemy
		dec a
		ld (barril_3_p + 1), a
		ld h, a
		call game_render_enemy
	attck_barril_4:
		ld a, b
		ld hl, (barril_4_p)
		sub a, l;; test collision con barril
		jr nz, end_attak_if_enemy
		ld a, h
		sub a, #0
		jp z, end_attak_if_enemy
		dec a
		ld (barril_4_p + 1), a
		ld h, a
		call game_render_enemy

	end_attak_if_enemy:
		pop hl ;; get old HL state
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION]    : game_player_attack
;; [description]: ataka una posicion delante de la direccion que apunta
;; --------------------------------------------------------------
game_player_attack:
	;; testeamos direccion de ataque
	ld a, (player_atk_d)
	dec a
	jr z, atk_r ;; apundamos a la derecha
	ld a, (player_atk_d)
	inc a
	jr z, atk_l ;; apundamos a la izquierda
	atk_r:
		ld hl, (player_p)
		ld de, player_atk_8x4_r
		call render_sprite_8x4 ;; render animation atak
		ld a, #70
		call delay
		call game_render_player_r
		inc hl ;; calculamos la posicion del ataque
		ld c, l
		jr make_damage
	atk_l:
		ld hl, (player_p)
		ld de, player_atk_8x4_l
		call render_sprite_8x4 ;; render animation atak
		ld a, #70
		call delay
		call game_render_player_l
		dec hl ;; calculamos la posicion del ataque
		jr make_damage
	make_damage:
		ld a, l
		call attack_if_enemy
		
	ret
;; [FIN FUNCION]

;; -------------------------------------------------------------
;; [FUNCION] setup_positions
;; [desc]    : configura posisciones iniciales del juego    
;; [modifies]: register HL
;; -------------------------------------------------------------
setup_positions:
	ld hl, #c388
	ld (player_p), hl
	ld a, #01
	ld (player_atk_d), a
	ret
;; [FIN FUNCIO]

main:
	game_init: ;; inicializamos el estado inicial del juego
		call setup_positions
		call game_render_floor
		call game_render_player_r
		ld hl, (barril_1_p)
		call game_render_enemy
		ld hl, (barril_2_p)
		call game_render_enemy
		ld hl, (barril_3_p)
		call game_render_enemy
		ld hl, (barril_4_p)
		call game_render_enemy
	
	game_loop: ;; loop donde se calcula el juego
		get_input:
			ld a, #1b
			call #bb1e ;; KM_TEST_KEY
		jr nz, move_right ;; pulsamos P
			ld a, #22
			call #bb1e ;; KM_TEST_KEY
		jr nz, move_left ;; pulsamos o
			ld a, (start_key)
			call #bb1e ;; KM_TEST_KEY
		jr nz, attack ;; pulsamos o
		jp continue ;; si no pulsamos nada saltamos el input
		move_right:
			call game_move_player_r
			jp continue
		move_left:
			call game_move_player_l
			jp continue
		attack:
			call game_player_attack
			jp continue
		continue:
	jp game_loop

	game_end:
		ld a, (reset_key) ;; si z == 0 el carrito se movera, sino se acaba el programa
		call #bb1e ;; KM_TEST_KEY
		jp nz, game_init ;; loop infinito hasta que presionemos reset
	jr game_end
























