extends Node2D
class_name enemy_spawner
@export var enemy : PackedScene
@export var enemies_per_wave : int = 1
@export var enemies_increment : int = 2

@export var pellet_spawner : NodePath

var pelletspawner : Pellet_Spawner
var waves: int = 0
var alive_enemies : int = 0
func _ready() -> void:
	await get_tree().process_frame
	pelletspawner = get_node(pellet_spawner) as Pellet_Spawner
	spawn_wave()
func spawn_wave() -> void:
	waves+=1
	enemies_per_wave += enemies_increment
	alive_enemies = enemies_per_wave
	for i in alive_enemies-1:
		var p = enemy.instantiate()
		add_child(p)
		p.add_to_group("enemies")
		randomize()
		var x1 = randi_range(Global.player.global_position.x - 3000,Global.player.global_position.x - 500 )
		var x2 = randi_range(Global.player.global_position.x + 500,Global.player.global_position.x + 3000 )
		var y1 = randi_range(Global.player.global_position.y - 3000,Global.player.global_position.y - 500 )
		var y2 = randi_range(Global.player.global_position.y + 500,Global.player.global_position.y + 3000 )
		p.global_position.x = randi_range(x1, x2)
		p.global_position.y = randi_range(y1, y2)
		p.connect("died", Callable(self, "on_death"))
	pelletspawner.spawn()
func on_death() -> void:
	alive_enemies -= 1
	if alive_enemies <= 0:
		spawn_wave()
