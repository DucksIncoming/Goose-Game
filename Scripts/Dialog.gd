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
var selectingResponse = false
var responseQueued = false
var preventDialogContinue = false

var option = 0 # 1 -> Left, 0 -> Right

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
	
	if (dialogElement.text == dialog and responseQueued and not preventDialogContinue):
		$ResponseDelay.start()
		responseQueued = false
		preventDialogContinue = true
	
	$LeftResponse.visible = selectingResponse
	$RightResponse.visible = selectingResponse
	
	if (selectingResponse):
		option = int(get_local_mouse_position().x < 1920 / 4)
		if (Input.is_action_just_pressed("Click")):
			decide(option)
			responseQueued = false
			selectingResponse = false
		
		var signedOption = (option*2) - 1
		
		var newLeftFill = clampf($LeftResponse.material.get_shader_parameter("fillAmount")+delta*signedOption*5, -0.2, 1)
		var newRightFill = clampf($RightResponse.material.get_shader_parameter("fillAmount")+delta*-signedOption*5, -0.2, 1)
		
		$LeftResponse.material.set_shader_parameter("fillAmount", newLeftFill)
		$RightResponse.material.set_shader_parameter("fillAmount", newRightFill)
	
	if Input.is_action_just_pressed("Interact") and currentCharacter > 1 and not preventDialogContinue and not responseQueued:
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
			
			if (dialog.substr(0,8) == "[CHOICE]"):
				responseQueued = true
				dialog = dialog.substr(8, -1)
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

func decide(option):
	player.dialogPartner.decide(option)
	preventDialogContinue = false
	selectingResponse = false

func _on_response_delay_timeout():
	selectingResponse = true
