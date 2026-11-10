import 'package:flutter/material.dart';
import '../models/url_item.dart';
import '../repositories/url_repository.dart';
import '../repositories/auth_repository.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/state_widgets.dart';
import '../widgets/filter_search_bar.dart';
import '../widgets/url_data_table.dart';
import '../widgets/url_mobile_list.dart';
import '../widgets/url_form_dialog.dart';
import '../widgets/url_details_dialog.dart';
import '../widgets/delete_confirmation_dialog.dart';

/// Primary Dashboard Screen managing URL statistics, filter state, and CRUD workflows.
class DashboardScreen extends StatefulWidget {
  final UrlRepository urlRepository;
  final AuthRepository authRepository;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.urlRepository,
    required this.authRepository,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UrlItem> _allUrls = [];
  bool _isLoading = true;
  String? _error;

  UrlEnvironment? _filterEnv;
  UrlStatus? _filterStatus;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUrls();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUrls() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = await widget.urlRepository.getUrls();
      setState(() => _allUrls = items);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<UrlItem> get _filteredUrls {
    return _allUrls.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesEnv = _filterEnv == null || item.environment == _filterEnv;
      final matchesStatus = _filterStatus == null || item.status == _filterStatus;

      return matchesQuery && matchesEnv && matchesStatus;
    }).toList();
  }

  void _showAddDialog() {
    UrlFormDialog.show(
      context: context,
      onSave: ({required name, required address, required description, required environment, required status}) async {
        await widget.urlRepository.addUrl(
          name: name,
          address: address,
          description: description,
          environment: environment,
          status: status,
        );
        _loadUrls();
        _showToast('URL successfully created');
      },
    );
  }

  void _showEditDialog(UrlItem item) {
    UrlFormDialog.show(
      context: context,
      item: item,
      onSave: ({required name, required address, required description, required environment, required status}) async {
        final updated = item.copyWith(
          name: name,
          address: address,
          description: description,
          environment: environment,
          status: status,
        );
        await widget.urlRepository.updateUrl(updated);
        _loadUrls();
        _showToast('URL updated successfully');
      },
    );
  }

  void _showDeleteDialog(UrlItem item) {
    DeleteConfirmationDialog.show(
      context: context,
      title: item.name,
      onConfirm: () async {
        await widget.urlRepository.deleteUrl(item.id);
        _loadUrls();
        _showToast('URL deleted');
      },
    );
  }

  Future<void> _toggleStatus(UrlItem item) async {
    try {
      await widget.urlRepository.toggleStatus(item.id);
      _loadUrls();
      _showToast('Status updated to ${item.status == UrlStatus.active ? 'Inactive' : 'Active'}');
    } catch (e) {
      _showToast('Failed to toggle status: $e', isError: true);
    }
  }

  void _showToast(String message, {bool isError = false}) {
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
    final int total = _allUrls.length;
    final int active = _allUrls.where((u) => u.status == UrlStatus.active).length;
    final int inactive = total - active;
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final filtered = _filteredUrls;

    return Scaffold(
      body: Column(
        children: [
          TopNavBar(
            isDarkMode: widget.isDarkMode,
            onToggleTheme: widget.onToggleTheme,
            onLogout: widget.onLogout,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? ErrorStateWidget(message: _error!, onRetry: _loadUrls)
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1320),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildStatsRow(total: total, active: active, inactive: inactive),
                                const SizedBox(height: 24),
                                FilterSearchBar(
                                  searchController: _searchController,
                                  selectedEnvironment: _filterEnv,
                                  selectedStatus: _filterStatus,
                                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                                  onEnvironmentChanged: (env) => setState(() => _filterEnv = env),
                                  onStatusChanged: (st) => setState(() => _filterStatus = st),
                                  onAddUrl: _showAddDialog,
                                ),
                                const SizedBox(height: 20),
                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: filtered.isEmpty
                                      ? EmptyStateWidget(
                                          title: 'No URLs Found',
                                          description: _searchQuery.isNotEmpty || _filterEnv != null || _filterStatus != null
                                              ? 'No streams match your filter parameters. Try clearing the search query or status.'
                                              : 'You have not added any stream URLs yet.',
                                          actionLabel: _searchQuery.isEmpty ? 'Add Your First URL' : null,
                                          onAction: _searchQuery.isEmpty ? _showAddDialog : null,
                                        )
                                      : isDesktop
                                          ? UrlDataTable(
                                              items: filtered,
                                              onDetails: (item) => UrlDetailsDialog.show(context, item),
                                              onEdit: _showEditDialog,
                                              onDelete: _showDeleteDialog,
                                              onToggleStatus: _toggleStatus,
                                            )
                                          : UrlMobileList(
                                              items: filtered,
                                              onDetails: (item) => UrlDetailsDialog.show(context, item),
                                              onEdit: _showEditDialog,
                                              onDelete: _showDeleteDialog,
                                              onToggleStatus: _toggleStatus,
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
        StatCard(
          title: 'Total URLs',
          value: total.toString(),
          icon: Icons.language_rounded,
          iconColor: const Color(0xFF6366F1),
          subtitle: 'All configured stream endpoints',
        ),
        StatCard(
          title: 'Active Streams',
          value: active.toString(),
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF10B981),
          subtitle: 'Currently routing live traffic',
        ),
        StatCard(
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

