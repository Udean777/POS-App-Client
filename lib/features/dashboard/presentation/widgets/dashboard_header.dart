import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum RevenueFilter { sevenDays, oneMonth, oneYear }

class DashboardHeader extends StatefulWidget {
  final UserEntity user;
  final List<TransactionEntity> transactions;

  const DashboardHeader({
    super.key,
    required this.user,
    required this.transactions,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  RevenueFilter _selectedFilter = RevenueFilter.oneMonth;

  double get _calculateTotalRevenue {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedFilter) {
      case RevenueFilter.sevenDays:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case RevenueFilter.oneMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case RevenueFilter.oneYear:
        startDate = DateTime(now.year, 1, 1);
        break;
    }

    return widget.transactions
        .where((tx) => tx.createdAt.isAfter(startDate))
        .fold(0.0, (sum, tx) => sum + tx.totalAmount);
  }

  String get _filterLabel {
    switch (_selectedFilter) {
      case RevenueFilter.sevenDays:
        return "7 Hari Terakhir";
      case RevenueFilter.oneMonth:
        return "Bulan Ini";
      case RevenueFilter.oneYear:
        return "Tahun Ini";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: const BoxDecoration(color: AppColors.background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.user.role.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo!",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.user.role,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textHeadline,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Revenue Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Pendapatan",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filterLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  CurrencyFormatter.toIDR(_calculateTotalRevenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 24),

                // Filter Switcher
                Row(
                  children: [
                    _buildFilterChip(RevenueFilter.sevenDays, "7 Hari"),
                    const SizedBox(width: 8),
                    _buildFilterChip(RevenueFilter.oneMonth, "Bulan"),
                    const SizedBox(width: 8),
                    _buildFilterChip(RevenueFilter.oneYear, "Tahun"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(RevenueFilter filter, String label) {
    bool isSelected = _selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
