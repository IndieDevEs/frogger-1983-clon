extends Area2D

export var speed = 32
func _physics_process(delta):
	global_position.x += speed * delta
	if global_position.x < -64:
		global_position.x = 512
	elif global_position.x > 512:
		global_position.x = -64
