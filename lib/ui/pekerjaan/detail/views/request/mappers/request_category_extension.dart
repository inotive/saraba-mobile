import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_category.dart';

extension RequestCategoryExtension on RequestCategory {
  String get label {
    switch (this) {
      case RequestCategory.operasional:
        return 'Operasional';
      case RequestCategory.material:
        return 'Material';
    }
  }

  String get iconAsset {
    switch (this) {
      case RequestCategory.operasional:
        return 'assets/icons/ic_pengeluaran_operasional.png';

      case RequestCategory.material:
        return 'assets/icons/ic_pengeluaran_material.png';
    }
  }

  String get submitValue {
    switch (this) {
      case RequestCategory.operasional:
        return 'operasional';

      case RequestCategory.material:
        return 'material';
    }
  }
}

RequestCategory requestCategoryFromString(String value) {
  switch (value.toLowerCase()) {
    case 'material':
      return RequestCategory.material;

    case 'operasional':
    default:
      return RequestCategory.operasional;
  }
}
