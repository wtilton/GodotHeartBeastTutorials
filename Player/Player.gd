extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var stats = PlayerStats

const player_speed = 90
const acceleration = 450
const roll_speed = 145
const friction = 450

onready var animation = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitBox
onready var hurtbox = $HurtBox

var state = MOVE

enum {
	MOVE, ATTACK, ROLL
}

func _ready():
	stats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
		

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	animation_tree.set("parameters/Idle/blend_position", input_vector)
	animation_tree.set("parameters/Run/blend_position", input_vector)
	animation_tree.set("parameters/Attack/blend_position", input_vector)
	animation_tree.set("parameters/Roll/blend_position", input_vector)
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * player_speed, acceleration * delta)
		
		if Input.is_action_just_pressed("roll"):
			state = ROLL
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animation_state.travel("Idle")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
		

func attack_state(_delta):
	animation_state.travel("Attack")

func attack_complete():
	state = MOVE

func roll_state(_delta):
	velocity = roll_vector * roll_speed
	animation_state.travel("Roll")
	velocity = move_and_slide(velocity)

func roll_complete():
	velocity = velocity * 0.8
	state = MOVE
		

func _on_HurtBox_area_entered(_area):
	print("Player Here")
	stats.health -= 1
	hurtbox.start_invicibility(0.5)
	var sound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(sound)
