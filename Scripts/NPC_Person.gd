extends Interactable
class_name NPC_Person

var personName = ""

@onready var PersonAnimator = $PersonAnimator

func npc_ready():
	pass

func interactable_ready():
	PersonAnimator.current_animation = "Idle"
	npc_ready()

func npc_process(delta: float):
	pass

func interactable_process(delta: float):
	npc_process(delta)

func interact():
	pass

func decide(option):
	pass
