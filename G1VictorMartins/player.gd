extends CharacterBody2D
var screen_size : Vector2
const SPEED = 300

var spawn_points := []

func _ready():
	screen_size = get_viewport_rect().size
	#position = screen_size/2

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var vertical_direction = Input.get_axis("ui_up", "ui_down")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	#move_and_collide(velocity)
	#position = position.clamp(Vector2.ZERO + $CollisionShape2D.shape.size/2, screen_size - $CollisionShape2D.shape.size/2)
	#position = position.clamp(Vector2.ZERO - $CollisionShape2D.shape.size/2, screen_size - $CollisionShape2D.shape.size)
	if velocity.length() != 0:
		
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				$AnimatedSprite2D.animation = "walk_right"
			else:
				$AnimatedSprite2D.animation = "walk_left"
			$AnimatedSprite2D.play()
		else:
			if velocity.y > 0:
				$AnimatedSprite2D.animation = "walk_down"
			else:
				$AnimatedSprite2D.animation = "walk_up"
			$AnimatedSprite2D.play()
	else:
		if $AnimatedSprite2D.frame == 2 || $AnimatedSprite2D.frame == 5:
			$AnimatedSprite2D.pause()
			#$AnimatedSprite2D.frame = 2
