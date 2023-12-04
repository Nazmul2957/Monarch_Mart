class WalletBalanceResponse {
  String? balance;
  String? lastRecharged;

  WalletBalanceResponse({this.balance, this.lastRecharged});

  WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    lastRecharged = json['last_recharged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['last_recharged'] = this.lastRecharged;
    return data;
  }
}
