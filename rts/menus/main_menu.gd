extends Control

var port = 10293
var ip = "127.0.0.1"


func _ready():
	Network.on_connected_to_server.connect(joined_game)
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
	Network.begin_join_server(ip, port)
	$join.disabled = true
	$host.disabled = true

func joined_game():
	Network.push_join_data($name_text.text)
	SceneManager.switch_lobby()

func began_hosting():
	Network.player_id_and_name[1] = $name_text.text
	SceneManager.switch_lobby()
