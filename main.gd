extends Node2D


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
			_run_through_top_node(data_received)
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

func _run_through_top_node(data: Dictionary):
	for fen in data["top"]:
		_run_through_node(data, fen)

func _run_through_node(data: Dictionary, selected_key: String):
	if !data.has(selected_key):
		return
		
	var start_node = GraphNode.new()
	start_node.set_title(selected_key)
	$tree_graph_edit.add_child(start_node)
	
	for fen in data[selected_key]:
		var end_node = GraphNode.new()
		end_node.set_title(fen)
		$tree_graph_edit.add_child(end_node)
		
		$tree_graph_edit.connect_node(selected_key, 0, fen, 0)
		##_run_through_node(data, fen)


func _on_load_tree_button_pressed():
	$load_tree_dialogue.popup_centered();
	


