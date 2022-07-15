extends Area2D

var speed = 2000
var damage = 3

onready var offScreenChecker: VisibilityNotifier2D = $OffScreenChecker

func _ready():
	connect("body_entered", self, "_on_body_entered")
	offScreenChecker.connect("screen_exited", self, "_on_screen_exited")

func _physics_process(delta):
	position += transform.x * speed * delta
	
func _on_screen_exited():
	queue_free()
		
func _on_body_entered(body: Node):
	if body.is_in_group("mobs"):
		body.call_deferred("hit", damage)
		SoundManager.playSound("hit")
		queue_free()
