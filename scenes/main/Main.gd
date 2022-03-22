extends Node2D

onready var Score = $CanvasLayer/Control/ColorRect/HBoxContainer/VBoxContainer/Score
onready var ScoreGameOver = $CanvasLayer/Control/GameOver/VBoxContainer/Score
onready var MaxScore = $CanvasLayer/Control/ColorRect/HBoxContainer/VBoxContainer2/MaxScore
onready var MaxScoreGameOver = $CanvasLayer/Control/GameOver/VBoxContainer/HighScore
onready var Life = $CanvasLayer/Control/ColorRect2/HBoxContainer/Life
onready var Homes = $Homes.get_children()
onready var HomeTimer = $HomeTimer
onready var LizardTimer = $LizardTimer
onready var Frogger = $Frogger
onready var timer = $Timer
onready var Progress = $CanvasLayer/Control/ColorRect2/HBoxContainer/ProgressBar
onready var GameOver = $CanvasLayer/Control/GameOver
var max_score = 0
var score = 0
var time = 60
var lifes = 3
var start = false
var game_over = false

func _ready():
	get_tree().paused = false
	max_score = load_data("high_score.dat")
	MaxScore.text = str(max_score)

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("retry"):
			get_tree().reload_current_scene()
		elif event.is_action_pressed("pause") and !game_over:
			get_tree().paused = !get_tree().paused
		if event.is_pressed() and !start:
			start = true
			$CanvasLayer/Control/Start.hide()
			timer.start()
			HomeTimer.start()
			LizardTimer.start()

func add_score(points):
	score += points
	Score.text = str(score)

func _on_Frogger_jump_up():
	add_score(10)

func _on_Timer_timeout():
	time -= 1
	Progress.value = time
	if time <= 0:
		Frogger.dead()

func _on_Frogger_is_dead():
	timer.stop()
	if lifes > 1:
		lifes -= 1
		Life.text = str(lifes)
	else:
		if score > max_score:
			max_score = score
			save_data(max_score,"high_score.dat")
		ScoreGameOver.text = str(score)
		MaxScoreGameOver.text = str(max_score)
		GameOver.show()
		game_over = true
		get_tree().paused = true

func _on_Frogger_respawned():
	time = 60
	Progress.value = time
	timer.start()
	check_homes()

func check_homes():
	var homes_ok = 0
	for home in Homes:
		if home.anim.animation == "OK":
			homes_ok += 1
	if homes_ok >= 5:
		add_score(1000)
		for home in Homes:
			home.anim.animation == "Empty"

func _on_HomeTimer_timeout():
	var list = []
	for home in Homes:
		if home.anim.animation == "Empty":
			list.append(home)
	if list.size() > 0:
		var random = randi()%list.size()
		list[random].butterfly()
	HomeTimer.wait_time = randi()%10+10
	HomeTimer.start()

func _on_LizardTimer_timeout():
	var list = []
	for home in Homes:
		if home.anim.animation == "Empty":
			list.append(home)
	if list.size() > 0:
		var random = randi()%list.size()
		list[random].lizard()
	LizardTimer.wait_time = randi()%10+10
	LizardTimer.start()

func save_data(data, filename):
	var file = File.new()
	file.open("user://"+filename, file.WRITE)
	file.store_var(data)
	file.close()

func load_data(filename):
	var file = File.new()
	if not file.file_exists("user://"+filename):
		return 0
	file.open("user://"+filename, file.READ)
	var data = file.get_var()
	file.close()
	return data
