extends Node2D

var posTween
var alphaTween

# Called when the node enters the scene tree for the first time.
func _ready():
	posTween = $PosTween
	alphaTween = $AlphaTween
	transform = get_transform()
	posTween.interpolate_property(self, 'position', null, $EndAnchor.position, 1.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	alphaTween.interpolate_property(self, 'modulate', null, Color(1,1,1,0), 1.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)

func reset():
	position = $StartAnchor.position
	modulate = Color(1,1,1,1)
