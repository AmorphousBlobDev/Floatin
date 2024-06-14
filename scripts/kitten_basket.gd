extends Area2D
@onready var sleepy_kitten = preload("res://scenes/sleepy_kitten.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_basket_entered"))
	pass # Replace with function body.

func _basket_entered(body):
	print(body.name)
	if(body.name.begins_with("kitten_liberated")):
		var lastPos = body.global_position
		var sleepyKitten = sleepy_kitten.instantiate()
		add_child(sleepyKitten)
		sleepyKitten.global_position = Vector2(lastPos.x, lastPos.y + randf_range(2, 12))
		body.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
