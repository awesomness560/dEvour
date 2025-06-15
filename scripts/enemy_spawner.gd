extends Node2D
class_name enemy_spawner
@export var nemy : PackedScene
@export var enemies_per_wave : int = 1
@export var enemies_increment : int = 2

@export var pellet_spawner : NodePath

var pelletspawner : Pellet_Spawner
var waves: int = 0
var alive_enemies : int = 0
func _ready() -> void:
	await get_tree().process_frame
	randomize()
	pelletspawner = get_node(pellet_spawner) as Pellet_Spawner
	
	await SignalBus.gameStart
	
	spawn_wave()
func spawn_wave() -> void:
	waves+=1
	SignalBus.newWave.emit()
	enemies_per_wave += enemies_increment
	alive_enemies = enemies_per_wave
	for i in range(enemies_per_wave):
		var p = nemy.instantiate()
		add_child(p)
		p.add_to_group("enemies")
		var side = randi() % 4
		var spawn = Vector2()
		var distance = randi_range(500,3000)
		match side:
			0: 
				spawn.x = Global.player.global_position.x - distance
				spawn.y = Global.player.global_position.y + randi_range(-3000, 3000)
			1:
				spawn.x = Global.player.global_position.x - distance
				spawn.y = Global.player.global_position.y + randi_range(-3000, 3000)
			2:
				spawn.x = Global.player.global_position.x + randi_range(-3000,3000)
				spawn.y = Global.player.global_position.y - distance
			3:
				spawn.x = Global.player.global_position.x + randi_range(-3000,3000)
				spawn.y = Global.player.global_position.y - distance
		p.global_position = spawn
		p.died.connect(on_death)
	pelletspawner.spawn()
func on_death() -> void:
	alive_enemies -= 1
	if alive_enemies <= 0:
		spawn_wave()
