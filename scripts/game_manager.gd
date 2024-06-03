extends Node

const SAVE_PATH = "user://high_score.json"
const HIGH_SCORE_SAVE_KEY = "high_score"

@onready var score_label = $"/root/Game/UICanvas/ScoreLabel"
@onready var high_score_label = $"/root/Game/UICanvas/HighScoreLabel"
@onready var fail_screen = $"/root/Game/UICanvas/FailScreen"

var playing = true
var time_elapsed = 0
var high_score = 0
var score = 0

func _ready():
	update_score_label()

	# Load high score
	if !FileAccess.file_exists(SAVE_PATH):
		update_high_score_label()
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		printerr("FileAccess Error: Failed to open '" + SAVE_PATH + "' (Error: " + str(FileAccess.get_open_error()) + ").")
		return
	var file_string = file.get_as_text()
	file.close()
	var data = JSON.parse_string(file_string)
	if data == null:
		printerr("JSON Parser Error: Failed to parse string from '" + SAVE_PATH + "'.")
		return
	elif typeof(data) != TYPE_DICTIONARY:
		printerr("JSON Data Error: Data from '" + SAVE_PATH + "' is of an unexpected type (Type: " + str(typeof(data.data)) + ", Expected: " + str(TYPE_DICTIONARY) + ").")
		return
	elif !data.has(HIGH_SCORE_SAVE_KEY):
		printerr("JSON Data Error: Property 'high_score' does not exist in '" + SAVE_PATH + "'.")
		return
	elif typeof(data[HIGH_SCORE_SAVE_KEY]) != TYPE_FLOAT:
		printerr("JSON Data Error: Property 'high_score' from '" + SAVE_PATH + "' is of an unexpected type (Type: " + str(typeof(data[HIGH_SCORE_SAVE_KEY])) + ", Expected: " + str(TYPE_FLOAT) + ").")
		return
	else:
		high_score = int(data[HIGH_SCORE_SAVE_KEY])
		update_high_score_label()

func _process(delta: float):
	time_elapsed += delta

func increment_score():
	score += 1
	update_score_label()

func update_score_label():
	score_label.text = "Score: " + str(score)
func update_high_score_label():
	high_score_label.text = "High Score: " + str(high_score)

func fail():
	playing = false
	fail_screen.visible = true

	# Save high score
	if score > high_score:
		var data = {"high_score": score}
		var data_string = JSON.stringify(data, "\t")
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file == null:
			printerr("FileAccess Error: Failed to open '" + SAVE_PATH + "' (Error: " + str(FileAccess.get_open_error()) + ").")
			return
		file.store_string(data_string)
		file.close()

# Play again button
func _on_play_again_button_pressed():
	get_tree().reload_current_scene()

# Menu button
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
