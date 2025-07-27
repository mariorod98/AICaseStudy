class_name Village extends Node

#region variables
const BASE_PRODUCTION_PER_TURN = 60.0
const BASE_MAX_CAPACITY = 1000

# TODO: we will have different layouts, but for now we will only use one
const LAYOUT = [GlobalData.ResourceType.WOOD,	#0
				GlobalData.ResourceType.WHEAT,	#1
				GlobalData.ResourceType.IRON,	#2
				GlobalData.ResourceType.CLAY,	#3
				GlobalData.ResourceType.CLAY,	#4
				GlobalData.ResourceType.WOOD,	#5
				GlobalData.ResourceType.IRON,	#6
				GlobalData.ResourceType.WHEAT,	#7
				GlobalData.ResourceType.WHEAT,	#8
				GlobalData.ResourceType.IRON,	#9
				GlobalData.ResourceType.IRON,	#10
				GlobalData.ResourceType.WHEAT,	#11
				GlobalData.ResourceType.WHEAT,	#12
				GlobalData.ResourceType.WOOD,	#13
				GlobalData.ResourceType.WHEAT,	#14
				GlobalData.ResourceType.CLAY,	#15
				GlobalData.ResourceType.WOOD,	#16
				GlobalData.ResourceType.CLAY,	#17
				]

# the first 18 buildings are always resource buildings
@export var _name := ""
@export var _owner : PlayerController = null

var _buildings : Array[Building] = []
var _resource_buildings : Array[ResourceBuilding] = []
var _resources : Dictionary[GlobalData.ResourceType, int] = {GlobalData.ResourceType.WOOD : 0, GlobalData.ResourceType.CLAY : 0, GlobalData.ResourceType.IRON : 0, GlobalData.ResourceType.WHEAT : 0} 
var _resource_capacities = {GlobalData.ResourceType.WOOD : BASE_MAX_CAPACITY, GlobalData.ResourceType.CLAY : BASE_MAX_CAPACITY, GlobalData.ResourceType.IRON : BASE_MAX_CAPACITY, GlobalData.ResourceType.WHEAT : BASE_MAX_CAPACITY} 
#endregion


# TODO: Load info from savegame
func _init(player_owner : PlayerController) -> void:
	_owner = player_owner
	_name = "Village of " + _owner._name
	name = _name
	
	_owner.on_new_turn.connect(update)
	
	for resource in LAYOUT:
		var building = ResourceBuilding.new(resource, self)
		add_child(building)
		_buildings.append(building)
		_resource_buildings.append(building)
	
	#TODO add first building on construction


# return the production that a village generates per turn
func get_production_per_turn() -> float:
	return BASE_PRODUCTION_PER_TURN # TODO * modifiers if any


func upgrade_building(building_idx : int) -> bool:
	var building = _buildings[building_idx]
	if building.can_upgrade(_resources):
		remove_resources(building.get_current_upgrade_cost())
		building.upgrade()
		return true
	else:
		print("Can't upgrade " + building._name)
		return false


# updates all buildings, called at the start of the player turn
func update() -> void:
	for building in _buildings:
		building.update()


func update_resource(resource : GlobalData.ResourceType, amount : int, use_multiplier : bool) -> void:
	var is_addition = amount >= 0
	var new_amount = _resources[resource] + amount #TODO: multiply by modifier
	
	if is_addition:
		_resources[resource] = _resource_capacities[resource] if new_amount >_resource_capacities[resource] else new_amount
	else:
		_resources[resource] = 0 if new_amount < 0 else new_amount


# update all resources at the same time
func add_resources(amounts : Array[int]) -> void:
	for resource in GlobalData.ResourceType:
		update_resource(resource, amounts[resource], false)


func remove_resources(amounts : Array[int]) -> void:
	for resource in GlobalData.ResourceType:
		update_resource(resource, amounts[resource] * -1, false)


func compute_resources_per_turn() -> Array[int]:
	var resource_per_turn = [0, 0, 0, 0]
	for building in _resource_buildings:
		resource_per_turn[building._resource] += building.get_production()
	
	# TODO: apply modifiers
	
	return resource_per_turn
