extends Sprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var open = preload("res://sprites/mouthopen.png");
var blow = preload("res://sprites/mouthblow.png");
@onready var target = get_parent().get_node("Floatin");

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!target): return
	global_position = get_global_mouse_position();
	look_at(target.global_position);
	if(Input.is_mouse_button_pressed(1)):
		texture = blow;
	else: 
		texture = open;
	
	if(global_position.x > target.global_position.x):
		flip_v = true;
	else:
		flip_v = false;
