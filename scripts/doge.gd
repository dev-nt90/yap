extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(_delta):
    var leader = get_node("/root/SceneRoot/Player")
    var distanceToLeader = position.distance_to(leader.position) 
    if int(distanceToLeader) > 150: #If more than 25 units away...    
        position += position.direction_to(leader.position) * 5
