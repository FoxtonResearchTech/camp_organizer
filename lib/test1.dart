import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hi Arpan\nWelcome Back',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              print('sujin1');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather and Energy Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard(
                  title: 'My Location',
                  subtitle: 'Burdwan',
                  value: '28°',
                  icon: Icons.wb_cloudy_outlined,
                ),
                _infoCard(
                  title: 'Energy Saving',
                  subtitle: '+35%',
                  value: '23.5 kWh',
                  icon: Icons.bolt_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Room Tabs
            const Text(
              'Living Room',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _deviceGrid(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Voice'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(icon, color: Colors.blue),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _deviceCard('Lighting', '10 Spotlights', true, Icons.lightbulb_outline),
          _deviceCard('Sony Bravia Smart TV', '1 device', false, Icons.tv),
          _deviceCard('LG AC', '2 devices', true, Icons.ac_unit_outlined),
          _deviceCard('Sony Studio', '7 devices', false, Icons.speaker),
        ],
      ),
    );
  }

  Widget _deviceCard(String title, String subtitle, bool isOn, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isOn ? Colors.blue.shade100 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: isOn ? Colors.orange : Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Switch(
                value: isOn,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
