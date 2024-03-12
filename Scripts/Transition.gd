extends Node2D
class_name Transition

var softTransition = true # true: remains in same scene, false: loads new scene
@export var transitionScenePath : String
@export var transitionDirection : Vector2
@export var exitPosition : Vector2
@export var exitWalkDirection : Vector2
@export var cameraAnimation : String

@onready var player = get_tree().get_root().get_node("Base/Goose") 

var transitionQueued = false

func _ready():
	pass

func _process(delta):
	if (transitionQueued and player.GUI.stateCompleted):
		transitionQueued = false
		player.GUI.fadeFromBlack()
		player.setPosition(exitPosition)
		player.transitionWalkDirection = exitWalkDirection
		player.CameraAnimator.current_animation = cameraAnimation
		print(cameraAnimation)
		print("BRUH")

func transition():
	transitionQueued = true
	player.inTransition = true
	player.CameraAnimator.current_animation = "CameraPos_DCWEnter"
	player.transitionWalkDirection = transitionDirection
	player.GUI.fadeToBlack()

func _on_trigger_body_entered(body):
	if (body.has_method("isPlayer") and (not transitionQueued)):
		transition()
