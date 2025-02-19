import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:novel_flutter_bit/route/route.dart';
import 'package:novel_flutter_bit/theme/theme_style.dart';
import 'package:novel_flutter_bit/tools/logger_tools.dart';
import 'package:novel_flutter_bit/widget/empty.dart';
import 'package:novel_flutter_bit/widget/loading.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
  } else if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色
      statusBarBrightness: Brightness.light, // 状态栏文字颜色
    ));

    /// 强制竖屏
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else if (Platform.isWindows || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      minimumSize: Size(800, 600),
      //maximumSize: Size(1200, 1000),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // make sure you don't initiate your router
  // inside of the build function.
  final _appRouter = AppRouter();
  late bool _init = false;
  @override
  Widget build(BuildContext context) {
    if (!_init) {
      SmartDialog.config.toast = SmartConfigToast(debounce: true);
      _init = true;
    }
    return Consumer(builder: (context, ref, child) {
      LoggerTools.looger.d("MyApp Page build");
      final theme = ref.watch(themeStyleProviderProvider);
      return Center(
        child: switch (theme) {
          AsyncData(:final value) => _buildSuccess(value),
          AsyncError() => EmptyBuild(),
          _ => const LoadingBuild(),
        },
      );
    });
  }

  /// build
  _buildSuccess(ThemeData theme) {
    return MaterialApp.router(
      title: 'BITReader',
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(
        navigatorObservers: () => [FlutterSmartDialog.observer],
      ),
      builder: FlutterSmartDialog.init(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
