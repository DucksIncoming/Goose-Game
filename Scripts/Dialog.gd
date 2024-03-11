extends Control

var dialog = ""
var dialogQueue = []

var expression = ""
var expressionQueue = []

var speakerName = ""
var nameQueue = []

var currentCharacter = 0
var textSpeed = 20

var dialogCompleted = false
var selectingResponse = true

var option = 0 # 0 -> Left, 1 -> Right

@onready var dialogElement = $SpeakerDialog
@onready var speakerNameElement = $SpeakerName
@onready var TextTimer = $TextTimer
@onready var speakerIcon = $SpeakerIcon
@onready var dialogBackground = $DialogBackground
@onready var audioPlayer = $AudioStreamPlayer2D

@onready var LeftResponse = $LeftOptionAnimator
@onready var RightResponse = $RightOptionAnimator

@onready var ttOn = preload("res://Assets/Textures/UI/TemporalEarpiece-Dialog.png")
@onready var ttOff = preload("res://Assets/Textures/UI/GooseEarpiece-Dialog.png")

@onready var player = get_parent().get_parent()

func _ready():
	stepDialog()

func _process(delta):
	speakerNameElement.text = speakerName
	dialogBackground.texture = [ttOff, ttOn][int(player.hasEarpiece)]
	
	if (selectingResponse):
		if (not option == int(get_local_mouse_position().x < get_viewport_rect().size.x / 2)):
			option = int(get_local_mouse_position().x < get_viewport_rect().size.x / 2)
			var lTime = LeftResponse.current_animation_position
			var rTime = RightResponse.current_animation_position
			
			LeftResponse.play("Select-Left")
			RightResponse.play("Select-Right")
			
			LeftResponse.seek(lTime, true)
			RightResponse.seek(rTime, true)
			
			LeftResponse.speed_scale = (option * 2) - 1
			RightResponse.speed_scale = -1 * ((option * 2) - 1)
			print(lTime)
	
	if Input.is_action_just_pressed("Interact") and currentCharacter > 1:
		if (not dialogCompleted):
			currentCharacter = len(dialog)
		elif (len(dialogQueue) > 0):
			dialog = dialogQueue[0]
			expression = expressionQueue[0]
			speakerName = nameQueue[0]
			
			dialogQueue.remove_at(0)
			expressionQueue.remove_at(0)
			nameQueue.remove_at(0)
			
			dialogCompleted = false
			currentCharacter = 1
			speakerIcon.texture = load(expression)
		else:
			closeDialog()

func stepDialog():
	dialogElement.text = dialog.substr(0,currentCharacter)
	currentCharacter += 1
	audioPlayer.play()
	TextTimer.start(1 / textSpeed)

func _on_text_timer_timeout():
	if (dialogElement.text != dialog):
		stepDialog()
	else:
		dialogCompleted = true

func loadDialog(text, expr, names):
	if (dialogCompleted):
		dialog = text[0]
		if (not player.hasEarpiece):
			dialog = gooseifyLanguage(dialog)
		
		expression = expr[0]
		speakerName = names[0]
		
		dialogCompleted = false
		speakerIcon.texture = load(expression)
		openDialog()
		
		text.remove_at(0)
		expr.remove_at(0)
		names.remove_at(0)
		
	for t in text:
		dialogQueue.append(t)
	
	for e in expr:
		expressionQueue.append(e)
	currentCharacter = 0
	
	for n in names:
		nameQueue.append(n)

func openDialog():
	visible = true
	player.inDialog = true
	dialogElement.text = ""

func closeDialog():
	visible = false
	player.inDialog = false

func gooseifyLanguage(text):
	var wordcount = text.count(" ")
	var gooseOutput = "Quack" + " quack".repeat(wordcount) + "."
	return gooseOutput

func showDialog():
	var LeftResponse = $Leftresponse
	var RightResponse = $RightResponse

	LeftResponse.visible = true
	RightResponse.visible = true
	selectingResponse = true
	
func hideDialog():
	var LeftResponse = $Leftresponse
	var RightResponse = $RightResponse

	LeftResponse.visible = false
	RightResponse.visible = false
	selectingResponse = false
