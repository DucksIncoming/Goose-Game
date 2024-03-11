extends Interactable
class_name Item

var itemSprite
var itemName

func interactable_ready():
	$ItemSprite.texture = itemSprite

func interactable_process(delta):
	pass

func itemPickup():
	pass

func interact():
	player.heldItem = get_script()
	itemPickup()
	queue_free()

func dropItem():
	pass
