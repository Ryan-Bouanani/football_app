import 'package:flutter/material.dart';

class TeamStandingCard extends StatelessWidget {
  final dynamic team;
  final int index;
  final List<dynamic> standings;

  const TeamStandingCard({
    super.key, 
    required this.team, 
    required this.index,
    required this.standings
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _getPositionColor(index, standings),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${team['position']}', 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Image.network(
              team['team']['crest'],
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
          ],
        ),
        title: Text(
          team['team']['name'], 
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${team['points']} pts', 
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'MJ: ${team['playedGames']}', 
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(int index, List<dynamic> standings) {
    final position = index + 1;
    if (position == 1) return Colors.green;
    if (position <= 4) return Colors.blue;
    if (position >= standings.length - 2) return Colors.red;
    return Colors.grey;
  }
}
