import 'package:evently/data/firestore_utils.dart';
import 'package:evently/model/category_dm.dart';
import 'package:evently/model/event_dm.dart';
import 'package:evently/ui/utils/app_assets.dart';
import 'package:evently/ui/utils/app_colors.dart';
import 'package:evently/ui/utils/dialog_utils.dart';
import 'package:evently/ui/widgets/category_tabs.dart';
import 'package:evently/ui/widgets/custom_button.dart';
import 'package:evently/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEvent extends StatefulWidget {
  final EventDM event;

  const EditEvent({super.key, required this.event});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late CategoryDM selectedCategory;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(text: widget.event.description);
    selectedCategory = CategoryDM.fromTitle(widget.event.categoryId);
    selectedDate = widget.event.date;
    selectedTime = TimeOfDay(hour: widget.event.date.hour, minute: widget.event.date.minute);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate);
    final timeStr = DateFormat('h:mma').format(
      DateTime(0, 1, 1, selectedTime.hour, selectedTime.minute),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                selectedCategory.image,
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            CategoryTabs(
              categories: CategoryDM.createEventsCategories,
              initialCategory: selectedCategory,
              onTabSelected: (cat) {
                setState(() => selectedCategory = cat);
              },
              selectedTabBg: AppColors.blue,
              selectedTabTextColor: AppColors.white,
              unselectedTabBg: AppColors.white,
              unselectedTabTextColor: AppColors.blue,
            ),
            const SizedBox(height: 16),

            fieldLabel('Title'),
            CustomTextField(
              hint: 'Event Title',
              prefixIcon: AppSvg.icTitle,
              controller: titleController,
            ),
            const SizedBox(height: 16),

            fieldLabel('Description'),
            CustomTextField(
              hint: 'Description',
              minLines: 5,
              controller: descriptionController,
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  initialDate: selectedDate,
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 8),
                  fieldLabel('Event Date'),
                  const Spacer(),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  fieldLabel('Event Time'),
                  const Spacer(),
                  Text(
                    timeStr,
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.place_rounded),
                  const SizedBox(width: 8),
                  fieldLabel('Location'),
                  const Spacer(),
                  const Text(
                    'Cairo , Egypt',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Update Event',
              onClick: onUpdatePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
  );

  Future<void> onUpdatePressed() async {
    final mergedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final updated = EventDM(
      id: widget.event.id,
      title: titleController.text.trim(),
      categoryId: selectedCategory.title,
      date: mergedDate,
      description: descriptionController.text.trim(),
      ownerId: widget.event.ownerId,
      lat: widget.event.lat,
      lng: widget.event.lng,
    );

    showLoading(context);
    try {
      await updateEventInFirestore(updated);
      Navigator.pop(context);
      Navigator.pop(context, updated);
    } catch (e) {
      Navigator.pop(context);
    }
  }
}