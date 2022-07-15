extends CanvasLayer

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func transitionTo(scenePath: String):
	animationPlayer.play("closeCurtain")
	yield(animationPlayer,"animation_finished")
	get_tree().change_scene(scenePath)
	animationPlayer.play_backwards("closeCurtain")
	
