extends Projectile

var boss
var player

func _ready():
	boss = Global.boss
	player = Global.player

func _move(delta : float ):
	if player.position.distance_to(boss.position) <= 8:
		var dir = (boss.global_position - global_position).normalized()
		position += delta*speed*dir
	else:
		position += speed*direction*delta