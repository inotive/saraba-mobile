import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Proyek',
                      style: AppStyles.body12Regular.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '60%',
                      style: AppStyles.body24SemiBold.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      backgroundColor: AppColors.neutral200,
                      color: AppColors.orangeContainer,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              'Mulai',
                              style: AppStyles.body12Regular.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                            Text(
                              '01/01/2026',
                              style: AppStyles.body14Regular.copyWith(
                                color: AppColors.neutral900,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 2,
                          children: [
                            Text(
                              'Selesai',
                              style: AppStyles.body12Regular.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                            Text(
                              '30/04/2026',
                              style: AppStyles.body14Regular.copyWith(
                                color: AppColors.neutral900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow('Dinas', 'Dinas PUPR'),
                    _buildInfoRow('Lokasi', 'Surabaya'),
                    _buildInfoRow('Nilai Proyek', 'Rp 500.000.000'),
                    _buildStatus(),
                  ],
                ),
              ),

              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow('Tanggal Mulai', '01 Januari 2026'),
                    _buildInfoRow('Tanggal Berakhir', '30 April 2026'),
                    _buildInfoRow('Durasi Pekerjaan', '120 Hari'),
                  ],
                ),
              ),

              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow('Estimasi Pengeluaran', 'Rp 200.000.000'),
                    _buildInfoRow('Pengeluaran Saat Ini', 'Rp 120.000.000'),
                    _buildInfoRow('Sisa Budget', 'Rp 80.000.000'),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Indicator Bar:',
                      style: AppStyles.body16Bold.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '60% Dari Estimasi',
                        style: AppStyles.body12SemiBold.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(4),
                      backgroundColor: AppColors.neutral200,
                      color: AppColors.primary300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.body14Regular.copyWith(color: AppColors.grey500),
          ),
          Text(
            value,
            style: AppStyles.body14Regular.copyWith(
              color: AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status',
          style: AppStyles.body14Regular.copyWith(color: AppColors.grey500),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.setujuButton,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.successBorder),
          ),
          child: Text(
            'Aktif',
            style: AppStyles.body12Medium.copyWith(
              color: AppColors.setujuTextButton,
            ),
          ),
        ),
      ],
    );
  }
}
