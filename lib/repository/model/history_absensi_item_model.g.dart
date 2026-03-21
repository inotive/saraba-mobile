// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_absensi_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbsensiItemAdapter extends TypeAdapter<AbsensiItem> {
  @override
  final int typeId = 1;

  @override
  AbsensiItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbsensiItem(
      id: fields[0] as String,
      tanggal: fields[1] as String,
      jamMasuk: fields[2] as String,
      jamKeluar: fields[3] as String,
      durasiKerja: fields[4] as String,
      status: fields[5] as String,
      keterangan: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AbsensiItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tanggal)
      ..writeByte(2)
      ..write(obj.jamMasuk)
      ..writeByte(3)
      ..write(obj.jamKeluar)
      ..writeByte(4)
      ..write(obj.durasiKerja)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.keterangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbsensiItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
