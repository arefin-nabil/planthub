class Article {
  final String id;
  final String title;
  final String titleBn;
  final String imageUrl;
  final String category;
  final String author;
  final String readTime;
  final DateTime date;
  final int views;

  const Article({
    required this.id,
    required this.title,
    required this.titleBn,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.readTime,
    required this.date,
    required this.views,
  });
}

/// Backwards compatibility alias
typedef MockArticle = Article;
