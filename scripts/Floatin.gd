extends RigidBody2D
@onready var empty_kitten = preload("res://scenes/empty_kitten.tscn")
@onready var liberated_kitten = preload("res://scenes/liberated_kitten.tscn")
@onready var particles = $CPUParticles2D
@onready var balloon = $Balloon
@onready var string = $String
@onready var kitten = $Kitten
@onready var death_area = $Area2D
@export var speed = 0.0;
var clickPoint = Vector2(0,0);
var isClick = false;
var kittens = [];

var floatin_state = 'alive'
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	set_linear_damp(100);
	death_area.connect("body_entered", Callable(self, "_death_area_entered"))
	connect("body_entered", Callable(self, "_hit_kitten"))
# warning-ignore:unused_argument
func _process(delta):
	if(floatin_state != 'alive'): return
	clickPoint = get_global_mouse_position() - global_position;
	isClick = Input.is_mouse_button_pressed(1)
	if(Input.is_action_just_pressed("space") && kittens.size() > 0):
		_liberate_kitten()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if(floatin_state != 'alive'): return
	rotation_degrees = 0
	if(isClick == true):
		state.linear_velocity -= clickPoint.normalized() * speed;
	else:
		linear_damp = 1;
func _hit_kitten(body):
	if(floatin_state != 'alive'): return
	if(body.name.begins_with("kitten")):
		var newKitten = empty_kitten.instantiate()
		add_child(newKitten)
		var targetPos = Vector2(0,0)
		if(kittens.size() > 0):
			var kittenPos = kittens[kittens.size() -1].position
			targetPos = Vector2(kittenPos.x, kittenPos.y - 48)
		else:
			targetPos = Vector2(12, -138)
		newKitten.position = targetPos
		kittens.append(newKitten)
		body.queue_free()
func _liberate_kitten():
	var kitten = kittens.pop_back()
	var kitPos = Vector2(kitten.global_position.x, kitten.global_position.y - 16)
	kitten.queue_free()
	var liberatedKitten = liberated_kitten.instantiate()
	liberatedKitten.name = 'kitten_liberated%s' % (kittens.size() + randf())
	liberatedKitten.global_position = kitPos
	get_parent().add_child(liberatedKitten)
func _death_area_entered(body):
	print('from death area entered')
	print(body)
	if(body.is_in_group("kill_on_collision")):
		_die()
func _die():
	floatin_state = 'dead'
	particles.emitting = true
	particles.restart()
	remove_child(particles)
	queue_free()

	






