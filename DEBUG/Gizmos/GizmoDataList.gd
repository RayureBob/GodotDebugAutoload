class_name GizmoDataList extends RefCounted

var gizmo_data:Array[GizmoDatum]

func draw() -> void:
	for data in self.gizmo_data:
		data._draw()

func add_gizmo(gizmo_datum:GizmoDatum) -> void:
	self.gizmo_data.append(gizmo_datum)

func flush() -> void:
	gizmo_data = []
