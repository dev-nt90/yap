# TODO: this is quickly turning into spaghetti code. 
# Figure out how DI works in GDScript and move this impl logic into animation/physics/state controllers/services/etc
extends CharacterBody2D

enum States {
    AIR = 1,
    FLOOR,
    WALL
}

# set to TRUE to have player spawn in at "DebugStartPosition" node
@export var debug = false 

const SPEED = 300.0
const RUNSPEED_MULTIPLIER = 2.5
const JUMP_VELOCITY = -550.0
const WALL_JUMP_BUFFER_LIMIT = 5

var wall_jump_direction_buffer: Array[bool] = []
var wall_jump_jump_buffer: Array[bool] = []
var double_jump_available = true
var current_state = States.AIR

var direction

@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
    disable_friction_smoke()
    if debug:
        var debugStartPosition = get_parent().get_node("DebugStartPosition")
        position.x = debugStartPosition.position.x
        position.y = debugStartPosition.position.x
    
func _physics_process(delta):
    handle_state(delta)
    handle_sprint()
    handle_state_agnostic()
    tick_buffer()
    
func handle_state(delta):
    direction = get_direction_input()
    match current_state:
        States.AIR:
            handle_air_state(delta)
        States.FLOOR:
            handle_floor_state()
        States.WALL:
            handle_wall_state(delta)
        
func handle_sprint():
    if current_state == States.AIR:
        disable_friction_smoke()
        
        if Input.is_action_pressed("sprint") and direction != 0:
            velocity.x = lerp(velocity.x, SPEED * RUNSPEED_MULTIPLIER * direction, 0.75)
            animation_player.speed_scale = 2.0
    elif Input.is_action_pressed("sprint") and current_state == States.FLOOR and direction != 0:
        enable_friction_smoke()
        $FrictionSmoke.scale.x = lerp($FrictionSmoke.scale.x, 1.0, .1) * direction 
        $FrictionSmoke.scale.y = lerp($FrictionSmoke.scale.y, 1.0, .1)
        $FrictionSmoke.position.x = -20 * direction
        
        velocity.x = lerp(velocity.x, SPEED * RUNSPEED_MULTIPLIER * direction, 0.75)
        animation_player.speed_scale = 2.0
    elif Input.is_action_just_released("sprint"):
        disable_friction_smoke()
    
"""
This function handles any logic which can apply when the player is in any state.
"""

func handle_state_agnostic():
    # apply horizontal flipping to our currently playing animation and wallchecker
    if(direction < 0):
        $HeroWalkSprite.flip_h = true
        $WallChecker.rotation_degrees = 90
    elif(direction > 0):
        $HeroWalkSprite.flip_h = false
        $WallChecker.rotation_degrees = -90

    move_and_slide()

func handle_floor_state():
    # state transition to AIR
    if not is_on_floor():
        current_state = States.AIR
        return
    
    # if we've landed on solid ground, the double jump should be reset
    double_jump_available = true
    
    # apply force from user input
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
    
    # if we're not moving, go idle, otherwise walk
    if velocity.x == 0:
        animation_player.speed_scale = 1.0
        animation_player.play("idle")
    else:
        animation_player.speed_scale = 1.0
        animation_player.play("walk")
    
    # apply jump from floor, transition to AIR
    if Input.is_action_just_pressed("jump"):
        velocity.y = JUMP_VELOCITY
        current_state = States.AIR
        
func handle_air_state(delta):
    # transition state
    if is_on_floor():
        current_state = States.FLOOR
        return
    elif is_near_wall():
        current_state = States.WALL
        velocity.y = lerp(velocity.y, 0.0, .5)
        return
    
    # play relevant animation
    animation_player.play("jump")
    
    # apply gravity
    velocity.y += gravity * delta
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
    
    # handle double jump
    if Input.is_action_just_pressed("jump") and double_jump_available:
        velocity.y = JUMP_VELOCITY
        double_jump_available = false

func handle_wall_state(delta):
    # do state transition
    if is_on_floor():
        #disable_friction_smoke()
        current_state = States.FLOOR
        return
    elif not is_near_wall():
        #disable_friction_smoke()
        current_state = States.AIR
        return
        
    # apply lesser gravity, so the initial slide down the wall is relatively slow
    velocity.y += (gravity * delta) * 0.4
    
    #TODO: fix wall jump friction smoke
    #enable_friction_smoke()
    #
    #print("velocity.y %02d" % velocity.y)
    #$FrictionSmoke.position.x = 20 * direction
    #
    #if(velocity.y > 50):
        #$FrictionSmoke.scale.x = clamp(abs(velocity.y) * 0.001, 0, 1)
        #$FrictionSmoke.scale.y = clamp(abs(velocity.y) * 0.001, 0, 1)
    
    # handle animation
    animation_player.play("wall")
    
    # handle input
    handle_wall_jump_input()
    
func handle_wall_jump_input():
    """
    This function:
      1) buffers the jump input
      2) gets the direction the user is inputting, and buffers that input if it's not the direction the sprite is currently facing
      3) checks to see if, in the last 5 frames, the jump input and the opposite direction input have been recorded
          NOTE: we record these as separate buffers because they are separate inputs; in other words, we wouldn't
                to record a false positive if the user happened to meet either one of these conditions,
                as that could lead to unexpected behavior, like the sprite "sliding" up a wall while holding jump...
                which might be a fun mechanic, but not what we want here
      4) if yes, apply velocity to the character, such that they are "pushed" from the wall
      4a) clear the jump buffers
      5) if no, continue
    
    A visual representation:
        **trivial example**
        frame 1: character faces right, user inputs left and jump
            wall_jump_jump_buffer: [true] ; from space input
            wall_jump_direction_buffer: [true] ; from mismatched character direction and input direction
            do wall jump
            clear wall jump buffers
        
        7 frame example
        frame 1: character faces right, user inputs nothing
            wall_jump_jump_buffer: [false]
            wall_jump_direction_buffer: [false]
        frame 2: character faces right, user inputs left
            wall_jump_jump_buffer: [false, false]
            wall_jump_direction_buffer: [true, false] ; input detection moves to position 0
        frame 3: user inputs nothing
            wall_jump_jump_buffer: [false, false, false]
            wall_jump_direction_buffer: [false, true, false]
        frame 4: user inputs nothing
            wall_jump_jump_buffer: [false, false, false, false]
            wall_jump_direction_buffer: [false, false, true, false]
        frame 5: user inputs nothing
            wall_jump_jump_buffer: [false, false, false, false, false]
            wall_jump_direction_buffer: [false, false, false, true, false]
        frame 6: user inputs nothing
            wall_jump_jump_buffer: [false, false, false, false, false, false]
            wall_jump_direction_buffer: [false, false, false, false, true, false]
            buffers outside limit! last item is removed
        from 7: user inputs jump
            wall_jump_jump_buffer: [true, false, false, false, false, false]
            wall_jump_direction_buffer: [false, false, false, false, false, true]
            because we had the input detection in frames 2 and 7, do wall jump
            clear wall jump buffers
    """
    
    var player_direction = 1 if not $HeroWalkSprite.flip_h else -1
    if Input.is_action_pressed("jump"):
        wall_jump_jump_buffer.push_front(true)
    
    if direction != player_direction and direction != 0:
        wall_jump_direction_buffer.push_front(true)
        
    if buffer_contains_true(wall_jump_jump_buffer) and buffer_contains_true(wall_jump_direction_buffer):
        velocity.x = SPEED * direction * 2
        velocity.y = JUMP_VELOCITY
        clear_wall_jump_buffer()
        disable_friction_smoke()
        
# Any input buffers, like coyote frames or wall jumps, should go here
func tick_buffer():
    tick_wall_jump_buffer()

func tick_wall_jump_buffer():
    tick_wall_jump_direction_buffer()
    tick_wall_jump_jump_buffer()
    
func tick_wall_jump_direction_buffer():
    if len(wall_jump_direction_buffer) > WALL_JUMP_BUFFER_LIMIT:
        wall_jump_direction_buffer.pop_back()
    
func tick_wall_jump_jump_buffer():
    if len(wall_jump_jump_buffer) > WALL_JUMP_BUFFER_LIMIT:
        wall_jump_jump_buffer.pop_back()
    
func clear_wall_jump_buffer():
    wall_jump_direction_buffer.clear()
    wall_jump_jump_buffer.clear()

# HACK: this
func buffer_contains_true(buffer):
    for b in buffer:
        if b:
            return true
    return false

func get_direction_input():
    return Input.get_axis("left", "right")
    
func is_near_wall():
    return $WallChecker.is_colliding()
            
func enable_friction_smoke():
    $FrictionSmoke.emitting = true
    
func disable_friction_smoke():
    $FrictionSmoke.scale.x = 0.0 # let the individual states handle lerping to the final smoke state
    $FrictionSmoke.scale.y = 0.0 
    $FrictionSmoke.emitting = false

func _on_fall_zone_body_entered(_body):
    get_tree().reload_current_scene()

func _on_ruby_area_ruby_collected():
    get_parent().get_node("HUD").increment_ruby_count()
    var ruby = get_parent().get_node("sfx").get_node("ruby")
    ruby.play()

func _on_cabin_area_body_entered(_body):
    get_tree().change_scene_to_file("res://scenes/Level2.tscn")

func _on_emerald_body_emerald_collected():
    get_parent().get_node("HUD").increment_emerald_count()
    var emerald = get_parent().get_node("sfx").get_node("emerald")
    emerald.play()
