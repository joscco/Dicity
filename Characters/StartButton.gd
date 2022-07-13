extends "res://UI/ScalingButton.gd"

func on_pressed():
	get_tree().change_scene("res://Scenes/MainGameScene.tscn")
	SoundManager.playMusic()
