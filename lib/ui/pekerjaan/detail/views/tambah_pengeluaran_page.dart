import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_state.dart';

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

  String get iconAsset {
    switch (this) {
      case PengeluaranCategory.operasional:
        return 'assets/icons/ic_pengeluaran_operasional.png';
      case PengeluaranCategory.material:
        return 'assets/icons/ic_pengeluaran_material.png';
      case PengeluaranCategory.pettyCash:
        return 'assets/icons/ic_pengeluaran_petty_cash.png';
    }
  }

  String get categorySheetIconAsset {
    switch (this) {
      case PengeluaranCategory.operasional:
        return 'assets/icons/ic_kategori_operasional.png';
      case PengeluaranCategory.material:
        return 'assets/icons/ic_kategori_material.png';
      case PengeluaranCategory.pettyCash:
        return 'assets/icons/ic_kategori_petty_cash.png';
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
            SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Image.asset(
                  category.categorySheetIconAsset,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
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

class MaterialItemSheetResult {
  final MaterialExpenseItem? item;
  final bool isDeleted;

  const MaterialItemSheetResult._({this.item, required this.isDeleted});

  factory MaterialItemSheetResult.saved(MaterialExpenseItem item) {
    return MaterialItemSheetResult._(item: item, isDeleted: false);
  }

  factory MaterialItemSheetResult.deleted() {
    return const MaterialItemSheetResult._(isDeleted: true);
  }
}

class MaterialAttachmentItem {
  final String path;
  final bool isFile;
  final bool isNetwork;

  const MaterialAttachmentItem({
    required this.path,
    required this.isFile,
    this.isNetwork = false,
  });

  factory MaterialAttachmentItem.file(String path) {
    return MaterialAttachmentItem(path: path, isFile: true);
  }

  factory MaterialAttachmentItem.asset(String path) {
    return MaterialAttachmentItem(path: path, isFile: false);
  }

  factory MaterialAttachmentItem.network(String path) {
    return MaterialAttachmentItem(path: path, isFile: false, isNetwork: true);
  }
}

class OperasionalExpenseItem {
  final String id;
  final String name;
  final double amount;
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final bool isSelected;
  final bool isCustom;

  const OperasionalExpenseItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.note,
    required this.attachments,
    this.isSelected = false,
    this.isCustom = false,
  });

  OperasionalExpenseItem copyWith({
    String? id,
    String? name,
    double? amount,
    String? note,
    List<MaterialAttachmentItem>? attachments,
    bool? isSelected,
    bool? isCustom,
  }) {
    return OperasionalExpenseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      attachments: attachments ?? this.attachments,
      isSelected: isSelected ?? this.isSelected,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class OperasionalItemSheetResult {
  final OperasionalExpenseItem? item;
  final bool isDeleted;

  const OperasionalItemSheetResult._({this.item, required this.isDeleted});

  factory OperasionalItemSheetResult.saved(OperasionalExpenseItem item) {
    return OperasionalItemSheetResult._(item: item, isDeleted: false);
  }

  factory OperasionalItemSheetResult.deleted() {
    return const OperasionalItemSheetResult._(isDeleted: true);
  }
}

class MaterialPengeluaranDraft {
  final String materialCode;
  final DateTime date;
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final List<MaterialExpenseItem> items;

  const MaterialPengeluaranDraft({
    required this.materialCode,
    required this.date,
    required this.note,
    required this.attachments,
    required this.items,
  });
}

class OperasionalPengeluaranDraft {
  final PengeluaranCategory category;
  final String operasionalName;
  final DateTime date;
  final String createdBy;
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final List<OperasionalExpenseItem> items;

  const OperasionalPengeluaranDraft({
    required this.category,
    required this.operasionalName,
    required this.date,
    required this.createdBy,
    required this.note,
    required this.attachments,
    required this.items,
  });
}

class PengeluaranMaterialFlowResult {
  final String title;
  final String message;

  const PengeluaranMaterialFlowResult({
    required this.title,
    required this.message,
  });
}

class TambahPengeluaranPage extends StatefulWidget {
  final String? projectId;
  final PengeluaranCategory category;
  final String pageTitle;
  final MaterialPengeluaranDraft? initialDraft;
  final OperasionalPengeluaranDraft? initialOperasionalDraft;
  final PengeluaranMaterialFlowResult successResult;

  const TambahPengeluaranPage({
    super.key,
    this.projectId,
    required this.category,
    this.pageTitle = 'Tambah Pengeluaran',
    this.initialDraft,
    this.initialOperasionalDraft,
    this.successResult = const PengeluaranMaterialFlowResult(
      title: 'Berhasil Menyimpan',
      message: 'Kamu berhasil menambahkan pengeluaran baru',
    ),
  });

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final _catatanController = TextEditingController();
  final _imagePicker = ImagePicker();
  late final TambahPengeluaranBloc _submitBloc;
  final List<MaterialAttachmentItem> _selectedImages = [];
  late DateTime _selectedDate;
  List<MaterialExpenseItem> _selectedItems = const [];
  List<OperasionalExpenseItem> _operasionalItems = const [];

  bool get _isEditMode =>
      widget.initialDraft != null || widget.initialOperasionalDraft != null;

  @override
  void initState() {
    super.initState();
    _submitBloc = TambahPengeluaranBloc(PekerjaanService());
    _selectedDate =
        widget.initialDraft?.date ??
        widget.initialOperasionalDraft?.date ??
        DateTime.now();
    _catatanController.text =
        widget.initialDraft?.note ?? widget.initialOperasionalDraft?.note ?? '';
    _selectedImages.addAll(
      widget.initialDraft?.attachments ??
          widget.initialOperasionalDraft?.attachments ??
          const [],
    );
    _selectedItems = widget.initialDraft?.items ?? const [];
    _operasionalItems = widget.initialOperasionalDraft?.items ?? const [];
  }

  @override
  void dispose() {
    _submitBloc.close();
    _catatanController.dispose();
    super.dispose();
  }

  double get _grandTotal {
    return _selectedItems.fold(0, (sum, item) => sum + item.total);
  }

  double get _operasionalGrandTotal {
    return _operasionalItems.fold(0, (sum, item) => sum + item.amount);
  }

  Future<void> _pickImages() async {
    final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);
    if (!mounted || pickedImages.isEmpty) {
      return;
    }

    setState(() {
      _selectedImages.addAll(
        pickedImages
            .take(5 - _selectedImages.length)
            .map((image) => MaterialAttachmentItem.file(image.path)),
      );
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
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => MaterialItemPickerSheet(
        projectId: widget.projectId,
        initialItems: _selectedItems,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _selectedItems = result;
    });
  }

  Future<void> _openEditMaterialItemSheet({
    required MaterialExpenseItem item,
    required int itemIndex,
  }) async {
    final result = await showModalBottomSheet<MaterialItemSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TambahItemBaruSheet(initialItem: item),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      final updatedItems = [..._selectedItems];
      if (result.isDeleted) {
        if (itemIndex >= 0 && itemIndex < updatedItems.length) {
          updatedItems.removeAt(itemIndex);
        }
      } else if (result.item != null &&
          itemIndex >= 0 &&
          itemIndex < updatedItems.length) {
        updatedItems[itemIndex] = result.item!;
      }
      _selectedItems = updatedItems;
    });
  }

  void _saveMaterialFlow() {
    if (_selectedItems.isEmpty) {
      return;
    }

    if (_isEditMode || widget.projectId == null) {
      Navigator.pop(context, widget.successResult);
      return;
    }

    _submitBloc.add(
      SubmitPengeluaranRequested(
        projectId: widget.projectId!,
        kategori: 'material',
        tanggal: _buildSubmitDate(_selectedDate),
        catatan: _catatanController.text.trim(),
        lampiranPaths: _collectUploadPaths(_selectedImages),
        items: _selectedItems
            .map(
              (item) => PengeluaranSubmissionPayload(
                nama: item.name,
                jumlah: item.quantity,
                nominal: item.total,
              ),
            )
            .toList(),
      ),
    );
  }

  String _buildSubmitDate(DateTime date) {
    return DateFormat("yyyy-MM-dd'T'00:00:00'Z'").format(date);
  }

  List<String> _collectUploadPaths(List<MaterialAttachmentItem> attachments) {
    return attachments
        .where((attachment) => attachment.isFile)
        .map((attachment) => attachment.path)
        .toList();
  }

  Future<void> _openOperasionalItemSheet({
    OperasionalExpenseItem? item,
    int? itemIndex,
  }) async {
    final result = await showModalBottomSheet<OperasionalItemSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TambahItemOperasionalSheet(initialItem: item),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (result.isDeleted && itemIndex != null) {
        final updatedItems = [..._operasionalItems]..removeAt(itemIndex);
        _operasionalItems = updatedItems;
      } else if (result.item != null && itemIndex != null) {
        final updatedItems = [..._operasionalItems];
        updatedItems[itemIndex] = result.item!;
        _operasionalItems = updatedItems;
      } else if (result.item != null) {
        _operasionalItems = [..._operasionalItems, result.item!];
      }
    });

    StatusBanner.show(
      context,
      title: result.isDeleted ? 'Berhasil Menghapus' : 'Berhasil Menyimpan',
      message: result.isDeleted
          ? 'Kamu berhasil menghapus item pengeluaran'
          : 'Kamu berhasil menambahkan item pengeluaran baru',
      type: StatusBannerType.success,
    );
  }

  Future<void> _openOperasionalItemPicker() async {
    final result = await showModalBottomSheet<List<OperasionalExpenseItem>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => OperasionalItemPickerSheet(
        projectId: widget.projectId,
        category: widget.category,
        initialItems: _operasionalItems,
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _operasionalItems = result;
    });
  }

  void _saveOperasionalFlow() {
    if (_operasionalItems.isEmpty) {
      return;
    }

    if (_isEditMode || widget.projectId == null) {
      Navigator.pop(context, widget.successResult);
      return;
    }

    _submitBloc.add(
      SubmitPengeluaranRequested(
        projectId: widget.projectId!,
        kategori: _buildSubmitCategory(),
        tanggal: _buildSubmitDate(_selectedDate),
        catatan: _buildSimpleExpenseCatatan(),
        lampiranPaths: _collectOperasionalAttachmentPaths(),
        items: _operasionalItems.asMap().entries.map((entry) {
          final item = entry.value;
          return PengeluaranSubmissionPayload(
            nama: item.name,
            jumlah: 1,
            nominal: item.amount,
          );
        }).toList(),
      ),
    );
  }

  String _buildSubmitCategory() {
    switch (widget.category) {
      case PengeluaranCategory.operasional:
        return 'operasional';
      case PengeluaranCategory.material:
        return 'material';
      case PengeluaranCategory.pettyCash:
        return 'petty_cash';
    }
  }

  String _buildSimpleExpenseCatatan() {
    return _catatanController.text.trim();
  }

  List<String> _collectOperasionalAttachmentPaths() {
    return _selectedImages
        .where((attachment) => attachment.isFile)
        .map((attachment) => attachment.path)
        .toSet()
        .toList();
  }

  void _handleSubmitState(BuildContext context, TambahPengeluaranState state) {
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      StatusBanner.show(
        context,
        title: 'Gagal Menyimpan',
        message: state.errorMessage!,
        type: StatusBannerType.error,
      );
      return;
    }

    if (state.isSuccess) {
      Navigator.pop(
        context,
        PengeluaranMaterialFlowResult(
          title: widget.successResult.title,
          message: state.successMessage ?? widget.successResult.message,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMaterial = widget.category == PengeluaranCategory.material;
    final isSimpleExpense =
        widget.category == PengeluaranCategory.operasional ||
        widget.category == PengeluaranCategory.pettyCash;

    return BlocProvider.value(
      value: _submitBloc,
      child: BlocListener<TambahPengeluaranBloc, TambahPengeluaranState>(
        listener: _handleSubmitState,
        child: Builder(
          builder: (context) {
            final submitState = context.watch<TambahPengeluaranBloc>().state;

            return Scaffold(
              backgroundColor: const Color(0xFFFAFAFA),
              body: SafeArea(
                child: Column(
                  children: [
                    _TambahPengeluaranHeader(title: widget.pageTitle),
                    Expanded(
                      child: isMaterial
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                24,
                              ),
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
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: _selectedImages.length + 1,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return _UploadBox(onTap: _pickImages);
                                        }

                                        return AttachmentThumbnail(
                                          image: _selectedImages[index - 1],
                                          galleryImages: _selectedImages,
                                          initialIndex: index - 1,
                                        );
                                      },
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
                                          .asMap()
                                          .entries
                                          .map(
                                            (entry) => Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              child: SelectedMaterialItemCard(
                                                item: entry.value,
                                                onTapEdit: () =>
                                                    _openEditMaterialItemSheet(
                                                      item: entry.value,
                                                      itemIndex: entry.key,
                                                    ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                ],
                              ),
                            )
                          : isSimpleExpense
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                24,
                              ),
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
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: _selectedImages.length + 1,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return _UploadBox(onTap: _pickImages);
                                        }

                                        return AttachmentThumbnail(
                                          image: _selectedImages[index - 1],
                                          galleryImages: _selectedImages,
                                          initialIndex: index - 1,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _FieldLabel('Item ${widget.category.label}'),
                                  const SizedBox(height: 8),
                                  if (_operasionalItems.isEmpty)
                                    _EmptyOperasionalState(
                                      minHeight:
                                          MediaQuery.of(context).size.height *
                                          0.38,
                                    )
                                  else
                                    Column(
                                      children: _operasionalItems
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              child: OperasionalExpenseCard(
                                                item: entry.value,
                                                onTapDetail: () {
                                                  showModalBottomSheet<void>(
                                                    context: context,
                                                    backgroundColor:
                                                        const Color(
                                                          0xFFFAFAFA,
                                                        ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(
                                                                      24,
                                                                    ),
                                                              ),
                                                        ),
                                                    builder: (_) =>
                                                        OperasionalDetailSheet(
                                                          note:
                                                              _catatanController
                                                                  .text,
                                                          attachments:
                                                              _selectedImages,
                                                          amount:
                                                              widget.category ==
                                                                  PengeluaranCategory
                                                                      .operasional
                                                              ? _formatCurrency(
                                                                  entry
                                                                      .value
                                                                      .amount,
                                                                )
                                                              : null,
                                                          totalItems:
                                                              widget.category ==
                                                                  PengeluaranCategory
                                                                      .operasional
                                                              ? _operasionalItems
                                                                    .length
                                                                    .toString()
                                                              : null,
                                                        ),
                                                  );
                                                },
                                                onTapEdit: () =>
                                                    _openOperasionalItemSheet(
                                                      item: entry.value,
                                                      itemIndex: entry.key,
                                                    ),
                                              ),
                                            );
                                          })
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
                        border: Border(
                          top: BorderSide(color: Color(0xFFF1F3F5)),
                        ),
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
                                _formatCurrency(
                                  isMaterial
                                      ? _grandTotal
                                      : _operasionalGrandTotal,
                                ),
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
                                  onPressed: submitState.isSubmitting
                                      ? null
                                      : isMaterial
                                      ? _openItemPicker
                                      : isSimpleExpense
                                      ? _openOperasionalItemPicker
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFF7944D),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFFF7944D),
                                  ),
                                  label: Text(
                                    isMaterial ? 'Pilih Item' : 'Tambah',
                                    style: const TextStyle(
                                      color: Color(0xFFF7944D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: submitState.isSubmitting
                                      ? null
                                      : isMaterial
                                      ? (_selectedItems.isEmpty
                                            ? null
                                            : _saveMaterialFlow)
                                      : isSimpleExpense
                                      ? (_operasionalItems.isEmpty
                                            ? null
                                            : _saveOperasionalFlow)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF7944D),
                                    disabledBackgroundColor: const Color(
                                      0xFFFAD1B7,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size.fromHeight(50),
                                    elevation: 0,
                                  ),
                                  child: submitState.isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
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
          },
        ),
      ),
    );
  }
}

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

class OperasionalItemPickerSheet extends StatefulWidget {
  final String? projectId;
  final PengeluaranCategory category;
  final List<OperasionalExpenseItem> initialItems;

  const OperasionalItemPickerSheet({
    super.key,
    required this.initialItems,
    required this.category,
    this.projectId,
  });

  @override
  State<OperasionalItemPickerSheet> createState() =>
      _OperasionalItemPickerSheetState();
}

class _OperasionalItemPickerSheetState extends State<OperasionalItemPickerSheet> {
  final _searchController = TextEditingController();
  final _service = PekerjaanService();
  List<OperasionalExpenseItem> _items = const [];
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
    if (widget.category == PengeluaranCategory.pettyCash ||
        widget.projectId == null ||
        widget.projectId!.isEmpty) {
      setState(() {
        _items = List<OperasionalExpenseItem>.from(widget.initialItems);
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

  List<OperasionalExpenseItem> _mergeWithRabItems(
    List<OperasionalExpenseItem> selected,
    List<ProjectRabItem> rabItems,
  ) {
    final mapped = <String, OperasionalExpenseItem>{};

    void addItem(OperasionalExpenseItem item) {
      mapped[_itemKey(item.name)] = item;
    }

    for (final item in _flattenRabItems(rabItems)) {
      addItem(
        OperasionalExpenseItem(
          id: 'rab-${item.id}',
          name: item.uraian,
          amount: 0,
          note: '',
          attachments: const [],
        ),
      );
    }

    for (final item in selected) {
      addItem(item.copyWith(isSelected: true));
    }

    return mapped.values.toList();
  }

  List<ProjectRabItem> _flattenRabItems(List<ProjectRabItem> items) {
    final result = <ProjectRabItem>[];

    void visit(ProjectRabItem item) {
      final isOperasional =
          item.kategori.trim().toLowerCase() == 'operasional';
      final isLeafItem = item.tipe.trim().toLowerCase() == 'item';
      final hasName = item.uraian.trim().isNotEmpty;

      if (isOperasional && isLeafItem && hasName) {
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

  List<OperasionalExpenseItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _items;
    }

    return _items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<void> _openAddNewItemSheet() async {
    final result = await showModalBottomSheet<OperasionalItemSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const TambahItemOperasionalSheet(),
    );

    if (result?.item == null) {
      return;
    }

    setState(() {
      _items = [..._items, result!.item!.copyWith(isSelected: true)];
    });
  }

  void _toggleItem(OperasionalExpenseItem item, bool value) {
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(
                    isSelected: value,
                    amount: value ? current.amount : 0,
                  )
                : current,
          )
          .toList();
    });
  }

  void _updateAmount(OperasionalExpenseItem item, String rawValue) {
    final sanitized = rawValue.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(sanitized) ?? 0;
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(amount: amount)
                : current,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = _items.where((item) => item.isSelected).toList();
    final emptyText = widget.category == PengeluaranCategory.pettyCash
        ? 'Belum ada item petty cash'
        : 'Belum ada item operasional';

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
                child: _isLoadingItems
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF7944D),
                        ),
                      )
                    : _filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          emptyText,
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredItems.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return OperasionalItemSelectionCard(
                            key: ValueKey(item.id),
                            item: item,
                            onChanged: (value) => _toggleItem(item, value),
                            onAmountChanged: (value) =>
                                _updateAmount(item, value),
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
  final MaterialExpenseItem? initialItem;

  const TambahItemBaruSheet({super.key, this.initialItem});

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
    _nameController.text = widget.initialItem?.name ?? '';
    _quantityController.text = widget.initialItem == null
        ? ''
        : widget.initialItem!.quantity.toString();
    _totalController.text = widget.initialItem == null
        ? ''
        : widget.initialItem!.total.toStringAsFixed(0);
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

  void _deleteItem() {
    Navigator.pop(context, MaterialItemSheetResult.deleted());
  }

  void _saveItem() {
    final item = MaterialExpenseItem(
      id:
          widget.initialItem?.id ??
          'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      total:
          double.tryParse(_totalController.text.trim().replaceAll(',', '')) ??
          0,
      isSelected: true,
      isCustom: widget.initialItem?.isCustom ?? true,
    );
    Navigator.pop(context, MaterialItemSheetResult.saved(item));
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
                Expanded(
                  child: Text(
                    widget.initialItem == null ? 'Tambah Item Baru' : 'Edit',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _FieldLabel('Nama Item'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Item 1',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF5D93E8)),
                ),
              ),
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
            const SizedBox(height: 24),
            if (widget.initialItem != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deleteItem,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF111827)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canSave ? _saveItem : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC7F1),
                        disabledBackgroundColor: const Color(0xFFD6EAF8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
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
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDetail;

  const SelectedMaterialItemCard({
    super.key,
    required this.item,
    this.onTapEdit,
    this.onTapDetail,
  });

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
      child: Stack(
        children: [
          Row(
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
                child: Padding(
                  padding: EdgeInsets.only(
                    right: onTapEdit != null || onTapDetail != null ? 118 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Material',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
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
                            flex: 1,
                            child: _MetaColumn(
                              label: 'Jumlah',
                              value: item.quantity.toString(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
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
              ),
            ],
          ),
          if (onTapEdit != null || onTapDetail != null)
            Positioned(
              top: 2,
              right: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onTapDetail != null)
                    OutlinedButton(
                      onPressed: onTapDetail,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF7944D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(
                          color: Color(0xFFF7944D),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  if (onTapDetail != null && onTapEdit != null)
                    const SizedBox(width: 4),
                  if (onTapEdit != null)
                    IconButton(
                      onPressed: onTapEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFF7944D),
                        size: 20,
                      ),
                      tooltip: 'Edit item',
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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
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

class OperasionalItemSelectionCard extends StatefulWidget {
  final OperasionalExpenseItem item;
  final ValueChanged<bool> onChanged;
  final ValueChanged<String> onAmountChanged;

  const OperasionalItemSelectionCard({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onAmountChanged,
  });

  @override
  State<OperasionalItemSelectionCard> createState() =>
      _OperasionalItemSelectionCardState();
}

class _OperasionalItemSelectionCardState
    extends State<OperasionalItemSelectionCard> {
  late final TextEditingController _amountController;
  late final FocusNode _amountFocusNode;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.item.amount == 0 ? '' : widget.item.amount.toStringAsFixed(0),
    );
    _amountFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant OperasionalItemSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextAmount = widget.item.amount == 0
        ? ''
        : widget.item.amount.toStringAsFixed(0);

    if (!_amountFocusNode.hasFocus && _amountController.text != nextAmount) {
      _amountController.text = nextAmount;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
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
          const _FieldLabel('Total'),
          const SizedBox(height: 6),
          _CompactTextField(
            controller: _amountController,
            focusNode: _amountFocusNode,
            hintText: 'Rp',
            prefixText: 'Rp ',
            keyboardType: TextInputType.number,
            enabled: widget.item.isSelected,
            onChanged: widget.onAmountChanged,
          ),
        ],
      ),
    );
  }
}

class OperasionalExpenseCard extends StatelessWidget {
  final OperasionalExpenseItem item;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDetail;

  const OperasionalExpenseCard({
    super.key,
    required this.item,
    this.onTapEdit,
    this.onTapDetail,
  });

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
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEAFE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.work_outline, color: Color(0xFF5D93E8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(item.amount),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B2A4A),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 36),
                child: OutlinedButton(
                  onPressed:
                      onTapDetail ??
                      () {
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: const Color(0xFFFAFAFA),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => OperasionalDetailSheet(
                            note: item.note,
                            attachments: item.attachments,
                          ),
                        );
                      },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFF7944D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: Color(0xFFF7944D),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (onTapEdit != null)
            Positioned(
              top: -6,
              right: -6,
              child: IconButton(
                onPressed: onTapEdit,
                icon: const Icon(Icons.edit_outlined, color: Color(0xFFF7944D)),
                tooltip: 'Edit item',
              ),
            ),
        ],
      ),
    );
  }
}

class TambahItemOperasionalSheet extends StatefulWidget {
  final OperasionalExpenseItem? initialItem;

  const TambahItemOperasionalSheet({super.key, this.initialItem});

  @override
  State<TambahItemOperasionalSheet> createState() =>
      _TambahItemOperasionalSheetState();
}

class _TambahItemOperasionalSheetState
    extends State<TambahItemOperasionalSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  bool get _canSubmit {
    return _nameController.text.trim().isNotEmpty &&
        (double.tryParse(
                  _amountController.text.trim().replaceAll(',', ''),
                ) ??
                0) >
            0;
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialItem?.name ?? '';
    _amountController.text = widget.initialItem == null
        ? ''
        : widget.initialItem!.amount.toStringAsFixed(0);
    _nameController.addListener(() => setState(() {}));
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _deleteItem() {
    Navigator.pop(context, OperasionalItemSheetResult.deleted());
  }

  void _saveItem() {
    final item = OperasionalExpenseItem(
      id:
          widget.initialItem?.id ??
          'operasional-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      amount:
          double.tryParse(_amountController.text.trim().replaceAll(',', '')) ??
          0,
      note: widget.initialItem?.note ?? '',
      attachments: List<MaterialAttachmentItem>.from(
        widget.initialItem?.attachments ?? const [],
      ),
      isSelected: true,
      isCustom: widget.initialItem?.isCustom ?? true,
    );

    Navigator.pop(context, OperasionalItemSheetResult.saved(item));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
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
                Expanded(
                  child: Text(
                    widget.initialItem == null ? 'Tambah Item Baru' : 'Edit',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _FieldLabel('Nama Item'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Item 1',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF5D93E8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Jumlah Biaya'),
            const SizedBox(height: 8),
            _CompactTextField(
              controller: _amountController,
              hintText: 'Rp',
              prefixText: 'Rp ',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (widget.initialItem != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deleteItem,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF111827)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canSubmit ? _saveItem : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC7F1),
                        disabledBackgroundColor: const Color(0xFFD6EAF8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _saveItem : null,
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

class OperasionalDetailSheet extends StatelessWidget {
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final String? amount;
  final String? totalItems;

  const OperasionalDetailSheet({
    super.key,
    required this.note,
    required this.attachments,
    this.amount,
    this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Lihat Detail',
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
            if (amount != null) ...[
              const Text(
                'Jumlah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              _DetailSheetBox(text: amount!),
              const SizedBox(height: 16),
            ],
            if (totalItems != null) ...[
              const Text(
                'Total Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              _DetailSheetBox(text: totalItems!),
              const SizedBox(height: 16),
            ],
            const Text(
              'Catatan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 8),
            _DetailSheetBox(text: note.trim().isEmpty ? '-' : note),
            const SizedBox(height: 16),
            const Text(
              'Lampiran',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 8),
            if (attachments.isEmpty)
              const _DetailSheetBox(text: '-')
            else
              SizedBox(
                height: 74,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: attachments.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AttachmentThumbnail(
                      image: attachments[index],
                      galleryImages: attachments,
                      initialIndex: index,
                      width: 74,
                      height: 74,
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

class _DetailSheetBox extends StatelessWidget {
  final String text;

  const _DetailSheetBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.45,
          color: Color(0xFF1F1F1F),
        ),
      ),
    );
  }
}

class _EmptyOperasionalState extends StatelessWidget {
  final double? minHeight;

  const _EmptyOperasionalState({this.minHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_material_background.png',
            height: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 14),
          const Text(
            'Belum Ada Pengeluaran',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan pilih item untuk menambah pengeluaran',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TambahPengeluaranHeader extends StatelessWidget {
  final String title;

  const _TambahPengeluaranHeader({required this.title});

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
          Expanded(
            child: Text(
              title,
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

class AttachmentThumbnail extends StatelessWidget {
  final MaterialAttachmentItem image;
  final List<MaterialAttachmentItem>? galleryImages;
  final int initialIndex;
  final double width;
  final double height;

  const AttachmentThumbnail({
    super.key,
    required this.image,
    this.galleryImages,
    this.initialIndex = 0,
    this.width = 92,
    this.height = 92,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _AttachmentThumbnailContent(
          image: image,
          width: width,
          height: height,
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _AttachmentPreviewPage(
          images: galleryImages ?? [image],
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _AttachmentThumbnailContent extends StatelessWidget {
  final MaterialAttachmentItem image;
  final double width;
  final double height;

  const _AttachmentThumbnailContent({
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (_isPdfAttachment(image.path)) {
      return _AttachmentDocumentTile(
        width: width,
        height: height,
        extensionLabel: 'PDF',
      );
    }

    if (_isSvgAttachment(image.path)) {
      if (image.isFile) {
        return SvgPicture.file(
          File(image.path),
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholderBuilder: (_) =>
              _AttachmentLoadingTile(width: width, height: height),
        );
      }

      if (image.isNetwork) {
        return SvgPicture.network(
          image.path,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholderBuilder: (_) =>
              _AttachmentLoadingTile(width: width, height: height),
        );
      }

      return SvgPicture.asset(
        image.path,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    if (image.isFile) {
      return Image.file(
        File(image.path),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    if (image.isNetwork) {
      return Image.network(
        image.path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _AttachmentLoadingTile(width: width, height: height);
        },
        errorBuilder: (_, _, _) =>
            _AttachmentErrorTile(width: width, height: height),
      );
    }

    return Image.asset(
      image.path,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}

class _AttachmentPreviewPage extends StatefulWidget {
  final List<MaterialAttachmentItem> images;
  final int initialIndex;

  const _AttachmentPreviewPage({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_AttachmentPreviewPage> createState() => _AttachmentPreviewPageState();
}

class _AttachmentPreviewPageState extends State<_AttachmentPreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: widget.images.length > 1
            ? Text('${_currentIndex + 1}/${widget.images.length}')
            : null,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(child: _buildPreviewContent(widget.images[index]));
        },
      ),
    );
  }

  Widget _buildPreviewContent(MaterialAttachmentItem image) {
    if (_isPdfAttachment(image.path)) {
      return _buildPdfPreview(image);
    }

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4,
      child: _buildImagePreview(image),
    );
  }

  Widget _buildImagePreview(MaterialAttachmentItem image) {
    if (_isSvgAttachment(image.path)) {
      if (image.isFile) {
        return SvgPicture.file(
          File(image.path),
          fit: BoxFit.contain,
          placeholderBuilder: (_) =>
              const CircularProgressIndicator(color: Colors.white),
        );
      }

      if (image.isNetwork) {
        return SvgPicture.network(
          image.path,
          fit: BoxFit.contain,
          placeholderBuilder: (_) =>
              const CircularProgressIndicator(color: Colors.white),
        );
      }

      return SvgPicture.asset(image.path, fit: BoxFit.contain);
    }

    if (image.isFile) {
      return Image.file(File(image.path), fit: BoxFit.contain);
    }

    if (image.isNetwork) {
      return Image.network(
        image.path,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        errorBuilder: (_, _, _) => const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white70,
          size: 48,
        ),
      );
    }

    return Image.asset(image.path, fit: BoxFit.contain);
  }

  Widget _buildPdfPreview(MaterialAttachmentItem image) {
    if (image.isFile) {
      return PdfViewer.file(
        image.path,
        params: const PdfViewerParams(backgroundColor: Colors.black),
      );
    }

    if (image.isNetwork) {
      return PdfViewer.uri(
        Uri.parse(image.path),
        params: const PdfViewerParams(backgroundColor: Colors.black),
      );
    }

    return Center(
      child: Text(
        _extractFileName(image.path),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AttachmentLoadingTile extends StatelessWidget {
  final double width;
  final double height;

  const _AttachmentLoadingTile({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF1F3F5),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _AttachmentErrorTile extends StatelessWidget {
  final double width;
  final double height;

  const _AttachmentErrorTile({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF1F3F5),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFF9AA0A6),
      ),
    );
  }
}

class _AttachmentDocumentTile extends StatelessWidget {
  final double width;
  final double height;
  final String extensionLabel;

  const _AttachmentDocumentTile({
    required this.width,
    required this.height,
    required this.extensionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: Color(0xFFD14343),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            extensionLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}

bool _isPdfAttachment(String path) => path.toLowerCase().endsWith('.pdf');

bool _isSvgAttachment(String path) => path.toLowerCase().endsWith('.svg');

String _extractFileName(String path) {
  final sanitized = path.split('?').first;
  final segments = sanitized.split('/');
  return segments.isEmpty ? path : segments.last;
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
