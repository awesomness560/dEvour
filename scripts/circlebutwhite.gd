extends Node2D
class_name Player
@export var camera: Camera2D
@export var circle: Sprite2D 
@export var speedingParticles : CPUParticles2D
@export var eatSoundEffect : AudioStreamPlayer
@export var intialSpeed = 1500
var speed = 200
#higher lower limit means circle must be larget to consume
@export var consumptionLowerLimit:float = .10
@export var area2d : Area2D
var zoomTarget : float = 1.0

var isSpeeding : bool = false

func _ready() -> void:
	Global.player = self
	Global.globalSize = .25
	checkForAreas()

func _process(delta: float) -> void:
	handleCamera()
	checkForAreas()
	if Input.is_action_pressed("ui_right"):
		global_position.x += speed*delta
	if Input.is_action_pressed("ui_left"):
		global_position.x -= speed*delta
	if Input.is_action_pressed("ui_up"):
		global_position.y -= speed*delta
	if Input.is_action_pressed("ui_down"):
		global_position.y += speed*delta
	if Input.is_key_pressed(KEY_SPACE):
		speed_up(delta)
	else:
		isSpeeding = false
		speed = intialSpeed * (Global.globalSize)
	
	speedingParticles.emitting = isSpeeding
	
func grow(): 
	circle.scale += Vector2(0.05,0.05)
	Global.globalSize = circle.scale.x
	updateParticleScale()

func updateParticleScale():
	# Scale particles based on player size
	var scale_multiplier = Global.globalSize * 60
	speedingParticles.scale_amount_min = scale_multiplier
	speedingParticles.scale_amount_max = scale_multiplier * 2.0

func checkForAreas():
	for i in area2d.get_overlapping_areas():
		var parent = i.get_parent()
		if parent is Food:
			Global.dots += round(parent.dots)
			SignalBus.collectedDots.emit(parent.dots)
			parent.queue_free()
			
			speed += 0.4
			eatSoundEffect.play()
			SignalBus.combo.emit()
			#zoom(parent)
		parent = parent.get_parent()
		if parent is enemy:
			Global.dots += round(Global.dots*.05)
			SignalBus.collectedDots.emit(round(Global.dots*.05))
			
			parent.die()
			SignalBus.combo.emit()
			#grow()#( i fix) kys (change if pellet scene is cganged in structure)
			#zoomTarget = lerpf(zoomTarget, 0.05, 0.05)
			speed += 0.4
			eatSoundEffect.play()
			#else:
				#circle.hide()
				
func handleCamera():
	var finalZoom = zoomTarget
	
	if isSpeeding:
		finalZoom *= 0.5
	camera.zoom.x = lerp(camera.zoom.x, finalZoom, 0.1)
	camera.zoom.y = lerp(camera.zoom.y, finalZoom, 0.1)
	
func speed_up(delta): 

	isSpeeding = true
	speed = intialSpeed * (Global.globalSize)*2
		# Only shrink if it won't go below the minimum
#func zoom(parent:Food):
	#camera.zoom /= zoomFactor
	#zoomFactor -= 0.05
	#zoomFactor = floor(zoomFactor)
