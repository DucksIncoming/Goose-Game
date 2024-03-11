extends StaticBody2D

@onready var FenceSprite = $FenceSprite
@onready var FenceCollision = $FenceCollision
@onready var FenceAnimator = $AnimationPlayer

var fenceOpen = false

func _ready():
	pass

func _process(delta):
	pass

func openFence():
	if (not fenceOpen):
		FenceCollision.disabled = true
		FenceSprite.play("Fence-Drop")

func closeFence():
	if (fenceOpen):
		FenceCollision.disabled = false
		FenceSprite.play("Fence-Drop", "-1")
