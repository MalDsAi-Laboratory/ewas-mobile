import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "scrapit-1826c",
          "private_key_id": "eb9170d619e2803d6414fcd49c6506943119780d",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDQtPBB3eA/LGSr\nRWAV0dd8GyNJMCYKZyl43aPinTBkNFTbNr666m/1tLgnuxIkcbFKqBahtUrba7Eh\nAD6slVZ6GouObJIj6B4eZeq8AJ9dYQVO2g8BJ3IUtcTxWDRuJ7bSJH6iN6y7RL2d\nBoMawRUDYjv13V4IBr2rtS5ySNDz7GkhxWVVACJLZrdqjADAio9KK3v0PomqAm1/\nqsh7BkUqrKeQ7rJCVs8SeVw4Q2ZeYE5JUOPu90W2VyiSsll2QQfcUH63rrA4iqUb\nUgfGFnUITJiWrqrWLBTUrqDUSZuAM01tznOj6cU2mzAqTqQl/CCYQbGhRAMNs5Jz\ngfTbuwHNAgMBAAECggEACa+CoIqSNq78pgPPHibHTAu7Xbu7DDZg6D/K9FWXUmh+\nUU+6AWp8qH0K+HximWfgUoa4ntJkcgiOUhR/lBqjG9a3CB9K7Jkqqqj6qt+8MEUe\nzgZpy1kqtBeCbLE1+lsOot54NQGF8Ik+Y8w9UdoeO50NC3o1kVmfZu7+g+W+srnT\nXjtPrRMrJyC+/XEpYjtaafyfO32y/9a/CjsFvg71Lflah0o6S55UcTJboQA0UOhS\nxMlcdRm/ZacUPydyCv4zfIpO2L5i6uXJtlPdsZDiV81eGUsnXea2RVMZXn9v3iDY\nxrp3wUIrd/cNAVvWtRwAMiE6rqeT4TBlz6cK/Lul4QKBgQD4Cdi+sYU97hPkC9U7\nEymHdOpsO9r2dgceAcYFvZSZkxiqTWfzH+vOjXyszYOrfZy7J9gz+rHzql+RQ6x8\neillpMLuXUijxGmlE6scwHSSg//Xj0VMc5z+U95gu+w4B8BNOr0R6keXvG/9HThu\nKrOgSkMXbinib5/DA2+O2ZJCbQKBgQDXZ+ZuFcbWZSyLvQd3DJeGuH/l20iiTTSU\nB7ueA3NgMcNZd+bDzgv3r6+MxXbuIsqoiTyYtkvi1GxRKtdT9YNwEprkvM2mYtQU\nT/2c2oe1TRY2W3FA1hPRjomO6Au2LWZDjR4e/knernj56AshN3gd0DFcA4mU1B69\nECvDrMUg4QKBgDp6P9J9kddO+PuL2qLJ2sGny9jmp7Hxk638Zw5VauJmLquAAmDs\nhrC05M7syP02aSwqsatXkHrNESjzVogmWPowxRBjh8usc+fKYk4uBY3BdyEAEyt6\nGmpPpZ8SzxdKpIjQr2C45lYcxB5dtD8s7Bp/R6APhepvvK/CcJuyKexlAoGBAKKK\nj3HwUstDKxsC99gYk1qgbDpZfvShx5QQRb3VosEqq9seQ+7q01MCqjhSZQ0LCdul\nOymNHbQ7UMTqy/NZ5uWx1FnYMmJkXt45AgnTSOZBFgrMc6hWIjxWD2zbosLEfU9p\n9Bm1Dq7O/xCszYEyJxxwFl71eGLqsYs+4ZdVDqdhAoGBAMRN8MXFuOIJhvzCZG8j\nITNep+hBs3JH8N8K5WNC528iKosAGE2/PJHTgMkXFNiqQaoPRcEcIXiL4w5QkmXn\nYb6WiDQplyaAJc+J87lI/DHzIEL5GwTxsW57EWGovfK9dOJk3Muja9En2qz+Rtw+\nTr7n7s9+BnX8k4a1LUihKHQU\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@scrapit-1826c.iam.gserviceaccount.com",
          "client_id": "102614684349027217087",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40scrapit-1826c.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
