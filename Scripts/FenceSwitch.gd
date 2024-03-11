extends Interactable

@onready var PortalFence = get_parent().get_node("PortalFence")

func interactable_ready():
	enabled = false
	pass

func interactable_process(delta):
	get_node("SwitchCoverSprite").rotation_degrees = [90, 270][int(enabled)]
	
func interact():
	PortalFence.openFence()
