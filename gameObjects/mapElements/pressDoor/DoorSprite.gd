extends AnimatedSprite2D

enum DIRECTION { Vertical, Horizontal }
@export var direction: DIRECTION = DIRECTION.Horizontal

var current_animation = "vertical"

func _ready():
	if direction == DIRECTION.Vertical:
		current_animation = "vertical"
	else:
		current_animation = "horizontal"
		
	self.play(current_animation)
	self.set_frame_and_progress(0, 0)
	self.pause()

func open():
	if frame != 0:
		return
		
	self.play(current_animation)
	
func close():
	print(sprite_frames)
	self.play_backwards(current_animation)
