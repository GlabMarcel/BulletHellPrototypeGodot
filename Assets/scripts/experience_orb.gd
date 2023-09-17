extends Area2D

var attraction_radius = 50  # Adjust as necessary
var attraction_speed = 200  # Adjust as necessary

func _ready():
    connect("body_entered", _on_Orb_body_entered)

func _on_Orb_body_entered(body):
    if body.is_in_group("player"):
        # Code to increase player's experience
        queue_free()  # This will remove the orb from the scene

func _physics_process(delta):
    var player = get_parent().get_node("Player")
    var distance_to_player = global_position.distance_to(player.global_position)
    
    if distance_to_player < attraction_radius:
        var direction_to_player = (player.global_position - global_position).normalized()
        global_position += direction_to_player * attraction_speed * delta

func _on_body_entered(body):
    if body.name == "Player":
        body.emit_signal("experience_gained", 1)  # Adjust the experience value as necessary
        queue_free()
