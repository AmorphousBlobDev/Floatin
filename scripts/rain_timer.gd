extends Timer
@onready var rain_drop = preload("res://scenes/rain_drop.tscn")
@onready var sad_cloud = get_parent()
@onready var cloud_sprite = sad_cloud.get_child(0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", Callable(self, "_on_timeout"))
	pass # Replace with function body.
	
func _on_timeout():
	var drop = rain_drop.instantiate()
	print(cloud_sprite.get_rect())
	var cloud_width = cloud_sprite.get_rect().size.x
	var rand = randf_range(0, 1)
	var xpos = 0
	if(rand > 0.5):
		xpos = cloud_width / 4
	else:
		xpos = -cloud_width / 4
	drop.position.x = xpos
	drop.position.y = 16
	sad_cloud.add_child(drop)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
