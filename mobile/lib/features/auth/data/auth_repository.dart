import '../../../core/network/api_client.dart';
import 'app_user.dart';

class AuthRepository {
  final ApiClient apiClient;
  AuthRepository(this.apiClient);

  Future<void> requestOtp(String telephone) async {
    await apiClient.dio.post('/auth/request-otp', data: {'telephone': telephone});
  }

  Future<({String token, AppUser user})> verifyOtp(String telephone, String code) async {
    final response = await apiClient.dio.post('/auth/verify-otp', data: {
      'telephone': telephone,
      'code': code,
    });
    final data = response.data as Map<String, dynamic>;
    return (token: data['token'] as String, user: AppUser.fromJson(data['user']));
  }

  Future<void> requestOtpEmail(String email) async {
    await apiClient.dio.post('/auth/email/request-otp', data: {'email': email});
  }

  Future<({String token, AppUser user})> verifyOtpEmail(String email, String code) async {
    final response = await apiClient.dio.post('/auth/email/verify-otp', data: {
      'email': email,
      'code': code,
    });
    final data = response.data as Map<String, dynamic>;
    return (token: data['token'] as String, user: AppUser.fromJson(data['user']));
  }
}