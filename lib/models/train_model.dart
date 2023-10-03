class TrainModel {
  final List<String> base64Images;
  final String tag;

  TrainModel({required this.base64Images, required this.tag});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['base64Images'] = base64Images;
    data['tag'] = tag;
    return data;
  }
}
