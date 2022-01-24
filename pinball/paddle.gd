extends StaticBody2D






export(bool)var paddle_side=false
export(Vector2)var paddle_force = Vector2(128,128)
var has_ball=false
var ball = null
var target_angle = 15
var is_active = false
func _ready():
	$Col.position.x = (int(!paddle_side)*2-1)*48
	$Sprite.position.x = (int(!paddle_side)*2-1)*48
	target_angle = (int(!paddle_side)*2-1)*15
func _input(_event):
	if Input.is_action_just_pressed("ui_left")&&!paddle_side:
		is_active = true
		if ball!=null:
			ball.apply_central_impulse(paddle_force*(1/get_tip().distance_to(ball.position))*32)
		target_angle = -30
	if Input.is_action_just_released("ui_left")&&!paddle_side:
		target_angle= 15
		is_active=false
	if Input.is_action_just_pressed("ui_right")&&paddle_side:
		is_active = true
		if ball!=null:
			ball.apply_central_impulse(paddle_force*(1/get_tip().distance_to(ball.position))*32)
		target_angle = 30
	if Input.is_action_just_released("ui_right")&&paddle_side:
		target_angle= -15
		is_active=false
func _process(delta):
	rotation_degrees += (target_angle-rotation_degrees)*delta*20
func get_tip():
	return (position+(Vector2(48*(int(!paddle_side)*2-1),0).rotated(rotation)))
