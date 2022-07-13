extends KinematicBody2D

export var speed := 200
export var dir := Vector2(0,0)


func move():
	dir = dir.normalized() * speed
	look_at(dir)

func _physics_process(delta):
	dir = move_and_slide(dir)
