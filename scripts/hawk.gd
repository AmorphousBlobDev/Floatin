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
	_create_action_timer()
	_animated_sprite.play("search")

func _create_action_timer():
	print("creating timer...")
	var timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = action_time
	timer.connect("timeout", _on_action_timeout)
	add_child(timer)
	timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(state == "dive"):
		if(global_position.y < divePos.y):
			var direction = global_position.direction_to(divePos)
			velocity = direction * dive_speed
			if(divePos):
				look_at(divePos)
	if(state == "search"):
		if(search_pos):
			var direction = global_position.direction_to(search_pos)
			velocity = direction * search_speed
	if(state == "chase"):
		var direction = global_position.direction_to(Vector2(target.global_position.x, target.global_position.y - chase_limit))
		velocity = direction * chase_speed
	move_and_slide()
	
func _on_action_timeout():
	print("TIMEOUTHAWK")
	if(state == "search"):
		_search()
	elif(state == "dive"):
		_dive()
	elif(state == "chase"):
		_chase()

func _chase():
	var distX = abs(global_position.x - target.global_position.x)
	if(target.global_position.y > global_position.y && distX < aggro_distance / 3):
		state = "dive"
		divePos = target.global_position
		_animated_sprite.play("dive")
		print("SET DIVE TRUE")
func _dive():
	if(global_position.distance_to(target.global_position) > aggro_distance):
		target = null
		state = "search"
		_animated_sprite.play("search")
		rotation = 0
func _search():
	print("SEARCHING")
	search_pos = Vector2(global_position.x + randf_range(-25, 25), global_position.y + randf_range(-25, 25));
	var prey = get_tree().get_nodes_in_group("hawkprey")
	print("PREY")
	print(prey)
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
	print(target)
	if(target):
		state = "chase"
		_chase()

				
			


