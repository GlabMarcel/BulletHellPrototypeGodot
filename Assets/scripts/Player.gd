extends Area2D

signal health_changed(new_health, max_health)
signal experience_gained(new_experience)
signal level_up(new_level)

@export var speed = 40
@export var max_hp = 10
var hp = max_hp
var is_alive = true

@export var deadzone = 50
@export var start: Vector2 = Vector2(0,1)

@onready var anim_tree = $AnimationTree
@onready var weapon = $Weapon_Gun

var experience = 0
var level = 1
var experience_to_next_level = 100
var game_over_scene_resource

var last_non_zero_velocity_norm = Vector2.ZERO
var velocity = Vector2.ZERO

# Experience multiplier for each level up
const EXPERIENCE_MULTIPLIER = 1.5
# Damage to apply when an enemy body enters

func _ready():
	add_to_group("player")
	anim_tree.active = true
	anim_tree.set("parameters/Idle/blend_position", start)
	emit_signal("health_changed", hp, max_hp)
	print("Player ready, initial health: ", hp)
	game_over_scene_resource = preload("res://Assets/Scenes/game_over_scene.tscn")

# In your player script
func gain_experience(amount):
	experience += amount
	if experience >= experience_to_next_level:
		level_up_player()
	else:
		emit_signal("experience_gained", experience, experience_to_next_level)

		
func level_up_player():
	experience = 0
	level += 1
	experience_to_next_level *= EXPERIENCE_MULTIPLIER  # Increase the experience needed for the next level
	emit_signal("level_up", level)
	emit_signal("experience_gained", experience, experience_to_next_level)

func _physics_process(_delta):
	if not is_alive: 
		return
	var target_position = get_global_mouse_position()
	var direction = target_position - global_position
	if direction.length() > deadzone:
		direction = direction.normalized()
		velocity = direction * speed
		last_non_zero_velocity_norm = velocity.normalized() if velocity.length() > 0 else last_non_zero_velocity_norm
		global_position += velocity * _delta
	else:
		velocity = Vector2.ZERO
	update_anim_param()
	var closest_enemy = get_closest_enemy()
	if closest_enemy:
		var direction2 = closest_enemy.global_position - global_position
		weapon.shoot(direction2)

func update_anim_param():
	var is_moving = velocity != Vector2.ZERO
	anim_tree["parameters/conditions/idle"] = !is_moving
	anim_tree["parameters/conditions/is_moving"] = is_moving
	var velocity_norm = velocity.normalized()
	if is_moving:
		anim_tree["parameters/Walk/blend_position"] = velocity_norm
	else:
		anim_tree["parameters/Idle/blend_position"] = last_non_zero_velocity_norm
		
func get_closest_enemy():
	var closest_enemy = null
	var min_distance = INF  # Set to infinity initially to ensure any real distance will be smaller

	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy

	return closest_enemy

func apply_damage(damage):
	hp = max(hp - damage, 0)
	emit_signal("health_changed", hp, max_hp)
	if hp <= 0:
		die()

func die():
	is_alive = false
	# Show the game over scene
	var game_over_scene = game_over_scene_resource.instantiate()
	get_tree().get_root().add_child(game_over_scene)

	# Hide player node without removing it to avoid crashing
	self.visible = false

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.inflict_damage()
