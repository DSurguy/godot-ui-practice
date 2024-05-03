class_name HealthBar extends Node2D

var damage_theme = preload("res://health_bar/damage_bar.tres")
var damage_script = preload("res://health_bar/damage.gd")

@export var max_health: int = 100
@export var current_health: int = 50
@export var width = 200;
@export var height = 40;
@export var decay_percent_per_sec = .25
@export var decay_delay_sec = 0.35
var last_health: float = 50
var has_damage: bool = false
var is_delaying: bool = false

func _ready():
	update_size()
	pass

func update_size():
	$Control/Health.set_size(Vector2(width, height))
	$Control/LastHealth.set_size(Vector2(width, height))
	pass

func lose_health(damage: int):
	current_health -= damage
	if current_health < 0: current_health = 0
	$Control/Health.value = current_health
	
	# create a damage node that animates and then deletes itself
	# the damage node should be over the lastHealth, but under health (in case it recovers)
	var damageNode = ProgressBar.new()
	damageNode.theme = damage_theme
	damageNode.value = damage
	damageNode.step = 1
	damageNode.set_size(Vector2(width, height))
	damageNode.position = Vector2(width * (current_health / damageNode.max_value), damageNode.position.y)
	damageNode.set_script(damage_script)
	damageNode.show_percentage = false
	$Control/DamageNodes.add_child(damageNode)
	has_damage = true
	
	# Start a timer to hold the decay portion
	$Control/DamageDecayTimer.wait_time = decay_delay_sec
	$Control/DamageDecayTimer.start()
	is_delaying = true
	pass

func gain_health(health: int):
	current_health += health
	if current_health > max_health: current_health = max_health
	$Control/Health.value = current_health
	if current_health > last_health:
		last_health = current_health
		$Control/LastHealth.value = last_health
		has_damage = false
	pass

func set_health(health: int):
	current_health = min(health, max_health)
	last_health = current_health
	$Control/Health.value = current_health
	$Control/LastHealth.value = current_health
	has_damage = false
	is_delaying = false
	pass

func _process(delta):
	if has_damage && !is_delaying:
		if current_health < last_health:
			last_health -= decay_percent_per_sec * delta * max_health
			$Control/LastHealth.value = last_health
		elif current_health > last_health:
			last_health = current_health
			$Control/LastHealth.value = last_health
			has_damage = false
		else: has_damage = false
	pass

func _on_damage_decay_timer_timeout():
	is_delaying = false
	pass
