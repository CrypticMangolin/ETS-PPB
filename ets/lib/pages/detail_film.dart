import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/film_database.dart';
import '../model/film.dart';
import 'edit_page.dart';

class DetailFilm extends StatefulWidget {
  final int filmId;

  const DetailFilm({
    super.key,
    required this.filmId,
  });

  @override
  State<DetailFilm> createState() => _DetailFilmState();
}

class _DetailFilmState extends State<DetailFilm> {
  late Film film;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshFilms();
  }

  Future refreshFilms() async {
    setState(() => isLoading = true);

    film = await FilmDatabase.instance.readFilm(widget.filmId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    film.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(film.createdTime),
                    style: const TextStyle(color: Colors.black26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    film.description,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
        )
    );
  }

  Widget editButton() => IconButton(
    icon: const Icon(Icons.edit),

    onPressed: () async {
      if (isLoading) return;

      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditPage(film: film),
      ));
    },
  );

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete),

    onPressed: () async {
      await FilmDatabase.instance.deleteFilm(widget.filmId);

      Navigator.of(context).pop();
    },
  );
}
