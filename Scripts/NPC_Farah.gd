extends NPC_Person

@export var dialog = [""]
@export var expressions = [""]
@export var names = [""]

func npc_ready():
	personName = "Farah"

func npc_process(delta: float):
	pass

func interact():
	pushDialog(["Can you understand me yet?"],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Right.png"], ["???"])
	if (player.hasEarpiece):
		get_parent().get_node("FenceSwitch").enabled = true
		pushDialog(dialog, expressions, names)
