import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/utils/header.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_form_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item_sheet_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/tambah_item_request_sheet.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/request_item_card.dart';

class RequestFormPage extends StatefulWidget {
  final DateTime? initialDate;
  final String? initialRequestText;
  final String pageTitle;
  final String submitLabel;
  final List<RequestItem>? initialItems;

  const RequestFormPage({
    super.key,
    this.initialDate,
    this.initialRequestText,
    this.pageTitle = 'Tambah Request',
    this.submitLabel = '+ Kirim Request',
    this.initialItems,
  });

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  final TextEditingController _deskripsiController = TextEditingController();

  late DateTime _selectedDate;

  final List<RequestItem> _items = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _deskripsiController.text = widget.initialRequestText ?? '';
    _items.clear();
    if (widget.initialItems != null) {
      _items.addAll(widget.initialItems!);
    }
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  double get _grandTotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _openItemSheet({RequestItem? item, int? index}) async {
    final result = await showModalBottomSheet<RequestItemSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TambahItemRequestSheet(
        initialItem: item,
        defaultName: item?.name ?? '',
      ),
    );

    if (result == null) return;

    setState(() {
      if (result.isDeleted && index != null) {
        _items.removeAt(index);
      } else if (result.item != null && index != null) {
        _items[index] = result.item!;
      } else if (result.item != null) {
        _items.add(result.item!);
      }
    });
  }

  void _submit() {
    if (_items.isEmpty) return;

    final mappedItems = _items.map((item) {
      return {
        "nama_item": item.name,
        "qty": item.quantity.toDouble(),
        "satuan": "pcs",
        "harga_satuan": item.unitPrice,
      };
    }).toList();

    Navigator.pop(
      context,
      ProjectRequestFormResult(
        requestDate: _selectedDate,
        requestText: _deskripsiController.text,
        items: mappedItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      body: SafeArea(
        child: Column(
          children: [
            TambahPengeluaranHeader(title: widget.pageTitle),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const FieldLabel('Tanggal Request'),
                    const SizedBox(height: 8),
                    DateField(
                      value: DateFormat(
                        'dd MMMM yyyy',
                        'id_ID',
                      ).format(_selectedDate),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Deskripsi'),
                    const SizedBox(height: 8),
                    NotesField(
                      controller: _deskripsiController,
                      hintText: 'Ketik Disini',
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Daftar Item'),
                    const SizedBox(height: 8),
                    if (_items.isEmpty)
                      const _EmptyState()
                    else
                      Column(
                        children: _items
                            .asMap()
                            .entries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),

                                child: RequestItemCard(
                                  item: entry.value,
                                  onTapEdit: () => _openItemSheet(
                                    item: entry.value,
                                    index: entry.key,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        formatCurrency(_grandTotal),
                        style: const TextStyle(
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
                          onPressed: () => _openItemSheet(),
                          icon: const Icon(Icons.add, color: Color(0xFFF7944D)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFF7944D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          label: const Text(
                            'Tambah Item',
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
                          onPressed: _items.isEmpty ? null : _submit,

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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 32),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        children: [
          Image.asset(
            'assets/images/no_material_background.png',
            height: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 14),
          const Text(
            'Belum Ada Item',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan pilih item untuk menambah request',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
