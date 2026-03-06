import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/extension/context_extension.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'package:saraba_mobile/common/widget/dropdown_single_widget.dart';
import 'package:saraba_mobile/common/widget/elevated_button_widget.dart';
import 'package:saraba_mobile/common/widget/ringbox_widget.dart';
import 'package:saraba_mobile/common/widget/rupiah_form_field.dart';
import 'package:saraba_mobile/common/widget/text_field_widget.dart';
import 'package:saraba_mobile/common/widget/upload_file_single_field.dart';

class InputExpensePage extends StatefulWidget {
  const InputExpensePage({super.key});

  @override
  State<InputExpensePage> createState() => _InputExpensePageState();
}

class _InputExpensePageState extends State<InputExpensePage> {
  String selected = "Operational";
  late TextEditingController rupiahController;

  @override
  void initState() {
    super.initState();
    rupiahController = TextEditingController();
  }

  @override
  void dispose() {
    rupiahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Pengeluaran',
          style: AppStyles.body20Bold.copyWith(color: AppColors.neutral900),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomBottomSheetDropdownSingle(
                label: 'Pilih Proyek',
                onChanged: (_) {},
                labelFn: (item) => item.toString(),
                asyncItems: (String query) async => [],
                itemBuilder: (item, isSelected) => Text(item.toString()),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori',
                    style: AppStyles.body16Bold.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  SizedBox(height: 12),
                  RadioRingWidget(
                    title: "Material",
                    isSelected: selected == "Material",
                    onTap: () {
                      setState(() {
                        selected = "Material";
                      });
                    },
                  ),
                  RadioRingWidget(
                    title: "Operational",
                    isSelected: selected == "Operational",
                    onTap: () {
                      setState(() {
                        selected = "Operational";
                      });
                    },
                  ),
                  RadioRingWidget(
                    title: "Petty Cash",
                    isSelected: selected == "Petty Cash",
                    onTap: () {
                      setState(() {
                        selected = "Petty Cash";
                      });
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Column(
                  spacing: 12,
                  children: [
                    AppRupiahTextFormField(
                      controller: rupiahController,
                      label: 'Nominal',
                    ),
                    AppTextFormField(
                      label: 'Deskripsi',
                      hintText: 'Jelaskan kebutuhan pengeluaran',
                      maxLines: 3,
                    ),
                    UploadFileSingleField(
                      title: '',
                      label: 'Upload Bukti',
                      subtitle: 'Format JPG/PNG/PDF (maks. 2 MB)',
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Divider(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 12 + context.bottomInset(),
                    left: 16,
                    right: 16,
                  ),
                  child: AppElevatedButton(
                    backgroundColor: AppColors.orangeContainer,
                    textColor: AppColors.neutral50,
                    text: 'Submit Pengeluaran',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
