import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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
        drawer: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            // Add your drawer content here
          ],
        ),
      ),
        backgroundColor: const Color.fromARGB(
            255, 169, 175, 175), // Change background color here
        appBar: AppBar(
          backgroundColor: Colors.blue, // Change background color here
          title: const Text('Farm Records Management'),
          titleTextStyle:
              const TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
          centerTitle: true,
        ),
        body:  Center(
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
                        title: 'Crops & Fields',
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) =>const DetailsPage(cardTitle: 'First Card'),
                  ),
                );
              },
            ),
                    CardItem(
                        title: 'Reports',
                        onTap: () {
                          navigateToDetailsPage(context, 'reports');
                        })
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
                        navigateToDetailsPage(context, 'Card 1');
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CardItem(
                      title: 'Card 5',
                      onTap: () {
                        navigateToDetailsPage(context, 'Card 2');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}


class CardItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CardItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
  
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 195,
          width: 195,
          alignment: Alignment.center,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20.0),
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
          style:const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
