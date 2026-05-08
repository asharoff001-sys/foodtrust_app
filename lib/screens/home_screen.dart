import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodTrust Dashboard'),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.restaurant, color: Colors.white, size: 50),

                  SizedBox(height: 10),

                  Text(
                    'FoodTrust',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),

            ListTile(
              leading: Icon(Icons.qr_code_scanner),
              title: Text('Scan Product'),
            ),

            ListTile(leading: Icon(Icons.inventory), title: Text('Products')),

            ListTile(leading: Icon(Icons.warning), title: Text('Alerts')),

            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Monitor food quality and product traceability.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,

                children: [
                  dashboardCard('Products', Icons.inventory, Colors.green),

                  dashboardCard('Scan QR', Icons.qr_code_scanner, Colors.blue),

                  dashboardCard('Alerts', Icons.warning, Colors.orange),

                  dashboardCard('Reports', Icons.bar_chart, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 60, color: color),

          const SizedBox(height: 15),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
