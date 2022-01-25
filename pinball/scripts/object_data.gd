extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float)var bounce_force=0.0
export(bool)var action_object=false
export(bool)var dont_hit_bottom=false
export(String)var action_name=""
export(String)var action_value=""
export(String)var action_group=""
export(int)var point_count_for_hit = 100
var polygon_pos = Vector2.ZERO
var active=false
func _ready():
	
	if get_node_or_null("Polygon2D")!=null&&$Polygon2D.get_class()!="Polygon2D":
		polygon_pos=$Polygon2D.rect_position
	if action_object:
		add_to_group(action_name)
		add_to_group("action_item")
		add_to_group(action_group)
		modulate=Color(0.5,0.5,0.5,1.0)
func get_bouncy():return bounce_force
func entered():
	if active:return
	modulate=Color(1.0,1.0,1.0,1.0)
	get_parent().get_parent().call(action_name,action_value,action_group)
	active=true
func disable():
	set_deferred('active',false)
	modulate=Color(0.5,0.5,0.5,1.0)


func bounce_off_of():
	var tween = Tween.new()
	add_child(tween)
	if $Polygon2D.get_class() == 'Polygon2D':
		tween.interpolate_property($Polygon2D,"scale",Vector2(1.25,1.25),Vector2.ONE,0.25,Tween.TRANS_BOUNCE)
	else:
		tween.interpolate_property($Polygon2D,"rect_scale",Vector2(1.25,1.25),Vector2.ONE,0.25,Tween.TRANS_BOUNCE)
		tween.interpolate_property($Polygon2D,"rect_position",-($Polygon2D.rect_size/2)*1.25+polygon_pos/2,polygon_pos,0.25,Tween.TRANS_BOUNCE)
	tween.start()
	tween.connect("tween_all_completed",self,"remove_object",[tween])
	
func remove_object(obj=null):
	if obj!=null:
		obj.disconnect('tween_all_completed',self,"remove_object")
		obj.queue_free()
