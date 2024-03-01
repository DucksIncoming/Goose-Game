extends Control

var dialog = ""
var dialogQueue = []

var expression = ""
var expressionQueue = []

var speakerName = ""
var nameQueue = []

var currentCharacter = 0
var textSpeed = 30
var dialogCompleted = false

@onready var dialogElement = $SpeakerDialog
@onready var speakerNameElement = $SpeakerName
@onready var TextTimer = $TextTimer
@onready var speakerIcon = $SpeakerIcon
@onready var player = get_parent().get_parent()

func _ready():
	stepDialog()

func _process(delta):
	speakerNameElement.text = speakerName
	print(dialogCompleted)
	
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
	TextTimer.start(1 / textSpeed)

func _on_text_timer_timeout():
	if (dialogElement.text != dialog):
		stepDialog()
	else:
		dialogCompleted = true

func loadDialog(text, expr, names):
	if (dialogCompleted):
		dialog = text[0]
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
