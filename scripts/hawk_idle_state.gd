extends State

@export var hawk: CharacterBody2D
@export var move_speed: float = 200.0

var search_pos: Vector2
var search_time: float = 0
var target
var aggro_distance: float = 500

func randomize_search():
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
		Transitioned.emit(self, 'chase')
	search_time = randf_range(1,3)

func enter():
	randomize_search()
	
func update(delta):
	if search_time > 0:
		search_time -= delta
	else:
		randomize_search()
func physics_update(delta):
	if(search_pos && move_speed):	
		hawk.velocity = move_speed * search_pos
		print(hawk.velocity)
