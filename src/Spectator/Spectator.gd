extends Spatial

const MOUSE_SENSITIVITY = 0.2

onready var rotation_helper = $RotationHelper
onready var camera = $RotationHelper/Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Camera movement.
	var left_right = Input.get_action_strength("movement_backward") - Input.get_action_strength("movement_forward")
	var up_down = Input.get_action_strength("movement_up") - Input.get_action_strength("movement_down")
	var forward_backward = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	translate(Vector3(forward_backward, up_down, left_right))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_rotate(event.relative)

func camera_rotate(vec):
	rotation_helper.rotate_x(deg2rad(vec.y * MOUSE_SENSITIVITY * -1))
	self.rotate_y(deg2rad(vec.x * MOUSE_SENSITIVITY * -1))
	# Set x/z to zero to avoid very strange camera stuff.
	self.rotation_degrees.x = 0
	self.rotation_degrees.z = 0
	
	var camera_rot = rotation_helper.rotation_degrees
	# FIXME: This clamp() is pretty arbitrary. It's worth playing with.
	#        -89,89 is one degree before straight down to one degree before straight up.
	#        Anything beyond this would allow the player to see behind them, which is a bit silly.
	camera_rot.x = clamp(camera_rot.x, -80, 89)
	# Set y/z to zero to avoid very strange camera stuff.
	camera_rot.y = 0
	camera_rot.z = 0
	rotation_helper.rotation_degrees = camera_rot
