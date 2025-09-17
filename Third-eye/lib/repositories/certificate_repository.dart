import 'dart:typed_data';
import 'package:thirdeye/services/certificate_service.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class CertificateRepository {
  Future<Uint8List?> getCertificate() async {
    final accessToken = await StorageHelper.getToken('access_token');
    if (accessToken == null) return null;

    return await CertificateService.fetchCertificate(accessToken);
  }
}
