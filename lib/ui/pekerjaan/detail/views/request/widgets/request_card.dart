import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';

class RequestCard extends StatefulWidget {
  final ProjectRequestItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RequestCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<RequestCard> createState() => RequestCardState();
}

class RequestCardState extends State<RequestCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final requestText = item.requestText;
    final shouldShowToggle =
        requestText.length > 120 || '\n'.allMatches(requestText).length >= 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Id Request',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.displayId,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ],
                ),
              ),
              RequestStatusChip(status: item.status),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: InfoColumn(label: 'Dibuat Oleh', value: item.createdBy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoColumn(
                  label: 'Tanggal Request',
                  value: DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(item.requestDate),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Request',
            style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
          ),
          const SizedBox(height: 4),
          Text(
            requestText,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF1F1F1F),
            ),
          ),
          if (shouldShowToggle) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Lebih Sedikit' : 'Lebih Banyak',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D93E8),
                  ),
                ),
              ),
            ),
          ],
          if (item.status == RequestStatus.pending &&
              (widget.onDelete != null || widget.onEdit != null)) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onDelete != null)
                  OutlinedButton(
                    onPressed: widget.onDelete,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF5B5B)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(92, 38),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        color: Color(0xFFFF5B5B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (widget.onDelete != null && widget.onEdit != null)
                  const SizedBox(width: 10),
                if (widget.onEdit != null)
                  OutlinedButton(
                    onPressed: widget.onEdit,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFF7944D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(92, 38),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Color(0xFFF7944D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
