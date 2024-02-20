extends Node2D

var counter = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_load_tree_file_selected(path):
	var json = JSON.new()
	var file = FileAccess.open(path, FileAccess.READ)
	var error = json.parse(file.get_as_text())
	
	if error == OK:
		var data_received = json.data
		if typeof(data_received["top"]) == TYPE_ARRAY:
			print("Data Received");
			var test = {
				"top": ["data1", "data2"],
				"data1": ["data", "alice"],
				"data2": ["data3", "kyunfire"],
				"data3": ["data4", "data5", "data6"],
			}
			_run_through_node(test, "top")
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		
	$tree_graph_edit.arrange_nodes()

func _run_through_node(data: Dictionary, selected_key: String):
	if !data.has(selected_key):
		return
	
	var node = get_node(str("tree_graph_edit", "/", selected_key))
	var start_node;
	if !node:
		start_node = GraphNode.new()
		var start_control_left = Control.new()
		var start_control_right = Control.new()
		start_node.set_title(selected_key)
		start_node.name = selected_key
		start_node.set_slot_enabled_left(0, true) 
		start_node.set_slot_type_left(0, 1)
		start_node.set_slot_enabled_right(1, true)
		start_node.set_slot_type_right(1, 1)
		start_node.add_child(start_control_left)
		start_node.add_child(start_control_right)
		$tree_graph_edit.add_child(start_node)
	else:
		start_node = node
	
	for fen in data[selected_key]:
		var end_node = GraphNode.new()
		var end_control_left = Control.new()
		var end_control_right = Control.new()
		end_node.set_title(fen)
		end_node.name = fen
		end_node.set_slot_enabled_left(0, true)
		end_node.set_slot_type_left(0, 1)
		end_node.set_slot_enabled_right(1, true)
		end_node.set_slot_type_right(1, 1)
		end_node.add_child(end_control_left)
		end_node.add_child(end_control_right)
		$tree_graph_edit.add_child(end_node)
		
		$tree_graph_edit.connect_node(fen, 0, selected_key, 0)
		_run_through_node(data, fen)


func _on_load_tree_button_pressed():
	$load_tree_dialogue.popup_centered();
	


