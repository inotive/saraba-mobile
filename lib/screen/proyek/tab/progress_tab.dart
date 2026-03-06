import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/extension/context_extension.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'package:saraba_mobile/common/widget/elevated_button_widget.dart';
import 'package:saraba_mobile/common/widget/text_field_widget.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            if (index == 5) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary500,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      color: AppColors.primary500,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Upload",
                                      style: AppStyles.body12SemiBold.copyWith(
                                        color: AppColors.primary500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        AppElevatedButton(
                          text: 'Add Photos',
                          icon: Icon(Icons.upload, color: AppColors.primary500),
                          backgroundColor: AppColors.whiteContainer,
                          borderColor: AppColors.primary400.withOpacity(0.5),
                          textColor: AppColors.primary500,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextFormField(
                          label: 'Input % Progress',
                          hintText: '0',
                          suffixIcon: Text('%'),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Maksimal 100%",
                          style: AppStyles.body12Medium.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppTextFormField(
                          label: 'Catatan',
                          hintText: 'Berikan catatan progress',
                          maxLines: 3,
                        ),
                      ],
                    ),
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
                  text: 'Submit Progress',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
