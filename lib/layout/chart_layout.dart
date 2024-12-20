import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ChartLayout extends StatefulWidget {
  final String title;
  final Widget chartWidget;
  final Function(DateTime) onDateSelected;
  final bool? selectMonth;
  final VoidCallback? backToPage;
  final bool? noPadding;

  const ChartLayout({
    super.key,
    required this.title,
    required this.chartWidget,
    required this.onDateSelected,
    this.selectMonth,
    this.backToPage,
    this.noPadding,
  });

  @override
  State<ChartLayout> createState() => _ChartLayoutState();
}

class _ChartLayoutState extends State<ChartLayout> {
  //DateTime selectedDate = DateTime.now();
  DateTime? selectedDate;
  late final bool _selectMonth = widget.selectMonth ?? true;
  late final bool _noPadding = widget.noPadding ?? false;

  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Todo: 년, 월 선택
    selectMonth() {
      showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        monthPickerDialogSettings: MonthPickerDialogSettings(
          headerSettings: PickerHeaderSettings(
            headerBackgroundColor: PRIMARY_COLOR,
            headerPadding: EdgeInsets.all(screenWidth * 0.05),
            headerIconsSize: 30,
            headerIconsColor: Colors.black,
            headerCurrentPageTextStyle: textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            headerSelectedIntervalTextStyle: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          dialogSettings: PickerDialogSettings(
              dialogBackgroundColor: LIGHT_IVORY,
              dialogRoundedCornersRadius: 15,
              dialogBorderSide: BorderSide(color: Colors.black)),
          buttonsSettings: PickerButtonsSettings(
            monthTextStyle: textTheme.bodySmall,
            selectedMonthBackgroundColor: BLUE_PURPLE,
            unselectedMonthsTextColor: Colors.black,
            currentMonthTextColor: ORANGE,
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
    }

    return Stack(children: [
      Positioned.fill(
        child: Image.asset(
          'assets/imgs/background/background_image_category_chart.png',
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.backToPage ??
                      () {
                        Navigator.of(context).pop();
                      },
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  iconSize: 30.0,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Expanded(
                    child: Text(
                  widget.title,
                  style: textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                )),
                Visibility(
                  visible: !_selectMonth,
                  child: SizedBox(width: 45),
                ),
                Visibility(
                  visible: _selectMonth,
                  child: SizedBox(
                    width: 45,
                    child: IconButton(
                      onPressed: selectMonth,
                      icon: Image.asset(
                        "assets/icons/calendar_icon.png",
                        width: 25,
                      ),
                      highlightColor: Colors.grey[100],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(
          //         "assets/imgs/background/background_image_category_chart.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Padding(
            padding: _noPadding
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: widget.chartWidget,
          ),
        ),
      ),
    ]);
  }
}
