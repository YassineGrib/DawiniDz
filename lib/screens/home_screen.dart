import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/home_card.dart';
import 'doctors/doctor_search_screen.dart';
import 'measurements/measurements_screen.dart';
import 'reports/health_reports_screen.dart';
import 'chatbot/health_assistant_screen.dart';
import 'tasks/tasks_screen.dart';
import 'profile/profile_screen.dart';
import 'appointments/appointments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const AppointmentsScreen(),
    const MeasurementsScreen(),
    const TasksScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'المواعيد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'القياسات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'المهام'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'دويني دي زد', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                gradient: AppConstants.primaryGradient,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusLarge,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بك',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    'كيف يمكننا مساعدتك اليوم؟',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Quick Actions
            const Text(
              'الخدمات السريعة',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: AppConstants.paddingMedium,
              mainAxisSpacing: AppConstants.paddingMedium,
              children: [
                HomeCard(
                  icon: Icons.search,
                  title: 'البحث عن طبيب',
                  subtitle: 'ابحث عن الطبيب المناسب',
                  color: AppConstants.primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DoctorSearchScreen(),
                      ),
                    );
                  },
                ),
                const HomeCard(
                  icon: Icons.calendar_today,
                  title: 'حجز موعد',
                  subtitle: 'احجز موعدك الطبي',
                  color: AppConstants.secondaryColor,
                ),
                HomeCard(
                  icon: Icons.monitor_heart,
                  title: 'قياساتي الطبية',
                  subtitle: 'سجل قياساتك اليومية',
                  color: AppConstants.accentColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MeasurementsScreen(),
                      ),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.chat,
                  title: 'المساعد الصحي',
                  subtitle: 'استشر المساعد الذكي',
                  color: AppConstants.successColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HealthAssistantScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Recent Activity Section
            const Text(
              'النشاط الأخير',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppConstants.primaryColor,
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      title: const Text('موعد قادم'),
                      subtitle: const Text('د. أحمد محمد - طب عام'),
                      trailing: const Text('غداً 10:00 ص'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppConstants.accentColor,
                        child: Icon(Icons.monitor_heart, color: Colors.white),
                      ),
                      title: const Text('قياس ضغط الدم'),
                      subtitle: const Text('120/80 mmHg'),
                      trailing: const Text('اليوم'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'المهام', showBackButton: false),
      body: Center(
        child: Text(
          'شاشة المهام\nقيد التطوير',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppConstants.fontSizeXLarge,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
