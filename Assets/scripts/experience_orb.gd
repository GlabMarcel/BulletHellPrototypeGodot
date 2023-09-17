extends Area2D

var attraction_radius = 50  # Adjust as necessary
var attraction_speed = 200  # Adjust as necessary

var player

func _ready():
    connect("body_entered", _on_area_entered)
    player = get_node("../Player")
    

func _physics_process(delta):
    var player = get_parent().get_node("Player")
    var distance_to_player = global_position.distance_to(player.global_position)
    
    if distance_to_player < attraction_radius:
        var direction_to_player = (player.global_position - global_position).normalized()
        global_position += direction_to_player * attraction_speed * delta

func _on_area_entered(area):
    print("Body entered: ", area.name)  # This will print the name of the node that entered
    if area.name == "Player":
        player.gain_experience(1)  # Adjust the experience value as necessary
        print("AAAAAAAYYY")
        queue_free()  # This will remove the orb from the scene







