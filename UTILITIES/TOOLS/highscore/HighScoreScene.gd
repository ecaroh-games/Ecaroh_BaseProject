extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LabelScore.text = str(ScoreSaver.score)
	$LabelHighscore.text = str(ScoreSaver.highscore)
	$RichTextLabelLeaderboard.text = LeaderboardLootLocker.leaderboardFormatted

func _on_button_upload_pressed():
	ScoreSaver.save()
	LeaderboardLootLocker.upload_score(ScoreSaver.score)
	pass # Replace with function body.

func _on_button_change_name_pressed():
	ScoreSaver.save_name($InputName.text)
	LeaderboardLootLocker.change_player_name($InputName.text)
	_start_loading_animation()
	pass # Replace with function body.

func _on_button_refresh_pressed():
	LeaderboardLootLocker.get_leaderboards()
	pass # Replace with function body.

func _on_button_subtract_pressed():
	ScoreSaver.add_points(-1)
	pass # Replace with function body.

func _on_button_add_pressed():
	ScoreSaver.add_points(1)
	pass # Replace with function body.

func _start_loading_animation() -> void:
	ScoreSaver.save()
	$RefreshTimer.start()
	$RefreshTimer/AnimationPlayer.play("loading")
	
func _on_refresh_timer_timeout():
	LeaderboardLootLocker.get_leaderboards()
	pass # Replace with function body.

