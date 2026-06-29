class_name MainLevel
extends Node2D

@export var pause_menu: PackedScene


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			return
		_open_pause_menu()


func _open_pause_menu() -> void:
	get_tree().paused = true
	var menu := pause_menu.instantiate()
	get_tree().root.add_child(menu)
