extends Node2D
class_name enemy
signal died
@export var speed = 100
func _ready() -> void:
	add_to_group("enemies")
func _process(delta: float) -> void:
	var movement : Vector2 = (Global.player.global_position - global_position).normalized()
	global_position += movement * delta * speed
	look_at(Global.player.global_position)
func die() -> void:
	emit_signal("died")
	queue_free()
