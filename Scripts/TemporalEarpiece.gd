extends Item

func interactable_ready():
	itemSprite = load("res://Assets/Textures/Items/Temporal-Earpiece.png")
	$ItemSprite.texture = itemSprite

func interactable_process(delta):
	pass

func itemPickup():
	player.hasEarpiece = true

func dropItem():
	player.hasEarpiece = false
	position.y += 25
