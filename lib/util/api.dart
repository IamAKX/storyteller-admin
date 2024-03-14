class Api {
  static const String baseUrl = 'http://3.109.185.125:80';

  // Category
  static const String getAllCategory = '$baseUrl/category';
  static const String getAllCategoryById = '$baseUrl/category/';
  static const String getCategoryByName = '$baseUrl/category/name/';
  static const String createCategory = '$baseUrl/category';
  static const String deleteCategory = '$baseUrl/category/';
  static const String updateCategory = '$baseUrl/category/';

  // Author
  static const String getAllAuthor = '$baseUrl/author';
  static const String getAuthorById = '$baseUrl/author/';
  static const String getAuthorByName = '$baseUrl/author/name/';
  static const String createAuthor = '$baseUrl/author';
  static const String deleteAuthor = '$baseUrl/author/';
  static const String updateAuthor = '$baseUrl/author/';

  // Subscription
  static const String getAllSubscription = '$baseUrl/subscription';
  static const String getSubscriptionById = '$baseUrl/subscription/';
  static const String getSubscriptionByName = '$baseUrl/subscription/name/';
  static const String createSubscription = '$baseUrl/subscription';
  static const String deleteSubscription = '$baseUrl/subscription/';
  static const String updateSubscription = '$baseUrl/subscription/';
}
