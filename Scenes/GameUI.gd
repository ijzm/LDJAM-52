extends Control

var Player

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_node("/root/Game/Player")

func update_ui():
	get_node("CanvasLayer/ScoreText").text = "%04d" % Player.Score
