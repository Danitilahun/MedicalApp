import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/doctor_list/doctor_list_bloc.dart';
import 'package:tenaye/application/doctor_list/doctor_list_event.dart';
import 'package:tenaye/application/doctor_list/doctor_list_state.dart';
import 'package:tenaye/domain/doctorList/doctor_repository.dart';
import 'package:tenaye/presentation/doctorDetail.dart';

class DoctorsListPage extends StatefulWidget {
  @override
  _DoctorsListPageState createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    BlocProvider.of<DoctorBloc>(context).add(FetchDoctors());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    BlocProvider.of<DoctorBloc>(context).add(SearchDoctors(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is DoctorsLoaded) {
                  final doctors = state.doctors;
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: doctor.profileImage != null
                                  ? NetworkImage(
                                      'http://10.0.2.2:3000/images/${doctor.profileImage}')
                                  : AssetImage('assets/avator.jpg')
                                      as ImageProvider<Object>,
                              radius: 40,
                            ),
                            Text(doctor.username!),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorDetailsPage(doctor: doctor),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is DoctorsLoadFailure) {
                  return Center(
                    child: Text('Failed to load doctors.'),
                  );
                } else if (state is SearchResultsLoaded) {
                  final searchResults = state.searchResults;
                  return ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final doctor = searchResults[index];
                      return ListTile(
                        title: Text(doctor.username!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorDetailsPage(doctor: doctor),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
