class_name Player
extends KinematicBody2D

export (int) var speed = 500

# Gun Stats
export (PackedScene) var Bullet
export var bulletDelay := 0.1
export var clipSize := 16
export var reloadTime := 0.5

var velocity = Vector2()

# Timer
var timer = null
var reloadTimer = null
var can_shoot = true

# Playerobjs
onready var renderer = $PlayerRenderer
onready var pickupArea = $XPPickupArea

func _ready():
	pickupArea.connect("area_entered", self, "_on_XP_pickuparea_area_entered")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bulletDelay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
	reloadTimer = Timer.new()
	reloadTimer.set_one_shot(true)
	reloadTimer.set_wait_time(reloadTime)
	reloadTimer.connect("timeout", self, "reload")
	add_child(reloadTimer)

func on_timeout_complete():
	can_shoot = true
	
func reload():
	GameManager.ammo = GameManager.maxAmmo
	
func shoot():
	if can_shoot and GameManager.ammo > 0:
		GameManager.ammo -= 1
		if GameManager.ammo <= 0:
			reloadTimer.start()
		else:
			can_shoot = false
			SoundManager.playSound("shells")			
			timer.start()
			var bullet = Bullet.instance()
			owner.add_child(bullet)
			bullet.position = renderer.getMuzzle().global_position
			bullet.rotation = renderer.getMuzzle().global_rotation

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("leftClick"):
		shoot()

	velocity = velocity.normalized() * speed
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	renderer.adaptToVelocity(velocity)

# Pickup XP
func _on_XP_pickuparea_area_entered(area):
	if area.is_in_group("xp"):
		area.startFollowing(self)
