extends Control

var dialog = "I might have to ajhsldljh;asljhdal;hjsn dashj dnhj;aslhjd lhjasdnhjl ahjlksdnh jlanjlshdn lhjaslhjd"
var dialogQueue = ["and then explode i think.", "It should be fine though."]

var expression = "res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Left.png"
var expressionQueue = ["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Down.png", "res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Forward.png"]

var currentCharacter = 0
var textSpeed = 10
var dialogCompleted = false

@onready var dialogElement = $SpeakerDialog
@onready var TextTimer = $TextTimer
@onready var speakerIcon = $SpeakerIcon

func _ready():
	stepDialog()
	loadDialog(["This is a test also."], ["res://Assets/Textures/NPCs/Farah/SpeakingIcons/Farah_Speaking-Up.png"])

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		if (not dialogCompleted):
			dialogCompleted = true
		elif (len(dialogQueue) > 0):
			dialog = dialogQueue[0]
			expression = expressionQueue[0]
			dialogQueue.remove_at(0)
			expressionQueue.remove_at(0)
			dialogCompleted = false
			currentCharacter = 0
			speakerIcon.texture = load(expression)
		else:
			closeDialog()

func stepDialog():
	dialogElement.text = [dialog.substr(0,currentCharacter), dialog][int(dialogCompleted)]
	currentCharacter += 1
	TextTimer.start(1 / textSpeed)
	

func _on_text_timer_timeout():
	if (dialogElement.text != dialog):
		stepDialog()
	else:
		dialogCompleted = true

func loadDialog(text, expr):
	if (dialogCompleted):
		dialog = text[0]
		dialogCompleted = false
		expression = expr[0]
		speakerIcon.texture = load(expression)
		openDialog()
		
		text.remove_at(0)
		expr.remove_at(0)
		
	for t in text:
		dialogQueue.append(t)
	
	for e in expr:
		expressionQueue.append(e)
	currentCharacter = 0

func openDialog():
	visible = true

func closeDialog():
	visible = false
