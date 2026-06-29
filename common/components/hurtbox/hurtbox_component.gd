@icon("res://assets/icons/hurtbox-icon.svg")
class_name HurtBoxComponent
extends Area2D

signal hurt(damage: float)

func take_damage(damage: float) -> void:
	hurt.emit(damage)
