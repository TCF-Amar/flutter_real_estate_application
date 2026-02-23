num? toNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}

double? toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  return double.tryParse(v.toString());
}

int? toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

String? toStr(dynamic v) {
  if (v == null) return null;
  return v.toString();
}
