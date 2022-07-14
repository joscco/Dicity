extends "res://GeneralScene/GUI/ScalingButton.gd"

func on_pressed():
	get_tree().change_scene("res://GameScene/GameScene.tscn")
	SoundManager.playMusic()
