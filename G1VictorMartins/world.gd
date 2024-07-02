extends Node2D
const PlayerState := preload("res://PlayerState.gd")
var enemy_scene := preload("res://enemy.tscn")
var shot_scene := preload("res://shot.tscn")
var spawn_points := []
var enemies := []
var playerState = PlayerState.new()
var experience = 0
const experience_per_level = 100
var level = 0

var gameOver = false
func refreshGameOver():
	if gameOver:
		$GameOver.show()
	else:
		$GameOver.hide()


func _input(event):
	if gameOver and Input.is_key_pressed(KEY_SPACE):
		get_tree().reload_current_scene()
		#gameOver = false
		#refreshGameOver()


signal game_over
func _on_game_over():
	gameOver = true
	refreshGameOver()

signal upgrade_chosen
func _on_upgrade_chosen():
	var shot_timer: Timer = get_node("shot_timer")
	shot_timer.wait_time = playerState.shot_delay
	showUpgradeView(false)

signal experience_increased(value)
func _on_experience_increased(value):
	experience += value * (1-(level * 0.1))
	if experience >= experience_per_level:
		showUpgradeView(true)
		experience = 0
		level += 1
	setExperience(experience)

@onready var upgradeView: Control = $UpgradeLayer/UpgradeView
@onready var upgradeViewBackground = $UpgradeLayer/ColorRect
func showUpgradeView(visibility):
	if visibility:
		#upgradeView.visible = true
		upgradeView.playerState = playerState
		upgradeView.randomize()
		upgradeView.player = $Player
		upgradeView.show()
		upgradeViewBackground.visible = true
	else:
		upgradeView.hide()
		#upgradeView.visible = false
		upgradeViewBackground.visible = false
			
var shots := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_node("EnemySpawner").get_children():
		if child is Marker2D:
			spawn_points.append(child)
	connect("experience_increased", _on_experience_increased)
	connect("upgrade_chosen", _on_upgrade_chosen)
	connect("game_over", _on_game_over)
	var timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)
	var shot_timer: Timer = get_node("shot_timer")
	shot_timer.wait_time = playerState.shot_delay
	shot_timer.timeout.connect(_on_shot_timer_timeout)
	showUpgradeView(false)
	refreshGameOver()

func setExperience(newValue):
	var piece = (get_viewport_rect().size.x - 100)/experience_per_level
	$ExperienceLayer/ExperienceRect.size.x = newValue * piece

var timer_count = 0

func _on_shot_timer_timeout():
	timer_count += 1
	#print(timer_count)
	#$Player.SPEED *= 1.01
	#experience_increased.emit(10)
	if timer_count % 10 == 0:
		var timer = get_node("Timer")
		timer.wait_time *= 0.99
	var enemy = []
	
	for i in range(playerState.shot_count):
		var result = findEnemyDirection(enemy)
		if result == []:
			break
		enemy.append(result[0])
		var dir = result[1]
		shoot(dir)
	
	#showUpgradeView(timer_count % 5 == 0)
	
func findEnemyDirection(ignoringEnemy):
	var chosenEnemy: CharacterBody2D
	for enemy in enemies:
		if is_instance_valid(enemy):
			if enemy not in ignoringEnemy:
				if chosenEnemy == null || $Player.position.distance_to(chosenEnemy.position) > $Player.position.distance_to(enemy.position):
					chosenEnemy = enemy
		else:
			enemies.erase(enemy)
	if chosenEnemy == null:
		return []
	var dir = chosenEnemy.position - $Player.position
	return [chosenEnemy, dir.normalized()]

func shoot(dir):
	var shot = shot_scene.instantiate()
	shot.position = $Player.position
	shot.speed = playerState.shot_speed
	
	shot.direction = dir
	self.add_child(shot)
	
func _on_timer_timeout():
	#var spawn = spawn_points[randi() % spawn_points.size()]
	var enemy = enemy_scene.instantiate()
	var rx = randf_range(-2000, 2000)
	var ry = randf_range(-1000, 1000)
	#print($Player.position)
	enemy.position = Vector2(rx, ry)
	self.enemies.append(enemy)
	self.add_child(enemy)
	
	

func _physics_process(delta):
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.player_position = $Player.position
		#else:
			#print(enemy)
			#enemies.erase(enemy)
