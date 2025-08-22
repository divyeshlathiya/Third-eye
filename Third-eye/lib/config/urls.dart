class ConfigURL {
  // static final apiURL = "http://10.47.125.29:8000/auth/register";
  static const base = "http://192.168.1.111:8000";
  static const loginURL = "$base/auth/login";
  static const signUpURL = "$base/auth/register";
  static const sendOtpURL = "$base/auth/send-otp";
  static const verifyOtpURL = "$base/auth/verify-otp";
  static const signWithGoogleURL = "$base/auth/google-sign-in";
}
