import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/approval/detail_approval_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_card.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  List<ProjectRequestItem> get _dummyData => [
    ProjectRequestItem(
      requestId: '20260410001',
      createdBy: 'Lily Karmila',
      requestDate: DateTime(2026, 4, 10),
      requestText: 'Lorem ipsum dolor sit amet',
      totalItem: 10,
      grandTotal: 300000,
      status: RequestStatus.pending,
      displayId: 'REQ-001',
    ),
    ProjectRequestItem(
      requestId: '20260410002',
      createdBy: 'Lily Karmila',
      requestDate: DateTime(2026, 4, 10),
      requestText: 'Lorem ipsum dolor sit amet',
      totalItem: 10,
      grandTotal: 150000000,
      status: RequestStatus.pending,
      displayId: 'REQ-002',
    ),
  ];

  void _openDetail(BuildContext context, ProjectRequestItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailApprovalPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = _dummyData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Request'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: requests.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final item = requests[index];

            return RequestCard(
              item: item,
              onDetail: () => _openDetail(context, item),
            );
          },
        ),
      ),
    );
  }
}
