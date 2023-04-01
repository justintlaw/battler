extends Node

class_name MinionController

@export var group: String
@export var flag: Node2D
@export var spawnPath: PathFollow2D
var minionTemplate = preload("res://scenes/minions/minion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_minion(minionType):
	var minion = minionTemplate.instantiate()
	minion.set_flag_position(flag.position)
	minion.add_to_group(group)
	minion.setup(minionType)
	
	spawnPath.progress_ratio = randi()
#	var direction = spawnPath.rotation + PI / 2
	minion.position = spawnPath.position

	
#	if group == Constants.Groups.PLAYER:
#		minion.position = Vector2(200,200)
#	else:
#		minion.position = Vector2(800, 400)	

	add_child(minion)
