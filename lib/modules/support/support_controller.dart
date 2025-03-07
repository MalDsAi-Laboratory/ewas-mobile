import 'package:get/get.dart';
import 'package:simple_ui/models/query_model.dart';

class UserQueryController extends GetxController {
  var isLoading = false.obs;
  var queries = <UserQueryModel>[].obs;
  var paginatedQueries = <UserQueryModel>[].obs;
  var currentPage = 0.obs;
  var itemsPerPage = 5;

  bool get hasNextPage =>
      (currentPage.value + 1) * itemsPerPage < queries.length;
  bool get hasPrevPage => currentPage.value > 0;
  int get totalPages => (queries.length / itemsPerPage).ceil();

  Future<void> fetchQueries() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1), () {
      queries.value = [
        UserQueryModel(
            userName: "John Doe",
            query: "How to reset password?",
            status: "Resolved"),
        UserQueryModel(
            userName: "Alice Smith",
            query: "App crashing on startup",
            status: "Pending"),
        UserQueryModel(
            userName: "Bob Johnson",
            query: "Where can I find settings?",
            status: "In Progress"),
      ];
      updatePagination();
      isLoading.value = false;
    });
  }

  void updatePagination() {
    int start = currentPage.value * itemsPerPage;
    int end = start + itemsPerPage;
    paginatedQueries.value =
        queries.sublist(start, end > queries.length ? queries.length : end);
  }

  void nextPage() {
    if (hasNextPage) {
      currentPage.value++;
      updatePagination();
    }
  }

  void prevPage() {
    if (hasPrevPage) {
      currentPage.value--;
      updatePagination();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchQueries();
  }
}
