import 'package:flutter/material.dart';
import 'asset_list_tab.dart';
import 'crud_db_tab.dart';

/// Parent dashboard container coordinating Lab 9 sub-screens
class Lab9DashboardScreen extends StatelessWidget {
  const Lab9DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local JSON Storage'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.grey.shade900, Colors.black]
                    : [Colors.indigo.shade600, Colors.deepPurple.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.library_books),
                text: 'Assets File (9.1)',
              ),
              Tab(
                icon: Icon(Icons.storage),
                text: 'Device CRUD (9.2 & 9.3)',
              ),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const TabBarView(
          children: [
            AssetListTab(),
            CrudDbTab(),
          ],
        ),
      ),
    );
  }
}
