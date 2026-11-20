extends VehicleBody3D

@export var steer = 0.9
@export var power = 3000


#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_layer(WorldLayer.LAYER_1)


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("steer_right", "steer_left") * steer, delta*10)
	engine_force = Input.get_axis("reverse", "gas")*power
	if Input.is_action_pressed("brake"):
		brake = 25.0
	else:
		brake = 0.0


@export var layer1: Node3D
@export var layer2: Node3D
@export var layer3: Node3D

enum WorldLayer {LAYER_1, LAYER_2, LAYER_3}
var current_layer: WorldLayer = WorldLayer.LAYER_1

const ALPHA_ACTIVE: float = 1.0
const ALPHA_INACTIVE: float = 0.25


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_layer"):
		if current_layer == WorldLayer.LAYER_1:
			switch_layer(WorldLayer.LAYER_2)
		elif current_layer == WorldLayer.LAYER_2:
			switch_layer(WorldLayer.LAYER_3)
		else:
			switch_layer(WorldLayer.LAYER_1)


func switch_layer(new_layer: WorldLayer):
	current_layer = new_layer
	
	match current_layer:
		WorldLayer.LAYER_1:
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, false)
			set_collision_mask_value(3, false)
			
			layer_transp(layer1, ALPHA_ACTIVE)
			layer_transp(layer2, ALPHA_INACTIVE)
			layer_transp(layer3, ALPHA_INACTIVE)
			
		WorldLayer.LAYER_2:
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, false)
			
			layer_transp(layer1, ALPHA_INACTIVE)
			layer_transp(layer2, ALPHA_ACTIVE)
			layer_transp(layer3, ALPHA_INACTIVE)
			
		WorldLayer.LAYER_3:
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, false)
			set_collision_mask_value(3, true)
			
			layer_transp(layer1, ALPHA_INACTIVE)
			layer_transp(layer2, ALPHA_INACTIVE)
			layer_transp(layer3, ALPHA_ACTIVE)
	
func layer_transp(test: Node3D, alpha_v:float):
	if not test:
		return
	
	for child in test.get_children():
		if child is CSGShape3D:
			
			child.material = child.material.duplicate()
			var mat = child.material as StandardMaterial3D
			if mat:
				var cur_color = mat.albedo_color
				cur_color.a = alpha_v
				mat.albedo_color = cur_color
