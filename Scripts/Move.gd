class_name Player
extends KinematicBody2D

export (int) var speed = 200

# Player Stats
export var hp := 10
export var xp := 0
export var ammo := 10

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
onready var sprite = $Sprite
onready var gun = $Gun

func _ready():
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
			GameManager.playSound("shoot")
			GameManager.playSound("shells")			
			timer.start()
			var bullet = Bullet.instance()
			owner.add_child(bullet)
			bullet.transform = $Gun/Muzzle.global_transform

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

func rotateSprite():
	if velocity[0] > 0:
		sprite.flip_h = false
	elif velocity[0] < 0:
		sprite.flip_h = true
	
func _physics_process(delta):
	
	gun.look_at(get_global_mouse_position())
	get_input()
	rotateSprite()
	velocity = move_and_slide(velocity)


# Pickup XP
func _on_XP_pickuparea_area_entered(area):
	if area.is_in_group("xp"):
		GameManager.playSound("blip")
		GameManager.xp += 1
		if GameManager.xp%2 == 0:
			GameManager.levelUp()
		area.queue_free()
