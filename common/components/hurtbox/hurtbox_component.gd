@icon("res://assets/icons/hurtbox-icon.svg")
class_name HurtBoxComponent
extends Area2D

signal hurt(damage: float, area: Area2D)

func take_damage(damage: float, area: Area2D) -> void:
	hurt.emit(damage, area)
