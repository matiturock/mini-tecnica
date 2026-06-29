class_name Player
extends CharacterBody2D

enum Direction { LEFT, RIGHT }

@export var max_speed = 300.0
@export var acceleration: float = 2500
@export var friction: float = 2300

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtBoxComponent = $HurtboxComponent

var input_vector: Vector2 = Vector2.ZERO
var last_direction: Direction = Direction.RIGHT
var is_attacking: bool = false


func _ready() -> void:
	hurtbox_component.hurt.connect(health_component._on_hurt)


func _physics_process(_delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if not is_attacking:
		_update_direction()

	move_and_slide()


func _update_direction() -> void:
	if input_vector.x > 0:
		animated_sprite_2d.flip_h = false
		last_direction = Direction.RIGHT
	elif  input_vector.x < 0:
		animated_sprite_2d.flip_h = true
		last_direction = Direction.LEFT
	else:
		animated_sprite_2d.flip_h = false if last_direction == Direction.RIGHT else true
