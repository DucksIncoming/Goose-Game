extends CharacterBody2D

# Movement variables
var walkSpeed = 300.0
var jumpVelocity = -400.0
var gravity = 1200.0
var knockback = Vector2.ZERO
var cameraSmooth = 5
var heldItem = null
var velocityMemory = Vector2.ZERO

# Transition stuff
var transitionWalkDirection = Vector2.ZERO

# Flags
var isJumping = false
@export var inTransition = false
var inDialog = false
var hasEarpiece = false

# Interaction Variables
var activeInteractableBodies = []
var activeInteractableNames = []

var dialogPartner : Node2D = null

# Onready vars
@onready var GooseSprite = $GooseSprite
@onready var CostumeSprite = $CostumeSprite
@onready var GooseAnimator = $GooseAnimator
@onready var InteractionRadius = $InteractionRadius
@onready var audioPlayer = $StepPlayer
@onready var PlayerCamera = get_parent().get_node("PlayerCamera")
@onready var CameraAnimator = PlayerCamera.get_node("AnimationPlayer")
@onready var GUI = $GUI
@onready var levelScript = get_parent()

var stepAudioTimer = 0

func _ready():
	GooseAnimator.current_animation = "Idle"
	CameraAnimator.current_animation = str(levelScript.currentLevel) + "-CameraPos_0"
	up_direction = Vector2(0,1)
	randomizeCostume()

func _process(delta):
	var accel = velocityMemory - velocity
	
	# I love handler functions
	animationHandler(delta)
	cameraHandler(delta)
	findInteractable()
	applyForces(delta)

	# Jump and Gravity handler
	velocity.y = [velocity.y, jumpVelocity][int(Input.is_action_just_pressed("Jump") and (velocity.y/delta == gravity) and canMove())]

	# Movement Input
	var direction = Input.get_axis("WalkRight", "WalkLeft") * int(canMove())
	velocity.x = [move_toward(velocity.x, 0, walkSpeed), direction * walkSpeed][int(direction != 0)]

	move_and_slide()
	isJumping = [isJumping, true][int(Input.is_action_just_pressed("Jump") and (velocity.y/delta == gravity))]

func applyForces(delta):
	velocity.y = velocity.y + gravity * delta
	velocity += calculateExternalMovement(delta)

func cameraHandler(delta):
	if (not inTransition):
		PlayerCamera.position.x = move_toward(PlayerCamera.position.x, position.x, (abs(position.x-PlayerCamera.position.x) * delta * cameraSmooth))

func animationHandler(delta):
	# Flip horizontally when changing direction
	var direction = Input.get_axis("WalkRight", "WalkLeft")
	GooseSprite.flip_h = [1, GooseSprite.flip_h, 0][direction+1]
	CostumeSprite.flip_h = GooseSprite.flip_h

	if ((not direction == 0) and (velocity.y == 0) and (not isJumping) and (Time.get_ticks_msec() - stepAudioTimer > 50) and canMove()):
		audioPlayer.play(0)
		stepAudioTimer = Time.get_ticks_msec()
	
	# Jump animations
	if Input.is_action_just_pressed("Jump") and (abs(velocity.y) < 50) and (not isJumping):
		isJumping = true
		GooseAnimator.current_animation = "Jump"
	elif isJumping and (velocity.y/delta == gravity):
		isJumping = false
		GooseAnimator.current_animation = "Land"
		
	# Idle and Walk Animations. Also jump. Need to clean up.
	if (not (GooseAnimator.current_animation == "Jump") or (GooseAnimator.current_animation == "Land")):
		GooseAnimator.current_animation = ["Walk", "Idle"][int(int(direction) * int(canMove()) == 0)]

func _on_interaction_radius_body_entered(body):
	if (body.has_method("promptInteraction")):
		body.promptInteraction()
		activeInteractableBodies.append(body)
		activeInteractableNames.append(body.name)

func _on_interaction_radius_body_exited(body):
	if (body.has_method("depromptInteraction")):
		body.depromptInteraction()
		activeInteractableBodies.remove_at(activeInteractableNames.find(body.name))
		activeInteractableNames.remove_at(activeInteractableNames.find(body.name))

func findInteractable():
	var minDist = 100000
	var minBody : Node2D
	
	for elm in activeInteractableBodies:
		var promptDistance = get_global_mouse_position().distance_to(elm.global_position)
		minDist = min(minDist, promptDistance)
		minBody = [minBody, elm][int(promptDistance == minDist)]
		
		elm.promptActive = false	
	if (minBody):
		minBody.promptActive = true
		if (Input.is_action_just_pressed("Interact") and canInteract() and minBody.enabled):
			minBody.interact()
			audioPlayer.stream = load("res://Assets/Audio/Player/player-interact.wav")
			audioPlayer.play(0)
			audioPlayer.stream = load("res://Elements/Audio Elements/GooseStepRandomizer.tres")

func pushDialog(text, expr, names):
	GUI.get_node("TemporalEarpiece").loadDialog(text, expr, names)

func canInteract():
	return not inDialog

func canMove():
	return not (inDialog or inTransition)

func _on_interaction_radius_area_entered(area):
	_on_interaction_radius_body_entered(area.get_parent())

func _on_interaction_radius_area_exited(area):
	_on_interaction_radius_body_exited(area.get_parent())

func randomizeCostume():
	var costumes = ["", "res://Assets/Textures/Player/Chef/Goose_ChefOutfit.png", "res://Assets/Textures/Player/Suit/Goose_Suit.png", "res://Assets/Textures/Player/Tux/Goose_Tux.png"]
	var random = RandomNumberGenerator.new()
	CostumeSprite.texture = load(costumes[random.randi_range(0, len(costumes)-1)])

func isPlayer():
	return true
	
func setPosition(pos):
	position = pos
	PlayerCamera.position.x = pos.x

func calculateExternalMovement(delta):
	var output = Vector2.ZERO
	output += transitionWalkDirection * walkSpeed * int(inTransition) * 0.5
	return output * delta
