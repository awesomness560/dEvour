extends Sprite2D
class_name Food
var size 
func _ready() -> void:
	var playerSize = (Global.globalSize)
	randomize()
	size = randf_range((playerSize*.5),(playerSize*1))
	scale = Vector2(size,size)
	print(scale)
