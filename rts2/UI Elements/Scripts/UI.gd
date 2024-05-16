extends CanvasLayer

@onready var commandManager: Node2D = get_parent()

@export var UIElementsToBeRendered: Array[Control]

func _ready():
	pass

func updateRender():
	for element in UIElementsToBeRendered:
		element.render(commandManager.selected_units)
