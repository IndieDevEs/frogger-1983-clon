extends Area2D

signal jump_up
signal is_dead
signal respawned
const STEP = 32
onready var t = $Tween
onready var anim = $AnimatedSprite
onready var spawn = global_position
onready var Jump = $Jump
onready var Plunk = $Plunk
onready var Squash = $Squash
var is_on_water = false
var platform = 0
var platform_move = 0
var is_alive = true

func _input(event):
	if event is InputEventKey:
		if !t.is_active() and is_alive:
			if event.is_action_pressed("right") and global_position.x < 432:
				move(Vector2.RIGHT)
				anim.frame = 0
				anim.play("right")
				anim.flip_h = false
				Jump.play()
			elif event.is_action_pressed("left")  and global_position.x > 16:
				move(Vector2.LEFT)
				anim.frame = 0
				anim.play("right")
				anim.flip_h = true
				Jump.play()
			elif event.is_action_pressed("up"):
				move(Vector2.UP)
				anim.frame = 0
				anim.play("up")
				anim.flip_h = false
				emit_signal("jump_up")
				Jump.play()
			elif event.is_action_pressed("down") and global_position.y < 448:
				move(Vector2.DOWN)
				anim.frame = 0
				anim.play("down")
				anim.flip_h = false
				Jump.play()

func move(dir):
	var new_pos = global_position + dir*STEP
	t.interpolate_property(self,
			"global_position",
			global_position,
			new_pos,
			0.3,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN,
			0)
	t.start()

func _physics_process(delta):
	if is_alive:
		var pos = global_position
		if pos.x <-16 or pos.x >464 or pos.y < -16 or pos.y > 496:
			dead()
		if platform <= 0:
			if is_on_water:
				dead()
			platform_move = 0
		else:
			global_position.x += platform_move * delta

func dead():
	if is_alive:
		is_alive = false
		anim.play("dead")
		emit_signal("is_dead")
		Squash.play()
		yield(anim,"animation_finished")
		restart()

func restart():
	global_position = spawn
	is_on_water = false
	is_alive = true
	anim.play("down")
	yield(anim,"animation_finished")
	platform = 0
	emit_signal("respawned")

func _on_Frogger_area_entered(area):
	if area.is_in_group("platform"):
		platform += 1
		platform_move = area.speed
	elif area.is_in_group("water"):
		is_on_water = true
	elif area.is_in_group("enemy"):
		dead()

func _on_Frogger_area_exited(area):
	if area.is_in_group("platform"):
		platform -= 1
	elif area.is_in_group("water"):
		is_on_water = false
