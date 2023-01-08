import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 퍼센트를 애니메이션으로 표현하고 싶을때 사용하는 위젯
class ProgressBar extends StatefulWidget {
  final double totalRatio;
  final double? sidePadding;
  final Widget? description;
  final TextStyle? percentStyle;
  final TextStyle? numberStyle;
  final bool? showPercent;
  final Color? progressColor;
  final Color? backgroundColor;
  final double? barHeight;
  final double? indicatorSize;
  final AnimationController? animationController;
  final VoidCallback? animationListener;


  const ProgressBar(
      {required this.totalRatio,
        this.numberStyle,
        this.percentStyle,
        this.showPercent,
        this.backgroundColor,
        this.progressColor,
        this.indicatorSize,
        this.barHeight,
        this.sidePadding,
        this.animationController,
        this.animationListener,
        this.description});

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {


  /// 프로그래스 애니메이션 컨트롤러
  late final AnimationController _animController;

  /// 애니메이션 담당하는 프로그래스
  late Animation myProgressAnim;

  /// 0부터 시작하여 그려지는 애니메이션의 값
  final ValueNotifier<double> progressRatio = ValueNotifier<double>(0.0); //

  TextStyle? numberStyle;
  TextStyle? percentStyle;

  @override
  void initState() {
    _animController = widget.animationController ?? AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    numberStyle = widget.numberStyle ??  const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        letterSpacing: -0.5,
        height: 1.2);

    percentStyle = widget.percentStyle ?? const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        letterSpacing: -0.5,
        height: 1.2);

    // 챌린지의 정보를 토대로 애니메이션을 설정
    setInitData();

    SchedulerBinding.instance.addPostFrameCallback((_){
      _animController.forward();
    });
    super.initState();
  }

  void setInitData(){
    myProgressAnim = Tween<double>(begin: 0, end: widget.totalRatio)
        .animate(_animController)
      ..addListener(_myProgressListener);

    if(widget.animationListener != null){
      myProgressAnim.addListener(widget.animationListener!);
    }
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    // 위젯 변경시에 변경된 정보를 가지고 새롭게 정보 설정
    setInitData();

    // 애니메이션이 진행된 경우 이를 초기화 하는 과정
    if (!_animController.isDismissed && !_animController.isAnimating) {
      progressRatio.value = 0.0;
      _animController.reset();
      _animController.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animController
      ..stop()
      ..dispose();
    super.dispose();
  }

  /// ## 퍼센트 애니메이션 컨트롤러
  /// 애니메이션이 시작됨에 따라 퍼센트의 변화를 통해 실제 프로그래스바가 움직인다.
  void _myProgressListener() {
    final value = myProgressAnim.value ?? 0;
    if (value > 0) {
      progressRatio.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.sidePadding ?? 0),
      child: _myProgressBar,
    );
  }

  /// 프로그래스바 영역
  Widget get _myProgressBar {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        percentInfo(),
        Stack(
          children: [
            _totalProgress(),
            if (widget.totalRatio != 0)
              ValueListenableBuilder(
                valueListenable: progressRatio,
                builder: (BuildContext context, double value, Widget? child) {
                  // value = _counter 로 적용
                  return _activeProgress(progressRatio.value, widget.progressColor ?? Colors.blue);
                },
              )

          ],
        ),
      ],
    );
  }

  Widget percentInfo(){
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      widget.description ?? Container(),
      ValueListenableBuilder(
        valueListenable: progressRatio, // 사용할 변수를 지정.
        builder: (BuildContext context, double value, Widget? child) {
          // value = _counter 로 적용
          return RichText(
              text: TextSpan(children: [
                TextSpan(
                    style: numberStyle,
                    text: progressRatio.value.toStringAsFixed(0)),
                TextSpan(
                    style: percentStyle,
                    text: '%')
              ]));
        },
      )
    ]);
  }

  Widget _totalProgress(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: widget.backgroundColor ?? Colors.white,
      ),
      width: double.infinity,
      height: widget.barHeight ?? 28,
    );
  }

  /// ### 실제 달성한 프로그래스 부분 (Foreground progress)
  /// [ratio]는 반영할 달성율을, [color]는 foreground 색상을 의미한다.
  Widget _activeProgress(double ratio, Color color) {
    /// 전체 프로그래스바의 너비
    final totalWidth = MediaQuery.of(context).size.width;
    final double _progressWidth = totalWidth - ((widget.sidePadding ?? 0) * 2);
    double _width = _progressWidth * (ratio / 100);

    return Container(
      height: widget.barHeight ?? 28,
      width: _width + 6,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(14.0)),
      child: Container(
        width: widget.indicatorSize ?? 24,
        height: widget.indicatorSize ?? 24,
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color),
        ),
      ),
    );
  }

}
