import 'dart:io';

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:novel_flutter_bit/db/preferences_db.dart';
import 'package:novel_flutter_bit/icons/novel_icon_icons.dart';
import 'package:novel_flutter_bit/pages/book_novel/entry/book_entry.dart';
import 'package:novel_flutter_bit/pages/detail_novel/entry/detail_entry.dart';
import 'package:novel_flutter_bit/pages/detail_novel/view_model/detail_view_model.dart';
import 'package:novel_flutter_bit/pages/home/entry/novel_history_entry.dart';
import 'package:novel_flutter_bit/pages/novel/state/novel_read_state.dart';
import 'package:novel_flutter_bit/pages/novel/state/novel_state.dart';
import 'package:novel_flutter_bit/pages/novel/view_model/novel_view_model.dart';
import 'package:novel_flutter_bit/widget/show_slider_sheet.dart';
import 'package:novel_flutter_bit/route/route.gr.dart';
import 'package:novel_flutter_bit/theme/theme_style.dart';
import 'package:novel_flutter_bit/tools/logger_tools.dart';
import 'package:novel_flutter_bit/widget/net_state_tools.dart';
import 'package:novel_flutter_bit/tools/padding_extension.dart';
import 'package:novel_flutter_bit/tools/size_extension.dart';
import 'package:novel_flutter_bit/widget/empty.dart';
import 'package:novel_flutter_bit/widget/loading.dart';
import 'package:novel_flutter_bit/widget/special_text_span_builder.dart';

@RoutePage()
class NovelPage extends ConsumerStatefulWidget {
  const NovelPage({
    super.key,
    required this.url,
    required this.name,
    required this.bookDatum,
  });
  final String url;
  final String name;
  final BookDatum bookDatum;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NovelPageState();
}

class _NovelPageState extends ConsumerState<NovelPage> {
  final NovelSpecialTextSpanBuilder _specialTextSpanBuilder =
      NovelSpecialTextSpanBuilder(color: Colors.black);

  /// 动画时长
  final Duration _duration = const Duration(milliseconds: 400);

  /// 控制AppBar和BottomNavigationBar的可见性
  bool _isAppBarVisible = false;
  bool _isBottomBarVisible = false;

  /// 详情
  late DetailViewModel _detailViewModel;

  /// 主题
  // late NovelTheme _novelTheme;
  late ThemeData _themeData;

  /// 主题样式
  late ThemeStyleProvider _themeStyleProvider;

  ///
  final ScrollController _controller = ScrollController();

  /// 构建 scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late TextStyle _style;

  /// 默认appbar 高度
  late double appbarHeight = 65;

  @override
  void dispose() {
    _controller.dispose();
    //_themeStyleProvider.initTheme(size: _value);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      appbarHeight = 80;
    }
    _initFontSize();
    _detailViewModel = ref.read(
        detailViewModelProvider(urlBook: widget.bookDatum.url ?? "").notifier);
    _themeStyleProvider = ref.read(themeStyleProviderProvider.notifier);
  }

  /// 初始化字体大小
  _initFontSize() async {
    double size = await PreferencesDB.instance.getNovelFontSize();
    String fontWeight = await PreferencesDB.instance.getNovelFontWeight();

    NovelReadState.size = size;
    NovelReadState.initFontWeight(fontWeight);
    LoggerTools.looger.d("初始化字体大小====》${NovelReadState.size}");
    LoggerTools.looger.d("初始化字体粗细====》${NovelReadState.weight.name}");
  }

  /// 显示隐藏
  _isShow() {
    setState(() {
      _isAppBarVisible = !_isAppBarVisible;
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }

  /// 小说页面切换
  _changeNovelData({required ListElement data}) {
    _detailViewModel.changeNovelDta(data);
    context.router.replace(NovelRoute(
        url: data.url ?? "",
        name: data.name ?? "",
        bookDatum: widget.bookDatum));
  }

  /// 小说页面切换 下一页
  _changeNovelToNext() {
    final index = _detailViewModel.getReadIndex();
    if ((_detailViewModel.detailState.detailNovel?.data?.list?.length ?? 0) <
        index + 1) {
      SmartDialog.showToast("已经是最后一章咯");
      return;
    }
    final data =
        _detailViewModel.detailState.detailNovel?.data?.list?[index + 1];
    _detailViewModel.changeNovelDta(
        data ?? ListElement(name: widget.name, url: widget.url));
    context.router.replace(NovelRoute(
        url: data?.url ?? widget.name,
        name: data?.name ?? widget.url,
        bookDatum: widget.bookDatum));
  }

  /// 小说页面切换 下一页
  _changeNovelToBack() {
    final index = _detailViewModel.getReadIndex();
    if (index == 0) {
      SmartDialog.showToast("已经是第一章咯");
      return;
    }
    final data =
        _detailViewModel.detailState.detailNovel?.data?.list?[index - 1];
    _detailViewModel.changeNovelDta(
        data ?? ListElement(name: widget.name, url: widget.url));
    context.router.replace(NovelRoute(
        url: data?.url ?? widget.name,
        name: data?.name ?? widget.url,
        bookDatum: widget.bookDatum));
  }

  /// 打开抽屉
  _openDrawer({Duration duration = const Duration(milliseconds: 300)}) {
    scaffoldKey.currentState?.openDrawer();
    final index = _detailViewModel.getReadIndex();
    final height = ((context.size?.height ?? 0) / 2.5);
    Future.delayed(duration, () {
      if (index > 100) {
        _controller.jumpTo(index.toDouble() * 50 - height);
        return;
      }
      _controller.animateTo(index.toDouble() * 50 - height,
          duration: duration, curve: Curves.easeIn);
    });
  }

  /// 打开设置
  _openSetting() async {
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return ShowSliderSheet(
              color: _themeData.primaryColor,
              value: NovelReadState.size,
              onChanged: (size) => setState(() {
                    NovelReadState.size = size;
                    NovelReadState.isChange = true;
                  }),
              themeStyleProvider: _themeStyleProvider);
        });
    if (NovelReadState.isChange) {
      await PreferencesDB.instance.setNovelFontSize(NovelReadState.size);
      NovelReadState.isChange = false;
    }
  }

  /// 获取文本
  String _getText({required String htmlContent}) {
    String plainText = htmlContent.replaceAll(RegExp(r'&nbsp;'), ' ');
    String plainText1 = plainText.replaceAll(RegExp(r'</p>'), ' ');
    String plainText2 = plainText1.replaceAll(RegExp(r'<br />'), '\n');
    return plainText2;
  }

  /// 构建初始数据
  void buildInitData() {
    _themeData = Theme.of(context);
    _specialTextSpanBuilder.color = _themeData.primaryColor;
    _style = TextStyle(
        fontSize: NovelReadState.size,
        fontWeight: NovelReadState.weight.fontWeight,
        color: _themeData.textTheme.bodyLarge?.color);
    _specialTextSpanBuilder.color =
        _themeData.textTheme.bodyMedium?.color ?? Colors.black;
  }

  /// 初始化历史记录
  NovelHistoryEntry _initNovelHistoryEntry() {
    final detailNovel = ref
        .read(detailViewModelProvider(urlBook: widget.bookDatum.url ?? "")
            .notifier)
        .detailState
        .detailNovel;
    LoggerTools.looger.d("buildInitData : ${detailNovel?.data?.name}");
    return NovelHistoryEntry(
        name: detailNovel?.data?.name,
        imageUrl: detailNovel?.data?.img,
        readUrl: widget.bookDatum.url,
        readChapter: widget.name,
        datumNew: widget.bookDatum.datumNew);
  }

  @override
  Widget build(BuildContext context) {
    buildInitData();
    final dataHistory = _initNovelHistoryEntry();
    final novelViewModel = ref.watch(novelViewModelProvider(
        urlNovel: widget.url, novelHistory: dataHistory));
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _themeData.scaffoldBackgroundColor,
      appBar: _buildAppBar(
          height: appbarHeight,
          minHeight: 40,
          duration: _duration,
          isAppBarVisible: _isAppBarVisible),
      body: switch (novelViewModel) {
        AsyncData(:final value) => Builder(builder: (BuildContext context) {
            Widget? child = NetStateTools.getWidget(value.netState);
            if (child != null) {
              return child;
            }
            return _buildSuccess(value: value, style: _style);
          }),
        AsyncError() => EmptyBuild(),
        _ => const LoadingBuild(),
      },
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
      backgroundColor: _themeData.scaffoldBackgroundColor,
      child: DefaultTextStyle(
        style: const TextStyle(fontWeight: FontWeight.w300),
        child: Container(
          padding:
              const EdgeInsets.only(top: 40, left: 10, bottom: 10, right: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _themeData.primaryColor,
                _themeData.scaffoldBackgroundColor
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, .05],
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "目录",
              style: TextStyle(
                  fontSize: 24, color: _themeData.textTheme.bodyLarge?.color),
            ),
            10.verticalSpace,
            Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _changeNovelData(
                            data: _detailViewModel
                                .detailState.detailNovel!.data!.list![index]),
                        child: SizedBox(
                          height: 50,
                          child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "${_detailViewModel.detailState.detailNovel?.data?.list?[index].name}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      _detailViewModel.getReadIndex() == index
                                          ? _themeData.primaryColor
                                          : Colors.black87)),
                        ),
                      );
                    },
                    itemCount: _detailViewModel
                        .detailState.detailNovel?.data?.list?.length))
          ]),
        ),
      ),
    );
  }

  /// 底部导航栏构建
  _buildBottmAppBar(
      {required double height,
      required double minHeight,
      required Duration duration,
      required bool isBottomBarVisible}) {
    //bool isDark = _themeStyleProvider.theme.brightness != Brightness.dark;
    return AnimatedContainer(
      height: isBottomBarVisible ? height : minHeight,
      duration: duration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _themeData.bottomAppBarTheme.color,
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
          color: _themeData.bottomAppBarTheme.color,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomAppBarItem(
                    icon: Icons.folder,
                    text: "目录",
                    onPressed: // 使用 scaffoldKey 当前 scaffold 打开抽屉
                        _openDrawer),
                _buildBottomAppBarItem(
                    icon: NovelIcon.backward,
                    text: "上一页",
                    onPressed: _changeNovelToBack),
                _buildBottomAppBarItem(
                    icon: NovelIcon.forward,
                    text: "下一页",
                    onPressed: _changeNovelToNext),
                // _buildBottomAppBarItem(
                //     icon: isDark ? Icons.nightlight : Icons.wb_sunny,
                //     text: isDark ? "夜间" : "白天",
                //     onPressed: _themeStyleProvider.switchTheme),
                _buildBottomAppBarItem(
                    icon: Icons.settings, text: "设置", onPressed: _openSetting)
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
              color: _themeData.primaryColor,
            )),
        Text(text,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300))
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
        curve: Curves.easeInOut,
        height: _isAppBarVisible ? height * 1.5 : minHeight,
        duration: duration,
        child: AnimatedOpacity(
          opacity: _isAppBarVisible ? 1.0 : 0.0,
          duration: duration,
          child: SingleChildScrollView(
            child: AppBar(
              leading: const AutoLeadingButton(),
              title: Text(
                widget.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建成功
  _buildSuccess({required NovelState value, required TextStyle style}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _isShow,
      child: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              padding: 20.padding,
              child: ExtendedText.rich(TextSpan(children: [
                _specialTextSpanBuilder.build(
                    _getText(htmlContent: value.novelEntry.data?.text ?? ''),
                    textStyle: style)
              ]))),
        ),
      ),
    );
  }
}
