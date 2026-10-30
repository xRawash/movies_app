import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late TextEditingController _searchController;
  List<Movies> searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _searchController,
              hint: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchMovies() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    ApiServices.searchMovies(_searchController.text).then((value) {
      setState(() {
        searchResults = value.data!.movies!;
      });
    });
  }
}
