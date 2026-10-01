import 'package:flutter_test/flutter_test.dart';
import 'package:saraba_mobile/repository/model/project/pekerjaan_list_response_model.dart';
import 'package:saraba_mobile/repository/model/project/turnamen_detail_response_model.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';

void main() {
  group('PekerjaanListResponse', () {
    final json = {
      'success': true,
      'message': 'ok',
      'data': {
        'items': [
          {
            'type': 'turnamen',
            'id': 5,
            'title': 'Gubernur Cup',
            'jumlah_pemain': 2,
            'nilai_pengeluaran': '1260000.00',
          },
          {
            'type': 'proyek',
            'id': 15,
            'title': 'Renovasi Mess',
            'progress': 40,
            'nilai_proyek': '1000000.00',
            'nilai_pengeluaran': '250000.00',
          },
        ],
        'pagination': {
          'current_page': 1,
          'last_page': 3,
          'per_page': 10,
          'total': 25,
        },
      },
    };

    test('parses both kinds and pagination', () {
      final response = PekerjaanListResponse.fromJson(json);

      expect(response.data.items, hasLength(2));
      expect(response.data.items[0].isTurnamen, isTrue);
      expect(response.data.items[0].jumlahPemain, 2);
      expect(response.data.items[1].isTurnamen, isFalse);
      expect(response.data.items[1].progress, 40);
      expect(response.data.pagination.lastPage, 3);
    });

    test('maps turnamen without progress/nilai and proyek with them', () {
      final models = PekerjaanService().mapPekerjaanToProjectModels(
        PekerjaanListResponse.fromJson(json).data.items,
      );

      final turnamen = models[0];
      expect(turnamen.type, ProjectType.turnamen);
      expect(turnamen.progress, 0);
      expect(turnamen.jumlahPemain, 2);
      expect(turnamen.pengeluaran, contains('1.260.000'));

      final proyek = models[1];
      expect(proyek.type, ProjectType.proyek);
      expect(proyek.progress, 0.4);
      expect(proyek.nilai, contains('1.000.000'));
      expect(proyek.jumlahPemain, 0);
    });

    test('missing fields fall back to safe defaults', () {
      final item = PekerjaanItem.fromJson(const {});

      expect(item.type, 'proyek');
      expect(item.id, 0);
      expect(item.title, '');
      expect(item.nilaiPengeluaran, '0');
    });
  });

  test('ProjectModel keeps proyek defaults for existing callers', () {
    const model = ProjectModel(
      id: '1',
      title: 'Proyek',
      progress: 0.5,
      nilai: 'Rp 1',
      pengeluaran: 'Rp 2',
    );

    expect(model.type, ProjectType.proyek);
    expect(model.isTurnamen, isFalse);
    expect(model.jumlahPemain, 0);
  });

  test('PekerjaanFilter sends the value the API expects', () {
    expect(PekerjaanFilter.all.apiValue, 'all');
    expect(PekerjaanFilter.proyek.apiValue, 'proyek');
    expect(PekerjaanFilter.turnamen.apiValue, 'turnamen');
  });

  test('TurnamenDetailResponse parses overview, pemain and pengeluaran', () {
    final response = TurnamenDetailResponse.fromJson({
      'success': true,
      'message': 'ok',
      'data': {
        'overview': {
          'id': 5,
          'nama_turnamen': 'Gubernur Cup',
          'tanggal_mulai': '2026-10-08',
          'lapangan': 'Stadion Pembataan',
          'keterangan': null,
          'total_pemain': 1,
          'total_pengeluaran': 3600000,
        },
        'pemain': [
          {'id': 25, 'nama_pemain': 'Edwin', 'no_rekening': '123'},
        ],
        'pengeluaran': {
          'total_pengeluaran': 3600000,
          'pemain': [
            {
              'pemain_id': 25,
              'nama_pemain': 'Edwin',
              'items_count': 1,
              'total': 3600000,
              'items': [
                {
                  'id': 11,
                  'nama_item': 'Air',
                  'qty': 3,
                  'satuan': 'DUS',
                  'harga_satuan': 1200000,
                  'total': 3600000,
                },
              ],
            },
          ],
        },
      },
    });

    final data = response.data;
    expect(data.overview.namaTurnamen, 'Gubernur Cup');
    expect(data.overview.keterangan, '');
    expect(data.overview.totalPengeluaran, 3600000);
    expect(data.pemain.single.noRekening, '123');
    expect(data.pemain.single.email, '');
    expect(data.pengeluaran.pemain.single.items.single.qty, 3);
    expect(data.pengeluaran.pemain.single.items.single.hargaSatuan, 1200000);
  });
}
