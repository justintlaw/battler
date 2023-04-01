extends MinionController


# Called when the node enters the scene tree for the first time.
func _ready():
	group = Constants.Groups.ENEMY
	spawn_minion(MinionStats.BANDIT_WARRIOR)
	spawn_minion(MinionStats.BANDIT_WARRIOR)
	spawn_minion(MinionStats.BANDIT_RIDER)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
