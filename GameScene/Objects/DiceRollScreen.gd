extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var die

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(GameManager.diceCount):
		var dieInstance = die.instance()
		add_child(dieInstance)
		dieInstance.position = $DiceAnchor.position + Vector2(i* 270,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
