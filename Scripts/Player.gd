extends CharacterBody2D

# Movement variables
var walkSpeed = 300.0
var jumpVelocity = -400.0
var gravity = 1200.0
var knockback = Vector2.ZERO
var cameraSmooth = 5

# Flags
var isJumping = false
var canInteract = true

# Interaction Variables
var activeInteractableBodies = []
var activeInteractableNames = []

# Onready vars
@onready var GooseSprite = $GooseSprite
@onready var GooseAnimator = $GooseAnimator
@onready var InteractionRadius = $InteractionRadius
@onready var PlayerCamera = get_parent().get_node("PlayerCamera")

func _ready():
	GooseAnimator.current_animation = "Idle"

func _process(delta):
	# I love handler functions
	applyForces(delta)
	animationHandler(delta)
	cameraHandler(delta)
	findInteractable()

	# Jump and Gravity handler
	velocity.y = [velocity.y, jumpVelocity][int(Input.is_action_just_pressed("Jump") and is_on_floor())]
	isJumping = [isJumping, true][int(Input.is_action_just_pressed("Jump") and is_on_floor())]

	# Movement Input
	var direction = Input.get_axis("WalkRight", "WalkLeft")
	velocity.x = [move_toward(velocity.x, 0, walkSpeed), direction * walkSpeed][int(direction != 0)]

	move_and_slide()

func applyForces(delta):
	velocity.y = [velocity.y + gravity * delta, velocity.y][int(is_on_floor())]
	velocity = velocity + knockback

func cameraHandler(delta):
	PlayerCamera.position.x = move_toward(PlayerCamera.position.x, position.x, (abs(position.x-PlayerCamera.position.x) * delta * cameraSmooth))

func animationHandler(delta):
	# Flip horizontally when changing direction
	var direction = Input.get_axis("WalkRight", "WalkLeft")
	GooseSprite.flip_h = [1, GooseSprite.flip_h, 0][direction+1]
	
	# Jump animations
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		isJumping = true
		GooseAnimator.current_animation = "Jump"
	elif isJumping and is_on_floor():
		isJumping = false
		GooseAnimator.current_animation = "Land"
		
	# Idle and Walk Animations. Also jump. Need to clean up.
	if (not (GooseAnimator.current_animation == "Jump") or (GooseAnimator.current_animation == "Land")):
		GooseAnimator.current_animation = ["Walk", "Idle"][int(direction == 0)]

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
	var minDist = 10000
	var minBody : Node2D
	
	for elm in activeInteractableBodies:
		var promptDistance = get_global_mouse_position().distance_to(elm.position)
		minDist = min(minDist, promptDistance)
		minBody = [minBody, elm][int(promptDistance == minDist)]
		
		elm.promptActive = false
	if (minBody):
		minBody.promptActive = true
		if (Input.is_action_just_pressed("Interact")):
			minBody.interact()
