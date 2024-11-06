import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class addEmployee extends StatefulWidget {
  const addEmployee({super.key});

  @override
  State<addEmployee> createState() => _addEmployeeState();
}

class _addEmployeeState extends State<addEmployee> {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Employee',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove default elevation
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.accentBlue,
                AppColors.lightBlue,
              ],
              end: Alignment.topLeft,
              begin: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
          // Always-visible drawer for desktop view
            Expanded(
              flex: 1,
              child: Container(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: Colors.lightBlueAccent),
                      child: Text("SCMS-PHP", style: TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                    _buildDrawerItem(Icons.dashboard, "Dashboard"),
                    _buildDrawerItem(Icons.people, "Add Employee"),
                    _buildDrawerItem(Icons.receipt, "Reports"),
                    Divider(),
                    //_buildDrawerItem(Icons.build, "Services List"),
                    _buildDrawerItem(Icons.supervised_user_circle, "Approvals"),
                    _buildDrawerItem(Icons.settings, "Settings"),
                    _buildDrawerItem(Icons.logout, "Logout"),
                  ],
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Enter Employee Details",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/avatar.png'), // Add client avatar image here
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Client:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text("20210002", style: TextStyle(fontSize: 18, color: Colors.teal)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow("Name", "Lou, Samantha Jane C"),
                                          _buildDetailRow("Gender", "Female"),
                                          _buildDetailRow("Date of Birth", "October 14, 1997"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow("Email", "sjlou@sample.com"),
                                          _buildDetailRow("Contact #", "097876546522"),
                                          _buildDetailRow("Address", "Sample Address Only, Anywhere, 2306"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                _buildStatusRow("Status", "Active"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(Icons.print, "Add", Colors.green),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : _buildMobileDrawer(),
    );
  }


  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Handle drawer item tap
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          Text(value, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        //primary: color,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        // Add your onPressed code here
      },
    );
  }

  Drawer _buildMobileDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text("SCMS-PHP", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard"),
          _buildDrawerItem(Icons.people, "Add Employee"),
          _buildDrawerItem(Icons.receipt, "Reports"),
          Divider(),
          _buildDrawerItem(Icons.build, "Approvals"),
          _buildDrawerItem(Icons.settings, "Settings"),
          _buildDrawerItem(Icons.logout, "Logout"),
        ],
      ),
    );
  }


}
