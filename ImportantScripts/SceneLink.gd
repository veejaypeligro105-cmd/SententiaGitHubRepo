extends Resource
class_name SceneLink

@export var id: String = "" #Shortkey like "road_scene" or "Intro_lobby"
@export var scene: PackedScene #drag the actual ".tscn" path
@export var entry_point_id: String = "" #which entrypoint in that scene player should land on
