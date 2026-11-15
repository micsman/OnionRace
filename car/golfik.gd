extends VehicleBody3D

@export var steer = 0.9
@export var power = 400

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * steer, delta*10)
	engine_force = Input.get_axis("ui_down", "ui_up")*power
