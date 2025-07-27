class_name Village extends Node

const BASE_PRODUCTION_PER_TURN = 60.0
const BASE_MAX_CAPACITY = 1000

# NOTE: maybe could have them in same array and do a class type check, don't know how expensive it is
@export var _village_buildings : Array[Building]
@export var _resource_buildings : Array[ResourceBuilding]
@export var _resources = {GlobalData.ResourceType.WOOD : 0, GlobalData.ResourceType.CLAY : 0, GlobalData.ResourceType.IRON : 0, GlobalData.ResourceType.WHEAT : 0} 

# NOTE: probably not necessary at all if the capacity is always the same for all resources
var _resource_capacities = {GlobalData.ResourceType.WOOD : BASE_MAX_CAPACITY, GlobalData.ResourceType.CLAY : 0, GlobalData.ResourceType.IRON : BASE_MAX_CAPACITY, GlobalData.ResourceType.WHEAT : BASE_MAX_CAPACITY} 

# TODO: Load info from savegame
func _ready() -> void:
	Simulation.on_new_turn.connect(update)
	
# return the production that a village generates per turn
# INFO it might have modifiers, to see
func get_production_per_turn() -> float:
	return BASE_PRODUCTION_PER_TURN # * modifiers if any

func upgrade_village_building(building_idx : int) -> bool:
	return upgrade_building(_village_buildings, building_idx)

func upgrade_resource_building(building_idx : int) -> bool:
	return upgrade_building(_resource_buildings, building_idx)

func upgrade_building(building_array : Array, building_idx : int) -> bool:
	var building = building_array[building_idx]
	if building.can_upgrade():
		if building._level == 0:
			building.build()
		else:
			building.upgrade()
		return true
	else:
		print("Can't upgrade " + building._name)

		return false

# generates the resources of the village, called at the end of each turn
func update() :
	for resource in _resource_buildings:
		var amount = resource.get_resource_amount()
		var type = resource._type
		_resources[type] += amount
		print("Gathered " + str(amount) + " resources from " + resource._name)
		#if _resources[type] > _resource_capacities[type]:
		#	_resources[type] = _resource_capacities[type]
