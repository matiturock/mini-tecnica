@tool
extends BTCondition

var in_rage: bool = false

func _tick(_delta: float) -> Status:
	in_rage = blackboard.get_var(&"in_range_attack", false)
	if in_rage:
		return SUCCESS
	else:
		return FAILURE
