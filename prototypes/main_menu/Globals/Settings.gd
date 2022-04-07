extends Control


# Temp Vars
const SAVE_PATH = "res://save.json"

var settings = {}
var play_music = 1
var new_choice = 1
var song # The song loaded
var menu = true
# Saved Vars

# Our sound
var master_volume = 2000
var music_volume = 2000
var master_mute = false

# Our resolution
var resolution_width = 1920
var resolution_height = 1080
var fullscreen = false

# Scan codes
var sp_use = 32
var sp_pause = 16777217


# Called when the node enters the scene tree for the first time.
func _ready():
	music_choice()
	resolution()
	
func _process(delta):
	if (!$music.is_playing()):
		music_choice()
		
	if (master_volume > 0 and music_volume > 0):
		play_music = int((master_volume/2000)*(music_volume/2000)*2000)
		
	else:
		play_music = 1
		
	$music.set_max_distance(play_music)
	
# Start the music for the menu
func music_choice():
	if (menu == true):
		menu_music()
		
	else:
		pass
	
	
func menu_music():
	randomize()
	new_choice = int(rand_range(1,20))
	
	match new_choice:
		1: 
			song = load("res://Assets/Music/Menu_Music/AFoolsAffair.wav")
		2:
			song = load("res://Assets/Music/Menu_Music/BimBomBomp.wav")
		3:
			song = load("res://Assets/Music/Menu_Music/BoundlessSlumber.wav")
		4:
			song = load("res://Assets/Music/Menu_Music/CalmRock.wav")
		5:
			song = load("res://Assets/Music/Menu_Music/ChillingMonkey.wav")
		6:
			song = load("res://Assets/Music/Menu_Music/ComatoseDreams.wav")
		7:
			song = load("res://Assets/Music/Menu_Music/DivingintoSpring.wav")
		8:
			song = load("res://Assets/Music/Menu_Music/FloatingintheAbyss.wav")
		9:
			song = load("res://Assets/Music/Menu_Music/FunkPump.wav")
		10:
			song = load("res://Assets/Music/Menu_Music/NewMorningNewSun.wav")
		11:
			song = load("res://Assets/Music/Menu_Music/PalmTreeShade.wav")
		12:
			song = load("res://Assets/Music/Menu_Music/PoseidonsRealm.wav")
		13:
			song = load("res://Assets/Music/Menu_Music/RaceTrackChimes.wav")
		14:
			song = load("res://Assets/Music/Menu_Music/SpaceDebris.wav")
		15:
			song = load("res://Assets/Music/Menu_Music/SpaceshipHanger.wav")
		16:
			song = load("res://Assets/Music/Menu_Music/StarRock.wav")
		17:
			song = load("res://Assets/Music/Menu_Music/Strange.wav")
		18:
			song = load("res://Assets/Music/Menu_Music/SunlightatMidnight.wav")
		19:
			song = load("res://Assets/Music/Menu_Music/TeardropTempo.wav")
		20:
			song = load("res://Assets/Music/Menu_Music/TheRiff.wav")
	$music.set_stream(song)
	$music.play(0.0)
	
	
func resolution():
	ProjectSettings.set_setting("display/window/size/width", resolution_width)
	ProjectSettings.set_setting("display/window/size/height", resolution_height)
	OS.set_window_size(Vector2(resolution_width, resolution_height))
	
	if (fullscreen == true):
		OS.set_window_fullscreen(false)
		OS.set_window_fullscreen(true)
		
	elif (fullscreen == false):
		OS.set_window_fullscreen(true)
		OS.set_window_fullscreen(false)
		OS.set_window_position(Vector2(0, 0))
	
	
	
	
	
	
	
	
	
	
	
