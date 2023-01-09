extends Node2D

export (int) var speed = 10

var direction = Vector2.ZERO

func _physics_process(_delta):
	if(direction != Vector2.ZERO):
		position += direction * speed

func set_direction(dir):
	self.direction = dir


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body:Node):
	if body.has_method("handle_hit"):
		body.handle_hit(self, direction)
	queue_free()
