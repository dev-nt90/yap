extends Area2D

@export var speed: int = 3000
@export var max_distance: int = 400
var direction: Vector2 = Vector2.ZERO
var distance_travelled: float = 0.0

func _ready():
    pass # Replace with function body.


func _physics_process(delta):
    var distance: float = speed * direction.x * delta
    
    global_position.x += distance
    distance_travelled += distance
    print("distance_travelled: %02d" % distance_travelled)
    if abs(distance_travelled) >= max_distance:
        destroy()

func set_direction(new_direction: Vector2):
    self.direction = new_direction
    
    # invalid vector
    if direction == Vector2.ZERO || direction == Vector2.DOWN || direction == Vector2.UP:
        destroy()

# TODO: figure out a better way for nodes and their projectiles to communicate
# Today, if we push the notification to modify health, there's no guarantee there's a method to modify that property,
# but if we pull, there's no way to know how much damage to reduce the hit object.
# My instinct is that the pull route is correct, and my lack of godot knowledge is stopping me from figuring this out.
func _on_body_entered(_body):
    print("player light range projectile body entered")
    #body.modify_health(-10) 
    self.destroy()

func _on_area_entered(_area):
    print("player light projectile entered area")
    #area.modify_health(-10)
    self.destroy()

func destroy():
    queue_free()
    # TODO: audio, animation?
