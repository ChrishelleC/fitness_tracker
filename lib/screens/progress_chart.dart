import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../controller/workout_controller.dart';

class ProgressChartsScreen extends StatefulWidget {
  const ProgressChartsScreen({super.key});

  @override
  State<ProgressChartsScreen> createState() => _ProgressChartsScreenState();
}

class _ProgressChartsScreenState extends State<ProgressChartsScreen> {
  final WorkoutController workoutController = Get.find<WorkoutController>();
  String selectedMetric = 'Workout Frequency';
  String selectedPeriod = 'Weekly';

  final List<String> metrics = [
    'Workout Frequency',
    'Calories Burned',
    'Duration'
  ];

  final List<String> periods = [
    'Weekly',
    'Monthly',
  ];

  List<FlSpot> getChartData() {
    final workouts = workoutController.workoutList;
    
    if (workouts.isEmpty) {
      return [const FlSpot(0, 0)];
    }

    final now = DateTime.now();
        final DateTime startDate = selectedPeriod == 'Weekly'
        ? DateTime(now.year, now.month, now.day - 6)
        : DateTime(now.year, now.month - 1, now.day);

    Map<int, double> dataPoints = {};
    
    int daysToTrack = selectedPeriod == 'Weekly' ? 7 : 30;
    for (int i = 0; i < daysToTrack; i++) {
      dataPoints[i] = 0;
    }

    final filteredWorkouts = workouts.where((workout) {
      try {
        final workoutDate = DateTime.parse(workout['date']);
        return workoutDate.isAfter(startDate) || workoutDate.isAtSameMomentAs(startDate);
      } catch (_) {
        return false;
      }
    }).toList();

    for (var workout in filteredWorkouts) {
      try {
        final workoutDate = DateTime.parse(workout['date']);
        final dayDifference = now.difference(workoutDate).inDays;
        
        if (dayDifference < daysToTrack) {
          final index = daysToTrack - dayDifference - 1;
          
          if (selectedMetric == 'Workout Frequency') {
            dataPoints[index] = (dataPoints[index] ?? 0) + 1;
          } else if (selectedMetric == 'Calories Burned') {
            final calories = int.tryParse(workout['calories'].toString()) ?? 0;
            dataPoints[index] = (dataPoints[index] ?? 0) + calories;
          } else if (selectedMetric == 'Duration') {
            final duration = int.tryParse(workout['duration'].toString()) ?? 0;
            dataPoints[index] = (dataPoints[index] ?? 0) + duration;
          }
        }
      } catch (_) {
        continue;
      }
    }

    return dataPoints.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }

  Map<String, dynamic> getStats() {
    final data = getChartData();
    
    if (data.isEmpty || data.length == 1 && data[0].y == 0) {
      return {
        'highest': {'day': 'N/A', 'value': 'N/A'},
        'average': 'N/A',
        'trend': '0%',
      };
    }
    FlSpot highestPoint = data.reduce((curr, next) => curr.y > next.y ? curr : next);
        double sum = data.fold(0, (prev, spot) => prev + spot.y);
    double average = sum / data.length;
        int midPoint = data.length ~/ 2;
    double firstHalfSum = 0;
    double secondHalfSum = 0;
    
    for (int i = 0; i < data.length; i++) {
      if (i < midPoint) {
        firstHalfSum += data[i].y;
      } else {
        secondHalfSum += data[i].y;
      }
    }
    
    double firstHalfAvg = firstHalfSum / midPoint;
    double secondHalfAvg = secondHalfSum / (data.length - midPoint);
    
    double trendPercentage = firstHalfAvg == 0 
        ? 0 
        : ((secondHalfAvg - firstHalfAvg) / firstHalfAvg) * 100;
    
    String trendDisplay = trendPercentage.abs() < 0.1 
        ? '0%' 
        : '${trendPercentage.toStringAsFixed(1)}%';
    
    String highestDayLabel = 'Day ${highestPoint.x.toInt() + 1}';
    String highestValue = '';
    
    if (selectedMetric == 'Workout Frequency') {
      highestValue = '${highestPoint.y.toInt()} workouts';
      average = double.parse(average.toStringAsFixed(1));
    } else if (selectedMetric == 'Calories Burned') {
      highestValue = '${highestPoint.y.toInt()} cal';
      average = double.parse(average.toStringAsFixed(0));
    } else {
      highestValue = '${highestPoint.y.toInt()} mins';
      average = double.parse(average.toStringAsFixed(0));
    }
    
    return {
      'highest': {'day': highestDayLabel, 'value': highestValue},
      'average': average.toString(),
      'trend': trendDisplay,
      'trendDirection': trendPercentage >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
      'trendColor': trendPercentage >= 0 ? Colors.green : Colors.red,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Charts", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMetric,
                    items: metrics
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMetric = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Metric",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedPeriod,
                    items: periods
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPeriod = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Period",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                final chartData = getChartData();
                double maxY = 0;
                
                if (chartData.isNotEmpty) {
                  maxY = chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
                  maxY = maxY * 1.2; 
                  maxY = maxY == 0 ? 10 : maxY; 
                }
                
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true, 
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (selectedPeriod == 'Weekly') {
                              final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              int index = value.toInt();
                              if (index >= 0 && index < weekdays.length) {
                                return Text(weekdays[index]);
                              }
                            }
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.2),
                        ),
                      ),
                    ],
                    minY: 0,
                    maxY: maxY,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final stats = getStats();
                final highest = stats['highest'];
                final average = stats['average'];
                final trend = stats['trend'];
                final trendIcon = stats['trendDirection'] ?? Icons.arrow_forward;
                final trendColor = stats['trendColor'] ?? Colors.grey;
                
                String avgDisplay = 'N/A';
                if (average != 'N/A') {
                  if (selectedMetric == 'Workout Frequency') {
                    avgDisplay = '$average per day';
                  } else if (selectedMetric == 'Calories Burned') {
                    avgDisplay = '$average cal';
                  } else {
                    avgDisplay = '$average mins';
                  }
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Stats: $selectedMetric",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem("Highest", highest['day'], highest['value']),
                        _buildStatItem("Average", avgDisplay),
                        _buildStatItem("Trend", trend, trendIcon, trendColor),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [dynamic iconOrSubtitle, Color? iconColor]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        if (iconOrSubtitle is String)
          Text(
            iconOrSubtitle,
            style: const TextStyle(fontSize: 12),
          )
        else if (iconOrSubtitle is IconData)
          Icon(
            iconOrSubtitle,
            size: 16,
            color: iconColor ?? Colors.green,
          ),
      ],
    );
  }
}