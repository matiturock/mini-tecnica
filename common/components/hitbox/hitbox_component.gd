@icon("res://assets/icons/hitbox-icon.svg")
class_name HitBoxComponent
extends Area2D

@export var damage: float = 1.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		area.take_damage(damage)
