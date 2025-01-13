import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;

  const PlayerCard({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacity(0.1),
                Colors.pink.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            title: Text(
              player['name'] ?? 'Nom inconnu',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Poste : ${player['position'] ?? 'Non spécifié'}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Nationalité : ${player['nationality'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Date de naissance : ${player['dateOfBirth'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.75, end: 1.0);
  }
}
