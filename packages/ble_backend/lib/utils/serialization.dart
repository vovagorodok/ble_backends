import 'dart:typed_data';

class MaxValue {
  static const uint8 = 0xFF;
  static const uint16 = 0xFFFF;
  static const uint32 = 0xFFFFFFFF;
}

class BytesSize {
  static const uint8 = 1;
  static const uint16 = 2;
  static const uint32 = 4;
}

Uint8List uint8ToBytes(int value) =>
    Uint8List(BytesSize.uint8)..buffer.asByteData().setUint8(0, value);

Uint8List uint16ToBytes(int value) => Uint8List(BytesSize.uint16)
  ..buffer.asByteData().setUint16(0, value, Endian.little);

Uint8List uint32ToBytes(int value) => Uint8List(BytesSize.uint32)
  ..buffer.asByteData().setUint32(0, value, Endian.little);

int bytesToUint8(Uint8List data, int offset) =>
    ByteData.sublistView(data).getUint8(offset);

int bytesToUint16(Uint8List data, int offset) =>
    ByteData.sublistView(data).getUint16(offset, Endian.little);

int bytesToUint32(Uint8List data, int offset) =>
    ByteData.sublistView(data).getUint32(offset, Endian.little);

List<bool> byteToBits(int byte, int size) {
  return List.generate(size, (i) => (byte & (1 << i)) != 0);
}

int bitsToByte(List<bool> bits) {
  int value = 0;
  for (int i = 0; i < bits.length; i++) {
    if (bits[i]) value |= (1 << i);
  }
  return value;
}
