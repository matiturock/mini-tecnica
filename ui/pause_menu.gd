class_name PauseMenu
extends Control

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_resume()


func _on_resume_pressed() -> void:
	_resume()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _resume() -> void:
	get_tree().paused = false
	queue_free()
