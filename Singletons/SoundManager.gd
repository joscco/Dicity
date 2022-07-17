extends Node

onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
onready var soundPlayer: AudioStreamPlayer = $SoundPlayer
var muted = false

# Looping Sound files work way better in ogg format!
var mainMusicIntro = preload("res://Assets/Music/Intro.ogg")
var mainMusic = preload("res://Assets/Music/Main.ogg")

var HitSound = preload("res://Assets/Sounds/hit.mp3")
var ShellSound = preload("res://Assets/Sounds/shells.mp3")
var ShootSound = preload("res://Assets/Sounds/shoot.mp3")
var BlipSound = preload("res://Assets/Sounds/blip.wav")
var DiceSound = preload("res://Assets/Sounds/diceroll.wav")
var ErrorSound = preload("res://Assets/Sounds/error.mp3")

var musicPlaying: bool
var introPlaying: bool

func playMusic():
	if !musicPlaying and !introPlaying:
		musicPlayer.stream = mainMusicIntro
		musicPlayer.play()
		
		introPlaying = true
		musicPlaying = true
		
		# Wait until the intro has finished playing
		yield(musicPlayer, "finished")
		introPlaying = false
		musicPlayer.stream = mainMusic
		musicPlayer.play()
		
func stopMusic():
	musicPlayer.stop()
	introPlaying = false
	musicPlaying = false

func mute():
	muted = true
	musicPlayer.stream_paused = true
	soundPlayer.stream_paused = true

func unmute():
	muted = false
	musicPlayer.stream_paused = false
	soundPlayer.stream_paused = false
	
func playSound(sfx: String):
	if sfx == "diceroll":
		soundPlayer.stream = DiceSound
	if sfx == "error":
		soundPlayer.stream = ErrorSound
	soundPlayer.play()
