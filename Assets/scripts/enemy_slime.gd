extends CharacterBody2D

# The player node
@export var speed = 20
@export var hp = 1
@export var damage = 1  
@export var start: Vector2 = Vector2(0,1)

@onready var player = get_node("../Player") 
@onready var anim_tree = $AnimationTree

# RandomNumberGenerator to generate timer countdown value 
var rng = RandomNumberGenerator.new()
#timer reference to redirect the enemy if collision events occur & timer countdown reaches 0
var timer = 0

func _ready():
	rng.randomize()

func _physics_process(_delta):
	var target_position
	if player:
		target_position = player.global_position
	else:
		target_position = get_global_mouse_position()
	
	var direction = target_position - global_position
	direction = direction.normalized()
	velocity = direction * speed
	update_anim_param()
	move_and_slide()
	
func apply_damage(damage):
	hp = max(hp - damage, 0)
	if hp <= 0:
		die()

func die():
	var experience_orb_scene = preload("res://Assets/Scenes/experience_orb.tscn")
	var experience_orb = experience_orb_scene.instantiate()
	experience_orb.global_position = self.global_position
	get_parent().call_deferred("add_child",experience_orb)
	call_deferred("queue_free")  # or any other death handling code


func update_anim_param():
	var velocity_norm = velocity.normalized()
	# Use only the x component of the velocity to set the blend position in the 1D blend space
	anim_tree["parameters/Walk/blend_position"] = velocity_norm.x

func inflict_damage():
	if player:
		player.apply_damage(damage)



