extends "res://GeneralScene/GUI/ScalingButton.gd"

func on_pressed():
	TransitionManager.transitionTo("res://GameScene/GameScene.tscn")
	SoundManager.playSound("plop")
