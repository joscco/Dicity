extends "res://UI/ScalingButton.gd"

func on_pressed():
	get_tree().change_scene("res://Characters/MainGameScene.tscn")
	SoundManager.playMusic()
