import 'package:auto_route/auto_route.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novel_flutter_bit/base/base_state.dart';
import 'package:novel_flutter_bit/icons/novel_icon_icons.dart';
import 'package:novel_flutter_bit/pages/detail_novel/view_model/detail_view_model.dart';
import 'package:novel_flutter_bit/pages/novel/state/novel_state.dart';
import 'package:novel_flutter_bit/pages/novel/view_model/novel_view_model.dart';
import 'package:novel_flutter_bit/style/theme_novel.dart';
import 'package:novel_flutter_bit/tools/padding_extension.dart';
import 'package:novel_flutter_bit/widget/empty.dart';
import 'package:novel_flutter_bit/widget/loading.dart';
import 'package:novel_flutter_bit/widget/special_text_span_builder.dart';

@RoutePage()
class NovelPage extends ConsumerStatefulWidget {
  const NovelPage({
    super.key,
    required this.url,
    required this.name,
    required this.novelUrl,
  });
  final String url;
  final String name;
  final String novelUrl;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NovelPageState();
}

class _NovelPageState extends ConsumerState<NovelPage> {
  final NovleSpecialTextSpanBuilder _specialTextSpanBuilder =
      NovleSpecialTextSpanBuilder(color: Colors.black);

  /// 动画时长
  final Duration _duration = const Duration(milliseconds: 300);

  /// 控制AppBar和BottomNavigationBar的可见性
  bool _isAppBarVisible = false;
  bool _isBottomBarVisible = false;

  /// 详情
  late DetailViewModel _detailViewModel;

  /// 主题
  late NovelTheme _novelTheme;

  /// 构建 scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// 主题
  //late ThemeStyleProvider _themeData;

  /// 显示隐藏
  _isShow() {
    setState(() {
      _isAppBarVisible = !_isAppBarVisible;
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _detailViewModel =
        ref.read(detailViewModelProvider(urlBook: widget.novelUrl).notifier);
  }

  /// 获取文本
  String _getText({required String htmlContent}) {
    String plainText = htmlContent.replaceAll(RegExp(r'&nbsp;'), ' ');
    String plainText1 = plainText.replaceAll(RegExp(r'</p>'), ' ');
    String plainText2 = plainText1.replaceAll(RegExp(r'<br />'), '\n');
    return plainText2;
  }

  @override
  Widget build(BuildContext context) {
    _novelTheme = Theme.of(context).extension<NovelTheme>()!;
    // _themeData = context.read<ThemeStyleProvider>();
    // _detailViewModel = context.watch<DetailViewModel?>();
    //_detailViewModel = Provider.of<DetailViewModel>(context);
    _specialTextSpanBuilder.color = _novelTheme.selectedColor!;
    final novelViewModel =
        ref.watch(novelViewModelProvider(urlNovel: widget.url));
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _novelTheme.backgroundColor,
      appBar: _buildAppBar(
          height: 65,
          minHeight: 40,
          duration: _duration,
          isAppBarVisible: _isAppBarVisible),
      body: switch (novelViewModel) {
        AsyncData(:final value) => Builder(builder: (BuildContext context) {
            //LoggerTools.looger.e(value.netState);
            if (value.netState == NetState.loadingState) {
              return const LoadingBuild();
            }
            return _buildSuccess(value: value);
          }),
        AsyncError() => const EmptyBuild(),
        _ => const LoadingBuild(),
      },
      // ProviderConsumer<NovelViewModel>(
      //   viewModel: _novelViewModel,
      //   builder: (BuildContext context, NovelViewModel value, Widget? child) {
      //     if (value.novelState.netState == NetState.loadingState) {
      //       return const LoadingBuild();
      //     }

      //     if (value.novelState.netState == NetState.emptyDataState) {
      //       return const EmptyBuild();
      //     }
      //     return _buildSuccess(value, novelTheme: _novelTheme);
      //   },
      // ),
      bottomNavigationBar: _buildBottmAppBar(
        height: 100,
        minHeight: 0,
        duration: _duration,
        isBottomBarVisible: _isBottomBarVisible,
      ),
      drawer: _buildDrawer(),
    );
  }

  /// 侧边栏构建抽屉
  _buildDrawer() {
    return Drawer(
      backgroundColor: _novelTheme.backgroundColor,
      child: SafeArea(
          child: Padding(
        padding: 10.padding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "目录",
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Text("${index}");
                  },
                  itemCount: _detailViewModel
                      .detailState.detailNovel?.data?.list?.length))
        ]),
      )),
    );
  }

  /// 底部导航栏构建
  _buildBottmAppBar(
      {required double height,
      required double minHeight,
      required Duration duration,
      required bool isBottomBarVisible}) {
    return AnimatedContainer(
      height: isBottomBarVisible ? height : minHeight,
      duration: duration,
      decoration: BoxDecoration(
        color: _novelTheme.bottomAppBarColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: AnimatedOpacity(
        opacity: isBottomBarVisible ? 1 : 0,
        duration: duration,
        child: BottomAppBar(
          color: _novelTheme.bottomAppBarColor,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomAppBarItem(
                    icon: Icons.folder,
                    text: "目录",
                    onPressed: // 使用 scaffoldKey 当前 scaffold 打开抽屉
                        scaffoldKey.currentState?.openDrawer),
                _buildBottomAppBarItem(icon: NovelIcon.backward, text: "上一页"),
                _buildBottomAppBarItem(icon: NovelIcon.forward, text: "下一页"),
                _buildBottomAppBarItem(
                    icon:
                        // _themeData.theme.brightness != Brightness.dark
                        //     ?
                        //  Icons.nightlight
                        // :
                        Icons.wb_sunny,
                    text:
                        // _themeData.theme.brightness != Brightness.dark
                        //     ? "夜间"
                        //     :
                        "白天",
                    onPressed: null //_themeData.switchTheme
                    ),
                _buildBottomAppBarItem(icon: Icons.settings, text: "设置")
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 底部导航栏子项构建
  _buildBottomAppBarItem({
    void Function()? onPressed,
    required IconData icon,
    required String text,
  }) {
    return Column(
      children: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: _novelTheme.selectedColor,
            )),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.black))
      ],
    );
  }

  /// appBar 构建
  _buildAppBar(
      {required double height,
      required double minHeight,
      required Duration duration,
      required bool isAppBarVisible}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: AnimatedContainer(
        height: _isAppBarVisible ? height * 1.5 : minHeight,
        duration: duration,
        child: AnimatedOpacity(
          opacity: _isAppBarVisible ? 1.0 : 0.0,
          duration: duration,
          child: SingleChildScrollView(
            child: AppBar(
              leading: const BackButton(),
              title: Text(widget.name),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建成功
  _buildSuccess({required NovelState value}) {
    TextStyle style = TextStyle(
        fontSize: _novelTheme.fontSize,
        fontWeight: _novelTheme.fontWeight,
        color: _novelTheme.notSelectedColor);
    return GestureDetector(
      onTap: _isShow,
      child: SingleChildScrollView(
          padding: 20.padding,
          child: ExtendedText.rich(TextSpan(children: [
            _specialTextSpanBuilder.build(
                _getText(htmlContent: value.novelEntry.data?.text ?? ''),
                textStyle: style)
          ]))),
    );
  }
}
