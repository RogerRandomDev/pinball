extends RigidBody2D

var direction = Vector2.ZERO
export(float)var bounce_force = 32.0





func _on_check_body_entered(body):
	if body.is_in_group("Bounce"):
		var bounce_factor = 64
		if body.has_method('get_bouncy'):
			bounce_factor = body.get_bouncy()
		var my_shape = $check/Col.get_shape()
		var check_shape_col = body.get_node("Col")
		var check_shape = null
		match check_shape_col.get_class():
			"CollisionShape2D":check_shape = check_shape_col.get_shape()
			"CollisionPolygon2D":
				var holder = ConvexPolygonShape2D.new()
				holder.set_points(check_shape_col.polygon)
				check_shape = holder
		var out_col = my_shape.collide_and_get_contacts(global_transform,check_shape,body.global_transform)
		for point in out_col:apply_central_impulse(Vector2(1,0).rotated(position.angle_to(point))*bounce_factor)
	if body.is_in_group("Paddle"):
		body.has_ball=true
		body.ball = self
		if body.target_angle!=body.rotation_degrees:apply_central_impulse(
			(body.paddle_force*int(body.is_active&&abs(body.rotation_degrees-body.target_angle)>1)*(1/body.get_tip().distance_to(position))*32).rotated(body.rotation)
			)
	
func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		linear_velocity.y = -1024


func _on_check_body_exited(body):
	if body.is_in_group("Paddle"):
		body.has_ball=false
		body.ball = null


func _on_check_area_entered(area):
	if !area.get_parent().is_in_group("Interaction"):return
