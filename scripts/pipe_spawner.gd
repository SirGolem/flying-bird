extends Node2D

@onready var game_manager = %GameManager
@onready var timer = $Timer
@onready var pipes_scene = preload ("res://scenes/pipes.tscn")

func _ready():
	spawn_pipes()

func _on_timer_timeout():
	spawn_pipes()

func spawn_pipes():
	if !game_manager.playing and !timer.is_stopped():
		timer.stop()

	var scene_instance = pipes_scene.instantiate()
	add_child(scene_instance)
	scene_instance.position = position

	if timer.wait_time > 1.5:
		timer.wait_time -= game_manager.time_elapsed / 1000
