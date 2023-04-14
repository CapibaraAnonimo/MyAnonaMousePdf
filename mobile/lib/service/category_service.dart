import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_api/src/models/bookCategory.dart';
import 'package:myanonamousepdf_repository/src/category_repository.dart';

abstract class CategoryService {
  Future<List<BookCategory>> getCategories();
}

class JwtCategoryService extends CategoryService {
  final CategoryRepository _categoryRepository = CategoryRepository();
  final box = GetStorage();

  JwtCategoryService() {}

  @override
  Future<List<BookCategory>> getCategories() async {
    String? jsonList = box.read("cateogries");

    if (jsonList != null) {
      return (jsonList as List).map((e) => BookCategory.fromJson(e)).toList();
    } else {
      return _categoryRepository.getCategories();
    }
  }
}
