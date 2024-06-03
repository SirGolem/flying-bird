extends CharacterBody2D

const FLAP_VELOCITY = -400

@onready var game_manager = %GameManager
@onready var wing_sprite = $Wing

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float):
	# Gravity
	velocity.y += gravity * delta

	# Flap
	if Input.is_action_just_pressed("flap"):
		velocity.y = FLAP_VELOCITY
	
	move_and_slide()

# Fail if moved off-screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	game_manager.fail()
	queue_free()
