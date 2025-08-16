extends Sprite2D
class_name Food
var size 
func _ready() -> void:
	var playerSize = (Global.globalSize)
	randomize()
	size = randf_range((playerSize*.5),(playerSize*1))
	scale = Vector2(size,size)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Food:
		area.get_parent().queue_free()
