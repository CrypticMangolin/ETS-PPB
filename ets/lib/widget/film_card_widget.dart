import 'package:flutter/material.dart';

import '../model/film.dart';

class FilmCardWidget extends StatelessWidget {
  final Film film;

  const FilmCardWidget({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              film.title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              film.description,
              style: const TextStyle(
                  fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${film.createdTime.toString()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Image.network('https://picsum.photos/250?image=9'),
          ],
        ),
      ),
    );
  }
}