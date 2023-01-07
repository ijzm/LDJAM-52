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

func _integrate_forces(state):
	if Player == null:
		print("Couldn't find player")
		return
	
	match State:
		ENEMY_STATE.ATTACKING:
			state.linear_velocity = (Player.position - position).normalized() * SPEED

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
	queue_free()

func _on_StunnedTimer_timeout():
	State = ENEMY_STATE.ATTACKING
