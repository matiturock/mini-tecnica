extends State

@onready var player: Player = self.get_owner() as Player


func enter() -> void:
	player.animated_sprite_2d.play(self.name.to_lower())


func physics_update(delta: float) -> void:
	player.velocity = player.velocity.move_toward(
		player.input_vector * player.max_speed,
		player.acceleration * delta)

	if player.input_vector == Vector2.ZERO:
		transitioned.emit("idle")

	if Input.is_action_just_pressed("attack_01"):
		transitioned.emit("attack")
