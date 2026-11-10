import 'package:flutter/material.dart';
import '../models/url_item.dart';

/// Filter and search controls bar
class FilterSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final UrlEnvironment? selectedEnvironment;
  final UrlStatus? selectedStatus;
  final Function(String) onSearchChanged;
  final Function(UrlEnvironment?) onEnvironmentChanged;
  final Function(UrlStatus?) onStatusChanged;
  final VoidCallback onAddUrl;

  const FilterSearchBar({
    super.key,
    required this.searchController,
    required this.selectedEnvironment,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onEnvironmentChanged,
    required this.onStatusChanged,
    required this.onAddUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: isDesktop ? 320 : double.infinity,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by name, address or desc...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<UrlEnvironment?>(
                value: selectedEnvironment,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Environment'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Envs')),
                  ...UrlEnvironment.values.map((env) {
                    return DropdownMenuItem(value: env, child: Text(env.label));
                  }),
                ],
                onChanged: onEnvironmentChanged,
              ),
            ),
            SizedBox(
              width: 140,
              child: DropdownButtonFormField<UrlStatus?>(
                value: selectedStatus,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Status')),
                  ...UrlStatus.values.map((st) {
                    return DropdownMenuItem(value: st, child: Text(st.label));
                  }),
                ],
                onChanged: onStatusChanged,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAddUrl,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add URL'),
            ),
          ],
        ),
      ],
    );
  }
}

