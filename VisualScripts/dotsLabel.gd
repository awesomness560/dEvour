extends Label

@export var pulseMaxSize = 1.1
@export var pulseTime = 0.1
@export var MaxPulsesPerStreak : int = 12


var pulsingTween : Tween

var pulses := 0
var container : Control

var originalScale : Vector2
var originalRotation : float
var tempdots : int
func _ready() -> void:
	originalScale = get_parent().scale
	originalRotation = get_parent().rotation_degrees
	container = get_parent().get_parent()
	text = str(Global.dots)
	SignalBus.collectedDots.connect(_collected)
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("Debug"):
		#combo()

func startPulse():
	pulsingTween = create_tween()
	pulsingTween.tween_property(container, "scale", Vector2(pulseMaxSize, pulseMaxSize), pulseTime)
	pulsingTween.tween_property(container, "scale", originalScale, pulseTime)

func _collected(amount:int):
	tempdots += amount
	

func _process(delta: float) -> void:
	if tempdots >0:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		if pulses>0:
			pulses = 0


func _on_timer_timeout() -> void:
	tempdots -= 1
	if pulses > MaxPulsesPerStreak:
		text = str(Global.dots)
		tempdots = 0
		pulses = 0
	
	else:
		pulses += 1
		startPulse()
		text = str(Global.dots-tempdots)
		if tempdots >0:
			$Timer.start()
			
