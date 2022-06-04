extends KinematicBody2D

var _velocity: Vector2
var speed := 80
var tick = 0
var face = 3  #integer 0 is right, 1 is up, 2 is left, 3 is down

onready var animatedSprite = get_node("CollisionShape2D/AnimatedSprite")

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("move left", "move right", "move up", "move down")
	var move_string = "idle "
	var dir_string = "down"
	
	
	if abs(_velocity.x) + abs(_velocity.y) > 20: #Manhatten distance is more efficient than .length()
		move_string = "walk "
	
	#Converts velocity vector into an angle, then into a 0-3 integer of cardinal direction movemnt
		var angle = abs(_velocity.angle()/3)*2
	
	#Rightward correction for symmetrical animation on diagonal movement
		if angle >= 0.5 && angle < 0.6: angle -= 0.1
		
		angle = round(clamp(angle, -2, 2))
		face = int(angle)
		if _velocity.y > 0 and face == 1: face = 3
	
	match face:
		0: dir_string = "right"
		1: dir_string = "up"
		2: dir_string = "left"
		3: dir_string = "down"

	animatedSprite.animation = move_string + dir_string
		
	if Input.is_action_pressed("run") and (Input.is_action_pressed("move up") or Input.is_action_pressed("move down") or Input.is_action_pressed("move left") or Input.is_action_pressed("move right")):
		speed = 120
		tick += 1
		if tick >= 3:
			PlayerData.takeEnergy(1)
			PlayerData.updateUI($"Control/Health Overlay", $"Control/Energy Overlay")
			tick = 0
	else:
		speed = 80
		tick = 0
	
	if Input.is_action_just_pressed("Inventory"): #for now I used this to test, replace this with your damage code etc.
		PlayerData.takeHealth(1)
		PlayerData.takeEnergy(1)
		PlayerData.updateUI($"Control/Health Overlay", $"Control/Energy Overlay")
	
	_velocity =_velocity.linear_interpolate(input * speed, 0.3)
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
func _input(event):
	if event.is_action_pressed("Inventory"):
		$Camera2D/UserInterface/Inventory.visible = !$Camera2D/UserInterface/Inventory.visible
		$Camera2D/UserInterface/ArmorSlots.visible = !$Camera2D/UserInterface/ArmorSlots.visible
		$Camera2D/UserInterface/Inventory.initialize_inventory()
		
	if event.is_action_pressed("Pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
