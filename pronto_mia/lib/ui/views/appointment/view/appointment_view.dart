import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pronto_mia/core/models/appointment.dart' as local;
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/views/appointment/view/appointment_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentView extends StatefulWidget {
  final bool adminModeEnabled;
  final DateTime initalSelectedDate;

  /// Initializes a new instance of [AppointmentView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree as an
  /// input.
  const AppointmentView({
    Key key,
    this.adminModeEnabled = false,
    this.initalSelectedDate,
  }) : super(key: key);

  @override
  AppointmentViewState createState() => AppointmentViewState();
}

class AppointmentViewState extends State<AppointmentView> {
  final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<AppointmentViewModel>.reactive(
        viewModelBuilder: () => AppointmentViewModel(),
        builder: (context, model, child) => NavigationLayout(
          title: "Kalender",
          body: SfCalendar(
            controller: _calendarController,
            initialSelectedDate: widget.initalSelectedDate,
            view: CalendarView.month,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.workWeek,
              CalendarView.month,
            ],
            monthViewSettings: const MonthViewSettings(showAgenda: true),
            firstDayOfWeek: 1,
            showNavigationArrow: true,
            showWeekNumber: true,
            showDatePickerButton: true,
            dataSource: AppointmentDataSource(model.data),
            allowViewNavigation: true,
            timeSlotViewSettings: const TimeSlotViewSettings(
              timeFormat: 'HH:mm',
            ),
            onTap: (CalendarTapDetails details) {
              calendarTapped(model, details);
            },
          ),
          actions: [
            if (widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Termin erstellen',
                icon: const Icon(Icons.add),
                onPressed: () => model.editAppointment(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                  selectedDate: _calendarController.selectedDate
                          ?.add(const Duration(hours: 18)) ??
                      DateTime.now(),
                ),
              ),
          ],
          actionsAppBar: const [],
        ),
      );

  void calendarTapped(AppointmentViewModel model, CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      local.Appointment appointmentDetails;
      if (details.appointments.first.runtimeType == local.Appointment) {
        appointmentDetails = details.appointments.first as local.Appointment;
      } else {
        final Appointment appointment =
            details.appointments.first as Appointment;
        appointmentDetails = local.Appointment(
          id: appointment.id as int,
          title: appointment.subject,
          location: appointment.location,
          from: appointment.startTime,
          to: appointment.endTime,
          isAllDay: appointment.isAllDay,
          isYearly: true,
        );
      }

      if (widget.adminModeEnabled) {
        model.editAppointment(
          appointment: appointmentDetails,
          asDialog: getValueForScreenType<bool>(
            context: context,
            mobile: false,
            desktop: true,
          ),
        );
      } else {
        final String _subjectText = appointmentDetails.title;
        final String _locationText = appointmentDetails.location;
        final String _dateText =
            DateFormat.yMMMMd('de_CH').format(appointmentDetails.from);
        final String _startTimeText =
            DateFormat('HH:mm').format(appointmentDetails.from);
        final String _endTimeText =
            DateFormat('HH:mm').format(appointmentDetails.to);
        String _timeDetails;
        if (appointmentDetails.isAllDay) {
          _timeDetails = 'Ganzer Tag';
        } else {
          _timeDetails = '$_startTimeText - $_endTimeText';
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(_subjectText),
              content: SizedBox(
                height: 120,
                child: Column(
                  children: <Widget>[
                    if (_locationText != null)
                      Row(
                        children: [
                          Text(
                            'Ort: $_locationText',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    if (_locationText != null)
                      Row(
                        children: const <Widget>[
                          Text(''),
                        ],
                      ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Datum: $_dateText',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Zeit: $_timeDetails',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('schliessen'),
                )
              ],
            );
          },
        );
      }
    }
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<local.Appointment> source) {
    appointments = source;
  }

  @override
  int getId(int index) {
    return (appointments[index] as local.Appointment).id;
  }

  @override
  DateTime getStartTime(int index) {
    final local.Appointment appointment =
        appointments[index] as local.Appointment;
    // Bug in syncfusion, do not return DateTime of appointment.from object
    return DateTime(
      appointment.from.year,
      appointment.from.month,
      appointment.from.day,
      appointment.from.hour,
      appointment.from.minute,
    );
  }

  @override
  DateTime getEndTime(int index) {
    final local.Appointment appointment =
        appointments[index] as local.Appointment;
    // Bug in syncfusion, do not return DateTime of appointment.to object
    return DateTime(
      appointment.to.year,
      appointment.to.month,
      appointment.to.day,
      appointment.to.hour,
      appointment.to.minute,
    );
  }

  @override
  String getSubject(int index) {
    return (appointments[index] as local.Appointment).title;
  }

  @override
  Color getColor(int index) {
    if ((appointments[index] as local.Appointment).isAllDay) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  bool isAllDay(int index) {
    return (appointments[index] as local.Appointment).isAllDay;
  }

  @override
  String getRecurrenceRule(int index) {
    if ((appointments[index] as local.Appointment).isYearly) {
      return 'FREQ=YEARLY;BYMONTHDAY=${getStartTime(index).day};'
          'BYMONTH=${getStartTime(index).month}';
    }
    return '';
  }
}
