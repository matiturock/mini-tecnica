extends Camera2D

func shake(duration: float, intensity: float) -> void:
	var tween: Tween = create_tween()
	# Le decimos al tween que ignore el time_scale del impacto
	tween.set_ignore_time_scale(true)

	# Hace pequeños movimientos aleatorios rápidos y vuelve al centro (0,0)
	for i in range(5):
		var new_offset: Vector2 = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(self, "offset", new_offset, duration / 5.0)

	tween.chain().tween_property(self, "offset", Vector2.ZERO, 0.05)
