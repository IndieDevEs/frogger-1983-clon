extends Area2D

const STEP = 32
onready var t = $Tween
onready var anim = $AnimatedSprite

func _input(event):
	if !t.is_active():
		if event.is_action_pressed("right"):
			move(Vector2.RIGHT)
			anim.frame = 0
			anim.play("right")
			anim.flip_h = false
		elif event.is_action_pressed("left"):
			move(Vector2.LEFT)
			anim.frame = 0
			anim.play("right")
			anim.flip_h = true
		elif event.is_action_pressed("up"):
			move(Vector2.UP)
			anim.frame = 0
			anim.play("up")
			anim.flip_h = false
		elif event.is_action_pressed("down"):
			move(Vector2.DOWN)
			anim.frame = 0
			anim.play("down")
			anim.flip_h = false

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
