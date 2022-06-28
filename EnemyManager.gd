extends Node2D

export var radius: int = 1000
export var spawn_rate: float = 5
export var Enemies: PackedScene = load("res://Enemy.tscn")

var player: Player

func _ready():
	$spawn_period.connect("timeout", self, "_on_spawn_period_timeout")
	$spawn_period.wait_time = 1 / spawn_rate

func _on_level_loaded():
	$spawn_period.start()

func _physics_process(delta):
	for enemy in get_children():
		if enemy is Enemy:
			enemy.global_position += enemy.global_position.direction_to(
				player.global_position
			) * enemy.speed * delta

func _on_enemy_died(enemy):
	enemy.queue_free()

func _on_spawn_period_timeout():
	var rand_dir = Vector2.UP.rotated(randi())
	var enemy = Enemies.instance()
	enemy.connect("died", self, "_on_enemy_died")
	add_child(enemy)
	enemy.global_position = player.global_position + radius * rand_dir
