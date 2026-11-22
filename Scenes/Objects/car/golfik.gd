extends VehicleBody3D

@export var steer = 0.9
@export var power = 3000


#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("steer_right", "steer_left") * steer, delta*10)
	engine_force = Input.get_axis("reverse", "gas")*power
	if Input.is_action_pressed("brake"):
		brake = 25.0
	else:
		brake = 0.0
