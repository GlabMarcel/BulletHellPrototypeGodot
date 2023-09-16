extends Node2D

@export var attack_range = 50.0
@export var attack_damage = 1
@export var cooldown_time = 2
@export var bullet_speed = 400.0
@export var float_speed = 2.0
@export var float_amplitude = 10.0

var can_attack = true

@onready var weapon_sprite = get_node("../Weapon_Gun")
@onready var bullet_scene = preload("res://bullet.tscn")

func _process(delta):
	weapon_sprite.global_position.y += sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude * delta	

func shoot(direction):
	if can_attack:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = direction.normalized()
		bullet.rotation = atan2(bullet.direction.y, bullet.direction.x)
		get_tree().current_scene.add_child(bullet)
		can_attack = false
		await get_tree().create_timer(cooldown_time).timeout
		can_attack = true


func attack(origin, target_group):
	if can_attack:
		for body in origin.get_overlapping_bodies():
			if body.is_in_group(target_group) and body.global_position.distance_to(origin.global_position) <= attack_range:
				body.apply_damage(attack_damage)
		can_attack = false
		await get_tree().create_timer(cooldown_time).timeout
		can_attack = true
