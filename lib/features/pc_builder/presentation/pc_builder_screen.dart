import 'package:flutter/material.dart';

import 'package:computology/features/pc_builder/data/pc_component.dart';
import 'package:computology/features/pc_builder/data/pc_component_data.dart';
import 'package:computology/features/pc_builder/logic/compatibility_service.dart';
import 'package:computology/features/pc_builder/presentation/compatibility_result_sheet.dart';

/// PC Builder screen that lets users select components, check compatibility,
/// and save a build.
class PCBuilderScreen extends StatefulWidget {
  const PCBuilderScreen({super.key});

  @override
  State<PCBuilderScreen> createState() => _PCBuilderScreenState();
}

class _PCBuilderScreenState extends State<PCBuilderScreen> {
  // Selected components
  PCComponent? selectedCPU;
  PCComponent? selectedMotherboard;
  PCComponent? selectedGPU;
  PCComponent? selectedRAM;
  PCComponent? selectedStorage;
  PCComponent? selectedPowerSupply;
  PCComponent? selectedCase;

  /// The most recent compatibility check result, if any.
  CompatibilityResult? _lastResult;

  final CompatibilityService _compatibilityService = CompatibilityService();

  // ---------------------------------------------------------------------------
  // Price & count helpers
  // ---------------------------------------------------------------------------

  /// Calculate total price of selected components.
  double _calculateTotalPrice() {
    double total = 0;
    if (selectedCPU != null) total += selectedCPU!.price;
    if (selectedMotherboard != null) total += selectedMotherboard!.price;
    if (selectedGPU != null) total += selectedGPU!.price;
    if (selectedRAM != null) total += selectedRAM!.price;
    if (selectedStorage != null) total += selectedStorage!.price;
    if (selectedPowerSupply != null) total += selectedPowerSupply!.price;
    if (selectedCase != null) total += selectedCase!.price;
    return total;
  }

  /// Count number of selected components.
  int _getComponentCount() {
    int count = 0;
    if (selectedCPU != null) count++;
    if (selectedMotherboard != null) count++;
    if (selectedGPU != null) count++;
    if (selectedRAM != null) count++;
    if (selectedStorage != null) count++;
    if (selectedPowerSupply != null) count++;
    if (selectedCase != null) count++;
    return count;
  }

  /// True when at least one component is selected.
  bool get _hasAnySelection => _getComponentCount() > 0;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Run compatibility checks and show the result bottom sheet.
  void _checkCompatibility() {
    final result = _compatibilityService.checkCompatibility(
      cpu: selectedCPU,
      motherboard: selectedMotherboard,
      gpu: selectedGPU,
      ram: selectedRAM,
      storage: selectedStorage,
      psu: selectedPowerSupply,
      pcCase: selectedCase,
    );

    setState(() => _lastResult = result);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CompatibilityResultSheet(result: result),
    );
  }

  /// Save the build (only allowed when the last check was compatible).
  void _savePCBuild() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PC Build Saved Successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Called whenever any dropdown changes — invalidate the last result so the
  /// user must re-check before saving.
  void _onSelectionChanged() {
    setState(() => _lastResult = null);
  }

  // ---------------------------------------------------------------------------
  // Widget builders
  // ---------------------------------------------------------------------------

  /// Build a dropdown selector card for a component category.
  Widget _buildComponentSelector(
    String label,
    IconData icon,
    List<PCComponent> components,
    PCComponent? selectedComponent,
    ValueChanged<PCComponent?> onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PCComponent>(
              initialValue: selectedComponent,
              hint: Text('Select $label'),
              items: components.map((component) {
                return DropdownMenuItem(
                  value: component,
                  child: Text('${component.name} — \$${component.price.toStringAsFixed(0)}'),
                );
              }).toList(),
              onChanged: (value) {
                onChanged(value);
                _onSelectionChanged();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build summary card showing selected components and pricing.
  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Build Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_lastResult != null)
                  _CompatibilityBadge(result: _lastResult!),
              ],
            ),
            const SizedBox(height: 12),
            _buildSummaryItem('Components', '${_getComponentCount()}/7'),
            if (selectedCPU != null)
              _buildSummaryItem('CPU', selectedCPU!.name),
            if (selectedMotherboard != null)
              _buildSummaryItem('Motherboard', selectedMotherboard!.name),
            if (selectedGPU != null)
              _buildSummaryItem('GPU', selectedGPU!.name),
            if (selectedRAM != null)
              _buildSummaryItem('RAM', selectedRAM!.name),
            if (selectedStorage != null)
              _buildSummaryItem('Storage', selectedStorage!.name),
            if (selectedPowerSupply != null)
              _buildSummaryItem('PSU', selectedPowerSupply!.name),
            if (selectedCase != null)
              _buildSummaryItem('Case', selectedCase!.name),
            const Divider(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual summary item row.
  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool canSave =
        _lastResult != null && _lastResult!.isCompatible;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Builder'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Build Your Perfect PC',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select components to customize your PC build',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Component selectors
          _buildComponentSelector(
            'CPU',
            Icons.memory,
            PCComponentData.cpus,
            selectedCPU,
            (value) => setState(() => selectedCPU = value),
          ),
          _buildComponentSelector(
            'Motherboard',
            Icons.developer_board,
            PCComponentData.motherboards,
            selectedMotherboard,
            (value) => setState(() => selectedMotherboard = value),
          ),
          _buildComponentSelector(
            'GPU',
            Icons.videogame_asset,
            PCComponentData.gpus,
            selectedGPU,
            (value) => setState(() => selectedGPU = value),
          ),
          _buildComponentSelector(
            'RAM',
            Icons.sd_storage,
            PCComponentData.rams,
            selectedRAM,
            (value) => setState(() => selectedRAM = value),
          ),
          _buildComponentSelector(
            'Storage',
            Icons.storage,
            PCComponentData.storages,
            selectedStorage,
            (value) => setState(() => selectedStorage = value),
          ),
          _buildComponentSelector(
            'Power Supply',
            Icons.power,
            PCComponentData.powerSupplies,
            selectedPowerSupply,
            (value) => setState(() => selectedPowerSupply = value),
          ),
          _buildComponentSelector(
            'Case',
            Icons.computer,
            PCComponentData.cases,
            selectedCase,
            (value) => setState(() => selectedCase = value),
          ),

          const SizedBox(height: 24),

          // Summary Card
          _buildSummaryCard(),

          const SizedBox(height: 16),

          // Check Compatibility Button
          FilledButton.tonalIcon(
            onPressed: _hasAnySelection ? _checkCompatibility : null,
            icon: const Icon(Icons.verified_user),
            label: const Text('Check Compatibility'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),

          // Build PC Button — disabled until compatibility passes
          ElevatedButton.icon(
            onPressed: canSave ? _savePCBuild : null,
            icon: const Icon(Icons.check),
            label: Text(
              canSave
                  ? 'Build PC'
                  : _lastResult == null
                      ? 'Build PC (Check Compatibility First)'
                      : 'Build PC (Fix Errors First)',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Small inline widgets
// -----------------------------------------------------------------------------

/// A compact badge showing the compatibility status in the summary card.
class _CompatibilityBadge extends StatelessWidget {
  const _CompatibilityBadge({required this.result});

  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final bool ok = result.isCompatible;
    final Color color = ok ? Colors.green : Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            ok ? 'Compatible' : 'Incompatible',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
