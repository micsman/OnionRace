extends Area3D

func _on_body_entered(body):
	ScreenFader.reload_scene(0.8)
