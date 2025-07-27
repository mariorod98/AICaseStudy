class_name BuildingUI extends Control

class Data:
	var _name : String = ""
	var _level : int = 0
	var _costs : Array[int]
	var _population : int = 0
	var _time : float = 0.0
	
	var _has_production : bool = false
	var _production : int = 0
	
	var _can_upgrade : bool = false
	var _is_upgrading : bool = false
	var _time_left : float = 0

@export var _name_label : Label
@export var _level_label : Label
@export var _wood_label : Label
@export var _clay_label : Label
@export var _iron_label : Label
@export var _wheat_label : Label
@export var _population_label : Label
@export var _time_label : Label
@export var _production_label : Label

@export var _time_left_label : Label
@export var _upgrade_button : Button

@export var _close_button : Button

func populate(data : Data) -> void:
	_name_label.text = data._name
	_level_label.text = str(data._level)
	_wood_label.text = str(data._costs[GlobalData.ResourceType.WOOD])
	_clay_label.text =  str(data._costs[GlobalData.ResourceType.CLAY])
	_iron_label.text =  str(data._costs[GlobalData.ResourceType.IRON])
	_wheat_label.text =  str(data._costs[GlobalData.ResourceType.WHEAT])
	_population_label.text =  str(data._population)
	_time_label.text =  str(data._time)

	#TODO: 	_prodruction_label.text =  str(data._production)
 
	if data._is_upgrading:
		_upgrade_button.text = "Cancel upgrade"
		_time_left_label.text = str(data._time_left)
		$VBoxContainer/HBoxContainer2/UpgradingContainer.show()
	else:
		_upgrade_button.text = "Upgrade"
		$VBoxContainer/HBoxContainer2/UpgradingContainer.hide()
	
	if data._is_upgrading or data._can_upgrade:
		_upgrade_button.disabled = false
	else:
		_upgrade_button.disabled = true
