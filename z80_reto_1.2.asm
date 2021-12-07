;; Comienzo del programa
org #4000
run main

bagon_8x8: 
	db #88, #f8, #fe, #ff, #bb, #15, #4a, #04, #11, #f1, #f7, #ff, #bb, #15, #4a, #04

main:
	ld hl, #c370
	call render_sprite_8x8
	jr $

render_sprite_8x8:
	ld a, (bagon_8x8)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#1)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#2)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#3)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#4)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#5)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#6)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#7)
	ld a, h
	sub a, #38
	ld h, a
	inc hl
	ld a, (bagon_8x8+#8)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#9)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#a)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#b)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#c)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#d)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#e)
	ld (hl), a
	ld a, #08
	add a, h
	ld h, a
	ld a, (bagon_8x8+#f)
	jr $