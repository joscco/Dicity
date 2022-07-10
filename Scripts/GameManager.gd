extends Node

export (PackedScene) var Enemy

export var initialDelay := 2
export var delayDecay := 0.99

onready var EnemyClass = preload("res://Characters/Ghost.tscn")

onready var HitSound = preload("res://sounds/hit.mp3")
onready var ShellSound = preload("res://sounds/shells.mp3")
onready var ShootSound = preload("res://sounds/shoot.mp3")

onready var player = get_node("../Characters/Player")

var timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(initialDelay)
	timer.connect("timeout", self, "spawn")
	add_child(timer)
	timer.start()

func spawn():
	timer.set_wait_time(timer.wait_time*delayDecay)
	timer.start()
	var b = EnemyClass.instance()
	var offset = Vector2(rand_range(50,200),rand_range(50,200))
	if randf()>0.5:
		offset.x = -offset.x
	if randf()>0.5:
		offset.y = -offset.y
	b.transform.origin = player.position + offset

	get_node("../Characters").add_child(b)
	
func playSound(sfx = "hit"):
	var asp = AudioStreamPlayer2D.new()
	
	add_child(asp)
	if sfx == "hit":
		asp.stream = HitSound
	if sfx == "shells":
		asp.stream = ShellSound
	if sfx == "shoot":
		asp.stream = ShootSound
	asp.play()

