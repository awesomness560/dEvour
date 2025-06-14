extends Node2D
class_name Player
@export var camera: Camera2D
@export var circle: Sprite2D 
@export var intialSpeed = 100
var speed = 100
#higher lower limit means circle must be larget to consume
@export var consumptionLowerLimit:float = .10
@export var area2d : Area2D
var zoomTarget = 1.0

func _ready() -> void:
	Global.player = self 
	checkForAreas()
func _process(delta: float) -> void:
	handleCamera()
	checkForAreas()
	if Input.is_key_pressed(KEY_D):
		global_position.x += speed*delta
	if Input.is_key_pressed(KEY_A):
		global_position.x -= speed*delta
	if Input.is_key_pressed(KEY_W):
		global_position.y -= speed*delta
	if Input.is_key_pressed(KEY_S):
		global_position.y += speed*delta
	if Input.is_key_pressed(KEY_SPACE):
		speed_up(delta)
	else:
		speed = intialSpeed
	
func grow(): 
	circle.scale += Vector2(0.05,0.05)
	Global.globalSize = circle.scale.x

func checkForAreas():
	for i in area2d.get_overlapping_areas():
		var parent = i.owner
		if parent is Food:
			if parent.scale.x < (Global.globalSize-consumptionLowerLimit):
				parent.queue_free() 
				grow()#( i fix) kys (change if pellet scene is cganged in structure)
				zoomTarget = lerpf(zoomTarget, 0.05, 0.05)
				speed += 0.4
				#zoom(parent)
		elif parent is enemy:
			#if parent.size.x < (Global.globalSize-consumptionLowerLimit):
			print("Enemy dying:", parent)
			parent.die()
			grow()#( i fix) kys (change if pellet scene is cganged in structure)
			zoomTarget = lerpf(zoomTarget, 0.05, 0.05)
			speed += 0.4
			#else:
				#circle.hide()
				
func handleCamera():
	camera.zoom.x = lerp(camera.zoom.x, zoomTarget, 0.1)
	camera.zoom.y = lerp(camera.zoom.y, zoomTarget, 0.1)
	
func speed_up(delta): 
	if(circle.scale.x < 0.25):
		return
	else:
		speed = 200
		circle.scale -= Vector2(0.05,0.05) * delta
		Global.globalSize = circle.scale.x 
#func zoom(parent:Food):
	#camera.zoom /= zoomFactor
	#zoomFactor -= 0.05
	#zoomFactor = floor(zoomFactor)
