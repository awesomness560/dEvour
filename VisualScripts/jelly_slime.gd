extends Sprite2D
class_name JellySlime

@export var grab_speed: float = 0.3  # Total grab time in seconds
@export var wobble_duration: float = 0.4  # Wobble time after grab
@export var wobble_strength: float = 0.15  # How much wobble
@export var other : RigidBody2D

var original_scale: Vector2
var active_absorptions: Array[RigidBody2D] = []

func _ready():
	original_scale = scale

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("Debug"):
		#absorb_target(other)

# MAIN FUNCTION - Call this to absorb any target
func absorb_target(target: Node2D) -> void:
	if not is_instance_valid(target) or target in active_absorptions:
		return
	
	active_absorptions.append(target)
	
	# Disable target physics immediately
	target.freeze = true
	
	# Quick grab animation
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Pull target to center quickly
	tween.tween_property(target, "global_position", global_position, grab_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# Shrink target as it gets pulled in
	tween.tween_property(target, "scale", Vector2.ZERO, grab_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# Start wobble slightly before grab completes
	tween.tween_callback(func(): start_wobble()).set_delay(grab_speed * 0.7)
	
	# Clean up target
	tween.tween_callback(func(): cleanup_target(target)).set_delay(grab_speed)

func start_wobble():
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Quick scale wobble
	tween.tween_property(self, "scale", 
		original_scale * (1.0 + wobble_strength), wobble_duration * 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", original_scale, wobble_duration * 0.7).set_delay(wobble_duration * 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# Slight rotation wobble
	var original_rotation = rotation
	tween.tween_property(self, "rotation", 
		original_rotation + wobble_strength * 0.2, wobble_duration * 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "rotation", original_rotation, wobble_duration * 0.7).set_delay(wobble_duration * 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func cleanup_target(target: Node2D):
	if is_instance_valid(target):
		target.queue_free()
	
	active_absorptions.erase(target)


func _on_area_2d_body_entered(body: Node2D) -> void:
	absorb_target(body)
