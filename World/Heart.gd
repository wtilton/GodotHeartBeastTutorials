extends Node2D

onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var audio = $AudioStreamPlayer

func play(global_position):
	print("Heart play()")
	PlayerStats.add_health(1)
	audio.play()
	tween.interpolate_property(sprite, "modulate:a", 0.0, 1.0, 0.5, Tween.EASE_IN, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(sprite, "scale", sprite.scale, Vector2(1.0, 1.0), 0.5, Tween.EASE_IN, Tween.TRANS_LINEAR)
	tween.interpolate_property(sprite, "modulate:a", 1.0, 0.0, 0.5, Tween.EASE_IN, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
