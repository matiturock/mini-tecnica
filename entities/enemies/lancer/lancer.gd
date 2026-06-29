class_name Lancer
extends BaseEnemy

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hitbox_collision_shape_2d: CollisionShape2D = $HitBoxComponent/CollisionShape2D2
@onready var detect_range_area_2d: Area2D = $DetectRangeArea2D

var impact_frame: int = 1
var is_player_detected: bool = false


func _ready() -> void:
	hitbox_collision_shape_2d.disabled = true
	cooldown_timer.timeout.connect(attack)
	animated_sprite_2d.frame_changed.connect(_on_frame_changed)
	hurbox_component.hurt.connect($HealthbarComponent._on_health_changed)
	detect_range_area_2d.area_entered.connect(_on_player_detected)
	detect_range_area_2d.area_exited.connect(_on_player_out_of_range)


func attack() -> void:
	animated_sprite_2d.play(&"attack")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play(&"idle")


func _on_frame_changed() -> void:
	if animated_sprite_2d.frame == impact_frame and animated_sprite_2d.animation == &"attack":
		(func(): hitbox_collision_shape_2d.disabled = false).call_deferred()
		await animated_sprite_2d.frame_changed
		(func(): hitbox_collision_shape_2d.disabled = true).call_deferred()


func _on_player_detected(area: Area2D) -> void:
	if area.get_owner() is Player:
		is_player_detected = true


func _on_player_out_of_range(area: Area2D) -> void:
	if area.get_owner() is Player:
		is_player_detected = false
