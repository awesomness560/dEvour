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
	self.visible = false
func _process(delta: float) -> void:
	if !self.visible:
		if !$Area2D.has_overlapping_areas() && !$Area2D.has_overlapping_bodies():
			self.visible = true
		else:
			self.free()
