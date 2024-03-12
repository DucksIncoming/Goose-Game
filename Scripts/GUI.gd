extends CanvasLayer

@onready var player = get_parent()
@onready var GUIAnimator = $GUIAnimator
@onready var fadeBlock = $FadeToBlack
@onready var earpiece = $TemporalEarpiece

@export var stateCompleted = false

func fadeToBlack():
	player.inTransition = true
	GUIAnimator.current_animation = "FadeToBlack"

func fadeFromBlack():
	GUIAnimator.current_animation = "FadeFromBlack"
