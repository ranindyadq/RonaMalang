import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '';
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<dynamic> places = [];
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _currentPage = (_currentPage < 4) ? _currentPage + 1 : 0;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> fetchPlaces({String categoryId = ''}) async {
    try {
      final url = categoryId.isEmpty
          ? 'http://192.168.18.48/backend/api.php'
          : 'http://192.168.18.48/backend/api.php?category_id=$categoryId';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          places = json.decode(response.body);
          // Menambahkan prefix 'assets/' pada path gambar
          for (var place in places) {
            place['image'] =
                'assets/${place['image']}'; // Pastikan ini menjadi path lokal
          }
        });
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching places: $e');
      }
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.18.48/backend/api.php?get_categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
          if (categories.isNotEmpty) {
            selectedCategory = categories[0]['id'].toString();
            fetchPlaces(categoryId: selectedCategory);
          }
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 60,
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rekomendasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPlacesGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.blue[900],
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildImageSlide('assets/bromo.png'),
                _buildImageSlide('assets/tumpaksewu.png'),
                _buildImageSlide('assets/jatimpark3.png'),
                _buildImageSlide('assets/piacapbangkok.png'),
                _buildImageSlide('assets/segosambelcakuut.png'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildCategoryButtons(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildImageSlide(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  List<Widget> _buildCategoryButtons() {
    return categories.map<Widget>((category) {
      return _buildCategoryButton(
        category['id'].toString(),
        category['name'],
      );
    }).toList();
  }

  Widget _buildCategoryButton(String categoryId, String label) {
    return CategoryButton(
      label: label,
      isSelected: selectedCategory == categoryId,
      onTap: () {
        setState(() {
          selectedCategory = categoryId;
        });
        fetchPlaces(categoryId: categoryId);
      },
    );
  }

  Widget _buildPlacesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return TouristPlaceCard(
          name: place['name'] ?? 'Unknown',
          location: place['location'] ?? 'Unknown',
          imageUrl:
              place['image'] ?? '', // Path gambar dari API, sudah dimodifikasi
          rating: place['rating'] != null
              ? double.parse(place['rating'].toString())
              : 0.0, // Ambil nilai rating
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.blue[900],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation),
          label: 'Navigasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Sejarah',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.blue[900],
        foregroundColor: isSelected ? Colors.blue[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}

class TouristPlaceCard extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final double rating; // Tambahkan parameter untuk rating

  const TouristPlaceCard({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating, // Tambahkan rating ke dalam konstruktor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set width to fill available space
      height: 250, // Set a fixed height for uniformity
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imageUrl, // Use local asset path directly
                fit: BoxFit.cover, // Ensures the image covers the card area
                width: double
                    .infinity, // Ensures the image stretches to the width of the container
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                // Menambahkan rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
