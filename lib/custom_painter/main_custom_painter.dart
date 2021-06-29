import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainCustomPainter extends StatefulWidget {
  @override
  _MainCustomPainterState createState() => _MainCustomPainterState();
}

class _MainCustomPainterState extends State<MainCustomPainter> {
  String _currentText = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _currentText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: BottomAnimated(
        items: [
          TabItem(Icons.home_rounded, "Home", () {
            _rebuild("Home");
          }),
          TabItem(Icons.search, "Search", () {
            _rebuild("Search");
          }),
          TabItem(Icons.notification_important, "Notify", () {
            _rebuild("Notify");
          }),
          TabItem(Icons.settings, "Settings", () {
            _rebuild("Settings");
          }),
        ],
      ),
    );
  }

  _rebuild(text) {
    setState(() {
      _currentText = text;
    });
  }
}

class TabItem {
  IconData iconData;
  String text;
  Function onTap;

  TabItem(this.iconData, this.text, this.onTap);
}

class BottomAnimated extends StatefulWidget {
  final List<TabItem> items;
  final Color backgroundColor;
  final Color circleSelectedColor;

  static const defaultBgColor = Color(0xFF132D48);

  const BottomAnimated({
    Key key,
    @required this.items,
    this.backgroundColor = defaultBgColor,
    this.circleSelectedColor = Colors.white,
  }) : super(key: key);

  @override
  _BottomAnimatedState createState() => _BottomAnimatedState();
}

class _BottomAnimatedState extends State<BottomAnimated>
    with SingleTickerProviderStateMixin {
  // Animation animation;
  AnimationController controller;
  int _currentIndex = 0;

  @override
  void didUpdateWidget(covariant BottomAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    controller.addListener(() {
      setState(() {});
    });
    controller.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 80,
      width: maxWidth,
      child: CustomPaint(
        painter: BNBCustomPainter(
          currentPosition: controller.value * maxWidth * 0.75,
          circleSelectedColor: widget.circleSelectedColor,
          backgroundColor: widget.backgroundColor,
        ),
        child: Container(
          // margin: EdgeInsets.only(top: 16),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(widget.items.length, (index) {
                var tabItem = widget.items[index];
                if (index == _currentIndex) {
                  return Expanded(
                    child: _TabItem(
                      onClick: (position) {},
                      index: index,
                      translateUpValue: 0,
                      color: controller.status == AnimationStatus.completed
                          ? Color(0xFF132D48)
                          : Colors.white,
                      iconData: tabItem.iconData,
                      text: tabItem.text,
                      isSelected: true,
                    ),
                  );
                } else {
                  return Expanded(
                    child: _TabItem(
                      onClick: (position) {
                        tabItem.onTap.call();
                        setState(() {
                          _currentIndex = index;
                        });
                        controller.animateTo(position / 3,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn);
                      },
                      index: index,
                      translateUpValue: 12,
                      color: Colors.white,
                      iconData: tabItem.iconData,
                      text: tabItem.text,
                      isSelected: false,
                    ),
                  );
                }
              })),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final ValueChanged<int> onClick;
  final int index;
  final double translateUpValue;
  final Color color;
  final IconData iconData;
  final String text;
  final bool isSelected;

  const _TabItem({
    Key key,
    @required this.text,
    @required this.iconData,
    @required this.onClick,
    @required this.index,
    @required this.translateUpValue,
    @required this.color,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(index),
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: translateUpValue),
        duration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: color,
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  double currentPosition;
  Color backgroundColor;
  Color circleSelectedColor;

  BNBCustomPainter({
    @required this.currentPosition,
    @required this.backgroundColor,
    @required this.circleSelectedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    var width = size.width;

    Path path = Path();
    path.moveTo(0, 16); // Start

    path.moveTo(currentPosition, 16);

    path.cubicTo(
        currentPosition + width * 0.125 / 2,
        16,
        currentPosition + width * 0.125 / 2,
        0,
        currentPosition + width * 0.125,
        0);

    path.cubicTo(
        currentPosition + size.width * (0.125 + 0.125 / 2),
        0,
        currentPosition + width * (0.125 + 0.125 / 2),
        16,
        currentPosition + width * 0.25,
        16);

    path.lineTo(size.width, 16);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 16);
    canvas.drawShadow(path, Colors.black, 60, true);
    canvas.drawPath(path, paint);

    Paint circlePaint = new Paint()
      ..color = circleSelectedColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(currentPosition + width * 0.125, (size.height) / 2),
        (size.height - 16) / 2,
        circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
