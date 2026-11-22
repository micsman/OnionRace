extends Node3D

var mat_path := "res://assets/Godot materials/Color_swap.tres"
var shared_mat: StandardMaterial3D

@export var layer1: Node3D
@export var layer2: Node3D
@export var layer3: Node3D
@export var car: VehicleBody3D

enum WorldLayer {LAYER_1, LAYER_2, LAYER_3}
@export var current_layer: WorldLayer = WorldLayer.LAYER_1

const ALPHA_ACTIVE: float = 1.0
const ALPHA_INACTIVE: float = 0.25


func _ready() -> void:
	shared_mat = load(mat_path) as StandardMaterial3D
	if shared_mat:
		shared_mat.albedo_color = Color.BLACK
		
	for pickup in $pickups.get_children():
		if pickup.has_signal("send_layer"):
			pickup.send_layer.connect(_on_send_layer)	


func _on_send_layer(set_layer: int) -> void:
	if set_layer == 1:
		switch_layer(0)
	if set_layer == 2:
		switch_layer(1)
	if set_layer == 3:
		switch_layer(2)
	

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("change_layer"):
		#if current_layer == WorldLayer.LAYER_1:
			#switch_layer(WorldLayer.LAYER_2)
		#elif current_layer == WorldLayer.LAYER_2:
			#switch_layer(WorldLayer.LAYER_3)
		#else:
			#switch_layer(WorldLayer.LAYER_1)


func switch_layer(new_layer: WorldLayer):
	current_layer = new_layer
	
	match current_layer:
		WorldLayer.LAYER_1:
			car.set_collision_mask_value(1, true)
			car.set_collision_mask_value(2, false)
			car.set_collision_mask_value(3, false)
			shared_mat.albedo_color = Color.RED
			layer_transp(layer1, ALPHA_ACTIVE)
			layer_transp(layer2, ALPHA_INACTIVE)
			layer_transp(layer3, ALPHA_INACTIVE)
			
		WorldLayer.LAYER_2:
			car.set_collision_mask_value(1, false)
			car.set_collision_mask_value(2, true)
			car.set_collision_mask_value(3, false)
			shared_mat.albedo_color = Color.GREEN
			layer_transp(layer1, ALPHA_INACTIVE)
			layer_transp(layer2, ALPHA_ACTIVE)
			layer_transp(layer3, ALPHA_INACTIVE)
			
		WorldLayer.LAYER_3:
			car.set_collision_mask_value(1, false)
			car.set_collision_mask_value(2, false)
			car.set_collision_mask_value(3, true)
			shared_mat.albedo_color = Color.BLUE
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
