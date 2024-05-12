extends CharacterBody2D
const Enemy := preload("res://enemy.gd")
var player_position: Vector2 = Vector2.ZERO
const SPEED = 1
var old_velocity: Vector2 = Vector2.ZERO

func _ready():
	#print("enemy ready")
	pass

func _physics_process(delta):
	#velocity.x = -10 if direction_right else 10
	var dir = self.player_position - self.position
	dir = dir.normalized() * SPEED
	velocity = dir + old_velocity/2
	if velocity.length() != 0:
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "walk_right"
		else:
			$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.play()
	else:
		if $AnimatedSprite2D.frame == 2 || $AnimatedSprite2D.frame == 5:
			$AnimatedSprite2D.pause()
			#$AnimatedSprite2D.frame = 2
	old_velocity = Vector2.ZERO
	var collision = move_and_collide(velocity)
	if collision:
		old_velocity = velocity.bounce(collision.get_normal())
		#var shot = collision.get_collider()
		#if shot is Enemy:
			#shot.queue_free()
			#queue_free()
		#move_and_slide()

func _on_body_entered(body):
	print(body)
