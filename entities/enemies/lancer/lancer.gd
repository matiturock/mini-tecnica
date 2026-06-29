class_name Lancer
extends BaseEnemy

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hitbox_collision_shape_2d: CollisionShape2D = $HitBoxComponent/CollisionShape2D2

var impact_frame: int = 1


func _ready() -> void:
	hitbox_collision_shape_2d.disabled = true
	cooldown_timer.timeout.connect(attack)
	animated_sprite_2d.frame_changed.connect(_on_frame_changed)


func attack() -> void:
	animated_sprite_2d.play(&"attack")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play(&"idle")


func _on_frame_changed() -> void:
	if animated_sprite_2d.frame == impact_frame and animated_sprite_2d.animation == &"attack":
		(func(): hitbox_collision_shape_2d.disabled = false).call_deferred()
		await animated_sprite_2d.frame_changed
		(func(): hitbox_collision_shape_2d.disabled = true).call_deferred()
