class PredictionModel {
  final String base64string;

  PredictionModel({required this.base64string});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['base64string'] = base64string;
    return data;
  }
}
