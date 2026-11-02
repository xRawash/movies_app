import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class GenresIds {
  static List<String> genres = [
    "action",
    "adventure",
    "animation",
    "biography",
    "comedy",
    "crime",
    "documentary",
    "drama",
    "family",
    "fantasy",
    "film - noir",
    "history",
    "horror",
    "music",
    "musical",
    "mystery",
    "romance",
    "sci - fi",
    "short",
    "sport",
    "thriller",
    "war",
    "western"
  ];

  static String getLocalizedGenre(BuildContext context, String genre) {
    final l10n = AppLocalizations.of(context)!;
    switch (genre.toLowerCase().trim()) {
      case 'action':
        return l10n.genreAction;
      case 'adventure':
        return l10n.genreAdventure;
      case 'animation':
        return l10n.genreAnimation;
      case 'biography':
        return l10n.genreBiography;
      case 'comedy':
        return l10n.genreComedy;
      case 'crime':
        return l10n.genreCrime;
      case 'documentary':
        return l10n.genreDocumentary;
      case 'drama':
        return l10n.genreDrama;
      case 'family':
        return l10n.genreFamily;
      case 'fantasy':
        return l10n.genreFantasy;
      case 'film - noir':
      case 'film-noir':
        return l10n.genreFilmNoir;
      case 'history':
        return l10n.genreHistory;
      case 'horror':
        return l10n.genreHorror;
      case 'music':
        return l10n.genreMusic;
      case 'musical':
        return l10n.genreMusical;
      case 'mystery':
        return l10n.genreMystery;
      case 'romance':
        return l10n.genreRomance;
      case 'sci - fi':
      case 'sci-fi':
        return l10n.genreSciFi;
      case 'short':
        return l10n.genreShort;
      case 'sport':
        return l10n.genreSport;
      case 'thriller':
        return l10n.genreThriller;
      case 'war':
        return l10n.genreWar;
      case 'western':
        return l10n.genreWestern;
      default:
        return genre[0].toUpperCase() + genre.substring(1);
    }
  }
}
