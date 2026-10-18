extends Node2D


@onready var score_container = $Offset/ScoreContainer
@onready var score_label = $Offset/ScoreContainer/ScoreLabel
@onready var news_label = $Offset/NewsLabel

var _tween: Tween

var news: Array[NewsItem]

func _ready() -> void:
	#show_news("")
	news = list_news()

func show_news(text: String):
	if _tween != null:
		_tween.stop()
	
	news_label.text = text
	news_label.update_minimum_size()
	
	var news_length = news_label.get_combined_minimum_size().x / 50.0
	
	news_label.offset_transform_position = Vector2(0, 24)
	score_label.offset_transform_position = Vector2.ZERO
	
	_tween = create_tween()
	_tween.tween_property(score_container, "offset_transform_position", Vector2(0, -24), 0.8)
	_tween.parallel().tween_property(news_label, "offset_transform_position", Vector2.ZERO, 0.8)
	_tween.tween_property(news_label, "offset_transform_position", Vector2(-news_label.get_combined_minimum_size().x, 0), news_length).set_delay(1.0)
	_tween.tween_property(score_container, "offset_transform_position", Vector2.ZERO, 0.8).set_delay(0.0)
	_tween.parallel().tween_property(news_label, "offset_transform_position", Vector2(0, 48), 0.8).as_relative()
	_tween.play()

class NewsItem:
	var threshold: int
	var text: String
	var down: bool
	
	func _init(down: bool, threshold: int, text: String) -> void:
		self.down = down
		self.threshold = threshold
		self.text = text

func list_news():
	var result: Array[NewsItem]
	result = [
		NewsItem.new(false, 0, "NEWS: Local DVD rental store opens!"),
		NewsItem.new(false, 750, "NEWS: Local store looking to expand soon!"),
		NewsItem.new(false, 1050, "NEWS: Grand opening of second location!"),
		NewsItem.new(false, 2500, "NEWS: DVD Rental Company 'BBI' opens 3 more stores!"),
		NewsItem.new(false, 4500, "NEWS: BBI Video Rental stock is surging"),
		NewsItem.new(false, 6000, "NEWS: BBI opens 25 more stores across the nation"),
		NewsItem.new(false, 9000, "NEWS: Analysts say 'BBI' is hottest stock of the decade"),
		NewsItem.new(false, 13500, "NEWS: New service announced 'MetBlix' movies available on your computer?"),
		NewsItem.new(false, 15000, "NEWS: MetBlix goes public!"),
		NewsItem.new(true, 1, "NEWS: TEST LOSING MONEY"),
	]
	return result

func _physics_process(delta: float) -> void:
	if not news.is_empty():
		var next = news.front()
		if (not next.down and ScoreManager.score >= next.threshold) or (next.down and ScoreManager.score <= next.threshold):
			news.pop_front()
			show_news(next.text)
