import 'package:client/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:flutter/material.dart';

class StackedStatCarousel extends StatefulWidget {
  final String totalProducts;
  final String transactionsToday;

  const StackedStatCarousel({
    super.key,
    required this.totalProducts,
    required this.transactionsToday,
  });

  @override
  State<StackedStatCarousel> createState() => _StackedStatCarouselState();
}

class _StackedStatCarouselState extends State<StackedStatCarousel> {
  late final PageController _pageController = PageController(initialPage: 10000)
    ..addListener(_updatePage);
  double _currentPage = 10000.0;

  void _updatePage() {
    setState(() {
      _currentPage = _pageController.page ?? 10000.0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_updatePage);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = [_buildTotalProductsCard(), _buildTransactionsTodayCard()];

    return SizedBox(
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base Stack Layout based on _currentPage
          ...(() {
            final decoratedCards = List.generate(2, (index) {
              // Calculate nearest active integer for this card
              // The card `index` is active at integer positions `index`, `index+2`, `index-2`...
              final double diff = _currentPage - index;
              final double e = (diff / 2.0).roundToDouble() * 2.0;
              final double nearestK = index + e;

              final double relativePosition = nearestK - _currentPage;

              double scale = 1.0;
              double dx = 0.0;
              double dy = 0.0;
              double opacity = 1.0;
              double rotate = 0.0;

              if (relativePosition > 0) {
                // Item is behind the current active card, moving to front
                scale = 1 - (relativePosition * 0.08).clamp(0.0, 1.0);
                dy = 24 * relativePosition;
              } else if (relativePosition <= 0) {
                // Item is sliding out to the left and looping to the back
                double progress = -relativePosition;

                // Parabolic sweep out and in
                double sweep = 4 * progress * (1 - progress);

                dx = sweep * -MediaQuery.of(context).size.width * 0.6;
                rotate = sweep * -0.15;

                scale = 1.0 - (progress * 0.08).clamp(0.0, 1.0);
                dy = progress * 24;
              }

              return _CardData(
                scale: scale,
                dx: dx,
                dy: dy,
                rotate: rotate,
                opacity: opacity,
                widget: cards[index],
              );
            });

            decoratedCards.sort((a, b) => a.scale.compareTo(b.scale));

            return decoratedCards.map((data) {
              return Transform.translate(
                offset: Offset(data.dx, data.dy),
                child: Transform.rotate(
                  angle: data.rotate,
                  child: Transform.scale(
                    scale: data.scale.clamp(0.0, 1.0),
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: data.opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: data.widget,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList();
          })(),

          // Invisible PageView to capture swipe gestures perfectly with native physics
          PageView.builder(
            controller: _pageController,
            // null itemCount enables infinite loops
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(color: Colors.transparent);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalProductsCard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DashboardStatCard(
        title: "Total Produk",
        value: widget.totalProducts,
        icon: Icons.inventory_2,
        color: const Color(0xFF6366F1),
      ),
    );
  }

  Widget _buildTransactionsTodayCard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DashboardStatCard(
        title: "Transaksi Hari Ini",
        value: widget.transactionsToday,
        icon: Icons.shopping_cart,
        color: const Color(0xFF10B981),
      ),
    );
  }
}

class _CardData {
  final double scale;
  final double dx;
  final double dy;
  final double rotate;
  final double opacity;
  final Widget widget;

  _CardData({
    required this.scale,
    required this.dx,
    required this.dy,
    required this.rotate,
    required this.opacity,
    required this.widget,
  });
}
