extends KinematicBody2D

onready var anim = $CharacterSprite/AnimationPlayer

export (int) var speed = 200

var velocity = Vector2()


func _ready():
	load_sprite()
	
	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
		anim.play("right")
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		anim.play("left")
	if Input.is_action_pressed('down'):
		velocity.y += 1
		anim.play("down")
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		anim.play("up")
	velocity = velocity.normalized() * speed


func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func load_sprite():
	$CharacterSprite/skin.modulate = Global.skinTone
	$CharacterSprite/hair.texture = load("res://assets/player/hairStyles/" + Global.hairStyle +".png")
	$CharacterSprite/hair.modulate = Global.hairColor
	$CharacterSprite/eyesColorPart.modulate = Global.eyeColor