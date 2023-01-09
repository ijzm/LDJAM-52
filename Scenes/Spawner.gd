extends Node2D

export (PackedScene) var Enemy
var rng = RandomNumberGenerator.new()

func _ready():
	$Timer.start(rng.randf_range(3.0, 10.0))

func _on_Timer_timeout():
	var newEnemy = Enemy.instance()
	newEnemy.set_as_toplevel(true)
	newEnemy.global_position = position
	add_child(newEnemy)

	$Timer.start(rng.randf_range(3.0, 10.0))
