class CurrencyModel {
  double? rate;
  From? from;
  To? to;
  int? timestamp;

  CurrencyModel({this.rate, this.from, this.to, this.timestamp});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    from = json['from'] != null ? new From.fromJson(json['from']) : null;
    to = json['to'] != null ? new To.fromJson(json['to']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    if (this.from != null) {
      data['from'] = this.from!.toJson();
    }
    if (this.to != null) {
      data['to'] = this.to!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class From {
  int? rate;
  String? currency;

  From({this.rate, this.currency});

  From.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['currency'] = this.currency;
    return data;
  }
}

class To {
  double? rate;
  String? currency;

  To({this.rate, this.currency});

  To.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['currency'] = this.currency;
    return data;
  }
}