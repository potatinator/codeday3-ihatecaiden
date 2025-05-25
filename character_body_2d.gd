extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D 
@onready var jumpSFX : AudioStreamPlayer2D = $jump

@export var speed : float = 150.0
@export var airMulti : float = 1.0
var jump : float = -400.0
var maxFall : float = 400.0
@export var maxStored : float = 1000.0
@export var storeMulti : float = 1.0
@export var groundFric : float = 100.0
@export var airFric : float = 10.0

const GRAV  : float = 1000.0;

var stored : Vector2 = Vector2(0.0,0.0)
var fric : float = 0.0;
var multi : float = 1.0;

signal dieSig

func _physics_process(delta: float):
	velocity.y += clamp(GRAV*delta, -maxFall, maxFall)
	if (is_on_floor()):
		fric = groundFric
		multi = 1.0
	else:
		fric = airFric
		multi = airMulti
	
	var dir = Input.get_axis("moveLeft", "moveRight")
	if(abs(dir) > 0):
		animated_sprite_2d.flip_h = dir < 0
	
	velocity.x += dir*speed*multi
	if(abs(fric*velocity.x) > abs(velocity.x)):
		velocity.x = 0
	else:
		velocity.x -= fric*velocity.x
	
	if(Input.is_action_pressed("jump") && is_on_floor()):
		velocity.y = jump;
		jumpSFX.play()
	
	if(Input.is_action_just_pressed("store")):
		if(stored.length() <= 0):
			store()
		else:
			launch()
	
	if(velocity.length() > 20 && velocity.length() < 400):
		if(is_on_floor()):
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("jump")
	elif(velocity.length() >= 400):
		animated_sprite_2d.play("roll")
	else:
		if(is_on_floor()):
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("jump")
	
	move_and_slide()

func store() -> void:
	stored += velocity*storeMulti
	stored = stored.normalized() * clamp(stored.length(), 0.0, maxStored)
	velocity = Vector2(0.0, 0.0)

func launch() -> void:
	velocity += stored*Vector2(fric/airFric, 1.0)
	stored = Vector2(0.0, 0.0)

func _on_area_2d_body_entered(body) -> void:
	die()

func die() -> void:
	dieSig.emit()
	get_tree().reload_current_scene()
