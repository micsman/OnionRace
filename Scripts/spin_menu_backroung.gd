extends Node3D

@export var rotation_speed: float = 45.0
var z: float
var x: float

func _ready() -> void:
	z=rotation.z
	x=rotation.x
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed)*delta)
	rotation.z = z
	rotation.x = x
