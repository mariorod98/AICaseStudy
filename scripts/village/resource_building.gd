class_name ResourceBuilding extends Building

@export var _type : GlobalData.ResourceType

func get_resource_amount() -> int:
	return _data.production[_level]
