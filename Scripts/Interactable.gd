extends Node2D
class_name Interactable

var interactionPrompt = preload("res://Elements/interaction_prompt.tscn")
var promptObject : Node2D
@export var promptPosition = Vector2.ZERO
@onready var player = get_tree().get_root().get_node("Base/Goose")

var promptActive = false

func interactable_ready():
	pass

func _ready():
	interactable_ready()
	
func interactable_process(delta: float):
	pass

func _process(delta: float):
	if (promptObject):
		promptObject.modulate.a = [0.2, 1][int(promptActive)]
		
	interactable_process(delta)

func interact():
	pass

func promptInteraction():
	if (not getPromptNode()):
		var prompt = interactionPrompt.instantiate()
		prompt.get_node("InteractAnimator").current_animation = "Prompt"
		add_child(prompt)
		prompt.position = promptPosition
		promptObject = prompt

func depromptInteraction():
	getPromptNode().queue_free()
	promptObject = null

func getPromptNode():
	for ch in get_children():
		if (ch.has_method("isPrompt")):
			return ch
	return null

func pushDialog(text, expr, names):
	player.pushDialog(text, expr, names)
