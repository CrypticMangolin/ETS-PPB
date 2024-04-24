import 'package:ets/database/film_database.dart';
import 'package:ets/pages/detail_film.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/film.dart';
import '../widget/film_card_widget.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Film> filmList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshFilms();
  }

  @override
  void dispose() {
    FilmDatabase.instance.close();

    super.dispose();
  }

  Future refreshFilms() async {
    setState(() => isLoading = true);

    filmList = await FilmDatabase.instance.readAllFilm();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Films',
          style: TextStyle(fontSize: 24),
        ),
        actions: const [Icon(Icons.search), SizedBox(width: 12,)],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : filmList.isEmpty
            ? const Text(
          'No Films',
          style: TextStyle(color: Colors.white),
        )
            : buildFilms(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditPage())
          );

          refreshFilms();
        },
      ),
    );
  }

  Widget buildFilms() => StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8),
      itemCount: filmList.length,
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (BuildContext context, int index) {
        final film = filmList[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailFilm(filmId: film.id!)
            ));
            refreshFilms();
          },
          child: FilmCardWidget(film: film),
        );
      }

  );

}