extends NPC_Person

@export var dialog = [""]
@export var expressions = [""]
@export var names = [""]

var replyCount = 0

func npc_ready():
	personName = "Farah"

func npc_process(delta: float):
	pass

func interact():
	player.dialogPartner = self
	
	pushDialog(["Can you understand me yet?"],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Right.png"], ["???"])
	if (player.hasEarpiece):
		queueResponse()
		get_parent().get_node("FenceSwitch").enabled = true

func decide(option):
	print(option)
	match replyCount:
		0:
			if (option == 0):
				pushDialog(["Oh good! Welcome in, you probably have no clue what you’re doing here, huh?"],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Forward.png"], ["???"])
			else:
				pushDialog(["Well I don't know if I'd put it that way, but great!"],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Forward.png"], ["???"])
			pushDialog(["First things first, my name is Farah. To make a *very* long story short, we’re here to fix the past. My partner and I have been working on this prototype for a time machine for the past few years, and we’ve finally gotten it online."],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Right.png"], ["Farah"])
			pushDialog(["The only issue is, due to the quantum properties required to sustain the time field, the portal could only be built with an opening just large enough for a goose."],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Left.png"], ["Farah"])
			pushDialog(["That earpiece will not only let you understand us, but let us continue to communicate with you even when you’re inside the timestream. We won’t be able to recharge it so it’ll need to be used sparingly, but Isaiah and I will do our best to guide you."],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Down.png"], ["Farah"])
			pushDialog(["Got all that?"],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Forward.png"], ["Farah"])
		1:
			pushDialog(["Great! I think. That earpiece only works one-way so I'm not really sure. I'll open the access port for you, go ahead and enter the portal when you're ready."],["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Left.png"], ["Farah"])
	replyCount += 1
