import 'package:flutter/material.dart';
import 'package:rick_and_morty_flutter/core/colors.dart';
import 'package:rick_and_morty_flutter/core/style.dart';
import 'package:rick_and_morty_flutter/models/character_mode.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Stack
    (
      children: [
            Hero(
              tag: character.id!,
              child: Container(
    height: 220,
    width: 160,
    margin: EdgeInsets.only(right: 25),
    padding: EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: DecorationImage(
        image: NetworkImage(character.image!),
        fit: BoxFit.cover,
      ),
    ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
    height: 220,
    width: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColor.secondaryColor, Colors.transparent]),
    ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 25,
              child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: PrimaryText(
              text: character.name!, size: 15, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4),
        PrimaryText(
            text: character.status!,
            color: Colors.white54,
            size: 10,
            fontWeight: FontWeight.w800)
      ]),
            ),
          ]);
  }
}