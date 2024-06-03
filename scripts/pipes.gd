extends Node2D

const MAX_POSITION_OFFSET = 150
const MAX_GAP_OFFSET = 48
const BASE_SPEED = 175
const MAX_SPEED = 325

@onready var game_manager = $"/root/Game/GameManager"
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe

func _ready():
	# Randomly change the gap between the pipes
	var gap_offset = randf_range(0, MAX_GAP_OFFSET)
	top_pipe.position.y -= gap_offset
	bottom_pipe.position.y += gap_offset

	# Randomly change the gap between the pipes
	var position_offset = randf_range( - MAX_POSITION_OFFSET, MAX_POSITION_OFFSET)
	top_pipe.position.y += position_offset
	bottom_pipe.position.y += position_offset

func _process(delta: float):
	if !game_manager.playing:
		return
	
	# Move
	position.x -= clampf((BASE_SPEED + game_manager.time_elapsed), BASE_SPEED, MAX_SPEED) * delta

# Destroy once off-screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_top_pipe_body_entered(_body: Node2D):
	game_manager.fail()
func _on_bottom_pipe_body_entered(_body: Node2D):
	game_manager.fail()

func _on_score_area_body_entered(_body: Node2D):
	game_manager.increment_score()
