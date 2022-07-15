extends Node

export (PackedScene) var Enemy

export var initialDelay := 2
export var delayDecay := 0.99

onready var EnemyClass = preload("res://GameScene/Characters/Enemy.tscn")

var player = null
var timer = null
var levelUpScreen = null

var hp = 10
var maxHp
var maxAmmo = 10
var ammo = maxAmmo
var level = 1
var xp = 0

func spawn():
	timer.set_wait_time(timer.wait_time*delayDecay)
	timer.start()
	var enemy = EnemyClass.instance()
	var offset = Vector2(rand_range(100, 200), rand_range(100, 200))
	if randf() > 0.5:
		offset.x = -offset.x
	if randf() > 0.5:
		offset.y = -offset.y
	enemy.transform.origin = player.position + offset
	get_tree().current_scene.find_node("Characters").add_child(enemy)


func prepareForMaingame():
	hp = 10
	ammo = 10
	level = 1
	xp = 0
	
	levelUpScreen = get_tree().current_scene.find_node("LevelUpScreen")
	player = get_tree().current_scene.find_node("Player")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(initialDelay)
	timer.connect("timeout", self, "spawn")
	add_child(timer)
	timer.start()
	
func addAmmo(amount: int) :
	ammo += amount

func addXP(amount: int):
	xp += amount
	if xp > getRequiredXP():
		levelUp()
		
func addHP(amount: int):
	hp += amount
	if hp <= 0:
		die()
		
func die():
	timer.stop()
	TransitionManager.transitionTo("res://GameOverScene/GameOverScene.tscn")

func getRequiredXP() -> int:
	return level * 2

func levelUp():
	level += 1
	xp = 0
	levelUpScreen.show()
	get_tree().paused = true
