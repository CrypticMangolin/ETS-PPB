import 'package:flutter/material.dart';

import '../database/film_database.dart';
import '../model/film.dart';

class AddEditPage extends StatefulWidget {
  final Film? film;

  const AddEditPage({
    super.key,
    this.film,
  });

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String link;
  bool get isUpdating => widget.film != null;

  @override
  void initState() {
    super.initState();
    if (isUpdating) {
      title = widget.film!.title;
      description = widget.film!.description;
      link = widget.film!.link;
    } else {
      title = '';
      description = '';
      link = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdating ? 'Edit Film' : 'Add Film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => description = value!,
              ),
              // TextFormField(
              //   initialValue: link,
              //   decoration: const InputDecoration(labelText: 'Link'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter the image Link';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) => description = value!,
              // ),
              ElevatedButton(
                onPressed: addOrUpdateFilm,
                child: Text(isUpdating ? 'Update Film' : 'Add Film'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addOrUpdateFilm() async {
    final isValid = _formKey.currentState!.validate();

    if(isValid) {
      if(isUpdating) {
        await updateFilm();
      } else {
        await addFilm();
      }
    }
    Navigator.of(context).pop();
  }

  Future updateFilm() async {
    final film = widget.film!.copy(
      title: title,
      description: description,
    );

    await FilmDatabase.instance.updateFilm(film);
  }

  Future addFilm() async {
    final film = Film(
      title: title,
      description: description,
      createdTime: DateTime.now(),
      link: link,
    );

    await FilmDatabase.instance.createFilm(film);
  }
}
