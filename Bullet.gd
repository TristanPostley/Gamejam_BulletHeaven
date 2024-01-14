extends Node2D
func enemyHit(area: Area2D):
	var enemy = area.get_parent()
	enemy.dead = true
	enemy.get_node("AnimationPlayer").play("Death")
