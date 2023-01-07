extends RigidBody2D

export (int) var FORCE_AMOUNT = 1000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func handle_hit(body, direction):
	print(body.position)
	#var dir = (position - body.position).normalized()
	apply_impulse(position, direction * FORCE_AMOUNT)

func handle_compactor():
	queue_free()