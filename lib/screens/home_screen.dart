import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_gallery/models/image_model.dart';
import 'package:image_gallery/screens/image_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<ImageModel> _images = [];
  int _page = 1;
  bool _loading = false;
  Timer? _debounce;
  final String apiUrl = "pixabay.com";

  @override
  void initState() {
    super.initState();
    _loadImages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _page = 1;
        _images.clear();
        _loadImages();
        return;
      } else {
        _page = 1;
        _images.clear();
        _loadImages(query: query);
      }
    });
  }

  void _loadImages({
    String? query,
  }) async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.get(
        Uri.https(
          apiUrl,
          '/api',
          {
            'key': dotenv.env['API_KEY'],
            'page': '$_page',
            'per_page': '30',
            if (query != null) 'q': query,
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        for (var image in data['hits']) {
          _images.add(ImageModel.fromJson(image));
        }
        setState(() {});
      } else {
        throw Exception('Failed to load images');
      }
    } on Exception catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load images'),
          ),
        );
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      _loadImages(
        query: _searchController.text == '' ? null : _searchController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search images',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _images.isEmpty && _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _images.isEmpty
                        ? const Center(
                            child: Text(
                              'No images found. Please try another search.',
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width ~/ 180,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _images.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _images.length) {
                                  if (_loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return const SizedBox();
                                }
                                return ImageCard(
                                  imageModel: _images[index],
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
