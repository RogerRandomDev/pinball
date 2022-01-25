extends RigidBody2D

var direction = Vector2.ZERO
export(float)var bounce_force = 32.0
export var fired = false
var fire_force = 0.0
var fire_rate = 1.0
var launch_angle = 0.0
var do_load=true
export var delayed = true
func _ready():
	randomize()
	#fire_ball()
# warning-ignore:unused_argument
func _process(delta):
	if (position.y > 592||!fired)&&!delayed:
		if do_load:
			get_parent().get_node("AnimationPlayer").play("new")
			do_load = false
			fire_force = 0.0
			launch_angle = 0.0
		else:
			$launch_shower.visible = true
			$ProgressBar.visible = true
			fired = false
			prepare_to_fire_ball()
		
	if linear_velocity.length_squared() >=16777216:
		linear_velocity = linear_velocity.normalized()*4096
func _on_check_body_entered(body):
	get_parent().play_sfx("bounce.wav")
	if body.is_in_group("Bouncer"):
		var bounce_factor = 64
		var dont_hit_bottom = false
		if body.has_method('get_bouncy'):
			bounce_factor = body.get_bouncy()
			get_parent().add_points(body.point_count_for_hit)
			dont_hit_bottom = body.dont_hit_bottom
			body.bounce_off_of()
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
		for point in out_col:
			if dont_hit_bottom&&point.y < position.y:continue
			var force = Vector2(bounce_factor,0).rotated(position.angle_to(point))
			apply_central_impulse(force)
			paddle_hit(force)
	if body.is_in_group("Paddle"):
		body.has_ball=true
		body.ball = self
		var force = ((body.paddle_force*int(body.is_active&&abs(body.rotation_degrees-body.target_angle)>1)*(1/body.get_tip().distance_to(position)*32))).rotated(body.rotation)
		if force.length() > body.paddle_force.length():
				force=force.normalized()*body.paddle_force.length()
		if body.target_angle!=body.rotation_degrees:apply_central_impulse(
			force
			)
		paddle_hit(force)


func _on_check_body_exited(body):
	if body.is_in_group("Paddle"):
		body.has_ball=false
		body.ball = null


func _on_check_area_entered(area):
	if !area.is_in_group("action_item"):return
	area.entered()
	
func paddle_hit(force=Vector2.ZERO):
	get_parent().get_node("Cam").apply_central_impulse(force/32)
	get_parent().play_sfx("bounce.wav")
func fire_ball():
	do_load = true
	global_position = Vector2(256,524)
	linear_velocity = (Vector2(rand_range(-32,32),rand_range(-512,-564))*pow(fire_force*2,2)).rotated($launch_shower.rotation)
	mode=MODE_RIGID
func prepare_to_fire_ball():
	if mode != MODE_STATIC:mode = MODE_STATIC
	rotation = 0
	global_position = Vector2(256,524)
	fire_force+=fire_rate*get_process_delta_time()
	$ProgressBar.value = fire_force
	$ProgressBar.modulate = Color(0.5-((fire_force-0.5)*int(fire_force>0.5)),((fire_force-0.5)*int(fire_force>0.5)),0)
	if fire_force>=1.0||fire_force<=0.0:
		fire_rate = -fire_rate
		fire_force = clamp(fire_force,0.0,1.0)
	launch_angle+=(float(Input.is_action_pressed("ui_right"))-float(Input.is_action_pressed("ui_left")))*get_process_delta_time()*30
	launch_angle =clamp(launch_angle,-30,30)
	$launch_shower.rotation_degrees = launch_angle
	if !Input.is_action_pressed("ui_up"):return
	fired=true
	$ProgressBar.visible = false
	$launch_shower.visible = false
	fire_ball()


