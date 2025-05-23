import 'package:finalmobileproject/util/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Search extends StatefulWidget {
  const Search({super.key, required this.setsearchvalue});
  final Function(String) setsearchvalue;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController value = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    value.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.setsearchvalue(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.shadow.withAlpha(decimal_to_alpha_colors(0.2)),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: value,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(
              context,
            ).colorScheme.secondary.withAlpha(decimal_to_alpha_colors(0.7)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withAlpha(decimal_to_alpha_colors(0.2)),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
