import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_attachment_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/attachment_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/detail_sheet_box.dart';

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
              DetailSheetBox(text: amount!),
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
              DetailSheetBox(text: totalItems!),
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
            DetailSheetBox(text: note.trim().isEmpty ? '-' : note),
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
              const DetailSheetBox(text: '-')
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