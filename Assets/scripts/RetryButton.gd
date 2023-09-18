extends Button

func _on_RetryButton_pressed():
	var current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	get_tree().change_scene_to_file("res://Assets/Scenes/main_scene.tscn")
	current_scene.queue_free()

