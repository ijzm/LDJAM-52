extends Control

func _on_BackButton_pressed():
	var game = load ("res://Scenes/MainMenu.tscn").instance()
	get_tree().get_root().add_child(game)
	queue_free()
