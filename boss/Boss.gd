extends Node2D

var phase := 0
var immunities := []
var health := 3.0

onready var projectile_attacks = $Body/ProjectileSpawners.get_children()
onready var special_attacks = $Body/SpecialAttacks.get_children()
onready var movement_abilities = $Body/Movement.get_children()

signal fire_projectile
signal move
signal special_attack

var gravity = 10
var player

func _ready():
	_set_states()
	player = get_tree().get_nodes_in_group("player")[0]


func hit(by : Node2D, damage : int, type : int, knockback : Vector2):
	if not type in immunities :
		health -= damage
		if health <= 0 :
			activate_phase(type)
	else :
		pass #something that shows it's immune

func activate_phase(type : int):
	phase += 1
	immunities.append(type)
	health = phase + 3

	#could do this by using class_name later
	for attack in projectile_attacks :
		if attack.is_in_group("type") :
			attack.connect("fire", self, "fire_projectile")
	for move in movement_abilities :
		if move.is_in_group("type") :
			move.connect("move", self, "move")
	#I guess this doesn't work, needs to randomly select a move
	for attack in special_attacks :
		if attack.is_in_group("type") :
			attack.connect("attack", self, "special")

func _fire():
	emit_signal("fire_projectile")
	pass

func _move():
	emit_signal("move")
	_hop()

func _special():
	emit_signal("special_attack")
	pass


#########################################################
#### STATE MACHINE CODE ###
#########################################################

var velocity = Vector2.ZERO

var state = null setget _set_state
var previous_state = null
var states : Dictionary = {}

func _set_states():
	_add_state('transforming')
	_add_state('hitstun')
	_add_state('special')
	_add_state('idle')
	_set_state('idle')

func _add_state(state_name):
	states[state_name] = states.size()

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	match old_state :
		1 :
			pass
	pass

func _set_state(new_state):
	previous_state = state
	state = new_state

	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)


func _state_logic(delta : float):
	_handle_movement(delta)

	_apply_movement()

func _get_transition(delta : float):
	match state :
		'idle':
			pass
	pass

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			_set_state(transition)

func _apply_movement():
	$Body.move_and_slide(velocity, Vector2.UP)

func _handle_movement(delta : float ):
	if $Body.is_on_floor() :
		velocity.x = lerp(velocity.x, 0, .1)
	else :
		velocity += Vector2.DOWN * gravity
	match state :
		'idle':
			pass

func _hop():
	velocity.y = -400
	velocity.x = sign(player.global_position.x - $Body.global_position.x) * 200