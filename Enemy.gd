extends KinematicBody2D
class_name Enemy

signal died(enemy)

export var hp: int = 100
export var speed: int = 100

func take_bullet(damage: int):
	hp -= damage
	if hp <= 0:
		emit_signal("died", self)
