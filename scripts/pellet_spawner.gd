extends Node2D
@export var pellet:PackedScene
func _ready() -> void:
	for i in 100:
		var f = pellet.instantiate() as Food
		add_child(f)
		randomize()
		var x1 = randi_range(Global.player.global_position.x - 3000,Global.player.global_position.x - 200 )
		var x2 = randi_range(Global.player.global_position.x + 200,Global.player.global_position.x + 3000 )
		var y1 = randi_range(Global.player.global_position.y - 3000,Global.player.global_position.y - 200 )
		var y2 = randi_range(Global.player.global_position.y + 200,Global.player.global_position.y + 3000 )
		f.global_position.x = randi_range(x1, x2)
		f.global_position.y = randi_range(y1, y2)
