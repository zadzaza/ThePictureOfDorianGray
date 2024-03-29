extends ParallaxLayer

@export var CLOUD_SPEED: int

func _process(delta):
	self.motion_offset.x += CLOUD_SPEED * delta
