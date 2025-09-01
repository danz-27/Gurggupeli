extends Sprite2D
@onready var rich_text_label = $CanvasLayer/RichTextLabel

var fade_duration = 1.0

func _ready():
   fade_in()

func fade_in():
   var tween = get_tree().create_tween()
   tween.tween_property(rich_text_label, "modulate:a", 0, fade_duration)
   tween.play()
   await tween.finished
   tween.kill()

func fade_out():
   var tween = get_tree().create_tween()
   tween.tween_property(rich_text_label, "modulate:a", 1, fade_duration)
   tween.play()
   await tween.finished
   tween.kill()
