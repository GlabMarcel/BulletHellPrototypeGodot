extends Node2D

var enemy_scene = preload("res://Assets/Scenes/enemy_slime.tscn")
@onready var player = get_node("../Player")
@onready var timer = get_node("Timer")

# Variable to control the number of enemies spawned in each wave
var enemies_per_wave = 5

func _ready():
	# Start the timer when the scene is loaded
	timer.start()

func _on_timer_timeout():
	# Spawn a wave of enemies at random positions around the player when the timer times out
	spawn_enemy_wave()

func spawn_enemy_wave():
	for i in range(enemies_per_wave):
		# Instantiate a new enemy instance
		var enemy = enemy_scene.instantiate()
		
		# Set the enemy's position to a random position around the player
		var spawn_radius = 100  # Adjust as needed
		var angle = randf() * 2 * PI
		var spawn_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
		
		get_parent().add_child(enemy)
		
		# Set the enemy's global position to the spawn position
		enemy.global_position = spawn_position

