extends Node2D
class_name Player
@export var camera: Camera2D
@export var circle: Sprite2D 
@export var speed = 100

var zoomTarget = 1.0

func _ready() -> void:
	Global.player = self
func _process(delta: float) -> void:
	handleCamera()
	
	if Input.is_key_pressed(KEY_D):
		global_position.x += speed*delta
	if Input.is_key_pressed(KEY_A):
		global_position.x -= speed*delta
	if Input.is_key_pressed(KEY_W):
		global_position.y -= speed*delta
	if Input.is_key_pressed(KEY_S):
		global_position.y += speed*delta
func grow(parent:Food): 
	circle.global_scale += Vector2(0.05,0.05)
func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Food:
		#print(area.scale)
		#print(circle.scale)
		if parent.scale < circle.scale:
			parent.queue_free() 
			grow(parent)#( i fix) kys (change if pellet scene is cganged in structure)
			zoomTarget = lerpf(zoomTarget, 0.05, 0.05)
			speed += 0.4
			#zoom(parent)

func handleCamera():
	camera.zoom.x = lerp(camera.zoom.x, zoomTarget, 0.1)
	camera.zoom.y = lerp(camera.zoom.y, zoomTarget, 0.1)

#func zoom(parent:Food):
	#camera.zoom /= zoomFactor
	#zoomFactor -= 0.05
	#zoomFactor = floor(zoomFactor)
