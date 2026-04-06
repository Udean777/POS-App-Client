import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';

class SalesChartWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const SalesChartWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Generate data for last 7 days
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateTime(date.year, date.month, date.day);
    });

    final dailyValue = <DateTime, double>{};
    for (var date in last7Days) {
      dailyValue[date] = 0;
    }

    for (var tx in transactions) {
      final date = DateTime(
        tx.createdAt.toLocal().year,
        tx.createdAt.toLocal().month,
        tx.createdAt.toLocal().day,
      );
      if (dailyValue.containsKey(date)) {
        dailyValue[date] = (dailyValue[date] ?? 0) + tx.totalAmount;
      }
    }

    final spots = last7Days.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), dailyValue[entry.value] ?? 0);
    }).toList();

    // Determine max Y for scaling
    double maxY = 0;
    for (var value in dailyValue.values) {
      if (value > maxY) maxY = value;
    }
    maxY = maxY == 0 ? 1000 : maxY * 1.2;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tren Penjualan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "7 Hari Terakhir",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AspectRatio(
            aspectRatio: 1.8,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey[100], strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= last7Days.length) {
                          return const SizedBox();
                        }
                        final date = last7Days[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            DateFormat('E').format(date),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: const Color(0xFF6366F1),
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.2),
                          const Color(0xFF6366F1).withValues(alpha: 0),
                        ],
                      ),
                    ),
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
