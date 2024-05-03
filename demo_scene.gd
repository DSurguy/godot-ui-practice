extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_damage_button_pressed():
	$HealthBar.lose_health(10)
	pass

func _on_heal_button_pressed():
	$HealthBar.gain_health(10)
	pass
