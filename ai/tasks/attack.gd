@tool
extends BTAction

var _lancer: Lancer


func _generate_name() -> String:
	return "Attack"


func _setup() -> void:
	_lancer = agent as Lancer


func _tick(_delta: float) -> Status:
	_lancer.velocity = Vector2.ZERO
	_lancer.move_and_slide()

	if _lancer.can_attack:
		_lancer.attack()
	return RUNNING
