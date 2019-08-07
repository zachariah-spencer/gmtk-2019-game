extends Area2D

func _process(delta):
	if not $WitherTimer.is_stopped() :
		$Sprite.modulate.a = $WitherTimer.time_left/$WitherTimer.wait_time

func _on_Vines_body_entered(body):
	var p = body as Player

	if p:
		p._set_state(p.states.climb)

func _on_Vines_body_exited(body):
	var p = body as Player

	if p:
		p._set_state(p.states.fall)

func hit(by : Node2D, damage : float, type : int, knockback : Vector2):
	if type == Damage.fire :
		wither()

func wither():
	##play a wither anim
	$WitherTimer.start()
