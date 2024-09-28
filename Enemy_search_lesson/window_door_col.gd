extends StaticBody3D

#added
var player_is_close := false


var player_in_room := false
var is_opened := false
var received_sound := 0
var get_data = null
#var query = null

#This script will run when player is in a room(area3d) w/open door/win.
#The sound with the highest value will be taken. whether it be the enemy2player
#or enemy2dor/win2player

#using a collider object because, intersect_rays can't collide with area3d
#raycast can be used also but, created bugs when colliding with walls
#put this collision on another layer so player and other enities can pass through it

func _ready() -> void:
	
	print(is_opened)

func _process(_delta):
	
	#added to group sound_tunnel, enemy will look for this group
	#during collision
	
	check_player_sound()
	open_door_window()
	
func check_door_window_open():
	
	#called and checked on listen func in enemy script
	return is_opened
	
func open_door_window():
	
	if Input.is_action_just_pressed("ui_left"):
		
		#called from the parent node now, no longer depended on node tree setup
		is_opened = true
		
	if Input.is_action_just_pressed("ui_right"):
		
		#called from the parent node now, no longer depended on node tree setup
		is_opened = false
	
func current_noise_level():
	
	return received_sound

func check_player_sound():
	
	#added, rewrote script. Now returns a boolean. if true, player is near window and can be heard
	
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(self.global_position, Global.player_current_pos)                                            
			
	var result = space_state.intersect_ray(query)
	
	if result["collider"].is_in_group("player"):
		
		player_is_close = true
		
		
	else:
		
		player_is_close = false
		
	return player_is_close
	
func _on_noise_collector_area_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("player"):
		
		player_in_room = true


func _on_noise_collector_area_body_exited(body: Node3D) -> void:
	
	
	if body.is_in_group("player"):
		print("bye")
		player_in_room = false
