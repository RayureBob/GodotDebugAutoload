class_name SphereGizmo extends GizmoDatum

enum SIZE {
	SMALL,
	MEDIUM,
	BIG
}

var _position:Vector3
var _size:float
var _color:Color

func _init(position:Vector3, size:SIZE = SIZE.SMALL, color:Color = Color.RED) -> void:
	self._position = position
	match size:
		SIZE.SMALL: self._size = .1
		SIZE.MEDIUM: self._size = .5
		SIZE.BIG: self._size = 1
	
	self._color = color

func _draw() -> void:
	DebugDraw3D.draw_sphere(_position, self._size, _color)
