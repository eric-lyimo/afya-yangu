import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/components/mch.services.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/baby.awaiting.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/screens/mch.layout.dart';
import 'package:mtmeru_afya_yangu/providers/pregnancy.provider.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:mtmeru_afya_yangu/services/api.services.dart';

class MaternalChildHealthScreen extends StatefulWidget {
  const MaternalChildHealthScreen({super.key});

  @override
  State<MaternalChildHealthScreen> createState() =>
      _MaternalChildHealthScreenState();
}

class _MaternalChildHealthScreenState extends State<MaternalChildHealthScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? weekDetails;
  late TabController _tabController;
  bool isLoading = true;
  String? token;
  final apiService = ApiService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userState = context.read<UserState>();
      final pregnancyState = context.read<PregnancyState>();
      token = userState.user?.token;

      // kick off data load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pregnancyState.loadPregnancyData();
      });
      fetchWeekDetails(pregnancyState.pregnancyWeek);

      _isInitialized = true;
    }
  }

  Future<void> fetchWeekDetails(int week) async {
    try {
      final data = await apiService.get(
        '/pregnancy/week/$week',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (data != null && data['data'] != null) {
        setState(() {
          weekDetails = Map<String, dynamic>.from(data['data']);
        });
      }
    } catch (e) {
      debugPrint("Failed to load week details: $e");
    } finally {
      // always stop loading
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pregnancyState = context.watch<PregnancyState>();
    final double progress = pregnancyState.pregnancyProgress;
    final int currentWeek = pregnancyState.pregnancyWeek;
    final String dueDate = pregnancyState.dueDate;
    final user = context.watch<UserState>().user;

    // Show spinner until we know the user & have attempted to load
    if (isLoading || user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MchLayout(
      tabController: _tabController,
      title: "Maternal & Child Health",
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
            ),
          ),
          TabBarView(
            controller: _tabController,
            children: [
              // 1️⃣ Pregnancy Tracker Tab
              weekDetails != null
                  ? _buildPregnancyTracker(
                      progress, currentWeek, dueDate, user, weekDetails!)
                  : _buildWeekDetailsFallback(),

              // 2️⃣ Awaiting Baby Tab
              const AwaitingBaby(),

              // 3️⃣ Educational Resources Tab
              _buildEducationalResources(),
            ],
          ),
        ],
      ),
    );
  }

  /// Fallback UI when weekDetails is null
  Widget _buildWeekDetailsFallback() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Couldn’t load pregnancy week details.\nPlease check your connection or try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }


  // Hero Banner with Progress Indicator
  Widget _buildHeroBanner(double progress, int currentWeek, String dueDate) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pregnancy Tracker",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CircularPercentIndicator(
              radius: 80,
              lineWidth: 10.0,
              animation: true,
              percent: progress,
              center: Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              progressColor: Colors.pinkAccent,
            ),
            const SizedBox(height: 10),
            Text(
              "$currentWeek - Due Date: $dueDate",
              style: TextStyle(color: Colors.grey[700]),
            ),
       
          ],
        ),
      ),
    );
  }

  // Pregnancy Tracker Section
  Widget _buildPregnancyTracker(double progress, int currentWeek, String dueDate,Users user,Map<String, dynamic> weekDetails) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
  
        _buildHeroBanner(progress, currentWeek, dueDate),
        const Text(
          "Your Weekly Updates",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        MchServices(weekDetails: weekDetails),

        const SizedBox(height: 10),
        
        _buildCardWithAnimation(
          title: "Baby's Development",
          description: weekDetails['babyDevelopment'] ?? "Hakuna Taarifa kwa sasa.",
          icon: FontAwesomeIcons.baby,
          backgroundColor: Colors.pinkAccent,
        ),
        const SizedBox(height: 10),
        _buildCardWithAnimation(
          title: "Tips for the Week",
          description: weekDetails['tips'] ?? "Hakuna Taarifa kwa sasa.",
          icon: FontAwesomeIcons.tint,
          backgroundColor: Colors.deepPurpleAccent,
        ),
      ],
    );
  }

  // Educational Resources Section
  Widget _buildEducationalResources() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          "Learn & Explore",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildResourceTile(
          title: "Nutrition During Pregnancy",
          subtitle: "What to eat for a healthy pregnancy.",
          icon: FontAwesomeIcons.appleWhole,
          color: Colors.green,
        ),
        _buildResourceTile(
          title: "Breastfeeding Tips",
          subtitle: "How to start and maintain breastfeeding.",
          icon: FontAwesomeIcons.babyCarriage,
          color: Colors.blue,
        ),
      ],
    );
  }

  // Animated Card
  Widget _buildCardWithAnimation({
    required String title,
    required String description,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: HtmlWidget(description),
      ),
    );
  }

  // Resource Tile
  Widget _buildResourceTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

}