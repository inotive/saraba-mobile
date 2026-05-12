import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/mappers/pengeluaran_category_extension.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_attachment_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_pengeluaran_draft.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_pengeluaran_draft.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_item_sheet_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_item_sheet_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_material_flow_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/utils/header.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/attachment_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/material_item_picker_sheet.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/operasional_expenses_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/operasional_item_picker.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/selected_material_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/tambah_item_baru_sheet.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/tambah_item_operasional_sheet.dart';

class TambahPengeluaranPage extends StatefulWidget {
  final String? projectId;
  final String? pengeluaranId;
  final PengeluaranCategory category;
  final String pageTitle;
  final MaterialPengeluaranDraft? initialDraft;
  final OperasionalPengeluaranDraft? initialOperasionalDraft;
  final PengeluaranMaterialFlowResult successResult;

  const TambahPengeluaranPage({
    super.key,
    this.projectId,
    this.pengeluaranId,
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
    // _selectedImages.addAll(
    //   widget.initialDraft?.attachments ??
    //       widget.initialOperasionalDraft?.attachments ??
    //       const [],
    // );
    _loadInitialAttachments();
    _selectedItems = widget.initialDraft?.items ?? const [];
    _operasionalItems = widget.initialOperasionalDraft?.items ?? const [];
  }

  @override
  void dispose() {
    _submitBloc.close();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialAttachments() async {
    final attachments =
        widget.initialDraft?.attachments ??
        widget.initialOperasionalDraft?.attachments ??
        const [];

    for (final attachment in attachments) {
      if (attachment.isFile) {
        _selectedImages.add(attachment);
        continue;
      }

      final file = await _downloadFile(attachment.path);

      if (file != null) {
        _selectedImages.add(MaterialAttachmentItem.file(file.path));
      }
    }

    if (mounted) {
      setState(() {});
    }
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

    if (result == null) {
      return;
    }

    setState(() {
      _operasionalItems = result;
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

    _showItemResultBanner(isDeleted: result.isDeleted, isEditing: true);
  }

  void _saveMaterialFlow() {
    if (_selectedItems.isEmpty) {
      return;
    }

    if (_isEditMode || widget.projectId == null) {
      if (widget.projectId == null || widget.pengeluaranId == null) {
        Navigator.pop(context, widget.successResult);
        return;
      }

      _submitBloc.add(
        SubmitPengeluaranRequested(
          projectId: widget.projectId!,
          pengeluaranId: widget.pengeluaranId,
          kategori: 'material',
          tanggal: _buildSubmitDate(_selectedDate),
          catatan: _catatanController.text.trim(),
          // lampiranPaths: _collectUploadPaths(_selectedImages),
          lampiranPaths: _collectAllAttachmentPaths(),
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
      return;
    }

    _submitBloc.add(
      SubmitPengeluaranRequested(
        projectId: widget.projectId!,
        kategori: 'material',
        tanggal: _buildSubmitDate(_selectedDate),
        catatan: _catatanController.text.trim(),
        // lampiranPaths: _collectUploadPaths(_selectedImages),
        lampiranPaths: _collectAllAttachmentPaths(),
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

  Future<File?> _downloadFile(String url) async {
    try {
      final dio = Dio();

      final dir = await getTemporaryDirectory();

      final fileName = url.split('/').last;

      final filePath = "${dir.path}/$fileName";

      await dio.download(url, filePath);

      return File(filePath);
    } catch (e) {
      debugPrint("Download error: $e");
      return null;
    }
  }

  List<String> _collectAllAttachmentPaths() {
    return _selectedImages
        .map((e) => e.path)
        .where((path) => path.isNotEmpty)
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
      builder: (_) => TambahItemOperasionalSheet(
        initialItem: item,
        category: widget.category,
        defaultName: item?.name ?? '',
      ),
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

    _showItemResultBanner(
      isDeleted: result.isDeleted,
      isEditing: itemIndex != null,
    );
  }

  void _showItemResultBanner({
    required bool isDeleted,
    required bool isEditing,
  }) {
    final message = isDeleted
        ? 'Kamu berhasil menghapus item pengeluaran'
        : isEditing
        ? 'Kamu berhasil memperbarui item pengeluaran'
        : 'Kamu berhasil menambahkan item pengeluaran baru';

    StatusBanner.show(
      context,
      title: isDeleted ? 'Berhasil Menghapus' : 'Berhasil Menyimpan',
      message: message,
      type: StatusBannerType.success,
    );
  }

  void _saveOperasionalFlow() {
    if (_operasionalItems.isEmpty) {
      return;
    }

    if (_isEditMode || widget.projectId == null) {
      if (widget.projectId == null || widget.pengeluaranId == null) {
        Navigator.pop(context, widget.successResult);
        return;
      }
      debugPrint("TOTAL ATTACHMENT:");
      debugPrint("${_selectedImages.length}");

      for (var img in _selectedImages) {
        debugPrint("PATH: ${img.path}");
      }
      _submitBloc.add(
        SubmitPengeluaranRequested(
          projectId: widget.projectId!,
          pengeluaranId: widget.pengeluaranId,
          kategori: _buildSubmitCategory(),
          tanggal: _buildSubmitDate(_selectedDate),
          catatan: _buildSimpleExpenseCatatan(),
          // lampiranPaths: _collectOperasionalAttachmentPaths(),
          lampiranPaths: _collectAllAttachmentPaths(),
          items: _operasionalItems.map((item) {
            return PengeluaranSubmissionPayload(
              nama: item.name,
              jumlah: item.quantity,
              nominal: item.amount,
            );
          }).toList(),
        ),
      );
      return;
    }

    _submitBloc.add(
      SubmitPengeluaranRequested(
        projectId: widget.projectId!,
        kategori: _buildSubmitCategory(),
        tanggal: _buildSubmitDate(_selectedDate),
        catatan: _buildSimpleExpenseCatatan(),
        // lampiranPaths: _collectOperasionalAttachmentPaths(),
        lampiranPaths: _collectAllAttachmentPaths(),
        items: _operasionalItems.asMap().entries.map((entry) {
          final item = entry.value;
          return PengeluaranSubmissionPayload(
            nama: item.name,
            jumlah: item.quantity,
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
      final result = PengeluaranMaterialFlowResult(
        title: widget.successResult.title,
        message: state.successMessage ?? widget.successResult.message,
      );

      final shouldShowInlineSuccess = widget.pengeluaranId != null;

      if (shouldShowInlineSuccess) {
        final navigator = Navigator.of(context);
        StatusBanner.show(
          context,
          title: result.title,
          message: result.message,
          type: StatusBannerType.success,
        );

        Future<void>.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) {
            return;
          }
          navigator.pop(result);
        });
        return;
      }

      Navigator.pop(context, result);
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index >= 0 && index < _selectedImages.length) {
        _selectedImages.removeAt(index);
      }
    });
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
                    TambahPengeluaranHeader(title: widget.pageTitle),
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
                                  const FieldLabel('Masukkan Tanggal'),
                                  const SizedBox(height: 8),
                                  DateField(
                                    value: DateFormat(
                                      'dd MMMM yyyy',
                                      'id_ID',
                                    ).format(_selectedDate),
                                    onTap: _pickDate,
                                  ),
                                  const SizedBox(height: 16),
                                  const FieldLabel('Catatan'),
                                  const SizedBox(height: 8),
                                  NotesField(
                                    controller: _catatanController,
                                    hintText: 'Ketik Disini',
                                  ),
                                  const SizedBox(height: 16),
                                  const FieldLabel('Lampiran'),
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
                                          return UploadBox(onTap: _pickImages);
                                        }

                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            AttachmentThumbnail(
                                              image: _selectedImages[index - 1],
                                              galleryImages: _selectedImages,
                                              initialIndex: index - 1,
                                            ),

                                            Positioned(
                                              top: -6,
                                              right: -6,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _removeImage(index - 1),
                                                child: Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const FieldLabel('Item Material'),
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
                                  const FieldLabel('Masukkan Tanggal'),
                                  const SizedBox(height: 8),
                                  DateField(
                                    value: DateFormat(
                                      'dd MMMM yyyy',
                                      'id_ID',
                                    ).format(_selectedDate),
                                    onTap: _pickDate,
                                  ),
                                  const SizedBox(height: 16),
                                  const FieldLabel('Catatan'),
                                  const SizedBox(height: 8),
                                  NotesField(
                                    controller: _catatanController,
                                    hintText: 'Ketik Disini',
                                  ),
                                  const SizedBox(height: 16),
                                  const FieldLabel('Lampiran'),
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
                                          return UploadBox(onTap: _pickImages);
                                        }

                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            AttachmentThumbnail(
                                              image: _selectedImages[index - 1],
                                              galleryImages: _selectedImages,
                                              initialIndex: index - 1,
                                            ),

                                            Positioned(
                                              top: -6,
                                              right: -6,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _removeImage(index - 1),
                                                child: Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FieldLabel('Item ${widget.category.label}'),
                                  const SizedBox(height: 8),
                                  if (_operasionalItems.isEmpty)
                                    const _EmptyOperasionalState()
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
                                formatCurrency(
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
                                    isMaterial || isSimpleExpense
                                        ? 'Pilih Item'
                                        : 'Tambah',
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

class _EmptyOperasionalState extends StatelessWidget {
  const _EmptyOperasionalState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
