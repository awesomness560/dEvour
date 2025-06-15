extends Control
class_name WaveVisual

@export var numberSettings : LabelSettings
@export var labelHeight = 80
@export var duration : float = 0.5
@export_group("References")
@export var numbersControl : Control
@export var newWaveSound : AudioStreamPlayer
@export var bufferTime : Timer

var currentNumber = 0
var currentLabel : Label
var pastLabel : Label

var startingPos : Vector2

func _ready() -> void:
	currentLabel = addNumberLabel(currentNumber, 0)
	startingPos = position
	
	SignalBus.newWave.connect(increment)

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#increment()

func increment():
	bufferTime.start()
	await bufferTime.timeout
	await moveScreenDown().finished
	currentNumber += 1
	
	pastLabel = currentLabel
	currentLabel = addNumberLabel(currentNumber, -labelHeight)
	
	newWaveSound.play()
	var tween := create_tween()
	
	tween.tween_property(pastLabel, "position", pastLabel.position + Vector2(0, labelHeight), duration)
	tween.set_parallel()
	tween.tween_property(currentLabel, "position", Vector2.ZERO, duration)
	
	await tween.finished
	
	cleanup_old_labels()
	moveScreenUp()

func moveScreenDown() -> Tween:
	var tween := create_tween()
	
	# Step 1: Overshoot past the target (go further down)
	tween.tween_property(self, "position", Vector2(0, 50), 0.5)
	tween.set_ease(Tween.EASE_OUT)
	
	# Step 2: Overcorrect (bounce back up past target)
	tween.tween_property(self, "position", Vector2(0, -20), 0.3)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Step 3: Settle to final position
	tween.tween_property(self, "position", Vector2.ZERO, 0.2)
	tween.set_ease(Tween.EASE_OUT)
	
	return tween

func moveScreenUp():
	var tween := create_tween()
	
	tween.tween_property(self, "position", Vector2(0, 50), 0.5)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "position", startingPos, 0.2)
	tween.set_ease(Tween.EASE_OUT)

func cleanup_old_labels():
	# Remove all labels except the one at position 0 (current number)
	for child in numbersControl.get_children():
		if child != currentLabel:
			child.queue_free()

func addNumberLabel(number : int, yPos : float) -> Label:
	var label = Label.new()
	label.text = str(number)
	label.label_settings = numberSettings
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size = Vector2(100, labelHeight)
	label.position = Vector2(0, yPos)
	
	numbersControl.add_child(label)
	
	return label
