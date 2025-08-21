extends Sprite2D
class_name Food
var size 
var dots : int
func _ready() -> void:
	var playerSize = (Global.globalSize)
	randomize()
	size = randf_range((playerSize*.25),(playerSize*0.75))
	if Global.dots <= 100:
		dots = 1 * (size*100)
	else:
		dots = Global.dots *0.01* (size*100)
	scale = Vector2(size,size)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Food:
		self.queue_free()
