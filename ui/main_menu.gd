class_name MainMenu
extends Control

@export var main_level: PackedScene

@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	if main_level:
		get_tree().change_scene_to_packed(main_level)


func _on_quit_pressed() -> void:
	get_tree().quit()
