extends RigidBody2D
onready var empty_kitten = preload("res://scenes/empty_kitten.tscn")
onready var liberated_kitten = preload("res://scenes/liberated_kitten.tscn")
export var speed = 0.0;
var clickPoint = Vector2(0,0);
var isClick = false;
var kittens = [];

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	contacts_reported = 1
	set_linear_damp(100);
	connect("body_entered", self, "_hit_kitten")
# warning-ignore:unused_argument
func _process(delta):
	clickPoint = get_global_mouse_position() - global_position;
	isClick = Input.is_mouse_button_pressed(1)
	if(Input.is_action_just_pressed("space") && kittens.size() > 0):
		_liberate_kitten()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	rotation_degrees = 0
	if(isClick == true):
		state.linear_velocity -= clickPoint.normalized() * speed;
	else:
		linear_damp = 1;
func _hit_kitten(body):
	if(body.name.begins_with("kitten")):
		var newKitten = empty_kitten.instance()
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
	var liberatedKitten = liberated_kitten.instance()
	liberatedKitten.name = 'kitten_liberated%s' % (kittens.size() + randf())
	liberatedKitten.global_position = kitPos
	get_parent().add_child(liberatedKitten)

	






