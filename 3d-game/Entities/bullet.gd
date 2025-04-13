extends Node3D

const SPEED = 40

@onready var ray: RayCast3D = $RayCast3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var part: GPUParticles3D = $GPUParticles3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		part.emitting = true
		ray.enabled = false
		if ray.get_collider().is_in_group("player"):
			ray.get_collider().hit()
			#print("hit")
		
		await get_tree().create_timer(1).timeout
		queue_free()
		


func _on_death_timer_timeout() -> void:
	queue_free()
