extends Node2D
class_name enemy
signal died
@export var speed = 100
func _ready() -> void:
	await get_tree().process_frame
	add_to_group("enemies")
	if $triangle.scale.x != Global.globalSize:
		$triangle.scale = Vector2(Global.globalSize/5.1,Global.globalSize/5.1)
		
func _process(delta: float) -> void:
	if Global.player:
		var movement : Vector2 = (Global.player.global_position - global_position).normalized()
		global_position += movement * delta * speed
		look_at(Global.player.global_position)
	
func die() -> void:
	died.emit()
	queue_free()
	
