import 'package:flutter/material.dart';
import 'package:notes_app/components/custom_grid_note/note_settings.dart';
import 'package:notes_app/models/note.dart';
import 'package:popover/popover.dart';

class CustomGridItem extends StatelessWidget {
  final Note note;
  final void Function(Note) onEditTitleTap;
  final void Function(int) onDeleteTap;
  final void Function(Note) onNoteSettingsTap;

  const CustomGridItem({
    super.key,
    required this.note,
    required this.onEditTitleTap,
    required this.onNoteSettingsTap, required this.onDeleteTap,
  });

  String formatDate(DateTime date) {
    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    String month = months[date.month - 1];
    int day = date.day;
    int year = date.year;

    return '$month $day, $year';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: Theme.of(context).colorScheme.secondary,
              child: InkWell(
                onTap: () {
                  
                },
                splashColor:
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          note.title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      right: -15,
                      child: Builder(
                        builder: (BuildContext newContext) {
                          return IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                            ),
                            color:
                                Theme.of(newContext).colorScheme.inversePrimary,
                            iconSize: 18,
                            onPressed: () => showPopover(
                              width: 75,
                              height: 75,
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              context: newContext,
                              bodyBuilder: (context) => NoteSettings(
                                note: note,
                                onEditTitleTap: onEditTitleTap,
                                onDeleteTap: onDeleteTap,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          formatDate(note.createdAt),
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
