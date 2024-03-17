extends Particles2D

func _process(delta):
	var alpha = get_self_modulate().a
	alpha -= 0.007
	set_self_modulate(Color(1,1,1,alpha))
	if (get_self_modulate().a <= 0):
		queue_free()
