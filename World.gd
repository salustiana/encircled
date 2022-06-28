extends Node

onready var viewport_size: Vector2 = get_viewport().size
onready var gun = load("res://Gun.tscn").instance()

var score: int = 0

func _ready():
	$player.connect("died", self, "_on_player_died")
	
	$enemy_manager.player = $player
	
	$player.add_child(gun)
	$bullet_manager.player = $player
	
	for child in get_children():
		if child.has_method("_on_level_loaded"):
			child._on_level_loaded()
	
	$score_timer.connect("timeout", self, "_on_score_timer_timeout")
	$score_timer.start()

func _on_player_died():
	$player.set_physics_process(false)
	$bullet_manager/fire_period.stop()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
