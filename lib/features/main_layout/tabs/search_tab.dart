import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/main_layout/movie_item/movie_item.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late TextEditingController _searchController;
  List<Movies> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiServices.searchMovies(query.trim());
      setState(() {
        searchResults = response.data?.movies ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
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
              hint: 'Search movies...',
              prefixIcon: Icon(Icons.search),
              onChanged: (value) {
                _searchMovies(value ?? '');
                return null;
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.yellow,
                      ),
                    )
                  : searchResults.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? "Search for your favorite movies"
                                : "No movies found",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return MovieItem(movie: searchResults[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      
    );
  }
}
