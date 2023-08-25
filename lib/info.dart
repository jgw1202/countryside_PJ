import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'board.dart';
import 'dart:convert';
import 'homepage.dart';
import 'search.dart';

class Info extends StatelessWidget {
  final String prevUri;
  Info({required this.prevUri});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ScaffoldWithTabs(
        prevUri: uri,
      ),
    );
  }
}

class Recruit {
  final String title;
  final String region;
  final String location;
  final String deadline;
  final String workTerm;
  final String workDay;
  final String workHour;
  final int pay;
  final String type;
  final String room;
  final String meal;
  final String creatorNumber;

  Recruit(
      {required this.title,
      required this.region,
      required this.location,
      required this.deadline,
      required this.workTerm,
      required this.workDay,
      required this.workHour,
      required this.pay,
      required this.room,
      required this.meal,
      required this.type,
      required this.creatorNumber});
}

class Farm {
  final String location;
  final String creatorNumber;

  Farm({
    required this.location,
    required this.creatorNumber,
  });
}

class ScaffoldWithTabs extends StatelessWidget {
  final String prevUri; // prevUri 변수 추가

  const ScaffoldWithTabs({Key? key, required this.prevUri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '맞춤검색',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage())); // 홈페이지로 이동하는 코드
            },
            child: Image.asset('assets/images/back.png'),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/farmField.jpg',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TabBar(
              labelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: '모집내용'),
                Tab(text: '농장정보'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RecruitPage(prevUri: prevUri),
                  FarmPage(prevUri: prevUri),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Color(0xFFD0F5EC),
            child: Container(
              height: 70.0, // Adjust the height as needed
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround, // Align items evenly
                children: [
                  Column(
                    children: [
                      SizedBox(height: 15),
                      Icon(Icons.home, color: Color(0xFF7AD6BF)),
                      Text(
                        "home",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(122, 214, 191, 1.0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 15),
                      Icon(Icons.map, color: Color(0xFF7AD6BF)),
                      Text(
                        "register",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(122, 214, 191, 1.0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 15),
                      Icon(Icons.search, color: Color(0xFF7AD6BF)),
                      Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(122, 214, 191, 1.0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 15),
                      Icon(Icons.account_circle, color: Color(0xFF7AD6BF)),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(122, 214, 191, 1.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoRow(dynamic label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF7AD6BF),
              fontSize: 19,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 19,
            ),
          ),
        ),
      ],
    ),
  );
}

class RecruitPage extends StatefulWidget {
  final String prevUri;

  RecruitPage({required this.prevUri});
  @override
  _RecruitPageState createState() => _RecruitPageState();
}

class _RecruitPageState extends State<RecruitPage> {
  late Recruit recruit;

  @override
  void initState() {
    super.initState();
    recruit = Recruit(
        title: 'Loading...',
        region: 'Loading...',
        location: '',
        deadline: 'Loading...',
        workTerm: 'Loading...',
        workDay: 'Loading...',
        workHour: 'Loading...',
        pay: 0,
        type: 'Loading...',
        meal: 'false',
        room: 'false',
        creatorNumber: 'Loading...');
    initRecruit();
  }

  Future<void> initRecruit() async {
    String url = widget.prevUri;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      print('debug');
      print(jsonData[0]);
      String isRoom = jsonData[0]['room'] ? "예" : "아니오";
      String isMeal = jsonData[0]['meal'] ? "예" : "아니오";
      setState(() {
        recruit = Recruit(
          title: jsonData[0]['title'],
          region: jsonData[0]['region'],
          location: jsonData[0]['location'],
          deadline: jsonData[0]['deadline'],
          workTerm: jsonData[0]['workTerm'],
          workDay: jsonData[0]['workDay'],
          workHour: jsonData[0]['workHour'],
          pay: jsonData[0]['pay'],
          type: jsonData[0]['type'],
          room: isRoom,
          meal: isMeal,
          creatorNumber: jsonData[0]['creatorNumber'],
        );
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            _buildInfoRow("제목          ", recruit.title),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("지역          ", recruit.region),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("마감일       ", recruit.deadline),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("기간           ", recruit.workTerm),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("요일          ", recruit.workDay),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("시간          ", recruit.workHour),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("급여          ", recruit.pay.toString()),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("유형          ", recruit.type),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("식사 제공  ", recruit.meal.toString()),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("숙박 제공  ", recruit.room.toString()),
          ],
        ),
      ),
    );
  }
}

class FarmPage extends StatefulWidget {
  final String prevUri;

  FarmPage({required this.prevUri});

  @override
  _FarmPageState createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  late Farm farm;

  @override
  void initState() {
    super.initState();
    farm = Farm(location: 'Loading...', creatorNumber: 'Loading...');
    initFarm();
  }

  Future<void> initFarm() async {
    String url = widget.prevUri;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        farm = Farm(
          location: jsonData[0]['location'],
          creatorNumber: jsonData[0]['creatorNumber'],
        );
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            _buildInfoRow("연락처 :       ", farm.creatorNumber.toString()),
            SizedBox(
              height: 5,
            ),
            _buildInfoRow("장소 :          ", farm.location),
          ],
        ),
      ),
    );
  }
}
