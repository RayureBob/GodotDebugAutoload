
class_name NodeDisplayer extends FoldableContainer

## Displays all data registered by one node in a unique foldable container
## Right now, data is subscribed once, and fetched by the container on process
## This means the nodes getting debugged need to subscribe ONCE during their lifecycle
## And this also means that only class fields can be debugged, and not local variables
## It should be possible for classes to display both
## Knowing that classes could display fields through the same method they'd display local variables
## And it seems unecessary to opt for a subscription based debugging since any debugging should be transient
## CONCLUSION
## - RuntimeNodeDebugger should be created for each node requesting a debug display
## - Requesting node should notify DebugPanel, and pass a reference to itself and the value to display
## - DebugPanel should either create or find the RuntimeNodeDebugger for the given node
## - DebugPanel should send data to be displayed to RuntimeNodeDebugger

var _source:Node
var _content:Label
var _logs:Array[String]
var temp_string:String

signal source_destroyed(NodeDisplayer)


func _init(source:Node) -> void:
	title = source.name
	
	source.tree_exiting.connect(
		func(): 
			source_destroyed.emit(self)
			free()
	)
	
	_source = source
	_content = Label.new()
	add_child(_content)

func add_log(_log:Variant) -> void:
	_logs.append(_log)

func display() -> void:
	temp_string = ""
	for message in _logs:
		temp_string = temp_string + message + "\n"
	
	_content.text = temp_string
	
	flush_logs()

func flush_logs() -> void:
	_logs = []
