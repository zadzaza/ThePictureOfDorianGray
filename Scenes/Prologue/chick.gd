extends StaticBody2D

#func _process(delta):
	#print($AnimatedSprite2D.get_animation())
#
#
#func _on_animated_sprite_2d_animation_finished():
	#if $AnimatedSprite2D.get_animation() == "cating":
		#$AnimatedSprite2D.set_animation("default")
#
#func default_looped():
	#if $AnimatedSprite2D.get_animation() == "default":
		#await get_tree().create_timer(6.0).timeout
		#$AnimatedSprite2D.set_animation("cating")
