class_name UpgradeContainer extends Control

enum UpgradeType { PLAYER_SPEED, SHOT_DELAY, SHOT_SPEED, SHOT_COUNT }
var upgrades = [UpgradeType.PLAYER_SPEED, UpgradeType.SHOT_SPEED, UpgradeType.SHOT_COUNT]

@onready var Label1 = $GridContainer/Panel/RichTextLabel
@onready var Label2 = $GridContainer/Panel2/RichTextLabel
@onready var Label3 = $GridContainer/Panel3/RichTextLabel
@onready var world = get_tree().root.get_node("world")

var Player := preload("res://player.tscn")
var player: Player
var playerState: PlayerState


func randomize():
	considered = false
	var allUpgrades = [
		UpgradeType.PLAYER_SPEED, UpgradeType.SHOT_DELAY, UpgradeType.SHOT_SPEED, 
		UpgradeType.PLAYER_SPEED, UpgradeType.SHOT_DELAY, UpgradeType.SHOT_SPEED, 
		UpgradeType.PLAYER_SPEED, UpgradeType.SHOT_DELAY, UpgradeType.SHOT_SPEED, 
		UpgradeType.SHOT_COUNT]
	allUpgrades.shuffle()
	Label1.text = upgradeLabel(upgrades[0])
	Label2.text = upgradeLabel(upgrades[1])
	Label3.text = upgradeLabel(upgrades[2])

func upgradeLabel(upgrade):
	match upgrade:
		UpgradeType.PLAYER_SPEED: return "[center]+ Player Speed[/center]"
		UpgradeType.SHOT_DELAY: return "[center]- Shot Delay[/center]"
		UpgradeType.SHOT_SPEED: return "[center]+ Shot Speed[/center]"
		UpgradeType.SHOT_COUNT: return "[center]+ Shot Count[/center]"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var considered = false
func _input(event) :
	if considered == false:
		if Input.is_key_pressed(KEY_1):
			applyUpgrade(upgrades[0])
			print("1")
			world.emit_signal("upgrade_chosen")
		if Input.is_key_pressed(KEY_2):
			applyUpgrade(upgrades[1])
			print("2")
			world.emit_signal("upgrade_chosen")
		if Input.is_key_pressed(KEY_3):
			applyUpgrade(upgrades[2])
			print("3")
			world.emit_signal("upgrade_chosen")
	


func applyUpgrade(upgrade):
	match upgrade:
		UpgradeType.PLAYER_SPEED: playerState.player_speed *= 1.05
		UpgradeType.SHOT_DELAY: playerState.shot_delay *= 0.95
		UpgradeType.SHOT_SPEED: playerState.shot_speed *= 1.1
		UpgradeType.SHOT_COUNT: playerState.shot_count += 1
	considered = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
