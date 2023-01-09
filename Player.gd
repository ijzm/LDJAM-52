extends KinematicBody2D

const UP = Vector2(0, -1)
const EPSILON = 0.1

export (int) var MAXSPEED = 100
export (int) var ACCELERATION = 10
export (PackedScene) var Bullet
export (float) var ATTACK_RATE = 0.4

export (int) var speed_upgrade = 0
export (int) var shield_upgrade = 0
export (int) var attack_upgrade = 0

export (float) var speed_upgrade_amount = MAXSPEED / 3
export (float) var shield_upgrade_amount = 0.0
export (float) var attack_upgrade_amount = -0.1

var rng = RandomNumberGenerator.new()
var weapon_sounds = []
var hurt_sound

var motion = Vector2()

var Score = 0

var Ui

# Called when the node enters the scene tree for the first time.
func _ready():
	Ui = get_node("/root/Game/GameUI")
	weapon_sounds.append(preload("res://assets/sfx/LD52_SFX_-_Shooting_Short_1.wav"))
	weapon_sounds.append(preload("res://assets/sfx/LD52_SFX_-_Shooting_Short_2.wav"))

	hurt_sound = preload("res://assets/sfx/LD52 SFX - Hurt.wav")

func Move():
	var CURRENT_MAXSPEED = MAXSPEED + speed_upgrade * speed_upgrade_amount
	motion.x = clamp(motion.x, -CURRENT_MAXSPEED, CURRENT_MAXSPEED)
	motion.y = clamp(motion.y, -CURRENT_MAXSPEED, CURRENT_MAXSPEED)

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

func Shoot():
	if Input.is_action_pressed("click") and $WeaponTimer.is_stopped():

		var target = get_global_mouse_position()
		var dir    = (target - position).normalized()

		var bullet = Bullet.instance()
		bullet.set_direction(dir)
		bullet.set_as_toplevel(true)

		bullet.global_position = position + dir * 35
		add_child(bullet)
		bullet.rotation = dir.angle()

		$WeaponTimer.start(ATTACK_RATE + attack_upgrade * attack_upgrade_amount)

		$WeaponSound.stream = weapon_sounds[rng.randi_range(0, len(weapon_sounds) - 1)]
		$WeaponSound.play()

func _physics_process(_delta):
	Move()
	Animation()
	Shoot()

	

func add_score(amount):
	Score += amount
	Ui.update_ui()

func handle_hurt(_body, _direction):
	if $HealthTimer.is_stopped():
		$WeaponSound.stream = hurt_sound
		$WeaponSound.play()
		
		$HealthTimer.start()
		$BlinkAnimationPlayer.play("hurt")
