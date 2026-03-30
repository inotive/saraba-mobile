import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

enum PengeluaranCategory { operasional, material, pettyCash }

extension PengeluaranCategoryX on PengeluaranCategory {
  String get label {
    switch (this) {
      case PengeluaranCategory.operasional:
        return 'Operasional';
      case PengeluaranCategory.material:
        return 'Material';
      case PengeluaranCategory.pettyCash:
        return 'Petty Cash';
    }
  }

  IconData get icon {
    switch (this) {
      case PengeluaranCategory.operasional:
        return Icons.business_center_outlined;
      case PengeluaranCategory.material:
        return Icons.layers_outlined;
      case PengeluaranCategory.pettyCash:
        return Icons.perm_media_outlined;
    }
  }
}

class PengeluaranCategorySheet extends StatelessWidget {
  const PengeluaranCategorySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Kategori Pengeluaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...PengeluaranCategory.values.map(
              (category) => _CategoryOptionTile(category: category),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryOptionTile extends StatelessWidget {
  final PengeluaranCategory category;

  const _CategoryOptionTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pop(context, category),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                category.icon,
                color: const Color(0xFF5D93E8),
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              category.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialExpenseItem {
  final String id;
  final String name;
  final int quantity;
  final double total;
  final bool isSelected;
  final bool isCustom;

  const MaterialExpenseItem({
    required this.id,
    required this.name,
    this.quantity = 0,
    this.total = 0,
    this.isSelected = false,
    this.isCustom = false,
  });

  MaterialExpenseItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? total,
    bool? isSelected,
    bool? isCustom,
  }) {
    return MaterialExpenseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      isSelected: isSelected ?? this.isSelected,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class TambahPengeluaranPage extends StatefulWidget {
  final PengeluaranCategory category;

  const TambahPengeluaranPage({super.key, required this.category});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final _catatanController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];
  late DateTime _selectedDate;
  List<MaterialExpenseItem> _selectedItems = const [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  double get _grandTotal {
    return _selectedItems.fold(0, (sum, item) => sum + item.total);
  }

  Future<void> _pickImages() async {
    final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);
    if (!mounted || pickedImages.isEmpty) {
      return;
    }

    setState(() {
      _selectedImages.addAll(pickedImages.take(5 - _selectedImages.length));
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _openItemPicker() async {
    final result = await showModalBottomSheet<List<MaterialExpenseItem>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => MaterialItemPickerSheet(initialItems: _selectedItems),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _selectedItems = result;
    });
  }

  void _saveMaterialFlow() {
    if (_selectedItems.isEmpty) {
      return;
    }

    Navigator.pop(context, 'Kamu berhasil menambahkan pengeluaran baru');
  }

  @override
  Widget build(BuildContext context) {
    final isMaterial = widget.category == PengeluaranCategory.material;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const _TambahPengeluaranHeader(),
            Expanded(
              child: isMaterial
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengeluaran ${widget.category.label}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Masukkan Tanggal'),
                          const SizedBox(height: 8),
                          _DateField(
                            value: DateFormat(
                              'dd MMMM yyyy',
                              'id_ID',
                            ).format(_selectedDate),
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Catatan'),
                          const SizedBox(height: 8),
                          _NotesField(
                            controller: _catatanController,
                            hintText: 'Ketik Disini',
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Lampiran'),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 92,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _UploadBox(onTap: _pickImages),
                                ..._selectedImages.map(
                                  (image) => Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(image.path),
                                        width: 92,
                                        height: 92,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Item Material'),
                          const SizedBox(height: 8),
                          if (_selectedItems.isEmpty)
                            const _EmptyMaterialState()
                          else
                            Column(
                              children: _selectedItems
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: SelectedMaterialItemCard(
                                        item: item,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Kategori ${widget.category.label} akan menyusul.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F3F5))),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatCurrency(_grandTotal),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF7944D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _openItemPicker,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFF7944D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          icon: const Icon(Icons.add, color: Color(0xFFF7944D)),
                          label: const Text(
                            'Pilih Item',
                            style: TextStyle(
                              color: Color(0xFFF7944D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedItems.isEmpty
                              ? null
                              : _saveMaterialFlow,
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
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialItemPickerSheet extends StatefulWidget {
  final List<MaterialExpenseItem> initialItems;

  const MaterialItemPickerSheet({super.key, required this.initialItems});

  @override
  State<MaterialItemPickerSheet> createState() =>
      _MaterialItemPickerSheetState();
}

class _MaterialItemPickerSheetState extends State<MaterialItemPickerSheet> {
  final _searchController = TextEditingController();
  late List<MaterialExpenseItem> _items;

  @override
  void initState() {
    super.initState();
    _items = _mergeWithDefaults(widget.initialItems);
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MaterialExpenseItem> _mergeWithDefaults(
    List<MaterialExpenseItem> selected,
  ) {
    final defaults = [
      const MaterialExpenseItem(id: 'item-1', name: 'Item 1'),
      const MaterialExpenseItem(id: 'item-2', name: 'Item 2'),
      const MaterialExpenseItem(id: 'item-3', name: 'Item 3'),
      const MaterialExpenseItem(id: 'item-4', name: 'Item 4'),
    ];

    final mapped = <String, MaterialExpenseItem>{
      for (final item in defaults) item.id: item,
      for (final item in selected) item.id: item,
    };

    return mapped.values.toList();
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
    final result = await showModalBottomSheet<MaterialExpenseItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const TambahItemBaruSheet(),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _items = [..._items, result.copyWith(isSelected: true)];
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
    final sanitized = rawValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final total = double.tryParse(sanitized) ?? 0;
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
              _SearchTextField(
                controller: _searchController,
                hintText: 'Cari Item',
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
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
                      onTotalChanged: (value) => _updateTotal(item, value),
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

class TambahItemBaruSheet extends StatefulWidget {
  const TambahItemBaruSheet({super.key});

  @override
  State<TambahItemBaruSheet> createState() => _TambahItemBaruSheetState();
}

class _TambahItemBaruSheetState extends State<TambahItemBaruSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _totalController = TextEditingController();

  bool get _canSave {
    return _nameController.text.trim().isNotEmpty &&
        (int.tryParse(_quantityController.text.trim()) ?? 0) > 0 &&
        (double.tryParse(_totalController.text.trim().replaceAll(',', '')) ??
                0) >
            0;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _quantityController.addListener(() => setState(() {}));
    _totalController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final item = MaterialExpenseItem(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      total:
          double.tryParse(_totalController.text.trim().replaceAll(',', '')) ??
          0,
      isSelected: true,
      isCustom: true,
    );
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          18,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                const Expanded(
                  child: Text(
                    'Tambah Item Baru',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _FieldLabel('Nama Item'),
            const SizedBox(height: 8),
            _SearchTextField(
              controller: _nameController,
              hintText: 'Cari Item',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Kuantitas'),
                      const SizedBox(height: 8),
                      _CompactTextField(
                        controller: _quantityController,
                        hintText: '0',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Total'),
                      const SizedBox(height: 8),
                      _CompactTextField(
                        controller: _totalController,
                        hintText: 'Rp',
                        prefixText: 'Rp ',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave ? _saveItem : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7944D),
                  disabledBackgroundColor: const Color(0xFFFAD1B7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }
}

class SelectedMaterialItemCard extends StatelessWidget {
  final MaterialExpenseItem item;

  const SelectedMaterialItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6FF),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: Color(0xFF5D93E8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Material',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MetaColumn(
                        label: 'Jumlah',
                        value: item.quantity.toString(),
                      ),
                    ),
                    Expanded(
                      child: _MetaColumn(
                        label: 'Total',
                        value: _formatCurrency(item.total),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaColumn extends StatelessWidget {
  final String label;
  final String value;

  const _MetaColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

class MaterialItemSelectionCard extends StatefulWidget {
  final MaterialExpenseItem item;
  final ValueChanged<bool> onChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onTotalChanged;

  const MaterialItemSelectionCard({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onQuantityChanged,
    required this.onTotalChanged,
  });

  @override
  State<MaterialItemSelectionCard> createState() =>
      _MaterialItemSelectionCardState();
}

class _MaterialItemSelectionCardState extends State<MaterialItemSelectionCard> {
  late final TextEditingController _quantityController;
  late final TextEditingController _totalController;
  late final FocusNode _quantityFocusNode;
  late final FocusNode _totalFocusNode;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity == 0 ? '' : widget.item.quantity.toString(),
    );
    _totalController = TextEditingController(
      text: widget.item.total == 0 ? '' : widget.item.total.toStringAsFixed(0),
    );
    _quantityFocusNode = FocusNode();
    _totalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant MaterialItemSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextQuantity = widget.item.quantity == 0
        ? ''
        : widget.item.quantity.toString();
    final nextTotal = widget.item.total == 0
        ? ''
        : widget.item.total.toStringAsFixed(0);

    if (!_quantityFocusNode.hasFocus &&
        _quantityController.text != nextQuantity) {
      _quantityController.text = nextQuantity;
    }

    if (!_totalFocusNode.hasFocus && _totalController.text != nextTotal) {
      _totalController.text = nextTotal;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _totalController.dispose();
    _quantityFocusNode.dispose();
    _totalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.item.isSelected ? const Color(0xFFFFF1E8) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.item.isSelected
              ? const Color(0xFFF7944D)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: widget.item.isSelected,
                onChanged: (value) => widget.onChanged(value ?? false),
                activeColor: const Color(0xFFF7944D),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Kuantitas'),
                    const SizedBox(height: 6),
                    _CompactTextField(
                      controller: _quantityController,
                      focusNode: _quantityFocusNode,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      enabled: widget.item.isSelected,
                      onChanged: widget.onQuantityChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Total'),
                    const SizedBox(height: 6),
                    _CompactTextField(
                      controller: _totalController,
                      focusNode: _totalFocusNode,
                      hintText: 'Rp',
                      prefixText: 'Rp ',
                      keyboardType: TextInputType.number,
                      enabled: widget.item.isSelected,
                      onChanged: widget.onTotalChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TambahPengeluaranHeader extends StatelessWidget {
  const _TambahPengeluaranHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          const Expanded(
            child: Text(
              'Tambah Pengeluaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F1F1F),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _DateField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: value,
        hintStyle: const TextStyle(color: Color(0xFF1F1F1F), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          color: Color(0xFF9CA3AF),
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _NotesField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _SearchTextField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _CompactTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final String? prefixText;
  final TextInputType keyboardType;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const _CompactTextField({
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.prefixText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: Color(0xFF1F1F1F),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF5D93E8),
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, color: Color(0xFF2563EB), size: 28),
            SizedBox(height: 8),
            Text(
              'Upload',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMaterialState extends StatelessWidget {
  const _EmptyMaterialState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_material_background.png',
            height: 56,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Material',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan pilih item untuk menambah material',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(value);
}
