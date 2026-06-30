@tool
extends BTAction

var _enemy: BaseEnemy


func _enter() -> void:
	_enemy = agent as BaseEnemy


func _tick(_delta: float) -> Status:
	var target := blackboard.get_var(&"target", null) as Node2D
	if not is_instance_valid(target):
		return FAILURE

	var direction := _enemy.global_position.direction_to(target.global_position)
	_enemy.velocity = direction * _enemy.max_speed
	_enemy.move_and_slide()
	return RUNNING
