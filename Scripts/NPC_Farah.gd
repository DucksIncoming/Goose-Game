extends NPC_Person

func npc_ready():
	personName = "Farah"

func npc_process(delta: float):
	pass

func interact():
	pushDialog(["What the scallop?"],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Down.png"], ["Farah"])
