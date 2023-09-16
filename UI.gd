extends CanvasLayer

@onready var health_bar = $UI/HealthBar
@onready var player = get_node("../Player")
@onready var timer_label = $UI/TimerLabel

var timer_start_time

func _ready():
    timer_start_time = Time.get_ticks_msec()/1000
    player.connect("health_changed", _on_Player_health_changed)
    health_bar.max_value = player.max_hp
    health_bar.value = player.hp
    _on_Player_health_changed(player.hp, player.max_hp)  # Set the initial color

func _process(delta):
    var elapsed_time = Time.get_ticks_msec()/1000 - timer_start_time
    var minutes = floor(elapsed_time / 60)
    var seconds = elapsed_time % 60
    timer_label.text = "%02d:%02d" % [minutes, seconds]



func _on_Player_health_changed(new_health, max_health):
    health_bar.min_value = 0
    health_bar.max_value = max_health
    health_bar.value = new_health
    
    var health_percentage : float = float(new_health) / max_health * 100.0

    
    print(health_percentage)

    if health_percentage > 70:
       var sb = StyleBoxFlat.new()
       sb.bg_color = Color("00FF00")  # Dark Green
       health_bar.add_theme_stylebox_override("fill", sb)
    elif health_percentage > 40:
        var sb = StyleBoxFlat.new()
        sb.bg_color = Color("008000")  # Light Green
        health_bar.add_theme_stylebox_override("fill", sb)
    elif health_percentage > 10:
        var sb = StyleBoxFlat.new()
        sb.bg_color = Color("FFFF00")  # Yellow
        health_bar.add_theme_stylebox_override("fill", sb)
    else:
        var sb = StyleBoxFlat.new()
        sb.bg_color = Color("FF0000")  # Red
        health_bar.add_theme_stylebox_override("fill", sb)


