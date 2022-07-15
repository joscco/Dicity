extends Area2D

var aim: KinematicBody2D = null

func startFollowing(player: KinematicBody2D):
	aim = player

func _process(delta):
	if aim != null:
		var distance = (aim.position - position).length()
		if distance < 20:
			SoundManager.playSound("blip")
			GameManager.addXP(1)
			queue_free()
		else:
			position = lerp(position, aim.position, 20/distance)
			
		
