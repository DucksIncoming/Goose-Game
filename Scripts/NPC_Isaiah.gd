extends NPC_Person

func npc_ready():
	personName = "Isaiah"

func npc_process(delta: float):
	pass

func interact():
	pushDialog(["Go talk to Farah once you can understand me, I'm sure you can figure it out."],["res://Assets/Textures/NPCs/Isaiah/SpeakerIcons/Isaiah_Speaking_Forward.png"], ["???"])
	if (player.hasEarpiece):
		pushDialog(["The name's Isaiah by the way."],["res://Assets/Textures/NPCs/Isaiah/SpeakerIcons/Isaiah_Speaking_Forward.png"], ["Isaiah"])
