extends Node

# TODO: maybe move this file out of /projectiles?
@export var attack_name : String
@export var attack_damage : float
@export var attack_pushback_force : float
@export var attack_pushback_time : float

func get_attack_metadata():
    return {
        "attack_name": attack_name,
        "attack_damage": attack_damage,
        "attack_pushback_force": attack_pushback_force,
        "attack_pushback_time" : attack_pushback_time
    }
