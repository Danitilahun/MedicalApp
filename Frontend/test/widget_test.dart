import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:tenaye/application/doctor/doctor_event.dart';
import 'package:tenaye/application/user/user_state.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/main.dart';
import 'package:tenaye/presentation/doctor_text_edit.dart';
import 'package:tenaye/presentation/appointmentListScreen.dart';
import 'package:tenaye/presentation/bookAppointment.dart';
import 'package:tenaye/presentation/doctorAppointment_list.dart';
import 'package:tenaye/presentation/doctorDashboard.dart';
import 'package:tenaye/domain/user/user.dart';
import 'package:tenaye/application/user/user_bloc.dart';
import 'package:tenaye/presentation/login.dart';
import 'package:tenaye/presentation/profile.dart';

@GenerateMocks([ProfileBloc])
void main() {
  
testWidgets('Edit Doctor Profile form test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  final usernameField = find.byKey(Key('add username'));
  final emailField = find.byKey(Key('add email'));
  final specializationField = find.byKey(Key('add specialization'));
  final phoneNumberField = find.byKey(Key('add phone number'));
  final feeField = find.byKey(Key('add fee'));
  final cityField = find.byKey(Key('add city'));
  final countryField = find.byKey(Key('add country'));

  await tester.enterText(usernameField, 'John');
  await tester.enterText(emailField, 'john@example.com');
  await tester.enterText(specializationField, 'Cardiology');
  await tester.enterText(phoneNumberField, '1234567890');
  await tester.enterText(feeField, '100');
  await tester.enterText(cityField, 'New York');
  await tester.enterText(countryField, 'USA');
  

  await tester.tap(find.text('Save'));

  await tester.pump();

  expect((usernameField.evaluate().single.widget as TextFormField).controller?.text, '');
  expect((emailField.evaluate().single.widget as TextFormField).controller?.text, '');
  expect((specializationField.evaluate().single.widget as TextFormField).controller?.text, '');
  expect((phoneNumberField.evaluate().single.widget as TextFormField).controller?.text, '');
  expect((feeField.evaluate().single.widget as TextFormField).controller?.text, '');
  expect((cityField.evaluate().single.widget as TextFormField).controller?.text, '');
  expect((countryField.evaluate().single.widget as TextFormField).controller?.text, '');
});

testWidgets('Profile screen test', (WidgetTester tester) async {
  // Create a mock user
  final user = User(
    id: "1",
    email: 'abebe@example.com',
    location: 'Addis Ababa',
    username: 'abebe',
    image: 'abebe.jpg',
    password: "abebe123"

  );

  final profileBloc = MockProfileBloc();
  when(profileBloc.state).thenReturn(ProfileLoadedState(user));

  await tester.pumpWidget(
    BlocProvider<ProfileBloc>.value(
      value: profileBloc,
      child: MaterialApp(
        home: ProfilePage(),
      ),
    ),
  );

  expect(find.text('Email: ${user.email}'), findsOneWidget);
  expect(find.text('Location: ${user.location}'), findsOneWidget);
  expect(find.text('Username: ${user.username}'), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, 'Edit Profile'));
  await tester.pumpAndSettle();

  expect(find.byType(UpdateProfilePage), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, 'Delete Account'));
  await tester.pumpAndSettle();

  expect(find.byType(AlertDialog), findsOneWidget);

  await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
  await tester.pumpAndSettle();

  expect(find.byType(AlertDialog), findsNothing);

  await tester.tap(find.widgetWithText(TextButton, 'Delete'));
  await tester.pumpAndSettle();

  verify(profileBloc.add()).called(1);

  expect(find.byType(AlertDialog), findsNothing);

  expect(find.byIcon(Icons.logout), findsOneWidget);

  await tester.tap(find.byIcon(Icons.logout));
  await tester.pumpAndSettle();

  expect(find.byType(LoginPage), findsOneWidget);
});

late MockProfileBloc mockProfileBloc;
  setUp(() {
    mockProfileBloc = MockProfileBloc();
  });
  group('ProfilePage', () {
    testWidgets('displays user profile and allows editing', (WidgetTester tester) async {
      final user = User(
        id: '1',
        email: 'john@example.com',
        location: 'New York',
        username: 'John',
        image: 'john.jpg',
        password: 'john123'
      );

      final profileBloc = MockProfileBloc();
      when(profileBloc.state).thenReturn(ProfileLoadedState(user));

      await tester.pumpWidget(
        BlocProvider<ProfileBloc>.value(
          value: profileBloc,
          child: MaterialApp(
            home: ProfilePage(),
          ),
        ),
      );

      expect(find.text('Email: ${user.email}'), findsOneWidget);
      expect(find.text('Location: ${user.location}'), findsOneWidget);
      expect(find.text('Username: ${user.username}'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Edit Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(UpdateProfilePage), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pumpAndSettle();

      verify(profileBloc.add()).called(1);
    });
  });
}
