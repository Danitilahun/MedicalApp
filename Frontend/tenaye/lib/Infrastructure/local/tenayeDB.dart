import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tenaye/domain/appointment/appointment.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/rating/rating.dart';
import 'package:tenaye/domain/user/user.dart';

class TenayeDB {
  final int version = 2;
  Database? db;

  static final TenayeDB _dbHelper = TenayeDB._internal();
  TenayeDB._internal();
  factory TenayeDB() {
    return _dbHelper;
  }

  Future<Database?> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'tenamdlkm.db'),
          onCreate: (database, version) {
        database.execute('''
          CREATE TABLE user(
            _id TEXT PRIMARY KEY,
            email TEXT,
            username TEXT,
            password TEXT,
            image TEXT,
            location TEXT,
            refreshToken TEXT,
            accessToken TEXT,
            role TEXT
          )
        ''');

        database.execute('''
  CREATE TABLE doctor(
    id TEXT PRIMARY KEY,
    username TEXT,
    email TEXT,
    profileImage TEXT,
    phoneNumber TEXT,
    specialization TEXT,
    feePerConsultation INTEGER,
    certificate TEXT,
    certificateStatus TEXT,
    city TEXT,
    country TEXT,
    experience TEXT,
    numberOfPeopleRateThisDoctor INTEGER,
    sumOfRating INTEGER,
    rating REAL
  )
''');

        database.execute('''
          CREATE TABLE appointment(
            id TEXT PRIMARY KEY,
            userId TEXT,
            doctorId TEXT,
            date TEXT,
            time TEXT,
            reason TEXT,
            message TEXT,
            reply TEXT
          )
        ''');

        database.execute('''
          CREATE TABLE rating(
            id TEXT PRIMARY KEY,
            doctorId TEXT,
            userId TEXT,
            message TEXT,
            rating REAL
          )
        ''');
      }, onUpgrade: (database, oldVersion, newVersion) {
        if (oldVersion < 2) {
          database.execute(
              'ALTER TABLE user ADD COLUMN refreshToken TEXT DEFAULT ""');
        }
      }, version: version);
    }
    return db;
  }

  Future<int?> insertUser(User user) async {
    // Delete existing user
    await db!.delete('user');

    // Create a new database
    await db!.execute('DROP TABLE IF EXISTS user');
    await db!.execute('''
      CREATE TABLE user(
        id TEXT PRIMARY KEY,
        email TEXT,
        username TEXT,
        password TEXT,
        image TEXT,
        location TEXT,
        refreshToken TEXT,
        accessToken TEXT,
        role TEXT
      )
    ''');

    int? id = await db?.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteUser(String userId) async {
    int result = await db!.delete("user", where: "id = ?", whereArgs: [userId]);
    return result;
  }

  Future<User?> getUser(String userId) async {
    final List<Map<String, dynamic>> maps =
        await db!.query('user', where: 'id = ?', whereArgs: [userId]);

    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);
      return user;
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    int result = await db!.update(
      'user',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result;
  }

  Future<int> updateUserProfile(User user) async {
    int result = await db!.update(
      'user',
      {
        'username': user.username,
        'password': user.password,
        'email': user.email,
        'image': user.image,
        'location': user.location,
      },
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result;
  }

  Future<int> updateUserProfileImg(User user) async {
    int result = await db!.update(
      'user',
      {
        'image': user.image,
      },
      where: "id = ?",
      whereArgs: [user.id],
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', user.image);

    return result;
  }

  Future<void> insertDoctors(List<Doctor> doctors) async {
    final List<Map<String, Object?>>? rows =
        await this.db?.query('doctor', orderBy: 'id');
    final int maxDoctors = 5; // Maximum number of doctors to store in the table

    if (rows!.length >= maxDoctors) {
      // Check if new doctors have higher ratings than the doctors with the lowest ratings
      final List<Doctor> sortedDoctors = List<Doctor>.from(doctors)
        ..sort((a, b) => a.rating!.compareTo(b.rating!));
      final double minRating = rows.first['rating'] as double;

      if (sortedDoctors.last.rating! <= minRating) {
        return; // Don't add the doctors to the table
      }

      final List<String> doctorIdsToDelete = rows
          .sublist(0, doctors.length)
          .map<String>((row) => row['id'] as String)
          .toList();

      await this.db?.transaction<void>((txn) async {
        for (String doctorIdToDelete in doctorIdsToDelete) {
          await txn
              .delete('doctor', where: 'id = ?', whereArgs: [doctorIdToDelete]);
        }

        for (Doctor doctor in doctors) {
          await txn.insert(
            'doctor',
            doctor.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } else {
      await this.db?.transaction<void>((txn) async {
        for (Doctor doctor in doctors) {
          await txn.insert(
            'doctor',
            doctor.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    }
  }

  Future<int?> insertDoctor(Doctor doctor) async {
    final List<Map<String, Object?>>? rows =
        await this.db?.query('doctor', orderBy: 'id');
    if (rows!.length >= 5) {
      // Check if new doctor has a higher rating than the doctor with the smallest rating
      final double minRating = rows.first['rating'] as double;
      if (doctor.rating != null && doctor.rating! > minRating) {
        final String doctorIdToDelete = rows.first['id'] as String;
        await this
            .db
            ?.delete('doctor', where: 'id = ?', whereArgs: [doctorIdToDelete]);
      } else {
        return null; // Don't add the doctor to the table
      }
    }

    int? id = await this.db?.insert(
          'doctor',
          doctor.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<Doctor>?> getDoctors() async {
    final List<Map<String, Object?>>? maps =
        await this.db?.query('doctor', orderBy: 'id');
    return List.generate(maps!.length, (i) {
      return Doctor.fromMap(maps[i]);
    });
  }

  Future<Doctor?> getDoctorById(String doctorId) async {
    final List<Map<String, Object?>>? maps =
        await this.db?.query('doctor', where: 'id = ?', whereArgs: [doctorId]);
    if (maps!.isNotEmpty) {
      return Doctor.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteDoctor(String doctorId) async {
    int result =
        await db!.delete("doctor", where: "id = ?", whereArgs: [doctorId]);
    return result;
  }

  Future<int> updateCertificate(String doctorId, Uint8List certificate) async {
    int result = await db!.update(
      'doctor',
      {'certificate': certificate},
      where: "id = ?",
      whereArgs: [doctorId],
    );
    return result;
  }

  Future<int> updateProfileImg(String doctorId, Uint8List profileImage) async {
    int result = await db!.update(
      'doctor',
      {'profileImage': profileImage},
      where: "id = ?",
      whereArgs: [doctorId],
    );
    return result;
  }

  Future<int> updateDoctor(Doctor doctor) async {
    int result = await db!.update(
      'doctor',
      {
        'username': doctor.username,
        'email': doctor.email,
        'profileImage': doctor.profileImage,
        'phoneNumber': doctor.phoneNumber,
        'specialization': doctor.specialization,
        'feePerConsultation': doctor.feePerConsultation,
        'certificate': doctor.certificate,
        'certificateStatus': doctor.certificateStatus,
        'city': doctor.city,
        'country': doctor.country,
        'experience': doctor.experience,
      },
      where: "id = ?",
      whereArgs: [doctor.id],
    );
    return result;
  }

  // Appointment Table CRUD Operations

  Future<int?> insertAppointment(Appointment appointment) async {
    int? id = await this.db?.insert(
          'appointment',
          appointment.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<Appointment>> getAppointments() async {
    final List<Map<String, dynamic>> maps =
        await db!.query('appointment', orderBy: 'id');
    return List.generate(maps.length, (i) {
      return Appointment.fromMap(maps[i]);
    });
  }

  Future<int> updateAppointment(Appointment appointment) async {
    int result = await db!.update(
      'appointment',
      {
        'userId': appointment.userId,
        'doctorId': appointment.doctorId,
        'date': appointment.date,
        'time': appointment.time,
        'reason': appointment.reason,
        'message': appointment.message,
        'reply': appointment.reply,
      },
      where: "id = ?",
      whereArgs: [appointment.id],
    );
    return result;
  }

  Future<int> deleteAppointment(String appointmentId) async {
    int result = await db!
        .delete("appointment", where: "id = ?", whereArgs: [appointmentId]);
    return result;
  }

  // Rating Table CRUD Operations

  Future<int?> insertRating(Rating rating) async {
    int? id = await this.db?.insert(
          'rating',
          rating.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

    if (id != null) {
      await updateDoctorRating(rating.doctorId!);
    }

    return id;
  }

  Future<int> updateDoctorRating(String doctorId) async {
    final List<Map<String, Object?>>? rows = await this
        .db
        ?.query('rating', where: 'doctorId = ?', whereArgs: [doctorId]);

    int numberOfPeopleRateThisDoctor = rows!.length;
    int sumOfRating = 0;
    for (final row in rows) {
      sumOfRating += row['rating'] as int;
    }

    int result = await db!.update(
      'doctor',
      {
        'numberOfPeopleRateThisDoctor': numberOfPeopleRateThisDoctor,
        'sumOfRating': sumOfRating,
        'rating': numberOfPeopleRateThisDoctor > 0
            ? sumOfRating / numberOfPeopleRateThisDoctor
            : 0,
      },
      where: "id = ?",
      whereArgs: [doctorId],
    );
    return result;
  }

  Future<List<Rating>> getRatings() async {
    final List<Map<String, Object?>>? maps =
        await this.db?.query('rating', orderBy: 'id');
    return List.generate(maps!.length, (i) {
      return Rating.fromMap(maps[i]);
    });
  }

  Future<int> deleteRating(String ratingId) async {
    int result =
        await db!.delete("rating", where: "id = ?", whereArgs: [ratingId]);
    return result;
  }
}
