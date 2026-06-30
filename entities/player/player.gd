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
@onready var collision_hit: CollisionShape2D = $HitboxComponent/CollisionShape2D

var input_vector: Vector2 = Vector2.ZERO
var _last_direction: Direction = Direction.RIGHT
var is_attacking: bool = false
var _offset_collision_hit: float = 50

# Variable para pasar datos de colisión al estado Hurt
var last_attacker_area: Area2D = null

func _ready() -> void:
	hurtbox_component.hurt.connect(health_component._on_hurt)
	hurtbox_component.hurt.connect(_on_player_hurt)
	health_component.died.connect(_on_player_died)

func _physics_process(_delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if not is_attacking:
		_update_direction()

	move_and_slide()

func _update_direction() -> void:
	if input_vector.x > 0:
		animated_sprite_2d.flip_h = false
		collision_hit.position.x = _offset_collision_hit
		_last_direction = Direction.RIGHT
	elif input_vector.x < 0:
		animated_sprite_2d.flip_h = true
		collision_hit.position.x = -_offset_collision_hit
		_last_direction = Direction.LEFT
	else:
		animated_sprite_2d.flip_h = false if _last_direction == Direction.RIGHT else true

func _on_player_hurt(_damage: float, attacker_area: Area2D) -> void:
	# Guardamos la referencia y transicionamos a Hurt usando el string correcto (nombre del nodo hijo)
	last_attacker_area = attacker_area
	state_machine._on_child_transition("hurt")

func _on_player_died() -> void:
	# Transicionamos directamente al estado definitivo de muerte
	state_machine._on_child_transition("dead")
