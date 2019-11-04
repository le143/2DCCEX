#A Very Basic Character Creator 
#by u/le143

extends Control


onready var colorSquares = $Panel/SkinColorSquares
onready var hairStyleOption = $Panel/HairStyleOption
onready var colorPicker = $Panel/ColorPickerControl/ColorPicker


onready var skin = $Panel/CharacterSprite/skin
onready var hair = $Panel/CharacterSprite/hair
onready var eyesColor = $Panel/CharacterSprite/eyesColorPart
onready var eyesWhite = $Panel/CharacterSprite/eyesWhitePart
onready var clothes = $Panel/CharacterSprite/clothes


onready var selectedSkinToneBtn = $Panel/SkinColorSquares/Color1
var selectedHairStyle


var skinTones = ["FFDBAC", "F1C27D", "E0AC69", "C68642", "8D5524"]
var hairStyles = ["bald","afro","combover","mohawk"]



var skinTone = "FFDBAC"
var eyeColor = "000000"
var hairStyle = "mohawk"
var hairColor = "000000"


var faceDir

func _ready():
	load_sprite()
	load_hair_styles_list()
	load_color_squares()
	
	for button in get_tree().get_nodes_in_group("color_btns"):
	    button.connect("pressed", self, "_colorButtonPressed", [button])
	    button.connect("focus_entered", self, "_colorButtonFocus", [button])	

func load_sprite():
	face("down")
	skin.modulate = skinTone
	eyesColor.modulate = eyeColor
	setHairTo(hairStyle)
	hair.modulate = hairColor
	

	
func load_color_squares():
	var normalTexture = load("res://Assets/ui/whiteSquare.png")
	var selectedTexture = load("res://Assets/ui/whiteSquare-selected.png")
	
	for i in colorSquares.get_child_count():
		var colorSquare = colorSquares.get_child(i)
		colorSquare.texture_normal = normalTexture
		colorSquare.modulate = Color(skinTones[i])
		
		
		selectedSkinToneBtn.texture_normal = selectedTexture


func load_hair_styles_list():
	var icon_path = "res://Assets/player/hairStyles/previews/placeholder.png"
	
	for i in hairStyles.size():
		var temp_icon = icon_path.replace("placeholder", hairStyles[i])
		var icon = ResourceLoader.load(temp_icon)
		hairStyleOption.add_item("",icon)
		
		
func _colorButtonFocus(button):
	var color = button.modulate
	skin.modulate = color

func _colorButtonPressed(button): 
	var color = Color(button.modulate)

	skin.modulate = color
	skinTone = color.to_html()
	selectedSkinToneBtn = button

	load_color_squares()		


	



func _on_ColorPicker_color_changed(color):
	hair.modulate = color
	hairColor = color



func randomize_appearance():
	#RANDOM HAIR COLOR
	var randomHairColor = Color(randf(), randf(), randf(), 1)
	hair.set_modulate(randomHairColor)
	hairColor = randomHairColor.to_html()
	colorPicker.color = randomHairColor
	
	#RANDOM SKIN COLOR
	var skinTonesIndex = randi() % skinTones.size()
	var randomSkinColor = skinTones[skinTonesIndex]
	skin.modulate = randomSkinColor
	skinTone = randomSkinColor
	selectedSkinToneBtn = colorSquares.get_child(skinTonesIndex)
	
	#RANDOM HAIR STYLE
	var randomHairIndex = randi() % hairStyles.size()
	var randomHairStyle = hairStyles[randomHairIndex]
	setHairTo(randomHairStyle)
	hairStyleOption.select(randomHairIndex)
	selectedHairStyle = randomHairIndex
	hairStyleOption.ensure_current_is_visible()

	load_color_squares()
	
	
func _on_Randomize_pressed():
	randomize_appearance()

func face(direction:String):
	var frame
	match direction:
		"down":
			frame = 0
			faceDir = "down"
		"up":
			frame = 1
			faceDir = "up"
		"left":
			frame = 2
			faceDir = "left"
		"right":
			frame = 3
			faceDir = "right"
	
	skin.frame = frame
	clothes.frame = frame
	eyesWhite.frame = frame
	eyesColor.frame = frame
	hair.frame = frame

func setHairTo(style):
	var path = "res://Assets/player/hairStyles/" + style + ".png"
	hair.texture = load(path)
	hairStyle = style
	
func _on_HairStyleOption_item_selected(index):
	setHairTo(hairStyles[index])

		

func _on_LeftArrow_pressed():
	match faceDir:
		"down":
			face("left")
		"left":
			face("up")
		"up":
			face("right")
		"right":
			face("down")


func _on_RightArrow_pressed():
	match faceDir:
		"down":
			face("right")
		"right":
			face("up")
		"up":
			face("left")
		"left":
			face("down")

func _on_Create_pressed():
	Global.skinTone = skinTone
	Global.hairStyle = hairStyle
	Global.hairColor = hairColor
	Global.eyeColor = eyeColor
	
	get_tree().change_scene("res://Scenes/PlayerController.tscn")
