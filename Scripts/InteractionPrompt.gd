extends Node2D

# Child Variables
@onready var InteractAnimator = $InteractAnimator

func _ready():
	InteractAnimator.current_animation = "Prompt"

func _process(delta):
	pass

func isPrompt():
	return true
