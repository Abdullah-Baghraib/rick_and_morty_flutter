import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_flutter/providers/api_provider.dart';
import 'package:rick_and_morty_flutter/widgets/character_card.dart';
import 'package:rick_and_morty_flutter/widgets/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        title: const Text(
          'Rick And Morty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCharacter());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      body: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        height: double.infinity,
        width: double.infinity,
        child:
            apiProvider.characters.isNotEmpty
                ? CharacterList(
                  apiProvider: apiProvider,
                  isLoading: isLoading,
                  scrollController: scrollController,
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CharacterList extends StatelessWidget {
  const CharacterList({
    super.key,
    required this.apiProvider,
    required this.scrollController,
    required this.isLoading,
  });

  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 5,
          mainAxisExtent: 220,
          childAspectRatio: 0.9,
        ),
        itemCount:
            isLoading
                ? apiProvider.characters.length + 2
                : apiProvider.characters.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < apiProvider.characters.length) {
            final character = apiProvider.characters[index];
            return GestureDetector(
              onTap: () {
                context.go('/character', extra: character);
              },
              child: Center(child: CharacterCard(character: character)),
            );
          } 
          else 
          {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
