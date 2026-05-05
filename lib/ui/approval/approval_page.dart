import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:saraba_mobile/ui/approval/bloc/approval_bloc.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_event.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_state.dart';

import 'package:saraba_mobile/ui/approval/detail_approval_page.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_model.dart';
import 'package:saraba_mobile/ui/approval/widgets/approval_card.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  @override
  void initState() {
    super.initState();
    context.read<ApprovalBloc>().add(FetchRequests());
  }

  void _openDetail(BuildContext context, RequestApprovalData item) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ApprovalBloc>(),
          child: DetailApprovalPage(requestId: item.id.toString()),
        ),
      ),
    );

    if (result == true) {
      context.read<ApprovalBloc>().add(FetchRequests());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _headerSection(),
          Expanded(
            child: BlocBuilder<ApprovalBloc, ApprovalState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.requests.isEmpty) {
                  return const Center(child: Text('Tidak ada request'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.requests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = state.requests[index];

                    return ApprovalCard(
                      item: item,
                      onDetail: () => _openDetail(context, item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _headerSection() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
    child: const Text(
      "Request Approval",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
