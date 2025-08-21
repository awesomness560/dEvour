extends Node2D
class_name MainMenu

@export_group("References")
@export var player : Player
@export var mainMenu : CanvasLayer
@export var hud : CanvasLayer

var origZoom : Vector2

func _ready() -> void:
	origZoom = player.camera.zoom
	player.zoomTarget = 1.6
	player.camera.zoom *= 1.6

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
		startGame()

func startGame():
	SignalBus.gameStart.emit()
	mainMenu.hide()
	hud.show()
	
	player.zoomTarget = 1
	
