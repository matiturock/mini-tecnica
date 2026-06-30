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
var _offset_collision_hit: float = 50 ## Distante in px of CollisionHit from the center of Player


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
	elif  input_vector.x < 0:
		animated_sprite_2d.flip_h = true
		collision_hit.position.x = -_offset_collision_hit
		_last_direction = Direction.LEFT
	else:
		animated_sprite_2d.flip_h = false if _last_direction == Direction.RIGHT else true


func _on_player_died() -> void:
	set_process(false)
	set_physics_process(false)
	(func(): $CollisionShape2D.disabled = true).call_deferred()

	play_death_animation()


func play_death_animation() -> void:
	# 1. Creamos el Tween usando el método oficial del nodo
	var tween: Tween = create_tween()

	# 2. Configuramos todas las animaciones iniciales para que ocurran simultáneamente
	tween.set_parallel(true)

	# - El "Salto" hacia arriba inicial (Eje Y)
	tween.tween_property(animated_sprite_2d, "position:y", animated_sprite_2d.position.y - 50.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# - Rotación dramática en el aire
	tween.tween_property(animated_sprite_2d, "rotation_degrees", 180.0, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# - Escala (Se encoge hacia la nada)
	tween.tween_property(animated_sprite_2d, "scale", Vector2.ZERO, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	# - Modulación (Desvanecimiento a transparente)
	tween.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.5)

	# 3. Usamos chain() para romper el paralelismo y programar la caída y la destrucción
	# La caída del eje Y ocurre DESPUÉS de que el salto inicial termine
	tween.chain().tween_property(animated_sprite_2d, "position:y", animated_sprite_2d.position.y + 100.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# 4. Al final de toda la secuencia de Tweeners, ejecutamos el callback para liberar el nodo
	tween.chain().tween_callback(queue_free)


func _on_player_hurt(_damage: float, attacker_area: Area2D) -> void:
	# 1. CALCULAR DIRECCIÓN DEL GOLPE (Knockback)
	# Restamos la posición global del atacante de la nuestra para obtener el vector de empuje
	var push_direction: Vector2 = global_position - attacker_area.global_position

	# Normalizamos el vector para quedarnos solo con la dirección (longitud 1)
	# y multiplicamos por la fuerza deseada en el eje X
	var knockback_force: float = 250.0
	velocity.x = push_direction.normalized().x * knockback_force

	# 2. IMPACT FRAME (Ralentizar el tiempo del juego)
	Engine.time_scale = 0.1

	# 3. CONFIGURAR EL TWEEN (Ignorando el time_scale del motor)
	var tween: Tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_parallel(true)

	# - Flash Rojo: Modulamos el sprite hacia un rojo intenso
	tween.tween_property(animated_sprite_2d, "modulate", Color(1.8, 0.2, 0.2, 1.0), 0.15).set_trans(Tween.TRANS_SINE)

	# - Frenado: Reducimos la velocidad del knockback gradualmente en 0.3 segundos
	tween.tween_property(self, "velocity:x", 0.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 4. ENCADENAR LA RESTAURACIÓN (Con chain para esperar a que lo anterior termine)
	# Mantenemos el congelamiento un breve instante más usando el intervalo oficial
	tween.chain().tween_interval(0.2)

	# Restauramos el color original del Sprite
	tween.chain().tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.1)

	# Devolvemos el tiempo del juego a la normalidad de forma paralela al cambio de color
	tween.parallel().tween_callback(func(): Engine.time_scale = 1.0)
