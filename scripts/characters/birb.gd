extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var leader 
var target 
var is_companion = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
    if is_companion:
        leader = get_node("/root/SceneManager/CurrentScene/SceneRoot/Player")
    $seagull.play()
    
func _process(_delta):
    if velocity.x < 0:
        $seagull.flip_h = true
    else:
        $seagull.flip_h = false
        
    if is_companion:
        var distanceToLeader = position.distance_to(leader.position) 
        if distanceToLeader > 150:
            var desired_velocity = (leader.position - position).normalized() * SPEED
            velocity = desired_velocity
            move_and_slide()
    else:
        position += position.direction_to(target) * 5

func set_target(target_vector: Vector2):
    target = target_vector
    
func set_is_companion(is_birb_companion):
    is_companion = is_birb_companion
