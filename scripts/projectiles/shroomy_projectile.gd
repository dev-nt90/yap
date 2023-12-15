extends Area2D

@export var speed: int = 50
@export var max_distance: int = 500
var direction: Vector2 = Vector2.ZERO
var distance_travelled: float = 0.0

func _ready():
    $AnimationPlayer.play("float")

func _physics_process(delta):
    var distance: float = speed * direction.x * delta
    
    global_position.x += distance
    distance_travelled += distance
    
    if distance_travelled >= max_distance:
        destroy()

func destroy():
    #todo: "pop" sound effect
    $AnimationPlayer.play("pop")
    
func set_direction(new_direction: Vector2):
    self.direction = new_direction
    
    # invalid vector
    if direction == Vector2.ZERO || direction == Vector2.DOWN || direction == Vector2.UP:
        destroy()

func _on_body_entered(body):
    body.modify_health(-10)
    self.destroy()

func _on_area_entered(_area):
    self.destroy()


func _on_animation_player_animation_finished(anim_name):
    if anim_name == "pop":
        queue_free()
