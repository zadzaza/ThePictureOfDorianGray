extends Control

@onready var chart: Chart = $VBoxContainer/Chart
var save_bird_count: int = 50
var not_save_bird_count: int = 50

# This Chart will plot 3 different functions
var f1: Function

func _ready():
	open()
	show_chart(LevelsManager.save_bird_count, LevelsManager.not_save_bird_count, LevelsManager.timeout_count)

func open():
	var tween = create_tween()
	tween.tween_property($Transition, "modulate", Color(1, 1, 1, 0), 1.0).from(Color(1, 1, 1, 1))
	await tween.finished
	$Transition.hide()

func close():
	$Transition.show()
	var tween = create_tween()
	tween.tween_property($Transition, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(1, 1, 1, 0))
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")

func show_chart(good_end: int, bad_end: int, timeout_end: int):
	# Let's create our @x values
	var x: Array = [good_end, bad_end, timeout_end]
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = ["Хорошая концовка", "Плохая концовка", "Не успели скрыть улики"]
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color("#ead4aa")
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.title = "Концовки игроков"
	cp.draw_grid_box = false
	cp.show_legend = true
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, Color.AQUAMARINE)
	gradient.set_color(1, Color.DEEP_PINK)
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Выбор", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		{
			gradient = gradient,
			type = Function.Type.PIE
		}
	)
	
	# Now let's plot our data
	chart.plot([f1], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)

func _on_complete_ep_pressed():
	close()
