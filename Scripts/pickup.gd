extends Node3D
@export var rotation_speed: float = 45.0
var tween: Tween
var start_y: float
@export var main: Node3D
signal send_layer(layer: int)



func _ready() -> void:
	start_y = position.y
	start_floating()
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed)*delta)

func start_floating() -> void:
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(self, "position:y", start_y + 1, 1.5)
	tween.tween_property(self, "position:y", start_y, 1.5)
	


func _on_red(_body: Node3D) -> void:
	send_layer.emit(1)
	queue_free()
	self.hide()
	
func _on_green(_body: Node3D) -> void:
	send_layer.emit(2)
	queue_free()
	self.hide()
	
func _on_blue(_body: Node3D) -> void:
	send_layer.emit(3)
	queue_free()
	self.hide()
