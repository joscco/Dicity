extends Area2D

var speed = 2000
var damage = 3
var bounce = 0
var pierce = 0



func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Bullet_area_entered(area):
	if area.is_in_group("mobs"):
		area.hit(damage)
		get_node("../GameManager").playSound("hit")
		queue_free()
		

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.hit(damage)
		get_node("../GameManager").playSound("hit")
		queue_free()
