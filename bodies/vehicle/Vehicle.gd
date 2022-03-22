extends Area2D

export var direction = 1
export var speed = 64

func _physics_process(delta):
	global_position.x += direction * speed * delta
	if global_position.x < -64:
		global_position.x = 512
	elif global_position.x > 512:
		global_position.x = -64
