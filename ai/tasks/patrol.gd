@tool
extends BTAction

@export var patrol_radius: float = 200.0
@export var wait_time: float = 1.2

var _enemy: BaseEnemy
var _target_position: Vector2
var _is_waiting: bool = false
var _wait_timer: float = 0.0
var _initialized: bool = false


func _generate_name() -> String:
	return "Patrol (radius: %s)" % patrol_radius


func _setup() -> void:
	_enemy = agent as BaseEnemy
	blackboard.set_var(&"spawn_position", _enemy.global_position)
	_pick_new_target()


func _enter() -> void:
	_is_waiting = false
	_wait_timer = 0.0


func _tick(delta: float) -> Status:
	# Primera vez que tickea: posición ya es la del mundo real
	if not _initialized:
		blackboard.set_var("spawn_position", _enemy.global_position)
		_pick_new_target()
		_initialized = true

	if _is_waiting:
		_enemy.velocity = Vector2.ZERO
		_enemy.move_and_slide()
		_wait_timer -= delta
		if _wait_timer <= 0:
			_is_waiting = false
			_pick_new_target()
		return RUNNING

	if _enemy.global_position.distance_to(_target_position) <= 8.0:
		_is_waiting = true
		_wait_timer = wait_time
		return RUNNING

	var direction: Vector2 = _enemy.global_position.direction_to(_target_position)
	_enemy.velocity = direction * _enemy.max_speed * 0.5
	_enemy.move_and_slide()
	return RUNNING


func _pick_new_target() -> void:
	var spawn: Vector2 = blackboard.get_var(&"spawn_position", _enemy.global_position)
	var angle: float = randf() * TAU
	var distance: float = randf_range(30.0, patrol_radius)
	_target_position = spawn + Vector2(cos(angle), sin(angle)) * distance
