extends Node2D


var tween

onready var tween_values = [Vector2(1,1), Vector2(1.1,1.1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = $Tween
	_start_tween()

func _start_tween():
	tween.interpolate_property(self,'scale',tween_values[0],tween_values[1],2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)    
	tween.start()


func _on_Tween_tween_completed(object, key):
	tween_values.invert()
	_start_tween()

func highlight():
	$Sprite.modulate = Color.blue
	
func  delight():
	$Sprite.modulate = Color.white

func _input(event):
	if $Sprite.get_rect().has_point(get_local_mouse_position()):
		highlight()
	else:
		delight()
