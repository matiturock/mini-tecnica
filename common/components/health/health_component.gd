@tool
@icon("res://assets/icons/health-icon.svg")
class_name HealthComponent
extends Node

signal health_changed(current_health: float)
signal died

@export var max_health: float = 3.0

var is_depleted: bool = false
var _current_health: float = 3.0
var current_health: float:
	get:
		return _current_health
	set(value):
		if is_depleted:
			return
		_current_health = clampf(value, 0.0, max_health)
		health_changed.emit(current_health)
		if _current_health <= 0.0:
			is_depleted = true
			died.emit()
		else:
			is_depleted = false


func _ready() -> void:
	current_health = max_health


func _on_hurt(damage: float, _area: Area2D) -> void:
	current_health -= damage


func health_recovery(amount: float) -> void:
	current_health += amount
