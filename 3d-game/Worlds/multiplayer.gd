# Multiplayer join UI based on: https://medium.com/@bitr13x/how-to-make-a-simple-2d-multiplayer-game-in-godot-6247b68d0af0 and https://www.youtube.com/watch?v=h5_eyycttgA
# Test locally with: https://www.reddit.com/r/godot/comments/9ahw6i/is_there_a_way_to_launch_two_instances_of_your/

extends Node3D
class_name MultiplayerHandler

const PORT = 4315
const MAX_CLIENTS = 10
var ip_address = ""

func _ready() -> void:
	if OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip


func host() -> void:
	# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(self.add_player)
	multiplayer.peer_disconnected.connect(self.remove_player)
	multiplayer.server_disconnected.connect(self.server_delete)
	
	add_player(multiplayer.get_unique_id()) # should always be 1 for host

func add_player(id):
	print("Added: ", id)
	var player_scene = preload("res://Entities/player.tscn")
	var player = player_scene.instantiate()
	player.name = "Player" + str(id)
	# yeah, put this somewhere else
	$Players.add_child(player)

func remove_player(id):
	print("Removed: ", id)

func server_delete():
	pass

func join(join_ip_address) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(join_ip_address, PORT)
	multiplayer.multiplayer_peer = peer
