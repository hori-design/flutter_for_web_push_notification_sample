typedef SubscriptionDataType = ({
  String endpoint,
  String p256dh,
  String auth,
});

typedef SubscribeResultType = ({
  SubscriptionDataType? data,
  String code,
});
