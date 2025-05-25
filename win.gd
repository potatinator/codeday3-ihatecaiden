extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var nextLVL : String = "res://lvl1.tscn"

var win : bool = false
var done : bool = false

func _ready() -> void:
	done = false
	win = false
	animated_sprite_2d.connect("animation_finished", Callable(self, "end"))
	
func end() -> void:
	done = true
	
func _physics_process(delta: float) -> void:
	animated_sprite_2d.visible = win
	if (win && done):
		get_tree().change_scene_to_file(nextLVL)

func _on_area_2d_area_entered(area: Area2D) -> void:
	animated_sprite_2d.play("win")
	win = true
