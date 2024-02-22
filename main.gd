extends Node2D

@onready var tree_graph = $tree_graph_edit

@onready var connection_data: Dictionary = {};
@onready var information_data: Dictionary = {};

@onready var graph_node = preload("res://graph_node.tscn")

func run_through_node(connection_data: Dictionary, information_data: Dictionary, selected_key: String):
	if !connection_data.has(selected_key):
		return
	
	var node = tree_graph.has_node(selected_key)
	if node == false:
		create_node(connection_data, information_data, selected_key)
	
	for fen in connection_data[selected_key]:
		var sub_node = tree_graph.has_node(fen)
		if sub_node == false:
			create_node(connection_data, information_data, fen)
			tree_graph.connect_node(fen, 0, selected_key, 0)

func _on_load_tree_dialogue_dir_selected(dir):
	var connection_json = JSON.new()
	var information_json = JSON.new()
	var connection_file = FileAccess.open(dir + "/debug_tree_connections.json", FileAccess.READ)
	var information_file = FileAccess.open(dir + "/debug_tree_information.json", FileAccess.READ)
	var connection_error = connection_json.parse(connection_file.get_as_text())
	var information_error = information_json.parse(information_file.get_as_text())
	
	if connection_error == OK and information_error == OK:
		connection_data = connection_json.data
		information_data = information_json.data
		if typeof(connection_data["top"]) == TYPE_ARRAY:
			print("Data Received");
			run_through_node(connection_data, information_data, "top")
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", connection_json.get_error_message(), " at line ", connection_json.get_error_line())

func _on_load_tree_button_pressed():
	$load_tree_dialogue.popup_centered()
	
func create_node(connection_data: Dictionary, information_data: Dictionary, selected_key: String) -> GraphNode:
	var start_node = graph_node.instantiate()
	var start_control_left = Control.new()
	var start_control_right = Control.new()
	
	start_node.set_title(selected_key)
	start_node.name = selected_key
	start_node.set_slot_enabled_left(0, true) 
	start_node.set_slot_type_left(0, 1)
	start_node.set_slot_enabled_right(1, true)
	start_node.set_slot_type_right(1, 1)
	
	## information put here

	disable_process_and_physics(start_node)
	disable_process_and_physics(start_control_left)
	disable_process_and_physics(start_control_right)
	
	var _gui_input = func (event: InputEvent):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				run_through_node(connection_data, information_data, start_node.name)
				## every frame that the mouse is held down, this runs.
	
	start_node.gui_input.connect(_gui_input)
	
	start_node.add_child(start_control_left)
	start_node.add_child(start_control_right)
	
	tree_graph.add_child(start_node)
	
	return start_node
	
func disable_process_and_physics(node):
	node.set_process(false)
	node.set_physics_process(false)


func _on_arrange_button_pressed():
	tree_graph.arrange_nodes()

