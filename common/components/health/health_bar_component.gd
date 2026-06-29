@tool
class_name HealthbarComponent
extends ProgressBar

@export var health_component: HealthComponent:
	get:
		return health_component
	set(value):
		health_component = value
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if not is_instance_valid(health_component):
		warnings.append("Debes asingar un HealthComponet a este Nodo")
	return warnings


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	max_value = health_component.max_health
	value = health_component.max_health
	health_component.health_changed.connect(_on_health_changed)


func _on_health_changed(current_health: float) -> void:
	value = current_health
