extends CanvasLayer

@export var all_recipes:ResourceGroup

var player:PlayerPlatformer
@onready var inventory_dialog:InventoryDialog = %InventoryDialog
@onready var crafting_dialog:CraftingDialog = %CraftingDialog
var _all_recipes:Array[Recipe] = []

func _ready():
	player = ToolsSingleton.get_player_platformer()
	all_recipes.load_all_into(_all_recipes)

func _unhandled_input(event):
	
	if ToolsSingleton.is_interactive_dialog_open_and_visible():
		return
	
	if event.is_action_released("inventory"):
		inventory_dialog.open(player.inventory)
		
	if event.is_action_released("crafting"):
		crafting_dialog.open(_all_recipes, player.inventory)
