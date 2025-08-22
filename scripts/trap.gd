extends Node2D
class_name Trap
var dots := 50
@export var dotCap := 1200
func _grow(amt : int):
	if dots > dotCap:
		Global.dots += round(amt)
		SignalBus.collectedDots.emit(round(amt*.5))
	else:
		Global.dots += round(amt*.5)
		SignalBus.collectedDots.emit(round(amt*.5))
		dots += round(amt*.5)
		self.scale = Vector2(dots,dots)
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Food:
		_grow(parent.dots)
		parent.queue_free()
	elif parent is Trap:
		if parent.dots > self.dots:
			self.queue_free()
		else:
			_grow(parent.dots)
	elif parent is enemy:
		_grow(Global.dots *0.01)
