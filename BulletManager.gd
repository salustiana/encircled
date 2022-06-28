extends Node2D

var player: Player
var Bullets: PackedScene

func _on_level_loaded():
	$fire_period.wait_time = 1 / player.get_node("gun").fire_rate
	$fire_period.connect("timeout", self, "_on_fire_period_timeout")
	Bullets = load(player.get_node("gun").bullets_path)
	$fire_period.start()

func _on_fire_period_timeout() -> void:
	var bullet: Bullet = Bullets.instance()
	add_child(bullet)
	bullet.global_rotation += player.global_rotation
	bullet.global_position = player.get_node("gun").get_node(
		"muzzle"
	).global_position
	bullet.vel = player.get_node("gun").get_node(
		"holster"
	).global_position.direction_to(
		player.get_node("gun").get_node("muzzle").global_position
	) * bullet.speed
	
	bullet.connect("body_entered", self, "_on_bullet_hit", [bullet])


func _physics_process(delta):
	for bullet in get_children():
		if bullet is Bullet:
			bullet.position += bullet.vel * delta

func _on_bullet_hit(body: Node, bullet: Bullet) -> void:
	if body.has_method("take_bullet"):
		body.take_bullet(bullet.damage)
		bullet.queue_free()
