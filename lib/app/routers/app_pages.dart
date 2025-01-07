import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/history/bindings/history_binding.dart';
import 'package:xengistic_app/app/modules/history/views/history_view.dart';
import 'package:xengistic_app/app/modules/home/bindings/home_binding.dart';
import 'package:xengistic_app/app/modules/home/views/home_view.dart';
import 'package:xengistic_app/app/modules/job_details/bindings/job_detail_binding.dart';
import 'package:xengistic_app/app/modules/job_details/views/job_detail_view.dart';
import 'package:xengistic_app/app/modules/jobs/bindings/jobs_binding.dart';
import 'package:xengistic_app/app/modules/jobs/views/jobs_view.dart';
import 'package:xengistic_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:xengistic_app/app/modules/profile/views/profile_view.dart';
import 'package:xengistic_app/app/modules/root/bindings/root_binding.dart';
import 'package:xengistic_app/app/modules/root/views/root_view.dart';
import 'package:xengistic_app/app/modules/settings/bindings/setting_binding.dart';
import 'package:xengistic_app/app/modules/settings/views/setting_view.dart';
import 'package:xengistic_app/app/modules/signin/bindings/signin_binding.dart';
import 'package:xengistic_app/app/modules/signin/views/signin_view.dart';
import 'package:xengistic_app/layouts/main_layout.dart';
import 'package:xengistic_app/middlewares/authorize_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: '/',
      page: () => const RootView(),
      bindings: [RootBinding()],
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          name: _Paths.signin,
          page: () => SignInView(),
          bindings: [
            SignInBinding(),
          ],
        ),
        GetPage(
          name: _Paths.home,
          preventDuplicates: true,
          page: () => const MainLayout(
            childOutlet: HomeView(),
          ),
          middlewares: [
            EnsureAuthMiddleware(),
          ],
          bindings: [
            HomeBinding(),
          ],
        ),
        GetPage(
          name: _Paths.jobs,
          page: () => const MainLayout(
            childOutlet: JobsView(),
          ),
          middlewares: [
            EnsureAuthMiddleware(),
          ],
          bindings: [
            JobsBinding(),
          ],
          children: [
            GetPage(
              name: _Paths.jobDetails,
              page: () => const MainLayout(
                childOutlet: JobDetailView(),
              ),
              bindings: [
                JobDetailViewBinding(),
              ],
              middlewares: [
                EnsureAuthMiddleware(),
              ],
            ),
          ],
        ),
        GetPage(
          name: _Paths.history,
          page: () => const MainLayout(
            childOutlet: HistoryView(),
          ),
          bindings: [
            HistoryBinding(),
          ],
          middlewares: [
            EnsureAuthMiddleware(),
          ],
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: _Paths.settings,
          page: () => const MainLayout(
            childOutlet: SettingView(),
          ),
          bindings: [SettingBinding()],
          middlewares: [
            EnsureAuthMiddleware(),
          ],
        ),
        GetPage(
          name: _Paths.profile,
          page: () => const MainLayout(
            childOutlet: ProfileView(),
          ),
          bindings: [ProfileBinding()],
          middlewares: [
            EnsureAuthMiddleware(),
          ],
        ),
      ],
    ),
  ];
}
