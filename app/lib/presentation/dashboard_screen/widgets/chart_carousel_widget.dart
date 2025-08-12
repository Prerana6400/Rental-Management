import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ChartCarouselWidget extends StatefulWidget {
  const ChartCarouselWidget({Key? key}) : super(key: key);

  @override
  State<ChartCarouselWidget> createState() => _ChartCarouselWidgetState();
}

class _ChartCarouselWidgetState extends State<ChartCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> chartData = [
    {
      "type": "bar",
      "title": "Monthly Revenue",
      "data": [
        {"month": "Jan", "value": 45000.0},
        {"month": "Feb", "value": 52000.0},
        {"month": "Mar", "value": 48000.0},
        {"month": "Apr", "value": 61000.0},
        {"month": "May", "value": 55000.0},
        {"month": "Jun", "value": 67000.0},
      ]
    },
    {
      "type": "pie",
      "title": "Product Categories",
      "data": [
        {"category": "Electronics", "value": 35.0, "color": "0xFF00BFA5"},
        {"category": "Furniture", "value": 28.0, "color": "0xFFFF9800"},
        {"category": "Vehicles", "value": 22.0, "color": "0xFF4CAF50"},
        {"category": "Others", "value": 15.0, "color": "0xFFF44336"},
      ]
    },
    {
      "type": "line",
      "title": "User Growth",
      "data": [
        {"week": 1, "value": 1200.0},
        {"week": 2, "value": 1350.0},
        {"week": 3, "value": 1180.0},
        {"week": 4, "value": 1420.0},
        {"week": 5, "value": 1580.0},
        {"week": 6, "value": 1650.0},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35.h,
        child: Column(children: [
          Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: chartData.length,
                  itemBuilder: (context, index) {
                    return _buildChart(chartData[index]);
                  })),
          SizedBox(height: 2.h),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  chartData.length,
                  (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      width: _currentIndex == index ? 3.w : 2.w,
                      height: 1.h,
                      decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppTheme.accentColor
                              : AppTheme.textDisabled,
                          borderRadius: BorderRadius.circular(4))))),
        ]));
  }

  Widget _buildChart(Map<String, dynamic> data) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.darkTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowDark,
                  blurRadius: 8,
                  offset: const Offset(0, 4)),
            ]),
        child: Column(children: [
          Text(data["title"],
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Expanded(
              child: data["type"] == "bar"
                  ? _buildBarChart(data["data"])
                  : data["type"] == "pie"
                      ? _buildPieChart(data["data"])
                      : _buildLineChart(data["data"])),
        ]));
  }

  Widget _buildBarChart(List<dynamic> data) {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 70000,
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  '\$${rod.toY.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  AppTheme.darkTheme.textTheme.bodySmall!
                      .copyWith(color: AppTheme.textPrimary));
            })),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final months = (data)
                          .map((item) => item["month"] as String)
                          .toList();
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()],
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondary));
                      }
                      return const SizedBox.shrink();
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10.w,
                    getTitlesWidget: (value, meta) {
                      return Text('${(value / 1000).toInt()}K',
                          style: AppTheme.darkTheme.textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary));
                    })),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
        barGroups: (data).asMap().entries.map((entry) {
          return BarChartGroupData(x: entry.key, barRods: [
            BarChartRodData(
                toY: (entry.value["value"] as double),
                color: AppTheme.accentColor,
                width: 6.w,
                borderRadius: BorderRadius.circular(4)),
          ]);
        }).toList(),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.dividerSubtle.withValues(alpha: 0.3),
                  strokeWidth: 1);
            })));
  }

  Widget _buildPieChart(List<dynamic> data) {
    return PieChart(PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 8.w,
        sections: (data).map((item) {
          return PieChartSectionData(
              color: Color(int.parse(item["color"])),
              value: item["value"],
              title: '${item["value"].toInt()}%',
              radius: 12.w,
              titleStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary, fontWeight: FontWeight.w600));
        }).toList(),
        pieTouchData:
            PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
          // Handle touch interactions
        })));
  }

  Widget _buildLineChart(List<dynamic> data) {
    return LineChart(LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 200,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.dividerSubtle.withValues(alpha: 0.3),
                  strokeWidth: 1);
            }),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text('W${value.toInt()}',
                          style: AppTheme.darkTheme.textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary));
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10.w,
                    getTitlesWidget: (value, meta) {
                      return Text('${(value / 1000).toInt()}K',
                          style: AppTheme.darkTheme.textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary));
                    })),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: 6,
        minY: 1000,
        maxY: 1800,
        lineBarsData: [
          LineChartBarData(
              spots: (data).map((item) {
                return FlSpot(
                    (item["week"] as int).toDouble(), item["value"] as double);
              }).toList(),
              isCurved: true,
              color: AppTheme.accentColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.accentColor,
                        strokeWidth: 2,
                        strokeColor: AppTheme.darkTheme.cardColor);
                  }),
              belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.accentColor.withValues(alpha: 0.1))),
        ],
        lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                    '${barSpot.y.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} users',
                    AppTheme.darkTheme.textTheme.bodySmall!
                        .copyWith(color: AppTheme.textPrimary));
              }).toList();
            }))));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
