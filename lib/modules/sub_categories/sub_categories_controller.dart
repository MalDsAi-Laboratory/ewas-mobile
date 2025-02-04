import 'package:get/get.dart';
import 'package:simple_ui/models/category_model.dart';

class SubCategoriesController extends GetxController {
  var allCategories = <Category>[].obs;
  Category? selectedSubCategory;
  void _fetchSubCategories() {
    // Simulating API call (replace with real backend call)
    allCategories.assignAll([
      Category(
          title: 'Lithium Ion battery',
          imageUrl:
              'https://4.imimg.com/data4/DN/KH/MY-2743443/amaron-four-wheeler-batteries-1000x1000.png'),
      Category(
          title: 'Nickle-Cadmium battery',
          imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
      Category(
          title: 'Nickle-Cadmium battery',
          imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
      Category(
          title: 'Nickle-Cadmium battery',
          imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
      Category(
          title: 'Nickle-Cadmium battery',
          imageUrl: 'https://m.media-amazon.com/images/I/61VC7cZXyCL.jpg'),
    ]);
  }

  setSelectedSubCategory(selectedCategory) {
    selectedSubCategory = selectedCategory;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchSubCategories();
  }
}
