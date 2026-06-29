class_name StateMachine
extends Node

@export var initial_state: State:
	get:
		return initial_state
	set(value):
		initial_state = value
		_current_state = initial_state

var _current_state: State = null
var states: Dictionary[String, State] = {}


func _ready() -> void:
	await  self.get_owner().ready

	_set_node_states()

	if initial_state:
		initial_state.enter()


func _process(delta: float) -> void:
	if _current_state:
		_current_state.update(delta)


func _physics_process(delta: float) -> void:
	if _current_state:
		_current_state.physics_update(delta)


func update_state(new_state: State) -> void:
	_current_state.exit()
	_current_state = new_state
	_current_state.enter()


func _set_node_states() -> void:
	for child in self.get_children():
		if child is State:
			states.set(child.name.to_lower(), child)
			child.transitioned.connect(_on_child_transition)


func _on_child_transition(new_state_name: String) -> void:
	var new_state = states.get(new_state_name.to_lower())

	if not new_state or new_state == _current_state:
		return

	update_state(new_state)
