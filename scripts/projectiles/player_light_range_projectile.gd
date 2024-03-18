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
    
    if abs(distance_travelled) >= max_distance:
        destroy()

func set_direction(new_direction: Vector2):
    self.direction = new_direction
    
    # invalid vector
    if direction == Vector2.ZERO || direction == Vector2.DOWN || direction == Vector2.UP:
        self.destroy()

# TODO: implement attack metadata for this projectile
func _on_body_entered(_body):
    self.destroy()

func _on_area_entered(_area):
    self.destroy()

func destroy():
    queue_free()
    # TODO: audio, animation?
