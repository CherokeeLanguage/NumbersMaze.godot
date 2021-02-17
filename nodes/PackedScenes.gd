extends Node2D

"""
I exist solely to stop issues with the dreaded 'already loaded' packed scene errors
"""

class_name PackedScenesScript

const FadeOutIn:PackedScene = preload("res://nodes/FadeOutIn.tscn")

const StartMenu:PackedScene = preload("res://ui/menus/StartMenu.tscn")
const SelectGameSlot:PackedScene = preload("res://ui/menus/SelectGameSlot.tscn")
const HowToPlay:PackedScene = preload("res://ui/menus/HowToPlay.tscn")
const OptionsMenu:PackedScene = preload("res://ui/menus/OptionsMenu.tscn")
const AboutMenu:PackedScene = preload("res://ui/menus/AboutMenu.tscn")

const PlayerFireball:PackedScene = preload("res://player/PlayerFireball.tscn")
const DieExplosion:PackedScene = preload("res://nodes/DieExplosion.tscn")

const DieNode:PackedScene =  preload("res://nodes/DieNode.tscn")

const LevelMap:PackedScene = preload("res://levels/LevelMap.tscn")
const Player:PackedScene = preload("res://player/Player.tscn")

const FloorPortal:PackedScene = preload("res://nodes/FloorPortal.tscn")
const WarpInAreaDetect:PackedScene = preload("res://nodes/WarpInAreaDetect.tscn")
const EnemySparklingFireball:PackedScene = preload("res://enemies/EnemySparklingFireball.tscn")

const SoundFx:PackedScene = preload("res://audio/SoundFx.tscn")
