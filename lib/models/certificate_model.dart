class Certificate {
  final String title;

  final String issuer;

  final String validUntil;

  final bool isVerified;

  Certificate({
    required this.title,

    required this.issuer,

    required this.validUntil,

    required this.isVerified,
  });
}
