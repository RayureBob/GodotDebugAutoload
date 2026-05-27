# Godot Runtime Debugger

This repository holds a Godot tool meant to be used as an Autoload.
It provides feature to debug various things during Runtime, and centralizes it all through a common UI accessible in game by pressing F1.

It offers three main features:
- Runtime value display
- Runtime console logger
- Per Object Gizmo (Requires [DebugDraw3D](https://godotengine.org/asset-library/asset/1766) by [Dmitriy Salnikov](https://godotengine.org/asset-library/asset?user=DmitriySalnikov))

---

## Runtime Value Display
The singleton offers two functions to handle display of values by object:

`DEBUG.DISPLAY_RUNTIME(source:Object, data:Variant) -> void`
`source` is the object to whom belongs the value, `data` the value itself. `data` can be of any type as long as the type overrides the `_to_string()` metamethod.

The debugger will create a foldable section in its UI to display all values from the same object under the same element.
One can destroy the section manually using the method `DEBUG.REMOVE_RUNTIME(source:Object)`. 
*It is however not meant to be called just anywhere as it is handled internally*

All Runtime Value are displayed in the *Runtime* tab of the main UI.

## Runtime Console Logger
the following functions:
- `DEBUG.LOG_INFO(source:Object, data:Variant)`
- `DEBUG.LOG_WARNING(source:Object, data:Variant)`
- `DEBUG.LOG_ERROR(source:Object, data:Variant)`

All do the same thing internally except for how `data` will be formatted.
All logs are displayed in the *Console* tab of the main UI.

## Per Object Gizmo
Gizmos can be registered per objects and displayed with the following method:
`DEBUG.REGISTER_GIZMO(sourde:Object, data:GizmoDatum)`

The type `GizmoDatum` is an abstract class meant to be inherited from to define specific draw behaviors by overriding the abstract method `_draw()`.
In this method you can call [DebugDraw3D](https://godotengine.org/asset-library/asset/1766) methods to draw the gizmo you like.

You can either use already existing LineGizmo or SphereGizmo found in `Gizmos/` or create your own.
