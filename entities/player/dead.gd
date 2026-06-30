extends State

@onready var player: Player = self.get_owner() as Player

func enter() -> void:
	if not player: return

	# Cortamos inputs y físicas mecánicas del Player
	player.set_process(false)
	player.set_physics_process(false)

	if player.has_node("CollisionShape2D"):
		player.get_node("CollisionShape2D").set_deferred("disabled", true)

	_play_death_sequence()

func _play_death_sequence() -> void:
	var sprite = player.animated_sprite_2d
	var tween: Tween = create_tween()
	tween.set_parallel(true)

	# Comportamiento del arco cinemático (Salto, giro, reducción y opacidad)
	tween.tween_property(sprite, "position:y", sprite.position.y - 50.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "rotation_degrees", 180.0, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)

	# Caída libre en el eje Y
	tween.chain().tween_property(sprite, "position:y", sprite.position.y + 100.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Eliminación segura del Player al concluir todo el proceso de animación
	tween.chain().tween_callback(player.queue_free)
