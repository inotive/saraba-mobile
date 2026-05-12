import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';

extension PengeluaranCategoryX on PengeluaranCategory {
  String get label {
    switch (this) {
      case PengeluaranCategory.operasional:
        return 'Operasional';
      case PengeluaranCategory.material:
        return 'Material';
      case PengeluaranCategory.pettyCash:
        return 'Petty Cash';
    }
  }

  String get iconAsset {
    switch (this) {
      case PengeluaranCategory.operasional:
        return 'assets/icons/ic_pengeluaran_operasional.png';
      case PengeluaranCategory.material:
        return 'assets/icons/ic_pengeluaran_material.png';
      case PengeluaranCategory.pettyCash:
        return 'assets/icons/ic_pengeluaran_petty_cash.png';
    }
  }

  String get categorySheetIconAsset {
    switch (this) {
      case PengeluaranCategory.operasional:
        return 'assets/icons/ic_kategori_operasional.png';
      case PengeluaranCategory.material:
        return 'assets/icons/ic_kategori_material.png';
      case PengeluaranCategory.pettyCash:
        return 'assets/icons/ic_kategori_petty_cash.png';
    }
  }
}
