import 'dart:ffi';

import 'package:flutter/material.dart';

class Film {

}

class Usuari{
  late int userID; //PK
  late String email;
  late String name;
  late String nickname;
  late String password;
  late bool admin;
  late String birthDate;
}

class Repositori{
  late int repoID; //PK
  late int temporadaID; //PK
  late String name;
  late String date;
  late String director;
  late String reparto;
  late String description;
  late bool type;
  late String photoRoute;
  late String pegi;
  late int durada;
  late int season;
  late int numberOfChapters;
  late String genre;
}

class Biblioteca{
  late int registerID; //PK
  late int userID;
  late int repoID;
  late int tempoID;
  late Double valoracio;
  late String comment;
}