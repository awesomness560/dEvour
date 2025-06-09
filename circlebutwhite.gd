extends Sprite2D
@export var speed = 2
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_D):
		global_position.x += speed
	if Input.is_key_pressed(KEY_A):
		global_position.x -= speed
	if Input.is_key_pressed(KEY_W):
		global_position.y -= speed
	if Input.is_key_pressed(KEY_S):
		global_position.y += speed
