extends KinematicBody2D
class_name Player

signal died

export var MAX_SPEED: int = 500
export var DASH_MULT: int = 2
export var ACCEL: int = 10000
export var FRICT: int = 15

onready var viewport_size: Vector2 = get_viewport_rect().size

var aim: Vector2
var dir: Vector2
var vel: Vector2
var dashing: bool = false
var dash_available: bool = true

func _init():
	if MAX_SPEED > ACCEL / FRICT:
		printerr("MAX_SPEED is greater than terminal velocity (ACCEL/FRICT)")

func _ready():
	$dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	$dash_cd.connect("timeout", self, "_on_dash_cd_timeout")

func _physics_process(delta):
	aim = get_global_mouse_position()
	look_at(aim)
	
	dir = get_input_dir()
	
	if !dashing:
		set_vel(delta)
	if move_and_collide(vel * delta):
		emit_signal("died")
	position.x = clamp(position.x, 0, viewport_size.x)
	position.y = clamp(position.y, 0, viewport_size.y)

	
func _unhandled_input(event):
	if event.is_action_pressed("ui_dash") && dash_available:
		start_dash()

func get_input_dir() -> Vector2:
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func set_vel(delta: float) -> void:
	vel += (dir * ACCEL - vel * FRICT) * delta
	vel = vel.clamped(MAX_SPEED)

func start_dash() -> void:
	dash_available = false
	dashing = true
	$dash_timer.start()
	$dash_cd.start()
	if dir:
		vel = dir * DASH_MULT * MAX_SPEED
	else:
		vel = global_position.direction_to(aim) * DASH_MULT * MAX_SPEED

func end_dash() -> void:
	vel = Vector2.ZERO

func _on_dash_timer_timeout() -> void:
	dashing = false
	end_dash()

func _on_dash_cd_timeout() -> void:
	dash_available = true
