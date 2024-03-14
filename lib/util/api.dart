class Api {
  static const String baseUrl = 'http://3.109.185.125:80';

  // Category
  static const String getAllCategory = '$baseUrl/category';
  static const String getAllCategoryById = '$baseUrl/category/';
  static const String getCategoryByName = '$baseUrl/category/name/';
  static const String createCategory = '$baseUrl/category';
  static const String deleteCategory = '$baseUrl/category/';
  static const String updateCategory = '$baseUrl/category/';
}