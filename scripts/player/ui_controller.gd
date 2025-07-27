class_name UIController extends Control


@export var _owner : PlayerController = null
@export var _general_ui : Control = null
@export var _village_ui : VillageUI = null
@export var _building_ui : BuildingUI = null


func _ready() -> void:
	_building_ui._upgrade_button.pressed.connect(on_building_upgrade_button_pressed)
	_village_ui.on_building_button_pressed.connect(on_building_button_pressed)


#region village ui
func open_village_ui(village : Village) -> void:
	var village_data = VillageUI.Data.new()
	village_data._name = village._name
	village_data._population = 0 # TODO
	village_data._resource_amount = village._resources
	village_data._resource_capacities = village._resource_capacities
	
	for building in village._resource_buildings:
		village_data._building_names.append(building._name)
		village_data._building_levels.append(building._level)

	_village_ui.populate(village_data)


func on_building_button_pressed(building_idx : int) -> void:
	_owner.set_current_building(building_idx)
#endregion


#region building ui
func open_building_ui(building : Building) -> void:
	var building_data = BuildingUI.Data.new()
	building_data._name = building._name
	building_data._level = building._level
	building_data._costs = building.get_current_upgrade_cost()
	building_data._population = 0 #TODO
	building_data._time = building.get_current_turn_cost()
	
	building_data._has_production = false # TODO
	building_data._production = building.get_production()
	
	building_data._can_upgrade = true # TODO
	building_data._is_upgrading = building._is_upgrading
	building_data._time_left = building._turns_left
	
	_building_ui.populate(building_data)
	_building_ui.show()
	_village_ui.hide()


func close_building_ui() -> void:
	_building_ui.hide()
	_village_ui.show()


func on_building_upgrade_button_pressed():
	pass
#endregion
