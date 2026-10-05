import '../../../data/mock/mock_data.dart';
import '../models/article_model.dart';

/// Handles Plant care guides & knowledge hub articles
class ArticleApi {
  Future<List<Article>> getArticles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(MockData.articles);
  }

  Future<Article?> getArticleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return MockData.articles.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
