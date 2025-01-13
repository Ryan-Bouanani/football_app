import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final String searchCriteria;
  final Function(String?) onCriteriaChanged;

  const SearchBarWidget({
    Key? key,
    required this.onSearch,
    required this.searchCriteria,
    required this.onCriteriaChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                labelText: 'Rechercher un joueur',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: searchCriteria,
            items: const [
              DropdownMenuItem(value: 'name', child: Text('Nom')),
              DropdownMenuItem(
                  value: 'nationality', child: Text('Nationalité')),
              DropdownMenuItem(value: 'postes', child: Text('Poste')),
            ],
            onChanged: onCriteriaChanged,
          ),
        ],
      ),
    );
  }
}
