extends Node2D
class_name enemy
signal died
@export var triangle : Sprite2D
var size 
@export var speed = 1000
func _ready() -> void:
	add_to_group("enemies")
	var playerSize = (Global.globalSize)
	size = randf_range((playerSize*0.5),(playerSize*1.5))
	scale = Vector2(size,size)
	print(scale)
func _process(delta: float) -> void:
	if Global.player:
		var movement : Vector2 = (Global.player.global_position - global_position).normalized()
		global_position += movement * delta * speed
		look_at(Global.player.global_position)	
func die() -> void:
	emit_signal("died")
	queue_free()
	
