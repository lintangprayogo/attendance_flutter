import 'package:flutter/material.dart';

class RecognitionEmbedding {
  final Rect location;

  final List<double> embedding;
  RecognitionEmbedding({
    required this.location,
    required this.embedding,
  });
}
