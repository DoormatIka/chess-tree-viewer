extends Node2D

@onready var tree_graph = $tree_graph_edit
@onready var data_received: Dictionary = {};

func _on_load_tree_file_selected(path):
	var json = JSON.new()
	var file = FileAccess.open(path, FileAccess.READ)
	var error = json.parse(file.get_as_text())
	
	if error == OK:
		data_received = json.data
		if typeof(data_received["top"]) == TYPE_ARRAY:
			print("Data Received");
			var test = {
				"top": ["data1", "data2"],
				"data1": ["data", "alice"],
				"data2": ["data3", "kyunfire"],
				"data3": ["data4", "data5", "data6"],
			}
			run_through_node(test, "top")
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		

func run_through_node(data: Dictionary, selected_key: String):
	if !data.has(selected_key):
		return
	
	var node = tree_graph.get_node(selected_key) ## hot spot.
	var start_node;
	if !node:
		start_node = create_node(data, selected_key)
	else:
		start_node = node
	
	for fen in data[selected_key]:
		create_node(data, fen)
		tree_graph.connect_node(fen, 0, selected_key, 0)
	
	tree_graph.arrange_nodes()

func _on_load_tree_button_pressed():
	$load_tree_dialogue.popup_centered();
	
func create_node(data: Dictionary, selected_key: String) -> GraphNode:
	var start_node = GraphNode.new()
	var start_control_left = Control.new()
	var start_control_right = Control.new()
	
	start_node.set_title(selected_key)
	start_node.name = selected_key
	start_node.set_slot_enabled_left(0, true) 
	start_node.set_slot_type_left(0, 1)
	start_node.set_slot_enabled_right(1, true)
	start_node.set_slot_type_right(1, 1)
	
	start_node.set_process(false)
	start_node.set_physics_process(false)
	start_control_left.set_process(false)
	start_control_left.set_physics_process(false)
	start_control_right.set_process(false)
	start_control_right.set_physics_process(false)
	
	var _gui_input = func (ev: InputEvent):
		if ev is InputEventMouseButton:
			if ev.button_index == MOUSE_BUTTON_LEFT:
				run_through_node(data, start_node.name)
				## every frame that the mouse is held down, this runs.
	
	start_node.gui_input.connect(_gui_input)
	
	start_node.add_child(start_control_left)
	start_node.add_child(start_control_right)
	
	tree_graph.add_child(start_node)
	
	return start_node
	
