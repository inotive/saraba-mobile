import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_item_sheet_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/material_item_selected_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/tambah_item_baru_sheet.dart';

class MaterialItemPickerSheet extends StatefulWidget {
  final String? projectId;
  final List<MaterialExpenseItem> initialItems;

  const MaterialItemPickerSheet({
    super.key,
    required this.initialItems,
    this.projectId,
  });

  @override
  State<MaterialItemPickerSheet> createState() =>
      _MaterialItemPickerSheetState();
}

class _MaterialItemPickerSheetState extends State<MaterialItemPickerSheet> {
  final _searchController = TextEditingController();
  final _service = PekerjaanService();
  List<MaterialExpenseItem> _items = const [];
  bool _isLoadingItems = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    if (widget.projectId == null || widget.projectId!.isEmpty) {
      setState(() {
        _items = _mergeWithRabItems(widget.initialItems, const []);
        _isLoadingItems = false;
      });
      return;
    }

    final response = await _service.fetchProyekDetail(widget.projectId!);
    final rabItems = response?.data.rab.items ?? const <ProjectRabItem>[];

    if (!mounted) {
      return;
    }

    setState(() {
      _items = _mergeWithRabItems(widget.initialItems, rabItems);
      _isLoadingItems = false;
    });
  }

  List<MaterialExpenseItem> _mergeWithRabItems(
    List<MaterialExpenseItem> selected,
    List<ProjectRabItem> rabItems,
  ) {
    final mapped = <String, MaterialExpenseItem>{};

    void addItem(MaterialExpenseItem item) {
      mapped[_itemKey(item.name)] = item;
    }

    for (final item in _flattenRabItems(rabItems)) {
      addItem(MaterialExpenseItem(id: 'rab-${item.id}', name: item.uraian));
    }

    for (final item in selected) {
      addItem(item);
    }

    return mapped.values.toList();
  }

  List<ProjectRabItem> _flattenRabItems(List<ProjectRabItem> items) {
    final result = <ProjectRabItem>[];

    void visit(ProjectRabItem item) {
      final isMaterial = item.kategori.trim().toLowerCase() == 'material';
      final isLeafItem = item.tipe.trim().toLowerCase() == 'item';
      final hasName = item.uraian.trim().isNotEmpty;

      if (isMaterial && isLeafItem && hasName) {
        result.add(item);
      }

      for (final child in item.children) {
        visit(child);
      }
    }

    for (final item in items) {
      visit(item);
    }

    return result;
  }

  String _itemKey(String value) {
    return value.trim().toLowerCase();
  }

  List<MaterialExpenseItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _items;
    }

    return _items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<void> _openAddNewItemSheet() async {
    final result = await showModalBottomSheet<MaterialItemSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const TambahItemBaruSheet(),
    );

    if (result?.item == null) {
      return;
    }

    setState(() {
      _items = [..._items, result!.item!.copyWith(isSelected: true)];
    });
  }

  void _toggleItem(MaterialExpenseItem item, bool value) {
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(
                    isSelected: value,
                    quantity: value ? current.quantity.clamp(1, 9999) : 0,
                    total: value ? current.total : 0,
                  )
                : current,
          )
          .toList();
    });
  }

  void _updateQuantity(MaterialExpenseItem item, String rawValue) {
    final quantity = int.tryParse(rawValue) ?? 0;
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(quantity: quantity)
                : current,
          )
          .toList();
    });
  }

  void _updateTotal(MaterialExpenseItem item, String rawValue) {
    final total = parseCurrencyInput(rawValue);
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(total: total)
                : current,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = _items.where((item) => item.isSelected).toList();

    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pilih Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SearchTextField(
                controller: _searchController,
                hintText: 'Cari Item',
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoadingItems
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF7944D),
                        ),
                      )
                    : _filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada item material',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredItems.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return MaterialItemSelectionCard(
                            key: ValueKey(item.id),
                            item: item,
                            onChanged: (value) => _toggleItem(item, value),
                            onQuantityChanged: (value) =>
                                _updateQuantity(item, value),
                            onTotalChanged: (value) =>
                                _updateTotal(item, value),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openAddNewItemSheet,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF7944D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.add, color: Color(0xFFF7944D)),
                      label: const Text(
                        'Tambah Baru',
                        style: TextStyle(color: Color(0xFFF7944D)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedItems.isEmpty
                          ? null
                          : () => Navigator.pop(context, selectedItems),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7944D),
                        disabledBackgroundColor: const Color(0xFFFAD1B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(50),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}