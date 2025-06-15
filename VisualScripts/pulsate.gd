extends Control
class_name Pulsate

##The amount by which to multiply the size by at max pulsation
@export var sizeMultiplier : float = 1.5 
##The duration for a full pulse cycle
@export var durationForPulseCycle : float = 1

var originalSize : Vector2

func _ready() -> void:
	await get_tree().process_frame
	originalSize = scale
	
	pivot_offset.x = size.x / 2
	pivot_offset.y = size.y / 2
	
	var tween := create_tween()
	
	tween.tween_property(self, "scale", originalSize * sizeMultiplier, durationForPulseCycle / 2)
	tween.tween_property(self, "scale", originalSize, durationForPulseCycle / 2)
	tween.set_loops()
