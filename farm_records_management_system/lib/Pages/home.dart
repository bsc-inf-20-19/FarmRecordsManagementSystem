import 'package:farm_records_management_system/Pages/transaction/transactions.dart';
import 'package:farm_records_management_system/screens/crops_livestock.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 16, 83, 8),
        body: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void navigateToDetailsPage(BuildContext context, String cardTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(cardTitle: cardTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('My Farm Manager',
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
              ),
              ListTile(
                //ignore: prefer_const_constructors
                leading: Icon(Icons.verified_user),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DetailsPage(cardTitle: 'First Card'),
                    ),
                  );
                },
              ),
              ListTile(
                //ignore: prefer_const_constructors
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DetailsPage(cardTitle: 'First Card'),
                    ),
                  );
                },
              ),
              ListTile(
                //ignore: prefer_const_constructors
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DetailsPage(cardTitle: 'First Card'),
                    ),
                  );
                },
              ),
              ListTile(
                //ignore: prefer_const_constructors
                leading: Icon(Icons.help_center),
                title: Text('How to use this app'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DetailsPage(cardTitle: 'First Card'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.blue, // Change background color here
        title: const Text('Farm Records Management'),
        titleTextStyle:
            const TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
        centerTitle: true,
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/background.png'), // Replace with your image file
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardItem(
                          title: 'Fields',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingPage()),
                            );
                          },
                        ),
                        CardItem(
                          title: 'Reports',
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DetailsPage(cardTitle: 'First Card'),
                              ),
                            )
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardItem(
                          title: 'Transactions',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Transaction()));
                          },
                        ),
                        CardItem(
                          title: 'Crops Comparison',
                          onTap: () {
                            navigateToDetailsPage(context, 'Card 2');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CardItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 180,
            width: 180,
            alignment: Alignment.center,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String cardTitle;

  const DetailsPage({super.key, required this.cardTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for $cardTitle'),
      ),
      body: Center(
        child: Text(
          'Details for $cardTitle will be shown here.',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
