import 'package:flutter/material.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/screens/account%20profile%20tab/post_view.dart';

class AccountTabbarView extends StatefulWidget {
  final String uid;
  const AccountTabbarView({super.key, required this.uid});

  @override
  AccountTabbarViewState createState() => AccountTabbarViewState();
}

class AccountTabbarViewState extends State<AccountTabbarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.grid_4x4_rounded),
              ),
              Tab(
                icon: Icon(Icons.tag_faces),
              )
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PostView(
                  uid: widget.uid, 
                ),
                const Text(unavailable),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
