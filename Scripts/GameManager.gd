extends Node

export (PackedScene) var Enemy

export var initialDelay := 2
export var delayDecay := 0.99

onready var EnemyClass = preload("res://Characters/Ghost.tscn")

onready var HitSound = preload("res://Sounds/hit.mp3")
onready var ShellSound = preload("res://Sounds/shells.mp3")
onready var ShootSound = preload("res://Sounds/shoot.mp3")
onready var BlipSound = preload("res://Sounds/blip.wav")

var player = null
var timer = null
var levelUpScreen = null


var hp
var maxHp
var maxAmmo = 10
var ammo = maxAmmo
var xp = 0


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

	get_tree().current_scene.find_node("Characters").add_child(b)
	
func playSound(sfx = "hit"):
	var asp = AudioStreamPlayer2D.new()
	
	add_child(asp)
	if sfx == "hit":
		asp.stream = HitSound
	if sfx == "shells":
		asp.stream = ShellSound
	if sfx == "shoot":
		asp.stream = ShootSound
	if sfx == "blip":
		asp.stream = BlipSound
	asp.play()


func prepareForMaingame():

	levelUpScreen = get_tree().current_scene.find_node("LevelUpScreen")
	player = get_tree().current_scene.find_node("Player")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(initialDelay)
	timer.connect("timeout", self, "spawn")
	add_child(timer)
	timer.start()


func levelUp():
	levelUpScreen.show()
	get_tree().paused = true
