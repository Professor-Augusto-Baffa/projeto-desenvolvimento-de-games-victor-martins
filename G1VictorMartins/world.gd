extends Node2D

var enemy_scene := preload("res://enemy.tscn")
var shot_scene := preload("res://shot.tscn")
var spawn_points := []
var enemies := []

var shots := []
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_node("EnemySpawner").get_children():
		if child is Marker2D:
			spawn_points.append(child)
			
	var timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)
	var shot_timer = get_node("shot_timer")
	shot_timer.timeout.connect(_on_shot_timer_timeout)

func _on_shot_timer_timeout():
	var shot = shot_scene.instantiate()
	shot.position = $Player.position
	var chosenEnemy: CharacterBody2D
	for enemy in enemies:
		if is_instance_valid(enemy):
			if chosenEnemy == null || $Player.position.distance_to(chosenEnemy.position) > $Player.position.distance_to(enemy.position):
				chosenEnemy = enemy
		else:
			enemies.erase(enemy)
	#while enemies.size() > 0 && chosenEnemy == null:
		#var randomIndex = randi() % enemies.size()
		#if is_instance_valid(enemies[randomIndex]) == false:
			#enemies.erase(enemies[randomIndex])
		#else:
			#chosenEnemy = enemies[randomIndex]
	var dir = chosenEnemy.position - $Player.position
	dir = dir.normalized()
	shot.direction = dir
	self.add_child(shot)
	
func _on_timer_timeout():
	var spawn = spawn_points[randi() % spawn_points.size()]
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn.position
	self.enemies.append(enemy)
	self.add_child(enemy)
	
	

func _physics_process(delta):
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.player_position = $Player.position
		else:
			print(enemy)
			enemies.erase(enemy)
