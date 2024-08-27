import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:dima/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock FirebaseAuth instance
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

Future<void> main() async {
  
  group('AuthenticationService', () {
    //WidgetsFlutterBinding.ensureInitialized();
    //Firebase.initializeApp();
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = AuthService();
    });

    test('signUpUser returns a UserModel if signup successful', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'email', password: 'password'))
          .thenAnswer((_) async => FakeUserCredential());

      final result = await authService.signUpWithEmailAndPassword('username', 'email', 'password');

      expect(result, isA<User_model>());
    });

    test('signUpUser returns null if signup fails', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'email', password: 'password'))
          .thenThrow(FirebaseAuthException(code: 'error'));

      final result = await authService.signUpWithEmailAndPassword('username', 'email', 'password');

      expect(result, null);
    });
  });
}

// Fake implementation of UserCredential for mocking
class FakeUserCredential extends Fake implements UserCredential {
  @override
  User get user => FakeUser();
}

// Fake implementation of User for mocking
class FakeUser extends Fake implements User {
  @override
  String get uid => 'fakeUid';

  @override
  String get email => 'fake@example.com';

  @override
  String? get displayName => 'Fake User';
}
