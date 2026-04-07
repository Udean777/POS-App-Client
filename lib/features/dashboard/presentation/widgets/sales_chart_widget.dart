import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/src/theme/app_theme.dart';

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

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tren Penjualan",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "7 Hari Terakhir",
                style: Theme.of(context).textTheme.bodySmall,
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
                      FlLine(color: AppColors.surfaceVariant, strokeWidth: 1),
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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                    color: AppColors.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.card,
                            strokeWidth: 3,
                            strokeColor: AppColors.primary,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0),
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
