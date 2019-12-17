import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_cast_button/bloc_media_route.dart';
import 'package:flutter_google_cast_button/flutter_google_cast_button.dart';

class CastButtonWidget extends StatefulWidget {
  final MediaRouteBloc bloc;
  final Color tintColor;

  CastButtonWidget({this.bloc, this.tintColor});

  @override
  State<StatefulWidget> createState() => _CastButtonWidgetState();
}

class _CastButtonWidgetState extends State<CastButtonWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<String> connectingIconTween;
  MediaRouteBloc _bloc;
  static const packageName = "flutter_google_cast_button";
  static const connectingAssets = [
    "images/ic_cast0_black_24dp.png",
    "images/ic_cast1_black_24dp.png",
    "images/ic_cast2_black_24dp.png",
  ];

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? BlocProvider.of<MediaRouteBloc>(context);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    connectingIconTween = TweenSequence<String>([
      TweenSequenceItem<String>(
        tween: ConstantTween<String>(connectingAssets[0]),
        weight: 34.0,
      ),
      TweenSequenceItem<String>(
        tween: ConstantTween<String>(connectingAssets[1]),
        weight: 33.0,
      ),
      TweenSequenceItem<String>(
        tween: ConstantTween<String>(connectingAssets[2]),
        weight: 33.0,
      ),
    ]).animate(_animationController);

    for (String path in connectingAssets) {
      Future(() async {
        final globalCache = PaintingBinding.instance.imageCache;
        var image = ExactAssetImage(path, package: packageName);
        var key = await image.obtainKey(
            createLocalImageConfiguration(context, size: Size(24, 24)));
        final codec = PaintingBinding.instance.instantiateImageCodec;
        globalCache.putIfAbsent(key, () => image.load(key, codec),
            onError: (e, s) => print("preload casting asset error"));
      });
    }
    connectingIconTween.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloc.close();
    super.dispose();
  }

  Future animationFuture;
  MediaRouteState currentState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, newState) {
        if (newState is NoDeviceAvailable) {
          currentState = newState;
          return Container();
        }
        Widget icon;
        if (newState is Unconnected) {
          icon = Icon(Icons.cast, color: widget.tintColor);
        } else if (newState is Connected) {
          icon = Icon(Icons.cast_connected, color: widget.tintColor);
        } else {
          if (!_animationController.isAnimating) {
            Future.delayed(Duration(milliseconds: 20), () {
              _animationController.forward(from: 0.0);
            });
          }
          icon = ImageIcon(
            ExactAssetImage(connectingIconTween.value, package: packageName),
            size: 24,
            color: widget.tintColor,
          );
        }
        currentState = newState;
        return IconButton(
          icon: icon,
          onPressed: () => FlutterGoogleCastButton.showCastDialog(),
        );
      },
    );
  }
}
