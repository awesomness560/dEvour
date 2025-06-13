extends Node2D
class_name enemy
@export var speed = 100
func _process(delta: float) -> void:
	var movement : Vector2 = (Global.player.global_position - global_position).normalized()
	global_position += movement * delta * speed
	look_at(Global.player.global_position)
