extends Area2D

export var speed = -24
export var is_trap = false
onready var anim = $AnimatedSprite
onready var timer = $Timer

func _ready():
	if is_trap:
		timer.start()

func _physics_process(delta):
	global_position.x += speed * delta
	if global_position.x < -64:
		global_position.x = 512
	elif global_position.x > 512:
		global_position.x = -64

func _on_Timer_timeout():
	anim.play("hideshow")
	$CollisionShape2D.disabled = true
	yield(anim,"animation_finished")
	anim.play("normal")
	$CollisionShape2D.disabled = false
	timer.start()
