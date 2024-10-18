import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/component/hobby_card.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ChartLayout extends StatefulWidget {
  final String title;
  final Widget chartWidget;
  final Function(DateTime) onDateSelected;

  const ChartLayout({
    super.key,
    required this.title,
    required this.chartWidget,
    required this.onDateSelected,
  });

  @override
  State<ChartLayout> createState() => _ChartLayoutState();
}

class _ChartLayoutState extends State<ChartLayout> {
  //DateTime selectedDate = DateTime.now();
  DateTime? selectedDate;

  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.chevron_left),
                  iconSize: 35.0,
                ),
                Text(widget.title, style: textTheme.headlineLarge),
                IconButton(
                  onPressed: () {
                    showMonthPicker(
                      context: context,
                      initialDate: DateTime.now(),

                      monthPickerDialogSettings: MonthPickerDialogSettings(
                        headerSettings: PickerHeaderSettings(
                            headerBackgroundColor: PRIMARY_COLOR),
                        dialogSettings: PickerDialogSettings(
                            dialogBackgroundColor: LIGHT_IVORY,
                            dialogRoundedCornersRadius: 15),
                        buttonsSettings: PickerButtonsSettings(
                          monthTextStyle: textTheme.bodySmall,
                          selectedMonthBackgroundColor: BLUE_PURPLE,
                          unselectedMonthsTextColor: Colors.black,
                          buttonBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          widget.onDateSelected(date); // 콜백 호출
                        });
                      }
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/calendar_icon.png",
                    width: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/imgs/background/background_image_category_chart.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: widget.chartWidget));
  }
}
