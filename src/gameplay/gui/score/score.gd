extends Control


var score = 0


func _ready():
	set_score(0)


func increase_score(score_delta):
	set_score(score + score_delta)


func set_score(score):
	self.score = score
	$margin_container/center_container/label.text = "Drilled layers: " + str(score)

