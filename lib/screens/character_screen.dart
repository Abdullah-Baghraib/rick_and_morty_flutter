import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_flutter/core/colors.dart';
import 'package:rick_and_morty_flutter/core/style.dart';
import 'package:rick_and_morty_flutter/models/character_mode.dart';
import 'package:rick_and_morty_flutter/providers/api_provider.dart';
class CharacterScreen extends StatefulWidget {
  final Character character;
  const CharacterScreen({Key? key, required this.character});

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return DestinationPage
    (
      controller: _controller,
      character: widget.character,
    );
  }
}

class DestinationPage extends StatefulWidget {
  final character;
  DestinationPage(
      {Key? key, required AnimationController controller,  this.character,})
      : animation = DestinationPageEnterAnimation(controller),
        super(key: key);
  final DestinationPageEnterAnimation animation;

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> 
{
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation.controller,
      builder: (context, child) => _buildAnimation(context , widget.character ),
    );
  }

  Hero _buildAnimation(BuildContext context , Character character) 
  {
    final size = MediaQuery.of(context).size;
    return Hero(
      tag: character.id!,
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Container
          (
            height: MediaQuery.of(context).size.height,
            child: Container(
              padding: const EdgeInsets.only(top: 50),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.character.image!),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => {Navigator.pop(context)},
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height - 350,
                    height: widget.animation.barHeight.value,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColor.secondaryColor,
                          AppColor.tertiaryColor,
                        ],
                      ),
                    ),
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: PrimaryText(
                                  text: widget.character.name!,
                                  size: 24),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: PrimaryText(
                                  text:
                                      '${widget.character.status!} - ${widget.character.species!} - ${widget.character.gender!} - ${widget.character.origin!.name!}',
                                  size: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white38),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PrimaryText(
                                  text: 'Episodes',
                                  size: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                PrimaryText(
                                    text: '${character.episode!.length}',
                                    size: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white24),
                              ],
                            ),
                            SizedBox(height: 20),
                            EpisodeList(size: size, character: character)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

}

class DestinationPageEnterAnimation 
{
  DestinationPageEnterAnimation(this.controller)
      : barHeight = Tween<double>(begin: 0, end: 520).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0, 0.5),
          ),
        );

  final AnimationController controller;
  final Animation<double> barHeight;
}

class EpisodeList extends StatefulWidget {
  const EpisodeList({super.key, required this.size, required this.character});

  final Size size;
  final Character character;

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getEpisodes(widget.character);
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    final apiProvider = Provider.of<ApiProvider>(context);
    return SizedBox(
      height: widget.size.height * 0.35,
      child: ListView.builder(
        itemCount: apiProvider.episodes.length,
        itemBuilder: (context, index) {
          final episode = apiProvider.episodes[index];
          return ListTile(
            leading: Text(episode.episode!),
            title: Text(episode.name!),
            trailing: Text(episode.airDate!),
          );
        },
      ),
    );
  }
}

