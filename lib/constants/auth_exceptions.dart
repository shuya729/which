const Map<String, String> authExceptions = {
  // FirebaseAuthInvalidUserException
  'error-user-disabled': '無効なユーザーです。',
  'error-user-not-found': 'ユーザーが見つかりません。',
  'error-user-token-expired': 'ユーザートークンが期限切れです。',
  'error-invalid-user-token': '無効なユーザートークンです。',
  // FirebaseAuthUserCollisionException
  'error-email-already-in-use': 'このメールアドレスは既に使用されています。',
  'error-account-exists-with-different-credential': 'このメールアドレスは既に使用されています。',
  'error-credential-already-in-use': 'このアカウントは既に使用されています。',
  // FirebaseAuthWebException
  'error-web-context-already-presented': '別のWeb操作が既に進行中です。',
  'error-web-context-cancelled': 'Web操作がキャンセルされました。',
  'error-web-storage-unsupported': 'Webストレージがサポートされていません。',
  'error-web-internal-error': '内部エラーが発生しました。',
};
