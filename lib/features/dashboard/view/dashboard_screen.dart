import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/url_item_model.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/stat_card_widget.dart';
import '../../../widgets/state_widget.dart';
import '../../auth/view/login_screen.dart';
import '../view_model/dashboard_view_model.dart';
import '../widgets/filter_search_bar_widget.dart';
import '../widgets/top_nav_bar_widget.dart';
import '../widgets/url_data_table_widget.dart';
import '../widgets/url_details_dialog_widget.dart';
import '../widgets/url_form_dialog_widget.dart';
import '../widgets/url_mobile_list_widget.dart';
import '../widgets/delete_confirmation_dialog_widget.dart';

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
            onToggleTheme: () => context.read<ThemeProvider>().toggleTheme(context),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1320),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStatsRow(
                            total: vm.totalUrls,
                            active: vm.activeUrls,
                            inactive: vm.inactiveUrls,
                          ),
                          const SizedBox(height: 24),
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
                          const SizedBox(height: 20),
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
                                : isDesktop
                                    ? UrlDataTableWidget(
                                        items: filtered,
                                        onDetails: (item) => UrlDetailsDialogWidget.show(context, item),
                                        onEdit: (item) {
                                          UrlFormDialogWidget.show(
                                            context: context,
                                            item: item,
                                            onSave: ({required name, required address, required description, required environment, required status}) async {
                                              await context.read<DashboardViewModel>().updateUrl(
                                                item.copyWith(
                                                  name: name,
                                                  address: address,
                                                  description: description,
                                                  environment: environment,
                                                  status: status,
                                                ),
                                              );
                                              if (context.mounted) _showToast(context, 'URL updated successfully');
                                            },
                                          );
                                        },
                                        onDelete: (item) {
                                          DeleteConfirmationDialogWidget.show(
                                            context: context,
                                            title: item.name,
                                            onConfirm: () async {
                                              await context.read<DashboardViewModel>().deleteUrl(item.id);
                                              if (context.mounted) _showToast(context, 'URL deleted');
                                            },
                                          );
                                        },
                                        onToggleStatus: (item) async {
                                          await context.read<DashboardViewModel>().toggleStatus(item.id);
                                          if (context.mounted) {
                                            _showToast(
                                              context,
                                              'Status updated to ${item.status == UrlStatus.active ? 'Inactive' : 'Active'}',
                                            );
                                          }
                                        },
                                      )
                                    : UrlMobileListWidget(
                                        items: filtered,
                                        onDetails: (item) => UrlDetailsDialogWidget.show(context, item),
                                        onEdit: (item) {
                                          UrlFormDialogWidget.show(
                                            context: context,
                                            item: item,
                                            onSave: ({required name, required address, required description, required environment, required status}) async {
                                              await context.read<DashboardViewModel>().updateUrl(
                                                item.copyWith(
                                                  name: name,
                                                  address: address,
                                                  description: description,
                                                  environment: environment,
                                                  status: status,
                                                ),
                                              );
                                              if (context.mounted) _showToast(context, 'URL updated successfully');
                                            },
                                          );
                                        },
                                        onDelete: (item) {
                                          DeleteConfirmationDialogWidget.show(
                                            context: context,
                                            title: item.name,
                                            onConfirm: () async {
                                              await context.read<DashboardViewModel>().deleteUrl(item.id);
                                              if (context.mounted) _showToast(context, 'URL deleted');
                                            },
                                          );
                                        },
                                        onToggleStatus: (item) async {
                                          await context.read<DashboardViewModel>().toggleStatus(item.id);
                                          if (context.mounted) {
                                            _showToast(
                                              context,
                                              'Status updated to ${item.status == UrlStatus.active ? 'Inactive' : 'Active'}',
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

  Widget _buildStatsRow({required int total, required int active, required int inactive}) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 768;
      final stats = [
        StatCardWidget(
          title: 'Total URLs',
          value: total.toString(),
          icon: Icons.language_rounded,
          iconColor: const Color(0xFF6366F1),
          subtitle: 'All configured stream endpoints',
        ),
        StatCardWidget(
          title: 'Active Streams',
          value: active.toString(),
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF10B981),
          subtitle: 'Currently routing live traffic',
        ),
        StatCardWidget(
          title: 'Inactive / Paused',
          value: inactive.toString(),
          icon: Icons.pause_circle_outline_rounded,
          iconColor: const Color(0xFF94A3B8),
          subtitle: 'Disabled or standby streams',
        ),
      ];

      if (isWide) {
        return Row(
          children: stats.map((card) => Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: card,
          ))).toList(),
        );
      } else {
        return Column(
          children: stats.map((card) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: card,
          )).toList(),
        );
      }
    });
  }
}

