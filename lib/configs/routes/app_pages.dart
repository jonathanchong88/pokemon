import 'package:get/get.dart';

import '../../views/view.dart';
import 'app_routes.dart';

class Routes {
  static List<GetPage> getRoutes() {
    return [
      GetPage<HomePage>(
        name: AppRoutes.HOME,
        binding: HomeBinding(),
        page: () => const HomePage(),
        preventDuplicates: true,
      ),
      GetPage<DetailPage>(
        name: AppRoutes.DETAIL,
        binding: DetailBinding(),
        page: () => DetailPage(),
        preventDuplicates: true,
      ),
    ];
  }
}
