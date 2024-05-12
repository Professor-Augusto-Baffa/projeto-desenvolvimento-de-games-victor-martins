extends CharacterBody2D
const Enemy := preload("res://enemy.gd")
var direction: Vector2

func _draw():
	draw_circle(Vector2(0, 0), 10, Color.WHITE)

func _physics_process(delta):
	#self.velocity = direction * 10
	var collided = move_and_collide(direction * 10)
	if collided:
		var enemy = collided.get_collider()
		if enemy is Enemy:
			print(enemy)
			enemy.free()
			self.free()



