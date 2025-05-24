extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D as Sprite2D

@export var speed : float = 150.0
@export var jump : float = -400.0
@export var maxFall : float = 400.0

const GRAV  : float = 1000.0;

func _physics_process(delta: float):
	velocity.y += clamp(GRAV*delta, -maxFall, maxFall)
	var dir = Input.get_axis("moveLeft", "moveRight")
	velocity.x = dir*speed
	if(Input.is_action_pressed("jump") && is_on_floor()):
		velocity.y = jump;
	move_and_slide()
