extends Control

var panel_data = {"A1":null, "A2":null, "A3":null, "B1":null, "B2":null, "B3":null}

func _ready():
	Network.on_client_select_lobby_panel.connect(client_select_panel)
	Network.on_client_connected.connect(client_joined_lobby)


func select_panel(panel_id, selector_name):
		var team = panel_id[0]
		var num = panel_id[1]
		var panel = get_node("team" + team + "_back").get_node("team" + team + "_" + num)
		panel.text = selector_name
		panel_data[panel_id] = selector_name
		panel.disabled = true

func deselect_panel(panel_id):
	var team = panel_id[0]
	var num = panel_id[1]
	var panel = get_node("team" + team + "_back").get_node("team" + team + "_" + num)
	panel.text = ""
	panel_data[panel_id] = null
	panel.disabled = false


func client_select_panel(panel_id, client_name):
	if panel_data[panel_id] == null:
		#checks if other panels are occupied by client so they can be deslected
		if panel_data.values().has(client_name):
			#finds panel id and gets the node
			var current_panel_id = panel_data.keys()[panel_data.values().find(client_name)]
			deselect_panel(current_panel_id)
		
		#gets panel and sets it text to the name of the client
		select_panel(panel_id, client_name)
		
		Network.push_lobby_state(panel_data)

func client_joined_lobby(id):
	Network.push_lobby_state(panel_data)

#functions for host selecting
func host_select_panel(panel_id):
	var host_name = Network.player_id_and_name[1]
	if panel_data.values().has(host_name):
		var current_panel_id = panel_data.keys()[panel_data.values().find(host_name)]
		deselect_panel(current_panel_id)
	select_panel(panel_id, host_name)
	
	Network.push_lobby_state(panel_data)

func _on_team_A1_pressed():
	host_select_panel("A1")

func _on_team_A2_pressed():
	host_select_panel("A2")

func _on_team_A3_pressed():
	host_select_panel("A3")

func _on_team_B1_pressed():
	host_select_panel("B1")

func _on_team_B2_pressed():
	host_select_panel("B2")

func _on_team_B3_pressed():
	host_select_panel("B3")
