extends Area2D

var speed = 400
var direction = Vector2.ZERO

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("apply_damage"):
			body.apply_damage(1)
			call_deferred("queue_free")  # Destroy the bullet

