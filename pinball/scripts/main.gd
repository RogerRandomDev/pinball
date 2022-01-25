extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var points=0
var point_mult = 1
var cur_lives = 5
var game_menu=null
export(Array,Array,bool)var actions = []
export(Array,int)var action_point_rewards=[]
func _ready():
	randomize()
	game_menu=get_parent().get_parent().get_parent().get_node("R")
func add_points(val):
	points+=val*point_mult
	play_sfx("point_gain.wav")
	game_menu.get_node("0/Score").text = "SCORE:\n"+str(points)
func Action(value,triggerer):
	actions[str2var(value)[0]][str2var(value)[1]]=true
	if !actions[str2var(value)[0]].has(false):
		if action_point_rewards[str2var(value)[0]]<0:point_mult*=2
		else:add_points(action_point_rewards[str2var(value)[0]])
		for point in actions[str2var(value)[0]].size():actions[str2var(value)[0]][point]=false
		for trigger in get_tree().get_nodes_in_group(triggerer):trigger.disable()
		
func play_sfx(sound=null):
	if sound!=null:
		var sfx = AudioStreamPlayer.new()
		sfx.volume_db = -10
		sfx.stream=load("res://audio/"+sound)
		add_child(sfx)
		sfx.play()
		sfx.connect("finished",self,'remove_sfx',[sfx])
func remove_sfx(obj=null):
	if obj!=null:
		obj.disconnect('finished',self,'remove_sfx')
		obj.queue_free()

func _input(_event):
	if Input.is_action_just_pressed("ui_down"):
		var push_range = Vector2(rand_range(-256,256),rand_range(-256,256))
		$Ball.apply_central_impulse(push_range)
		$Cam.apply_central_impulse(-push_range)
func remove_live():
	cur_lives-=1
	var lives_left = ""
	for life in cur_lives:lives_left+="*"
	game_menu.get_node("0/Lives").text="LIVES LEFT:\n"+lives_left
	if cur_lives==0:
		game_over()
func game_over():
	get_parent().get_parent().get_node("Label").show()
	get_tree().paused = true
func reload_menu():
	game_menu.get_node("0/Lives").text = "LIVES LEFT:\n*****"
	game_menu.get_node("0/Score").text = "SCORE:\n0"
