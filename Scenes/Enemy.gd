extends RigidBody2D


enum ENEMY_STATE {
	ATTACKING,
	RAGDOLL
}

export (int) var FORCE_AMOUNT = 200
export (int) var SPEED = 50

var Player
var State = ENEMY_STATE.ATTACKING


func _ready():
	Player = get_node("/root/Game/Player")

func Animate(dir):
	var Vectors = [
		Vector2.UP,
		Vector2.UP + Vector2.RIGHT,
		Vector2.RIGHT,
		Vector2.DOWN + Vector2.RIGHT,
		Vector2.DOWN,
		Vector2.DOWN + Vector2.LEFT,
		Vector2.LEFT,
		Vector2.UP + Vector2.LEFT
	]

	var Dirs = [
		"move_up",
		"move_up_right",
		"move_right",
		"move_down_right",
		"move_down",
		"move_down_left",
		"move_left",
		"move_up_left"
	]

	var minIndex = 0
	var minValue = 10000

	for i in len(Vectors):
		var val = dir.angle_to(-Vectors[i])
		if val < minValue:
			minValue = val
			minIndex = i

	$AnimationPlayer.play(Dirs[minIndex])
	

func _integrate_forces(state):
	if Player == null:
		print("Couldn't find player")
		return
	
	match State:
		ENEMY_STATE.ATTACKING:
			state.linear_velocity = (Player.position - position).normalized() * SPEED
			Animate(state.linear_velocity)

		ENEMY_STATE.RAGDOLL:
			pass
		
		_:
			print("ERROR STATE")


func handle_hit(_body, direction):
	#var dir = (position - body.position).normalized()
	
	State = ENEMY_STATE.RAGDOLL
	apply_impulse(position, direction * FORCE_AMOUNT)
	$StunnedTimer.start()

func handle_compactor():
	Player.add_score(1)
	queue_free()

func _on_StunnedTimer_timeout():
	State = ENEMY_STATE.ATTACKING
