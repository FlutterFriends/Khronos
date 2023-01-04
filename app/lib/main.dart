import 'dart:async';

import 'package:flutter/material.dart';

// number of milliseconds in a minute
const minute = 1000 * 60;

void main() {
  runApp(const AeMetronome());
}

class AeMetronome extends StatelessWidget {
  const AeMetronome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Æ Metronome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const MetronomePage(title: 'Æ Metronome'),
    );
  }
}

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key, required this.title});

  final String title;

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  double _tempo = 80;

  final double _minimumTempoValue = 30;
  final double _maximumTempoValue = 200;
  final double _tempoIncrement = 10;

  double get _tempoDivisions =>
      (_maximumTempoValue - _minimumTempoValue) / _tempoIncrement;

  late Timer _timer;

  int _calculateTimerInterval(int tempo) {
    double timerInterval = minute / tempo;

    return timerInterval.round();
  }

  void _handleTimer(Timer timer) {
    // ignore: avoid_print
    print('Tick: ${timer.tick}');
    // ignore: todo
    // TODO: add sound
  }

  Timer _scheduleTimer([int milliseconds = 10000]) {
    return Timer.periodic(Duration(milliseconds: milliseconds), _handleTimer);
  }

  @override
  void initState() {
    super.initState();
    _timer = _scheduleTimer(_calculateTimerInterval(_tempo.round()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _tempo.round().toString(),
              style: Theme.of(context).textTheme.headline1,
            ),
            Slider(
              value: _tempo,
              min: _minimumTempoValue,
              max: _maximumTempoValue,
              divisions: _tempoDivisions.round(),
              label: _tempo.round().toString(),
              onChanged: (double value) {
                _timer.cancel();

                setState(() {
                  _tempo = value;
                });

                _timer = _scheduleTimer(
                  _calculateTimerInterval(_tempo.round()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
