extends Node3D
var live_udp := PacketPeerUDP.new()
var player_marker: MeshInstance3D
const DUNGEON_FILE = "res://dungeon_current.json"
@onready var camera: Camera3D = $Camera3D
var camera_distance := 10.0
var data: Dictionary = {}
var dungeon: Array = []

func _ready() -> void:
	var file = FileAccess.open(DUNGEON_FILE, FileAccess.READ)
	if file == null:
		push_error("Dungeon-Datei nicht gefunden")
		return
	#camera.rotation.y += deg_to_rad(45.0)
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Ungültige JSON-Datei")
		return

	data = parsed
	dungeon = data["dungeon"]

	print("Dungeon geladen: ", dungeon.size(), " Zeilen")
	print("Spalten: ", dungeon[0].size())
	print("Seed: ", data["seed"])

	visualize_dungeon()
	visualize_doors()
	var err = live_udp.bind(45678, "127.0.0.1")
	if err != OK:
		push_error("Live-UDP konnte nicht gestartet werden: " + str(err))
	else:
		print("Live-UDP bereit auf Port 45678")
		player_marker = MeshInstance3D.new()

	var marker_mesh = BoxMesh.new()
	marker_mesh.size = Vector3(0.7, 3.0, 0.7)

	var marker_material = StandardMaterial3D.new()
	marker_material.albedo_color = Color(0.0, 1.0, 0.0)
	marker_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	marker_mesh.material = marker_material
	player_marker.mesh = marker_mesh
	player_marker.position = Vector3(0, 2.0, 0)
	add_child(player_marker)
	var arrow_root = Node3D.new()
	arrow_root.position = Vector3(0, 1.65, 0)
	player_marker.add_child(arrow_root)

	var arrow_material = StandardMaterial3D.new()
	arrow_material.albedo_color = Color(1.0, 0.0, 0.0)
	arrow_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	arrow_material.cull_mode = BaseMaterial3D.CULL_DISABLED

	# Schmaler Pfeilschaft
	var shaft = MeshInstance3D.new()
	var shaft_mesh = BoxMesh.new()
	shaft_mesh.size = Vector3(0.12, 0.08, 0.55)
	shaft_mesh.material = arrow_material
	shaft.mesh = shaft_mesh
	shaft.position = Vector3(0, 0, -0.12)
	arrow_root.add_child(shaft)

	# Dreieckige Pfeilspitze
	var tip = MeshInstance3D.new()
	var tip_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array([
		Vector3(-0.30, 0, -0.30),
		Vector3(0.30, 0, -0.30),
		Vector3(0, 0, -0.80)
		])

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	tip_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	tip_mesh.surface_set_material(0, arrow_material)

	tip.mesh = tip_mesh
	arrow_root.add_child(tip)
	
	
func visualize_dungeon() -> void:
	var wall_material = StandardMaterial3D.new()
	wall_material.albedo_color = Color(0.24, 0.29, 0.35)
	var floor_material = StandardMaterial3D.new()
	floor_material.albedo_color = Color(0.62, 0.49, 0.36)
	var pieces = data["dPiece"]
	var properties = data["tileProperties"]

	for z in range(pieces.size()):
		for x in range(pieces[z].size()):
			var tile_id = int(pieces[z][x])
			if tile_id == 0:
				continue
				
			var is_door = false
			
			for door in data.get("doors", []):
				if int(door["x"]) == x and int(door["y"]) == z:
					is_door = true
					break
				if is_door:
					continue
			var solid = (int(properties[z][x]) & 1) != 0
			var block = MeshInstance3D.new()
			var mesh = BoxMesh.new()
			if solid:
				mesh.size = Vector3(1.0, 2.0, 1.0)
				mesh.material = wall_material
				block.position = Vector3(x - 56, 1.0, z - 56)
			else:
				mesh.size = Vector3(1.0, 0.1, 1.0)
				mesh.material = floor_material
				block.position = Vector3(x - 56, 0.0, z - 56)

			block.mesh = mesh
			add_child(block)
func visualize_doors() -> void:	
	var door_material = StandardMaterial3D.new()
	door_material.albedo_color = Color(1.0, 0.05, 0.05)
	door_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	for door in data.get("doors", []):
		var marker = MeshInstance3D.new()
		var mesh = BoxMesh.new()
		
		mesh.size = Vector3(0.7, 3.0, 0.7)
		mesh.material = door_material
		marker.mesh = mesh
		marker.position = Vector3(
			float(door["x"]) - 56.0,
			2.0,
			float(door["y"]) - 56.0)
			
		add_child(marker)
func _process(_delta: float) -> void:
	while live_udp.get_available_packet_count() > 0:
		var message = live_udp.get_packet().get_string_from_utf8()
		var player = JSON.parse_string(message)
		if typeof(player) == TYPE_DICTIONARY:
			print("Spieler: ", player)
			player_marker.position = Vector3(
				float(player["x"]) - 56.0,
				2.0,
				float(player["y"]) - 56.0
				)

		if camera:
			var target = player_marker.global_position
			#var camera_distance = 35.0
			camera.global_position = target + camera.global_basis.z * camera_distance
		if player.has("direction"):
			var direction = int(player["direction"])
			if direction >= 0 and direction < 8:
				player_marker.rotation.y = deg_to_rad(225.0 - direction * 45.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_distance = maxf(3.0, camera_distance - 1.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_distance = minf(50.0, camera_distance + 1.0)
