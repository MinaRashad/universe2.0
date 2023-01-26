extends KinematicBody



export var mouse_sensitivity := 0.04
export var speed := 10.0;
export var acceleration := 1;
export var jump :=5.0;
export var friction := 0.05

onready var head = $head
onready var mesh = $Mesh
var state = "idle"

# calculate the direction based on rotation of camera
# ignoring the x-axis rotation
# initial conditions
var current_rotation = 0
var motion = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	mesh.set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var dir = Vector2(0,0)
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("forward")) - int(Input.is_action_pressed("backward"))
	
	# by rotating the Forward vector (initial forward direction)
	# we can attain the new forward direction with respect to camera
	# by multiplying the dir x and y with it we will get the full motion direction
	
	var forward_dir = Vector3.FORWARD.rotated(Vector3.UP,current_rotation).normalized()
	var right_dir = forward_dir.cross(Vector3.UP).normalized()

	
	if state == "idle":

		# if they are trying to move, change state to walking
		if dir.length_squared() != 0 :
			state = "walking"
		
		motion = lerp(motion, Vector3.ZERO, friction)
	elif state == "walking":
		# determining the direction it should move
		# the forward is the positive (same as right),
		var moving_dir = (forward_dir*dir.y + right_dir*dir.x).normalized()
		
		
		motion = lerp(motion, moving_dir*speed, acceleration)
		
		print(motion)
	
		
		if dir.length_squared() == 0 :
			state = "idle"
			
			
	move_and_slide(motion)
			
			
func _input(event):
	## ToDo: Virtual reality
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(event.relative.x*mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y*mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x,-PI/2,PI/2)
		current_rotation = rotation.y

		

