extends MinionController

var spawnTimer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	group = Constants.Groups.ENEMY
	spawn_minion(MinionStats.BANDIT_WARRIOR)
	spawn_minion(MinionStats.BANDIT_WARRIOR)
	spawn_minion(MinionStats.BANDIT_RIDER)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timer_timeout():
	print("spawning")
	const minionOptions = [MinionStats.BANDIT_WARRIOR, MinionStats.BANDIT_RIDER]
	spawn_minion(minionOptions.pick_random())
