extends State

@onready var player: Player = self.get_owner() as Player

@export var impact_frame: int = 2


func enter() -> void:
	player.is_attacking = true
	player.velocity = Vector2.ZERO
	player.animated_sprite_2d.frame_changed.connect(_on_frame_chaged)
	player.animated_sprite_2d.play(self.name.to_lower())
	await player.animated_sprite_2d.animation_finished
	transitioned.emit(&"idle")


func exit() -> void:
	player.is_attacking = false
	player.animated_sprite_2d.frame_changed.disconnect(_on_frame_chaged)


func _on_frame_chaged() -> void:
	if is_impact_frame():
		(func(): player.collision_hit.disabled = false).call_deferred()
	else:
		(func(): player.collision_hit.disabled = true).call_deferred()


func is_impact_frame() -> bool:
	return player.animated_sprite_2d.animation == self.name.to_lower() and player.animated_sprite_2d.frame == impact_frame
