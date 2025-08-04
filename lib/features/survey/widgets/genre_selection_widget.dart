import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moodsic/shared/states/survey_provider.dart'; // đảm bảo đúng đường dẫn

class GenreSelectionWidget extends StatefulWidget {
  final int maxSelection;

  const GenreSelectionWidget({super.key, this.maxSelection = 5});

  @override
  State<GenreSelectionWidget> createState() => _GenreSelectionWidgetState();
}

class _GenreSelectionWidgetState extends State<GenreSelectionWidget> {
  final Set<String> selectedGenres = <String>{};

  final List<String> genres = [
    'Pop',
    'Ballad',
    'Rock',
    'R&B',
    'Jazz',
    'Hip hop',
    'Folk',
    'Indie',
    'Dance',
    'Classical',
    'Country',
    'Electronic',
  ];

  void toggleGenre(String genre) {
    final surveyProvider = context.read<SurveyProvider>();

    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else if (selectedGenres.length < widget.maxSelection) {
        selectedGenres.add(genre);
      }
    });

    // Cập nhật Provider
    surveyProvider.setGenres(selectedGenres.toList());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'DÒNG NHẠC YÊU THÍCH CỦA BẠN?\nchọn tối đa 5',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Selection counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${selectedGenres.length}/${widget.maxSelection} đã chọn",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Genre grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                for (int i = 0; i < genres.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildGenreItem(genres[i])),
                        const SizedBox(width: 16),
                        if (i + 1 < genres.length)
                          Expanded(child: _buildGenreItem(genres[i + 1]))
                        else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            selectedGenres.length >= widget.maxSelection
                ? "Bạn đã chọn đủ ${widget.maxSelection} thể loại!"
                : "Chọn tối đa ${widget.maxSelection} thể loại yêu thích của bạn",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGenreItem(String genre) {
    final isSelected = selectedGenres.contains(genre);
    final canSelect = selectedGenres.length < widget.maxSelection || isSelected;

    return GestureDetector(
      onTap: canSelect ? () => toggleGenre(genre) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: 2,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, right: 12),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF5BA4B0)
                        : Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: isSelected ? const Color(0xFF5BA4B0) : Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
            Expanded(
              child: Text(
                genre,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF5BA4B0) : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
