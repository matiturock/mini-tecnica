@tool
extends BTCondition


func _tick(_delta: float) -> Status:
	var target = blackboard.get_var(&"target", null)
	return SUCCESS if is_instance_valid(target) else FAILURE
