extends Node2D
class_name Pellet_Spawner
@export var pellet:PackedScene
@export var time_between_waves: float = 5.0
@export var pellets_per_wave: int = 20
@export var pellets_increment: int = 0  # increase pellets each wave if desired

var waves : int = 0
func spawn() -> void:
	waves+=1
	pellets_per_wave += pellets_increment
	var pellet_count = pellets_per_wave * waves
	if (waves == 1):
		for i in pellets_per_wave:
			var f = pellet.instantiate() as Food
			add_child(f)
			f.add_to_group("pellets")
			randomize()
			var x1 = randi_range(Global.player.global_position.x - 3000,Global.player.global_position.x - 200 )
			var x2 = randi_range(Global.player.global_position.x + 200,Global.player.global_position.x + 3000 )
			var y1 = randi_range(Global.player.global_position.y - 3000,Global.player.global_position.y - 200 )
			var y2 = randi_range(Global.player.global_position.y + 200,Global.player.global_position.y + 3000 )
			f.global_position.x = randi_range(x1, x2)
			f.global_position.y = randi_range(y1, y2)
	else:
		for i in pellets_per_wave:
			var f = pellet.instantiate() as Food
			add_child(f)
			randomize()
			var x1 = randi_range(0 - 3000,0- 200 )
			var x2 = randi_range(0+ 200,0+ 3000 )
			var y1 = randi_range(0- 3000,0 - 200 )
			var y2 = randi_range(0+ 200,0 + 3000 )
			f.global_position.x = randi_range(x1, x2)*(waves/2)*Global.globalSize
			f.global_position.y = randi_range(y1, y2)*(waves/2)*Global.globalSize
