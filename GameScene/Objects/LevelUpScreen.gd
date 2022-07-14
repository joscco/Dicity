extends Control

func _ready():
	hide()

func _physics_process(delta):
	if Input.is_action_pressed("leftClick"):
		get_tree().paused = false
		hide()
