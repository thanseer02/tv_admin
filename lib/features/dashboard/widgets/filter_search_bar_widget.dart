import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/url_item_model.dart';
import '../../../utils/styles.dart';

class FilterSearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final UrlEnvironment? selectedEnvironment;
  final UrlStatus? selectedStatus;
  final Function(String) onSearchChanged;
  final Function(UrlEnvironment?) onEnvironmentChanged;
  final Function(UrlStatus?) onStatusChanged;
  final VoidCallback onAddUrl;

  const FilterSearchBarWidget({
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
      spacing: 12.spMin,
      runSpacing: 12.spMin,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: isDesktop ? 320.spMin : double.infinity,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: tsS14W400,
            decoration: InputDecoration(
              hintText: 'Search by name, address or desc...',
              hintStyle: tsS14W400.copyWith(color: Colors.grey),
              prefixIcon: Icon(Icons.search, size: 20.spMin),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 18.spMin),
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
          spacing: 12.spMin,
          runSpacing: 12.spMin,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 160.spMin,
              child: DropdownButtonFormField<UrlEnvironment?>(
                initialValue: selectedEnvironment,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Environment'),
                items: [
                  DropdownMenuItem(value: null, child: Text('All Envs', style: tsS14W400)),
                  ...UrlEnvironment.values.map((env) {
                    return DropdownMenuItem(value: env, child: Text(env.label, style: tsS14W400));
                  }),
                ],
                onChanged: onEnvironmentChanged,
              ),
            ),
            SizedBox(
              width: 140.spMin,
              child: DropdownButtonFormField<UrlStatus?>(
                initialValue: selectedStatus,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(value: null, child: Text('All Status', style: tsS14W400)),
                  ...UrlStatus.values.map((st) {
                    return DropdownMenuItem(value: st, child: Text(st.label, style: tsS14W400));
                  }),
                ],
                onChanged: onStatusChanged,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAddUrl,
              icon: Icon(Icons.add, size: 18.spMin),
              label: Text('Add URL', style: tsS14W600.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}
