extends KinematicBody2D

export var run_speed := 25
export var maxHp := 10
export var velocity := Vector2.ZERO
export var dmg := 1
export (PackedScene) var XP

onready var player = get_node("../Player")
onready var sprite = get_node("Sprite")
onready var target = player
onready var timer = null
onready var hitTimer = null
onready var enthralled = false
onready var hp = maxHp
onready var canHit = true

func _ready():
	randomize()
	add_to_group("mobs")
	timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "restoreColor")
	add_child(timer)
	
	hitTimer = Timer.new()
	hitTimer.set_wait_time(1)
	hitTimer.set_one_shot(true)
	hitTimer.connect("timeout",self,"canHitAgain")
	add_child(hitTimer)
	
	enthralled = randf()>0.9
	
func canHitAgain():
	canHit = true

func restoreColor():
	sprite.modulate = Color(1,1,1)
	if is_in_group("friends"):
		sprite.modulate = Color(.2,1,1)

func hit(dmg):
	hp -= dmg
	if hp <= 0:
		death()
	else:
		sprite.modulate = Color(1,.2,.2)
		timer.start()
		
		
func findEnemy():
	var enemies = get_tree().get_nodes_in_group("mobs")
	var lowestDist = 99999
	for enemy in enemies:
		var dist = get_global_transform().origin.distance_to(enemy.get_global_transform().origin)
		if dist < lowestDist:
			lowestDist = dist
			target = enemy
			

func death():
	remove_from_group("mobs")
	target = null
	if enthralled:
		add_to_group("friends")
		#set_collision_layer_bit( 2, false )
		hp = maxHp
		sprite.modulate = Color (.2,1,1)
		timer.stop()
		findEnemy()
	else:
		var b = XP.instance()
		get_node("..").add_child(b)
		b.transform = global_transform
		queue_free()
		

func _physics_process(delta):
	velocity = Vector2.ZERO

	if target:
		if is_instance_valid(target):
			if target.is_in_group("friends"):
				findEnemy()
			else:
				velocity = position.direction_to(target.position)
				var collision = move_and_collide(velocity * run_speed * delta)
				
				if collision:
					if collision.collider.is_in_group("player"):
						position-=  30*position.direction_to(collision.collider.position)
						if is_in_group("mobs") && canHit:
							canHit = false
							hitTimer.start()
							GameManager.addHP(-dmg)
							
					elif  canHit && is_in_group("friends") && collision.collider.is_in_group("mobs"):
						collision.collider.hit(dmg)
						canHit = false
						hitTimer.start()
					elif  canHit && is_in_group("mobs") && collision.collider.is_in_group("friends"):
						collision.collider.hit(dmg)
						canHit = false
						hitTimer.start()
					
		else:
			findEnemy()
	else:
		findEnemy()
		
	
	if velocity[0] > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
