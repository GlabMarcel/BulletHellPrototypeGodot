extends CharacterBody2D

# The player node
@export var speed = 20
@export var hp = 1

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
	queue_free()


func update_anim_param():
	var velocity_norm = velocity.normalized()
	# Use only the x component of the velocity to set the blend position in the 1D blend space
	anim_tree["parameters/Walk/blend_position"] = velocity_norm.x




