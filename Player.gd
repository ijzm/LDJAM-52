extends KinematicBody2D

const UP = Vector2(0, -1)
const EPSILON = 0.1

export (int) var MAXSPEED = 100
export (int) var ACCELERATION = 10
export (PackedScene) var Bullet


var motion = Vector2()

var Score = 0

var Ui

# Called when the node enters the scene tree for the first time.
func _ready():
	Ui = get_node("/root/Game/GameUI")

func Move():
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	motion.y = clamp(motion.y, -MAXSPEED, MAXSPEED)
	
	if Input.is_action_pressed("right"):
		motion.x += ACCELERATION
	elif Input.is_action_pressed("left"):
		motion.x -= ACCELERATION
	else:
		motion.x = lerp(motion.x, 0, 0.2)

	if Input.is_action_pressed("up"):
		motion.y -= ACCELERATION
	elif Input.is_action_pressed("down"):
		motion.y += ACCELERATION
	else:
		motion.y = lerp(motion.y, 0, 0.2)
	
	motion = move_and_slide(motion, UP)

func Animation():
	if Input.is_action_pressed("right") and Input.is_action_pressed("up"):
		$AnimationPlayer.play("move_up_right")
	elif Input.is_action_pressed("right") and Input.is_action_pressed("down"):
		$AnimationPlayer.play("move_down_right")

	elif Input.is_action_pressed("left") and Input.is_action_pressed("up"):
		$AnimationPlayer.play("move_up_left")
	elif Input.is_action_pressed("left") and Input.is_action_pressed("down"):
		$AnimationPlayer.play("move_down_left")


	elif Input.is_action_pressed("up"):
		$AnimationPlayer.play("move_up")
	elif Input.is_action_pressed("down"):
		$AnimationPlayer.play("move_down")
	elif Input.is_action_pressed("left"):
		$AnimationPlayer.play("move_left")
	elif Input.is_action_pressed("right"):
		$AnimationPlayer.play("move_right")
		
func _physics_process(_delta):
	Move()
	Animation()

	if Input.is_action_pressed("click") and $WeaponTimer.is_stopped():

		var target = get_global_mouse_position()
		var dir    = (target - position).normalized()

		var bullet = Bullet.instance()
		bullet.set_direction(dir)
		bullet.set_as_toplevel(true)

		bullet.global_position = position + dir * 30
		add_child(bullet)
		bullet.rotation = dir.angle()

		$WeaponTimer.start()

func add_score(amount):
	Score += amount
	Ui.update_ui()