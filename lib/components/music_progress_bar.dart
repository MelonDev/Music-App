import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget musicProgressBar(
    {required BuildContext context,
    required double width,
    ThemeData? theme,
    Duration? buffer,
    ValueChanged<Duration>? onChanged,
    required Duration total,
    required Duration progress}) {
  int totalValue = total.inMilliseconds;
  int progressValue = progress.inMilliseconds;
  int bufferValue = buffer?.inMilliseconds ?? 0;
  theme ??= Theme.of(context);

  Duration remainingDuration = Duration(milliseconds: totalValue - progressValue);
  double percent = (bufferValue / totalValue).toDouble();
  return Column(
    children: [
      Container(height:8),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: theme.colorScheme.primary,
          inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.1),
          trackShape: const RoundedRectSliderTrackShape(),
          trackHeight: 6.0,
          thumbColor: Colors.white,
          thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 14.0, elevation: 6, pressedElevation: 10),
          overlayColor: Colors.white,
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Stack(
                alignment: Alignment.centerLeft,
                children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: percent >= 0.0 && percent <= 1.0 ? LinearPercentIndicator(
                    width: width - 40,
                    lineHeight: 6.0,
                    percent: percent,
                    barRadius: const Radius.circular(10),
                    backgroundColor: Colors.transparent,
                    progressColor: theme.colorScheme.primary.withOpacity(0.2),
                  ) : Container(),
                ),
                Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                    value: progressValue.toDouble(),
                    min: 0,
                    max: totalValue.toDouble(),
                    onChanged: (double value) {

                      if(onChanged != null){
                        onChanged.call(Duration(milliseconds: value.toInt()));
                      }

                    },
                  ),
                ),
              ]
            ),
            Container(
              margin: const EdgeInsets.only(left:30,top:32,right: 30),
              child: Stack(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${progress.inMinutes.remainder(60).toString().padLeft(2, "0")}:${(progress.inSeconds.remainder(60).toString().padLeft(2, "0"))}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "-${remainingDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${(remainingDuration.inSeconds.remainder(60).toString().padLeft(2, "0"))}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    ],
  );
}
