extends Node2D

onready var bodySprite: Sprite = $Body
onready var eyesSprite: Sprite = $Body/Eyes
onready var gunSprite: Sprite = $Body/Gun
onready var mullet: Node2D = $Body/Gun/Muzzle
onready var legs: Sprite = $Legs
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var running: bool = false
var wiggleIntensity: float = 5
var rotationIntensity: float = 0.1
var movementSpeed: float = 5

var rotationTime = 0
var wiggleTime = 0
		
func getMuzzle():
	print(mullet.position)
	return mullet
	
func adaptToVelocity(velocity: Vector2):
	if running and velocity.length() < 0.1:
		if animationPlayer.is_playing():
			yield(animationPlayer, "animation_finished")
		animationPlayer.play("idle")
		running = false
	elif !running and velocity.length() > 0.1:
		animationPlayer.play("run", 0.5, 1.7)
		running = true
		
	if velocity.x > 0.05:
		bodySprite.scale.x = 1
		legs.scale.x = 1
	elif velocity.x < -0.05:
		bodySprite.scale.x = -1
		legs.scale.x = -1

func _process(delta):
	
	var mousePosition = get_global_mouse_position()
	gunSprite.look_at(mousePosition)
	
	var relativeMousePosition = to_local(mousePosition)
	
	if relativeMousePosition.y < 0:
		gunSprite.z_index = -1
		eyesSprite.z_index = -1
	else:
		gunSprite.z_index = 1
		eyesSprite.z_index = 1
	
	rotationTime += delta
	bodySprite.rotation = rotationIntensity * sin(movementSpeed * rotationTime)
	if !running:
		wiggleTime += delta
		bodySprite.position.y = wiggleIntensity * sin(movementSpeed * wiggleTime)
		
