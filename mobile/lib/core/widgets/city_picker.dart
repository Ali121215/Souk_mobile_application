import 'package:flutter/material.dart';
import '../data/chad_cities.dart';
import '../theme/app_theme.dart';

Future<String?> showCityPicker(BuildContext context, {required String current}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final maxHeight = MediaQuery.of(context).size.height * 0.7;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    Text('Choisir une ville', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: chadCities.length,
                  itemBuilder: (context, index) {
                    final city = chadCities[index];
                    final isSelected = city == current;
                    return ListTile(
                      title: Text(city, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.clay) : null,
                      onTap: () => Navigator.of(context).pop(city),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}