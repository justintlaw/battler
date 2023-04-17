extends CharacterBody2D

signal die

@export var health := 100
@export var damage := 20 * 100
@export var speed := 3000
@export var attackRange := 30
@export var detectionRange := 100
@export var attackCooldown := 2
var baseSprite: String
var minionType

var flagPosition: Vector2
var target

var targetScanTimer: Timer
var attackCooldownTimer: Timer
var attackCooldownActive := false
var isAttacking := false
var isDying := false

# Called when the node enters the scene tree for the first time.
func _ready():
	attackCooldownTimer = Timer.new()
	attackCooldownTimer.connect("timeout", _on_attack_cooldown_timer_timeout)
	add_child(attackCooldownTimer)
	
	targetScanTimer = Timer.new()
	targetScanTimer.connect("timeout", _on_target_scan_timer_timeout)
	add_child(targetScanTimer)
	targetScanTimer.start(2)
	
	setup_collision()


func _draw():
	pass
#	draw_arc(
#		Vector2(0, 0),
#		$DetectionRange/CollisionShape2D.shape.radius,
#		deg_to_rad(0),
#		deg_to_rad(360),
#		20,
#		Color.RED
#	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_instance_valid(target):
		move_towards_position(target.position, delta)
	else:
		move_towards_position(flagPosition, delta)

	if is_instance_valid(target):
		if not attackCooldownActive and position.distance_to(target.position) <= attackRange:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = position.x > target.position.x
			attack()

	if health <= 0:
		$AnimatedSprite2D.play(baseSprite + "die")
	elif isAttacking:
		$AnimatedSprite2D.play(baseSprite + "attack")
	elif velocity != Vector2.ZERO:
		$AnimatedSprite2D.play(baseSprite + "move")
	else:
		$AnimatedSprite2D.play(baseSprite + "idle")


func _on_animated_sprite_2d_animation_looped():
	if "die" in $AnimatedSprite2D.animation:
		queue_free()
	elif "attack" in $AnimatedSprite2D.animation:
		if is_instance_valid(target) and target.has_method("take_damage") and position.distance_to(target.position) < attackRange:
			target.take_damage(damage)
		isAttacking = false


func _on_target_scan_timer_timeout():
	if not is_instance_valid(target) and $DetectionRange.has_overlapping_bodies():
		var potentialTargets = $DetectionRange.get_overlapping_bodies()
		if potentialTargets.size() > 0:
			target = get_closest_target(potentialTargets)
			

func setup(minionType):
	self.minionType = minionType.duplicate(true)
	health = minionType.health
	damage = minionType.damage
	speed = minionType.speed
	attackRange = minionType.attackRange
	detectionRange = minionType.detectionRange
	attackCooldown = minionType.attackCooldown
	baseSprite = minionType.baseSprite


func setup_collision():
	$DetectionRange/CollisionShape2D.shape.radius = detectionRange

	if is_in_group(Constants.Groups.PLAYER):
		set_collision_layer_value(Constants.Layers.PLAYER, true)
		set_collision_mask_value(Constants.Layers.ENEMY, true)
		
		$DetectionRange.set_collision_mask_value(Constants.Layers.ENEMY, true)
	elif is_in_group(Constants.Groups.ENEMY):
		set_collision_layer_value(Constants.Layers.ENEMY, true)
		set_collision_mask_value(Constants.Layers.PLAYER, true)
		
		$DetectionRange.set_collision_mask_value(Constants.Layers.PLAYER, true)


func set_flag_position(pos: Vector2):
	flagPosition = pos


func move_towards_position(targetPosition: Vector2, delta):
	if targetPosition == null or position.distance_to(targetPosition) < 20:
		velocity = Vector2.ZERO
	else:
		var direction = (targetPosition - position).normalized()
		velocity = direction * speed * delta
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0

	move_and_slide()


func attack():
	attackCooldownActive = true
	isAttacking = true
	attackCooldownTimer.start(attackCooldown)


func _on_attack_cooldown_timer_timeout():
	attackCooldownActive = false


func take_damage(amount: int):
	health -= amount

	if not isDying and health <= 0:
		health = 0
		isDying = true
		
		if is_in_group(Constants.Groups.ENEMY):
			State.gold += 10

		die.emit(minionType)

func get_closest_target(targets: Array[Node2D]):
	var closest_target = null
	var closest_distance = 10000000000

	if targets.size() == 0:
		return null # No target
	else:
		for target in targets:
			if is_instance_valid(target) and target.has_method("take_damage"):
				var distance = target.position.distance_to(position)
				if distance < closest_distance:
					closest_distance = distance
					closest_target = target

	return closest_target


func _on_detection_range_body_entered(body: Node2D):
	if not is_instance_valid(target):
		target = body
	elif position.distance_to(body.position) < position.distance_to(target.position):
		target = body
