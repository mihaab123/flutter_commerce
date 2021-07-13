class LiqpayCheckout {
  final int version;
  final int amount;
  final String public_key;
  final String action;
  final String currency;
  final String description;
  final String order_id;

  LiqpayCheckout(this.version, this.public_key,this.action,this.amount,this.currency,this.description,this.order_id);

  LiqpayCheckout.fromJson(Map<String, dynamic> json)
      : version = json['version'] as int,
        public_key = json['public_key'] as String,
        amount = json['amount'] as int,
        currency = json['currency'] as String,
        description = json['description'] as String,
        order_id = json['order_id'] as String,
        action = json['action'] as String;

  Map<String, dynamic> toJson() => {
    'version': version,
    'public_key': public_key,
    'amount': amount,
    'action': action,
    'currency': currency,
    'description': description,
    'order_id': order_id,
  };
}