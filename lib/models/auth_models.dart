class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class CreateAccountRequest {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  CreateAccountRequest({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    };
  }
}

class OTPRequest {
  final String email;

  OTPRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class OTPVerifyRequest {
  final String email;
  final String otpCode;

  OTPVerifyRequest({
    required this.email,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp_code': otpCode,
    };
  }
}

class AuthResponse {
  final String? token;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  AuthResponse({
    this.token,
    this.refreshToken,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? json['access'] ?? json['access_token'],
      refreshToken: json['refresh_token'] ?? json['refresh'],
      user: json['user'],
    );
  }
}

class UserProfile {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatar;

  UserProfile({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? json['firstName'],
      lastName: json['last_name'] ?? json['lastName'],
      phone: json['phone'],
      avatar: json['avatar'] ?? json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'avatar': avatar,
    };
  }
}

