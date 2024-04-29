extends Control

var port = 10293


func _ready():
	Network.on_connected_to_server.connect(joined_game)
	Network.on_connection_to_server_failed.connect(failed_join_game)
	Network.on_host_started.connect(began_hosting)

func _on_host_pressed():
	if $name_text.text == "":
		$error.text = "you gotta choose a name dude"
		return
	Network.begin_hosting(port, 2)
	$join.disabled = true
	$host.disabled = true


func _on_join_pressed():
	if $name_text.text == "":
		$error.text = "you gotta choose a name dude"
		return
	if !$ip_text.text.is_valid_ip_address():
		$error.text = "you don't know what an IP is do you?"
		return
	Network.begin_join_server($ip_text.text, port)
	$join.disabled = true
	$host.disabled = true

func failed_join_game():
	$join.disabled = false
	$host.disabled = false

func joined_game():
	Network.push_join_data($name_text.text)
	SceneManager.switch_lobby()

func began_hosting():
	Network.player_id_and_name[1] = $name_text.text
	SceneManager.switch_lobby()
