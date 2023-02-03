extends KinematicBody2D

onready var anim = $anim_player
onready var anim_tree = $anim_tree
onready var anim_state = anim_tree.get("parameters/playback")

enum {
	IDLE,
	WALK
}

var look_dir = Vector2.DOWN
var move_dir = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE

export var speed = 150


func _ready() -> void:
	anim_tree.active = true

func _physics_process(delta) -> void:
	_set_anim_parameters()
	_match_states()
	if move_dir != Vector2.ZERO:
		state = WALK
	else:
		state = IDLE
	
func _input(event) -> void:
	var y_dir = Input.get_action_strength("down") - Input.get_action_strength("up")
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_dir = Vector2(x_dir, y_dir).normalized()
	
	if move_dir != Vector2.ZERO:
		look_dir = move_dir

func _set_anim_parameters() -> void:
	anim_tree.set("parameters/idle/blend_position", look_dir)
	anim_tree.set("parameters/run/blend_position", move_dir)

func _match_states() -> void:
	match state:
		IDLE:
			idle()
		WALK:
			walk()
	
func idle() -> void:
	anim_state.travel("idle")

func walk() -> void:
	anim_state.travel("run")
	velocity = move_and_slide(move_dir * speed)
