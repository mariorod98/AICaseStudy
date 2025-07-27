class_name VillageUI extends Control

class Data:
	var _name : String
	var _population : int
	var _building_names : Array[String]
	var _building_levels  : Array[int]
	var _resource_amount  : Dictionary[GlobalData.ResourceType, int]
	var _resource_capacities  : Dictionary[GlobalData.ResourceType, int]


@export var _name_label : Label
@export var _population_label : Label
@export var _resource_labels : Array[Label]
@export var _building_buttons : Array[Button]

signal on_building_button_pressed(int)

func populate(data : Data):
	_name_label.text = data._name
	_population_label.text = str(data._population)
	
	for resource in GlobalData.ResourceType.values():
		_resource_labels[int(resource)].text = str(data._resource_amount[resource]) + "/" + str(data._resource_capacities[resource])
	
	for i in _building_buttons.size():
		_building_buttons[i].text = data._building_names[i] + " lvl " + str(data._building_levels[i])


func _on_resource_button_pressed(buildingIdx: int) -> void:
	on_building_button_pressed.emit(buildingIdx)
	pass # Replace with function body.
