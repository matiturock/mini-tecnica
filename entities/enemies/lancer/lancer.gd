class_name Lancer
extends BaseEnemy

enum Direction { LEFT, RIGHT }

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hitbox_collision_shape_2d: CollisionShape2D = $HitBoxComponent/CollisionShape2D2
@onready var detect_range_area_2d: Area2D = $DetectRangeArea2D
@onready var attack_range_area_2d: Area2D = $AttackRangeArea2D
@onready var healthbar_component: HealthbarComponent = $HealthbarComponent
@onready var bt_player: BTPlayer = $BTPlayer
@onready var collision_hit: CollisionShape2D = $HitBoxComponent/CollisionShape2D2

var impact_frame: int = 1
var can_attack: bool = false
var is_attacking: bool = false
var _last_direction: Direction = Direction.RIGHT
var _offset_collision_hit: float = 90 ## Distante in px of CollisionHit from the center of Player


func _ready() -> void:
	# Hitbox arranca deshabilitada
	hitbox_collision_shape_2d.disabled = true

	# Cadena de daño: HurtBox → HealthComponent → Healthbar
	hurbox_component.hurt.connect(health_component._on_hurt)
	hurbox_component.hurt.connect(_on_lancer_hurt)
	health_component.died.connect(_on_lancer_died)

	cooldown_timer.start()
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

	# Animación
	animated_sprite_2d.frame_changed.connect(_on_frame_changed)

	# Sensores → Blackboard
	detect_range_area_2d.area_entered.connect(_on_player_detected)
	detect_range_area_2d.area_exited.connect(_on_player_out_of_range)
	attack_range_area_2d.area_entered.connect(_on_attack_range_entered)
	attack_range_area_2d.area_exited.connect(_on_attack_range_exited)


func _physics_process(_delta: float) -> void:
	if is_attacking:
		return
	_update_direction()
	if velocity.length() > 0.0:
		animated_sprite_2d.play(&"run")
	else:
		animated_sprite_2d.play(&"idle")


func _update_direction() -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		collision_hit.position.x = _offset_collision_hit
		_last_direction = Direction.RIGHT
	elif  velocity.x < 0:
		animated_sprite_2d.flip_h = true
		collision_hit.position.x = -_offset_collision_hit
		_last_direction = Direction.LEFT
	else:
		animated_sprite_2d.flip_h = false if _last_direction == Direction.RIGHT else true


func attack() -> void:
	if not can_attack:
		return
	can_attack = false
	is_attacking = true
	animated_sprite_2d.play(&"attack")
	await animated_sprite_2d.animation_finished
	is_attacking = false


func _on_frame_changed() -> void:
	if animated_sprite_2d.animation == &"attack" and animated_sprite_2d.frame == impact_frame:
		(func(): hitbox_collision_shape_2d.disabled = false).call_deferred()
		await animated_sprite_2d.frame_changed
		(func(): hitbox_collision_shape_2d.disabled = true).call_deferred()


func _on_cooldown_timer_timeout() -> void:
	can_attack = true


#region Sensors

func _on_player_detected(area: Area2D) -> void:
	if area.get_owner() is Player:
		bt_player.blackboard.set_var("target", area.get_owner())

func _on_player_out_of_range(area: Area2D) -> void:
	if area.get_owner() is Player:
		bt_player.blackboard.set_var("target", null)

func _on_attack_range_entered(area: Area2D) -> void:
	if area.get_owner() is Player:
		print("Entrando en rango de ataque")
		bt_player.blackboard.set_var("in_range_attack", true)

func _on_attack_range_exited(area: Area2D) -> void:
	if area.get_owner() is Player:
		print("Saliendo de rango de ataque")
		bt_player.blackboard.set_var("in_range_attack", false)

#endregion Sensors


#region Animations

func _on_lancer_hurt(_damage: float, attacker_area: Area2D) -> void:
	# 1. Calcular dirección del empujón (Desde el jugador hacia el Lancer)
	var push_direction: Vector2 = global_position - attacker_area.global_position
	var knockback_force: float = 200.0
	velocity.x = push_direction.normalized().x * knockback_force

	# 2. Impact Frame global (Ralentiza el juego brevemente)
	Engine.time_scale = 0.1

	# 3. Tween de feedback visual (Flash Blanco e ignorando el time_scale)
	var tween: Tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_parallel(true)

	# Flash Blanco: Subimos los valores RGB por encima de 1.0 para que brille
	tween.tween_property(animated_sprite_2d, "modulate", Color(2.0, 2.0, 2.0, 1.0), 0.1)
	# Frenado del enemigo
	tween.tween_property(self, "velocity:x", 0.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 4. Restauración del estado normal
	tween.chain().tween_interval(0.15)
	tween.chain().tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.1)
	tween.parallel().tween_callback(func(): Engine.time_scale = 1.0)


func _on_lancer_died() -> void:
	# Desactivamos el procesamiento y colisiones del enemigo para que no estorbe
	set_process(false)
	set_physics_process(false)
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	# Iniciamos secuencia de muerte con Tween
	var tween: Tween = create_tween()
	tween.set_parallel(true)

	# Arco de salto (Eje Y)
	tween.tween_property(animated_sprite_2d, "position:y", animated_sprite_2d.position.y - 40.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Rotación de caída
	tween.tween_property(animated_sprite_2d, "rotation_degrees", -180.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Encogerse
	tween.tween_property(animated_sprite_2d, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# Desvanecerse
	tween.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.4)

	# Caída libre después del salto inicial
	tween.chain().tween_property(animated_sprite_2d, "position:y", animated_sprite_2d.position.y + 120.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Eliminar al enemigo de la escena definitivamente
	tween.chain().tween_callback(queue_free)

#endregion
