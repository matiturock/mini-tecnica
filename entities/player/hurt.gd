extends State

@onready var player: Player = self.get_owner() as Player

func enter() -> void:
	if not player: return

	# 1. CALCULAR DIRECCIÓN DEL GOLPE (Knockback)
	if player.last_attacker_area:
		var push_direction: Vector2 = player.global_position - player.last_attacker_area.global_position
		var knockback_force: float = 250.0
		player.velocity.x = push_direction.normalized().x * knockback_force

	# 2. IMPACT FRAME (Ralentizar el motor)
	Engine.time_scale = 0.1

	# 3. OPCIONAL: Screen shake si existe una Camera2D en el Player
	if player.has_node("Camera2D"):
		_apply_camera_shake(player.get_node("Camera2D"), 0.2, 8.0)

	# 4. CONFIGURAR EL TWEEN DE RETROALIMENTACIÓN
	var tween: Tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_parallel(true)

	# Flash Rojo e interpolación de desaceleración lineal en x
	tween.tween_property(player.animated_sprite_2d, "modulate", Color(1.8, 0.2, 0.2, 1.0), 0.15).set_trans(Tween.TRANS_SINE)
	tween.tween_property(player, "velocity:x", 0.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 5. RESTAURACIÓN Y RETORNO AL FLUJO DEL JUEGO
	tween.chain().tween_interval(0.2)
	tween.chain().tween_property(player.animated_sprite_2d, "modulate", Color.WHITE, 0.1)
	tween.parallel().tween_callback(func(): Engine.time_scale = 1.0)

	# Al finalizar el tween, regresamos al estado base (Idle) de forma segura
	tween.chain().tween_callback(func(): transitioned.emit("idle"))

func _apply_camera_shake(camera: Camera2D, duration: float, intensity: float) -> void:
	var shake_tween: Tween = create_tween()
	shake_tween.set_ignore_time_scale(true)
	for i in range(5):
		var offset_pos: Vector2 = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		shake_tween.tween_property(camera, "offset", offset_pos, duration / 5.0)
	shake_tween.chain().tween_property(camera, "offset", Vector2.ZERO, 0.05)
