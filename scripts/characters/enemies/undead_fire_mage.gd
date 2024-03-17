extends CharacterBody2D

enum States 
{
    IDLE,
    MOVING,
    PUSHBACK,
    ATTACK
}

@export var player : CharacterBody2D
@export var speed = 250
@export var debug = false
@export var pushback_distance = 200
@export var pushback_time = 0.5

var pushback_tween = null

var direction
var current_state
var frame_num = 0

func _ready():
    current_state = States.IDLE

func handle_debug():
    if debug:
        var distance_to_target = "distance_to_target %2f"
        var targeting_info = "Target reachable: %s
Target reached: %s"
        var target_reachable = $NavigationAgent2D.is_target_reachable()
        var target_reached = $NavigationAgent2D.is_target_reached()
        
        $DistanceToTargetLabel.text = distance_to_target % $NavigationAgent2D.distance_to_target()
        $TargetingInfoLabel.text = targeting_info % [target_reachable, target_reached]
        
func _process(_delta):
    frame_num += 1
    handle_debug()
    handle_state()

func handle_state():
    if debug:
        print("current_state %s %d" % [States.find_key(current_state), frame_num])
    match current_state:
        States.IDLE:
            handle_idle_state()
        States.MOVING:
            handle_moving_state()
        States.PUSHBACK:
            handle_pushback_state()
        States.ATTACK:
            handle_attack_state()
    
func handle_idle_state():
    if can_move_to_player():
        current_state = States.MOVING
    
func handle_moving_state():
    if can_move_to_player():
        direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
        velocity = direction * speed
        move_and_slide()
    else:
        current_state = States.IDLE

func handle_pushback_state():
    if pushback_tween == null: # do this to guard against constant tween recreation
        var target_position = global_position - (direction * pushback_distance)
        
        pushback_tween = create_tween()
        pushback_tween.tween_property(self, "position", target_position, pushback_time) \
            .set_ease(Tween.EASE_OUT) \
            .set_trans(Tween.TRANS_BACK)
        pushback_tween.tween_callback(_on_pushback_completed)
    
func handle_attack_state():
    # TODO: attack windup animation
    # TOOD: attack launch animation
    # TODO: attack windup sfx
    # TODO: attack launch sfx
    # TODO: spawn a projectile
    # TODO: projectile attack metadata
    # TODO: projectile animations
    # TODO: projectile sfx
    current_state = States.IDLE
    

func _on_pushback_completed():
    current_state = States.IDLE
    pushback_tween = null
    
func _on_timer_timeout():
    $NavigationAgent2D.target_position = player.position

func can_move_to_player():
    return not $NavigationAgent2D.is_target_reached() and $NavigationAgent2D.is_target_reachable()

func _on_navigation_agent_2d_target_reached():
    print("target reached")
    current_state = States.ATTACK

func _on_collision_area_body_entered(_body):
    current_state = States.PUSHBACK
