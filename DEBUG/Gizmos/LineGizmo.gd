class_name LineGizmo extends GizmoDatum

var start:Vector3
var end:Vector3
var color:Color

func _init(start:Vector3, end:Vector3, color:Color = Color.GREEN, life_time:float = -1) -> void:
	super._init(life_time)
	self.start = start
	self.end = end
	self.color = color

func _draw() -> void:
	DebugDraw3D.draw_line(start, end, color)
