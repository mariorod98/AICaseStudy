class_name Village extends Node

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
@export var _buildings : Array[Building] = []
@export var _resource_buildings : Array[ResourceBuilding] = []
@export var _resources = {GlobalData.ResourceType.WOOD : 0, GlobalData.ResourceType.CLAY : 0, GlobalData.ResourceType.IRON : 0, GlobalData.ResourceType.WHEAT : 0} 

# NOTE: probably not necessary at all if the capacity is always the same for all resources
var _resource_capacities = {GlobalData.ResourceType.WOOD : BASE_MAX_CAPACITY, GlobalData.ResourceType.CLAY : 0, GlobalData.ResourceType.IRON : BASE_MAX_CAPACITY, GlobalData.ResourceType.WHEAT : BASE_MAX_CAPACITY} 

# TODO: Load info from savegame
func _init() -> void:
	for resource in LAYOUT:
		var building = ResourceBuilding.new(resource, self)
		add_child(building)
		_buildings.append(building)
		_resource_buildings.append(building)
		
	Simulation.on_new_turn.connect(update)

# return the production that a village generates per turn
# TODO it might have modifiers, to see
func get_production_per_turn() -> float:
	return BASE_PRODUCTION_PER_TURN # * modifiers if any

func upgrade_building(building_idx : int) -> bool:
	var building = _buildings[building_idx]
	if building.can_upgrade(_resources):
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
		var amount_to_add = resource.get_resource_amount()
		var type = resource._type
		var new_amount = _resources[type] + amount_to_add
		_resources[type] = new_amount >_resource_capacities[type] if _resource_capacities[type] else new_amount
		print("Gathered " + str(amount_to_add) + " resources from " + resource._name)
