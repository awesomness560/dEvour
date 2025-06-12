extends Label
class_name Combo

@export var pulseMaxSize = 1.1
@export var pulseTime = 0.1
@export var comboMaxSize = 1.5
@export var comboRotation = 15
@export var comboTime = 0.1
@export var comboTimer : Timer
@export var comboBar : ProgressBar

var pulsingTween : Tween
var comboTween : Tween
var comboRotationTween : Tween

var container : Control

var originalScale : Vector2
var originalRotation : float

func _ready() -> void:
	originalScale = get_parent().scale
	originalRotation = get_parent().rotation_degrees
	container = get_parent().get_parent()
	startPulse()
	
	comboBar.max_value = comboTimer.wait_time
	
	SignalBus.combo.connect(combo)

func _process(delta: float) -> void:
	comboBar.value = comboTimer.time_left

func startPulse():
	pulsingTween = create_tween()
	pulsingTween.tween_property(container, "scale", Vector2(pulseMaxSize, pulseMaxSize), pulseTime)
	pulsingTween.tween_property(container, "scale", originalScale, pulseTime)
	pulsingTween.set_loops()

func refreshTimer():
	comboTimer.stop()
	comboTimer.start()

func combo():
	Global.combo += 1
	self.text = str(Global.combo)
	
	refreshTimer()
	
	if pulsingTween:
		pulsingTween.kill()
	if comboTween:
		comboTween.kill()
	if comboRotationTween:
		comboRotationTween.kill()
	
	if scale > Vector2(pulseMaxSize, pulseMaxSize):
		scale = Vector2(pulseMaxSize, pulseMaxSize)
	
	comboTween = create_tween()
	comboTween.tween_property(container, "scale", Vector2(comboMaxSize, comboMaxSize), comboTime)
	comboTween.tween_property(container, "scale", originalScale, comboTime)
	
	comboRotationTween = create_tween()
	var comboRotTime = comboTime/3
	comboRotationTween.tween_property(container, "rotation_degrees", -comboRotation, comboRotTime)
	comboRotationTween.tween_property(container, "rotation_degrees", comboRotation, comboRotTime)
	comboRotationTween.tween_property(container, "rotation_degrees", originalRotation, comboRotTime)
	
	await comboTween.finished
	
	startPulse()


func _on_combo_timer_timeout() -> void:
	Global.combo = 1
	self.text = str(Global.combo)
