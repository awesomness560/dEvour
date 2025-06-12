extends Sprite2D
class_name Food
var size 
func _ready() -> void:
	print(Global.player.circle.global_scale)
	var playerSize = (Global.player.circle.global_scale.x)
	print(playerSize)
	randomize()
	size = randf_range((playerSize*0.5),(playerSize*1.5))
	print(size)
	scale = Vector2(size,size)
	print(scale)
