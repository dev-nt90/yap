# HACK: not pictured in this script, but for the attached node itself
# Apparently a character body is requires a collision object. But for nodes to communicate with this one, we need
# an area. TODO: figure this out

extends CharacterBody2D

signal enemy_defeated

enum STATES {
    IDLE,
    PLAYER_IN_RANGE,
    FIRING_PROJECTILE,
    DEATH
}

@export var firing_distance: int = 200
@export var max_health: int = 10
@onready var projectile_windup_sfx = $sfx.get_node("shroomy-projectile-windup")
@onready var death_sfx = $sfx.get_node("shroomy-death")

var projectile = preload("res://scenes/projectiles/shroomy_projectile.tscn")
var current_health = max_health

const SPEED = 10

var projectile_ready = true
var current_state = STATES.IDLE
var player : CharacterBody2D = null
var ground_position

func _ready():
    $AnimationPlayer.play("idle")
    $ProjectileCooldownTimer.stop()
    $HealthBarContainer.set_max_value(max_health)
    $HealthBarContainer.set_current_value(max_health)
    ground_position = position.y # HACK: this

func _process(_delta):
    position.y = ground_position
    velocity.y = 0 # no funny business ya hear?
    match current_state:
        STATES.IDLE:
            handle_idle_state()
        STATES.PLAYER_IN_RANGE:
            handle_player_in_range_state()
        STATES.FIRING_PROJECTILE:
            handle_firing_projectile()
        
func handle_idle_state():
    $AnimationPlayer.play("idle")

func handle_player_in_range_state():
    # HACK: if the detection area was exiting while firing, we capture that condition and return to idle
    # while this solves the race condition, it's damn ugly
    if player == null: 
        current_state = STATES.IDLE
        
    if velocity.x < 0:
        $Sprite2D.flip_h = true
    else:
        $Sprite2D.flip_h = false
    
    $AnimationPlayer.play("idle")
    
    var player_position = player.position
    var self_position = self.position
    var desired_velocity = (player_position - self_position).normalized() * SPEED
    velocity.x = desired_velocity.x
    move_and_slide()
    
    if self_position.distance_to(player_position) <= firing_distance and projectile_ready:
        current_state = STATES.FIRING_PROJECTILE

func handle_firing_projectile():
    $AnimationPlayer.play("projectile_windup")

func _on_animation_player_animation_finished(anim_name):
    if anim_name == "projectile_windup":
        self.instantiate_projectile()

func _on_animation_player_animation_started(anim_name):
    if anim_name == "projectile_windup":
        projectile_windup_sfx.position = self.position
        projectile_windup_sfx.play()
    if anim_name == "death":
        death_sfx.position = self.position
        death_sfx.play()
    
func instantiate_projectile():
    var new_projectile = projectile.instantiate()
    var direction = Vector2.ZERO
    if $Sprite2D.flip_h:
        direction = Vector2.LEFT
    else:
        direction = Vector2.RIGHT
    new_projectile.set_direction(direction)
    new_projectile.set_position(self.position)
    $Projectiles.add_child(new_projectile)
    
    handle_projectile_cooldown()
    
    if current_state == STATES.FIRING_PROJECTILE: 
        current_state = STATES.PLAYER_IN_RANGE
    
func handle_projectile_cooldown():
    #mark projectile unavailable
    projectile_ready = false
    
    #start the cooldown timer
    $ProjectileCooldownTimer.start()
    
func _on_detection_area_body_entered(body):
    player = body
    current_state = STATES.PLAYER_IN_RANGE

func _on_detection_area_body_exited(_body):
    player = null
    current_state = STATES.IDLE

func _on_projectile_cooldown_timer_timeout():
    projectile_ready = true
    $ProjectileCooldownTimer.stop()

func modify_health(modify_amount):
    current_health += modify_amount
    $HealthBarContainer.set_current_value(max_health)

# TODO: update this to use attack metadata
func _on_hitbox_area_area_entered(_area):
    modify_health(-5)
    $HealthBarContainer.set_current_value(self.current_health)
    if self.current_health <= 0:
        get_parent().get_parent().get_node("HUD").increment_enemy_defeated_count()
        # TODO: death animation
        $AnimationPlayer.play("death")
        
        emit_signal("enemy_defeated")
        
        queue_free()
    



