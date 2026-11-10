import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/state_widget.dart';
import '../../auth/view/login_screen.dart';
import '../view_model/dashboard_view_model.dart';
import '../widgets/dashboard_stats_header_widget.dart';
import '../widgets/dashboard_table_section_widget.dart';
import '../widgets/filter_search_bar_widget.dart';
import '../widgets/top_nav_bar_widget.dart';
import '../widgets/url_form_dialog_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..loadUrls(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  void _showToast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Column(
        children: [
          TopNavBarWidget(
            isDarkMode: isDarkMode,
            onToggleTheme: () => context.read<ThemeProvider>().toggleTheme(),
            onLogout: () async {
              await AuthService().clearSession();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              }
            },
          ),
          Expanded(
            child: Consumer<DashboardViewModel>(
              builder: (context, vm, _) {
                if (vm.isLoading && vm.urls.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = vm.filteredUrls;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.spMin, vertical: 24.spMin),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1320.spMin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DashboardStatsHeaderWidget(
                            total: vm.totalUrls,
                            active: vm.activeUrls,
                            inactive: vm.inactiveUrls,
                          ),
                          SizedBox(height: 24.spMin),
                          FilterSearchBarWidget(
                            searchController: vm.searchController,
                            selectedEnvironment: vm.filterEnv,
                            selectedStatus: vm.filterStatus,
                            onSearchChanged: (v) => context.read<DashboardViewModel>().setSearchQuery(v),
                            onEnvironmentChanged: (env) => context.read<DashboardViewModel>().setFilterEnv(env),
                            onStatusChanged: (st) => context.read<DashboardViewModel>().setFilterStatus(st),
                            onAddUrl: () {
                              UrlFormDialogWidget.show(
                                context: context,
                                onSave: ({required name, required address, required description, required environment, required status}) async {
                                  await context.read<DashboardViewModel>().addUrl(
                                    name: name,
                                    address: address,
                                    description: description,
                                    environment: environment,
                                    status: status,
                                  );
                                  if (context.mounted) _showToast(context, 'URL successfully added');
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20.spMin),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: filtered.isEmpty
                                ? EmptyStateWidget(
                                    title: 'No URLs Found',
                                    description: vm.searchQuery.isNotEmpty || vm.filterEnv != null || vm.filterStatus != null
                                        ? 'No streams match your filter parameters. Try clearing the search query or status.'
                                        : 'You have not added any stream URLs yet.',
                                    actionLabel: vm.searchQuery.isEmpty ? 'Add Your First URL' : null,
                                    onAction: vm.searchQuery.isEmpty
                                        ? () {
                                            UrlFormDialogWidget.show(
                                              context: context,
                                              onSave: ({required name, required address, required description, required environment, required status}) async {
                                                await context.read<DashboardViewModel>().addUrl(
                                                  name: name,
                                                  address: address,
                                                  description: description,
                                                  environment: environment,
                                                  status: status,
                                                );
                                                if (context.mounted) _showToast(context, 'URL successfully added');
                                              },
                                            );
                                          }
                                        : null,
                                  )
                                : DashboardTableSectionWidget(
                                    items: filtered,
                                    isDesktop: isDesktop,
                                    onUpdate: (item) async {
                                      await context.read<DashboardViewModel>().updateUrl(item);
                                      if (context.mounted) _showToast(context, 'URL updated successfully');
                                    },
                                    onDelete: (id) async {
                                      await context.read<DashboardViewModel>().deleteUrl(id);
                                      if (context.mounted) _showToast(context, 'URL deleted');
                                    },
                                    onToggleStatus: (item) async {
                                      await context.read<DashboardViewModel>().toggleStatus(item.id);
                                      if (context.mounted) {
                                        _showToast(
                                          context,
                                          'Status updated to ${item.status.name == 'active' ? 'Inactive' : 'Active'}',
                                        );
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
