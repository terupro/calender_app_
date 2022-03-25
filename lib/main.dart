import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// カレンダーアプリ
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ja'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Calender',
        theme: ThemeData(
            primaryColor: Colors.blue,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.brown)),
        home: CalenderPage());
  }
}

// 日付の定数を作成
final DateTime dayTime = DateTime.now();

// Providerの作成
final _selectedDayProvider = StateProvider((ref) => dayTime);
final _focusedDayProvider = StateProvider((ref) => dayTime);

class CalenderPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerの監視
    final _selectedDay = ref.watch(_selectedDayProvider.notifier);
    final _focusedDay = ref.watch(_focusedDayProvider.notifier);
    const _textStyle = TextStyle(
        fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black54);
    return Scaffold(
      appBar: AppBar(title: const Text('Calender')),
      body: Column(
        children: [
          // table_calenderの内容
          TableCalendar(
            locale: 'ja',
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: ref.watch(_focusedDayProvider),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay.state, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              // Providerの状態を更新
              _selectedDay.state = selectedDay;
              _focusedDay.state = focusedDay;
            },
          ),
          const SizedBox(height: 20.0),
          // 選択した年/月/日を確認するためのWidget
          Container(
            decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'selected year : ${_selectedDay.state.year}年',
                    style: _textStyle,
                  ),
                  Text(
                    'selected month : ${_selectedDay.state.month}月',
                    style: _textStyle,
                  ),
                  Text(
                    'selected day : ${_selectedDay.state.day}日',
                    style: _textStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
