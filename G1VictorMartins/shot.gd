extends CharacterBody2D
const Enemy := preload("res://enemy.gd")
@onready var world = get_tree().root.get_node("world")
var direction: Vector2
var speed: float

func _draw():
	draw_circle(Vector2(0, 0), 10, Color.DIM_GRAY)

func _physics_process(delta):
	#self.velocity = direction * 10
	var collided = move_and_collide(direction * speed * 200 * delta)
	if collided:
		var enemy = collided.get_collider()
		if enemy is Enemy:
			#print(enemy)
			enemy.life -= 1
			if enemy.life <= 0:
				enemy.free()
				world.emit_signal("experience_increased", 10)
			self.free()
			



