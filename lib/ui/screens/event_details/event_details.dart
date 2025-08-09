import 'package:evently/ui/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/event_dm.dart';
import '../../../model/category_dm.dart';
import '../../widgets/info_tile.dart';
import '../../../ui/utils/app_colors.dart';

class EventDetails extends StatefulWidget {
  final EventDM event;

  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late EventDM currentEvent;

  @override
  void initState() {
    super.initState();
    currentEvent = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    final categoryDM = CategoryDM.fromTitle(currentEvent.categoryId);
    final dateStr = DateFormat('d MMMM yyyy').format(currentEvent.date);
    final timeStr = DateFormat('h:mma').format(currentEvent.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                AppRoutes.editEvent(currentEvent),
              );
              if (updated is EventDM) {
                setState(() {
                  currentEvent = updated;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              categoryDM.image,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            currentEvent.title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),

          InfoTile(
            icon: Icons.calendar_month_rounded,
            title: dateStr,
            subtitle: timeStr,
          ),
          const SizedBox(height: 10),

          const InfoTile(
            icon: Icons.place_rounded,
            title: 'Cairo , Egypt',
          ),
          const SizedBox(height: 14),

          Text('Description', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 6),
          Text(
            currentEvent.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}