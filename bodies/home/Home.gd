extends Area2D

onready var anim = $AnimatedSprite
var speed = 0
var ExtraPoints = preload("res://bodies/extraPoints/ExtraPoints.tscn")

func _on_Home_area_entered(area):
	if area.is_in_group("frogger"):
		if anim.animation == "Empty" or anim.animation == "Butterfly":
			area.t.stop_all()
			area.Plunk.play()
			area.restart()
			if anim.animation == "Butterfly":
				get_tree().current_scene.add_score(200)
				add_child(ExtraPoints.instance())
			else:
				get_tree().current_scene.add_score(50)
			anim.play("OK")
		else:
			area.dead()

func butterfly():
	anim.play("Butterfly")
	yield(get_tree().create_timer(5),"timeout")
	anim.play("Empty")

func lizard():
	anim.play("Lizard")
	yield(anim,"animation_finished")
	anim.play("Empty")
