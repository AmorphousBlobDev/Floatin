extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
var action_time = 0.5

var aggro_distance = 500

var dive_speed = 750
var search_speed = 75
var chase_speed = 200

var search_pos = null

var chase_limit = 300

var states = ["search", "chase", "dive"]
var state = states[0]

var target = null
var divePos = null
# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play("search")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	
func _on_action_timeout():
	if(state == "search"):
		_search()
	elif(state == "dive"):
		_dive()
	elif(state == "chase"):
		_chase()

func _chase():
	if(!target): return
	var distX = abs(global_position.x - target.global_position.x)
	if(target.global_position.y > global_position.y && distX < aggro_distance / 3):
		state = "dive"
		divePos = target.global_position
		_animated_sprite.play("dive")
func _dive():
	if(!target): return
	if(global_position.distance_to(target.global_position) > aggro_distance):
		target = null
		state = "search"
		_animated_sprite.play("search")
		rotation = 0
func _search():
	search_pos = Vector2(global_position.x + randf_range(-25, 25), global_position.y + randf_range(-25, 25));
	var prey = get_tree().get_nodes_in_group("hawkprey")
	if(target == null && prey.size() > 0):
		var lastdistance = null
		for p in prey:
			var distance = p.global_position.distance_to(global_position)
			if(distance < aggro_distance):
				if(!lastdistance):
					lastdistance = distance
					target = p
				elif(distance < lastdistance):
					target = p
	if(target):
		state = "chase"
		_chase()

				
			


