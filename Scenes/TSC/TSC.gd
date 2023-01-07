extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var game
# Called when the node enters the scene tree for the first time.
func _ready():
	game = preload ("res://World.tscn").instance ()
	$"Camera2D/TSC Jingle".play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TSC_Jingle_finished():
	get_tree().get_root().add_child(game)
	hide()

	
