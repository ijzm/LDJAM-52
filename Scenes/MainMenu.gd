extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	var game = preload ("res://Scenes/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	queue_free()

func _on_CreditsButton_pressed():
	var game = preload ("res://Scenes/Credits.tscn").instance()
	get_tree().get_root().add_child(game)
	queue_free()
