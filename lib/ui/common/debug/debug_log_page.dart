import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';

class DebugLogPage extends StatelessWidget {
  const DebugLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Debug Logs',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: AppLogger.exportText()),
              );

              if (!context.mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Log berhasil disalin')),
              );
            },
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Salin',
          ),
          IconButton(
            onPressed: () {
              AppLogger.clear();
            },
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Bersihkan',
          ),
        ],
      ),
      body: ValueListenableBuilder<List<AppLogEntry>>(
        valueListenable: AppLogger.entries,
        builder: (context, entries, _) {
          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada log',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          final items = entries.reversed.toList(growable: false);

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = items[index];
              return _DebugLogCard(entry: entry);
            },
          );
        },
      ),
    );
  }
}

class _DebugLogCard extends StatelessWidget {
  final AppLogEntry entry;

  const _DebugLogCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final color = switch (entry.level) {
      AppLogLevel.request => const Color(0xFF2563EB),
      AppLogLevel.response => const Color(0xFF15803D),
      AppLogLevel.error => const Color(0xFFDC2626),
      AppLogLevel.info => const Color(0xFF6B7280),
    };

    final label = switch (entry.level) {
      AppLogLevel.request => 'REQUEST',
      AppLogLevel.response => 'RESPONSE',
      AppLogLevel.error => 'ERROR',
      AppLogLevel.info => 'INFO',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.tag,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Text(
                DateFormat('HH:mm:ss').format(entry.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            entry.message,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
