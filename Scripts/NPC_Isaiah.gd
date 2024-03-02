extends NPC_Person

func npc_ready():
	personName = "Isaiah"

func npc_process(delta: float):
	pass

func interact():
	pushDialog(["I can't fucking stand this mf."],["res://Assets/Textures/NPCs/Isaiah/SpeakerIcons/Isaiah_Speaking_Forward.png"], ["Isaiah"])
