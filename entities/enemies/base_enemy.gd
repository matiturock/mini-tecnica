class_name BaseEnemy
extends CharacterBody2D

@export var max_speed: float = 100.0
@export var damage_amount:float = 1.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurbox_component: HurtBoxComponent = $HurtBoxComponent
@onready var hitbox_component: HitBoxComponent = $HitBoxComponent
