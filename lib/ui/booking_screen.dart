import 'package:flutter/material.dart';
import 'package:movie_ticket/widget/app_widget.dart';
import 'package:movie_ticket/widget/videoclipper.dart';
import 'package:movie_ticket/widget/videoclipper2.dart';

import 'package:video_player/video_player.dart';

class BookingScreen extends StatefulWidget {
  final VideoPlayerController moviePlayerController;
  final VideoPlayerController reflectionPlayerController;
  final String movieName;

  const BookingScreen(
      {super.key,
      required this.moviePlayerController,
      required this.reflectionPlayerController,
      required this.movieName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  Size get _size => MediaQuery.of(context).size;
  final List<AnimationController> _dateSelectorACList = [];
  final List<Animation<double>> _dateSelectorTweenList = [];

  final List<AnimationController> _timeSelectorACList = [];
  final List<Animation<double>> _timeSelectorTweenList = [];

  late AnimationController _dateBackgroundAc;
  late Animation<double> _dateBackgroundTween;

  late AnimationController _cinemaScreenAc;
  late Animation<double> _cinemaScreenTween;

  late AnimationController _reflectionAc;
  late Animation<double> _reflectionTween;

  late AnimationController _payButtonAc;
  late Animation<double> _payButtonTween;

  late AnimationController _cinemaChairAc;
  late Animation<double> _cinemaChairTween;

  int _dateIndexSelected = 1;
  int _timeIndexSelected = 1;
  late final List<List<int>> _chairStatus = [
    [0, 3, 2, 1, 2, 2, 0],
    [2, 2, 2, 2, 1, 2, 2],
    [1, 1, 2, 2, 2, 2, 2],
    [0, 2, 1, 1, 1, 2, 0],
    [2, 2, 2, 2, 2, 2, 2],
    [0, 3, 3, 2, 1, 1, 0]
  ];

  final List<String> _chairSelected = [];

  @override
  void initState() {
    super.initState();
    widget.moviePlayerController.setLooping(true);
    widget.reflectionPlayerController.setLooping(true);
    widget.moviePlayerController.play();
    widget.reflectionPlayerController.play();

    initializeAnimation();
  }

  void initializeAnimation() {
    // initialize dateSelector List
    for (int i = 0; i < 7; i++) {
      _dateSelectorACList.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)));
      _dateSelectorTweenList.add(Tween<double>(begin: 1000, end: 0)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(_dateSelectorACList[i]));
      Future.delayed(Duration(milliseconds: i * 50 + 170), () {
        _dateSelectorACList[i].forward();
      });
    }

    // initialize dateSelector Background
    _dateBackgroundAc = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _dateBackgroundTween = Tween<double>(begin: 1000, end: 0)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(_dateBackgroundAc);
    Future.delayed(const Duration(milliseconds: 150), () {
      _dateBackgroundAc.forward();
    });

    // initialize timeSelector List
    for (int i = 0; i < 4; i++) {
      _timeSelectorACList.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)));
      _timeSelectorTweenList.add(Tween<double>(begin: 1000, end: 0)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(_timeSelectorACList[i]));
      Future.delayed(Duration(milliseconds: i * 25 + 100), () {
        _timeSelectorACList[i].forward();
      });
    }

    // initialize cinemaScreen
    _cinemaScreenAc = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _cinemaScreenTween = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutQuart))
        .animate(_cinemaScreenAc);
    Future.delayed(const Duration(milliseconds: 800), () {
      _cinemaScreenAc.forward();
    });

    // initialize reflection
    _reflectionAc = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _reflectionTween = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutQuart))
        .animate(_reflectionAc);
    Future.delayed(const Duration(milliseconds: 1800), () {
      _reflectionAc.forward();
    });

    // paybutton
    _payButtonAc = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _payButtonTween = Tween<double>(begin: -1, end: 0)
        .chain(CurveTween(curve: Curves.easeInOutQuart))
        .animate(_payButtonAc);
    Future.delayed(const Duration(milliseconds: 800), () {
      _payButtonAc.forward();
    });

    // chair
    _cinemaChairAc = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    _cinemaChairTween = Tween<double>(begin: -1, end: 0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_cinemaChairAc);
    Future.delayed(const Duration(milliseconds: 1200), () {
      _cinemaChairAc.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: <Widget>[
            _appBar(),
            _dateSelector(),
            _timeSelector(),
            _cinemaRoom(),
            _payButton(),
          ],
        ),
      ),
    );
  }

  Widget _cinemaRoom() {
    return Expanded(
        flex: 47,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: _size.width,
            ),
            Container(
              padding: const EdgeInsets.only(top: 18),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: 800,
                child: Center(
                  child: widget.reflectionPlayerController.value.isInitialized
                      ? AnimatedBuilder(
                          animation: _reflectionAc,
                          builder: (ctx, child) {
                            return Opacity(
                              opacity: _reflectionTween.value,
                              child: child,
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: .5,
                            child:
                                VideoPlayer(widget.reflectionPlayerController),
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
            Positioned(
              top: 48,
              child: ClipPath(
                clipper: VideoClipper2(),
                child: AnimatedBuilder(
                  animation: _reflectionAc,
                  builder: (ctx, child) {
                    return Opacity(
                      opacity: _reflectionTween.value,
                      child: child,
                    );
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300] ?? Colors.grey,
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 1],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: _size.height * .02,
                child: AnimatedBuilder(
                    animation: _cinemaChairTween,
                    builder: (ctx, child) {
                      return Transform.translate(
                        offset: Offset(0, _cinemaChairTween.value * 100),
                        child: Opacity(
                            opacity: _cinemaChairTween.value + 1, child: child),
                      );
                    },
                    child: SizedBox(width: _size.width, child: _chairList()))),
            Positioned(
              top: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: widget.moviePlayerController.value.isInitialized
                          ? AnimatedBuilder(
                              animation: _cinemaScreenAc,
                              builder: (ctx, child) {
                                double perspective =
                                    0.004 * _cinemaScreenTween.value;
                                // return ClipPath(
                                //     clipper: VideoClipper(
                                //         curveValue: monitorTween.value),
                                //     child: child);
                                return AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Transform(
                                      alignment: Alignment.topCenter,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, perspective)
                                        ..rotateX(_cinemaScreenTween.value),
                                      child: ClipPath(
                                          clipper: VideoClipper(
                                              curveValue:
                                                  _cinemaScreenTween.value),
                                          child: child)),
                                );
                              },
                              child: VideoPlayer(widget.moviePlayerController),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _payButton() {
    return Expanded(
      flex: 20,
      child: AnimatedBuilder(
        animation: _payButtonAc,
        builder: (ctx, child) {
          double opacity() {
            if (_payButtonTween.value + 1 < 0.2) {
              return (_payButtonTween.value + 1) * 5;
            }
            return 1;
          }

          return Transform.translate(
            offset: Offset(0, _payButtonTween.value * 200),
            child: Opacity(opacity: opacity(), child: child),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _chairCategory(Colors.white, "FREE"),
                  _chairCategory(AppColor.primary, "YOURS"),
                  _chairCategory(Colors.grey[700]!, "RESERVED"),
                  _chairCategory(Colors.red[800]!, "NOT AVAILABLE"),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // print the selected of chair
                },
                child: SizedBox(
                  width: _size.width - 64,
                  height: _size.height * .08,
                  child: const Center(
                    child: Text(
                      'Pay',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chairCategory(Color color, String category) {
    return Row(
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: color),
        ),
        Text(
          category,
          style: const TextStyle(
              fontSize: 12, color: Colors.grey, fontFamily: "Bebas-Neue"),
        ),
      ],
    );
  }

  Widget _chairList() {
    // 0 is null
    // 1 is free
    // 2 is reserved
    // 3 is notavailable
    // 4 is yours

    return Column(
      children: <Widget>[
        for (int i = 0; i < 6; i++)
          Container(
            margin: EdgeInsets.only(top: i == 3 ? _size.height * .02 : 0),
            child: Row(
              children: <Widget>[
                for (int x = 0; x < 9; x++)
                  Expanded(
                    flex: x == 0 || x == 8 ? 2 : 1,
                    child: x == 0 ||
                            x == 8 ||
                            (i == 0 && x == 1) ||
                            (i == 0 && x == 7) ||
                            (i == 3 && x == 1) ||
                            (i == 3 && x == 7) ||
                            (i == 5 && x == 1) ||
                            (i == 5 && x == 7)
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              if (_chairStatus[i][x - 1] == 1) {
                                setState(() {
                                  _chairStatus[i][x - 1] = 4;
                                  _chairSelected.add("$i$x");
                                });
                              } else if (_chairStatus[i][x - 1] == 4) {
                                setState(() {
                                  _chairStatus[i][x - 1] = 1;
                                  _chairSelected.remove("$i$x");
                                });
                              }
                            },
                            child: Container(
                              height: _size.width / 11 - 10,
                              margin: const EdgeInsets.all(5),
                              child: _getChairWidget(_chairStatus[i][x - 1]),
                            ),
                          ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _getChairWidget(int status) {
    switch (status) {
      case 1:
        // free
        return AppWidget.whiteChair();
      case 2:
        // reserved
        return AppWidget.greyChair();
      case 3:
        // not available
        return AppWidget.redChair();
      default:
        // yours
        return AppWidget.yellowChair();
    }
  }

  Widget _timeSelector() {
    final time = [
      ["01.30", 45],
      ["06.30", 45],
      ["10.30", 45],
      ["12.30", 45]
    ];

    return Expanded(
      flex: 17,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: _size.height * .035),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: time.length,
          itemBuilder: (ctx, index) {
            return AnimatedBuilder(
              animation: _timeSelectorACList[index],
              builder: (ctx, child) {
                return Transform.translate(
                  offset: Offset(_timeSelectorTweenList[index].value, 0),
                  child: child,
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: index == 0 ? 32 : 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _timeIndexSelected = index;
                    });
                  },
                  child: _timeItem(time[index][0] as String,
                      time[index][1] as int, index == _timeIndexSelected),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _timeItem(String time, int price, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
            color: active ? AppColor.primary : Colors.white, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: time,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColor.primary : Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' PM',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: active ? AppColor.primary : Colors.white,
                    ),
                  )
                ]),
          ),
          Text(
            "IDR ${price}K",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _dateSelector() {
    DateTime currentDate = DateTime.now();

    return Expanded(
      flex: 13,
      child: Container(
        width: _size.width,
        padding: const EdgeInsets.only(left: 32),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            AnimatedBuilder(
              animation: _dateBackgroundAc,
              builder: (ctx, child) {
                return Transform.translate(
                  offset: Offset(_dateBackgroundTween.value, 0),
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _size.width,
              child: ListView.builder(
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  var date = currentDate.add(Duration(days: index));

                  return AnimatedBuilder(
                    animation: _dateSelectorACList[index],
                    builder: (ctx, child) {
                      return Transform.translate(
                        offset: Offset(_dateSelectorTweenList[index].value, 0),
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _dateIndexSelected = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(
                            vertical: _size.height * .025, horizontal: 12),
                        width: 44,
                        decoration: BoxDecoration(
                            color: _dateIndexSelected == index
                                ? AppColor.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _dayFormat(date.weekday),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: index == _dateIndexSelected
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                color: index == _dateIndexSelected
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dayFormat(int dayWeek) {
    switch (dayWeek) {
      case 1:
        return "MO";
      case 2:
        return "TU";
      case 3:
        return "WE";
      case 4:
        return "TH";
      case 5:
        return "FR";
      case 6:
        return "SA";
      case 7:
        return "SU";
      default:
        return "MO";
    }
  }

  Widget _appBar() {
    return Expanded(
      flex: 8,
      child: Container(
        width: _size.width,
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(
              widget.movieName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Positioned(
              left: 24,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
