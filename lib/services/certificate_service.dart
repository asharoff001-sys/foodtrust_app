import '../models/certificate_model.dart';

class CertificateService {
  static final List<Certificate> certificates = [
    Certificate(
      title: 'Halal Certified',

      issuer: 'Bangladesh Halal Authority',

      validUntil: 'December 2027',

      isVerified: true,
    ),

    Certificate(
      title: 'Food Safety Approved',

      issuer: 'Food Safety Department',

      validUntil: 'August 2026',

      isVerified: true,
    ),

    Certificate(
      title: 'Organic Product Verified',

      issuer: 'Organic Food Council',

      validUntil: 'March 2027',

      isVerified: false,
    ),
  ];

  static List<Certificate> getVerifiedCertificates() {
    return certificates.where((certificate) => certificate.isVerified).toList();
  }
}
