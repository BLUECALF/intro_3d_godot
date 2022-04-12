extends KinematicBody

onready var head =  $head
onready var body  =  $body
var mouse_sensitivity =  1
var gravity = Vector3.DOWN * 12
var speed =  4
var jump_speed  =  6
var spin = 0.1
var jump

export (NodePath) var joystickRightPath
onready var joystickRight : VirtualJoystick = get_node(joystickRightPath)

var velocity = Vector3()


func _physics_process(delta: float) -> void:
	velocity += gravity * delta
	get_input()
	rotate_player()
	velocity = move_and_slide(velocity,Vector3.UP)
	if jump and is_on_floor():
		velocity.y = jump_speed
	

func get_input() -> void:
	var vy = velocity.y
	velocity =  Vector3()
	
	 #check for inputs
	if Input.is_action_pressed("move_foward"):
		velocity -=  transform.basis.z * speed	
	if Input.is_action_pressed("move_back"):
		velocity +=  transform.basis.z * speed
	if Input.is_action_pressed("strafe_right"):
		velocity +=  transform.basis.x * speed
	if Input.is_action_pressed("strafe_left"):
		velocity -=  transform.basis.x * speed
	velocity.y = vy
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-lerp(0, spin,event.relative.x/10))
		head.rotate_x(-lerp(0, spin,event.relative.y/10))
		head.rotation_degrees.x = min(60,head.rotation_degrees.x)
		head.rotation_degrees.x = max(-45,head.rotation_degrees.x)

func rotate_player():
	rotate_y(deg2rad(joystickRight.get_output().x * mouse_sensitivity))
	head.rotate_x(deg2rad(joystickRight.get_output().y * mouse_sensitivity))
	head.rotation_degrees.x = min(60,head.rotation_degrees.x)
	head.rotation_degrees.x = max(-45,head.rotation_degrees.x)
