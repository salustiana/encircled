extends CanvasLayer

func update_score(score: int) -> void:
	$score_label.text = str(score)
