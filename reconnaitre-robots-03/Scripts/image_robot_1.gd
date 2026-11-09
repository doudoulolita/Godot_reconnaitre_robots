extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var score = 0

@onready var count = get_parent().get_node("GUI/MeshInstance3D/Compteur") as Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	count.text = str(score)
	
	rotation=Vector3.ZERO

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func _on_robot_1_body_entered(_body: Node) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().name != "Sol1"):
			print ("J'ai touché " + collision.get_collider().name)
			count.text = str(score + 1) + " - Gagné !"
			velocity.y = JUMP_VELOCITY * 1.5

func _on_robot_2_body_entered(_body: Node) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().name != "Sol1"):
			print ("J'ai touché " + collision.get_collider().name)
			rotate_z(90)
			count.text = str(score - 1) + " - Perdu !"
