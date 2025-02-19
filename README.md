![示例图片](https://m.qpic.cn/psc?/V13kbO6L1NnSEN/LiySpxowE0yeWXwBdXN*STQ.Aqq*ouV8lzjkVT0hQzfHSa8Cw3Teo5Lt5YnKhxap1gzFFdwJHMxLJRyCdr4KIhlvFs0Hri7JBdfKPDOubiQ!/b&bo=AAqQAQAKkAEFFzQ!&rf=viewer_4)

<p align="center">
    <a href='https://github.com/fluttercandies/flutter_novel'><img alt="Github stars" src="https://img.shields.io/github/stars/fluttercandies/flutter_novel?logo=github"></a>
    <a href='https://github.com/fluttercandies/flutter_novel'><img alt="Github stars" src="https://img.shields.io/github/forks/fluttercandies/flutter_novel?logo=github"></a>
    <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies">FlutterCandies糖果技术交流</a>
    <a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=mYfvheURi3cqPskrWXaLddE5MyslIIy8&jump_from=webapi&authKey=pGJ8ddoO9qrnRY0AKs7pEML06J4s02WaJRs0KDJsDQju9kw8GYX0WevrACX96c8o"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="造物主动态桌面Ⅰ群" title="造物主动态桌面Ⅰ群">造物主动态桌面Ⅰ群</a>
</p>

## 项目介绍*

《BITReader》是一款开源的阅读APP拥有功能。搜索源搜索、收藏书架、历史记录、书籍详情介绍、阅读设置、字体设置、主题选择、自定义阅读字体、背景、阅读切换、 。。

未来将会继续更新，并且会加入更多功能。

导入阅读书源等。。。

## 项目地址

<a href='https://github.com/7-bit11/novel_flutter_bit_source/blob/main/%E7%88%B1%E7%9C%8B2.1.1.apk'><img alt="Github stars" src="https://img.shields.io/github/stars/7-bit11/novel_flutter_bit_source?logo=github">下载地址</a>

## 支持平台

| 平台                           | 是否支持
|------------------------------- | ---------------------------
| Android                        |  ✅
| IOS                            |  ✅
| Windows                        |  ✅
| Web                            |  ❌ 跨域问题
| MacOS                          |  ✅
| Linux                          |  ❌

## 项目结构

```
lib
├── main.dart -- 入口
├── assets -- 本地资源生成
├── base -- 请求状态、页面状态
├── db -- 数据缓存
├── icons -- 图标
├── net -- 网络请求、网络状态
├── n_pages
    ├── detail -- 详情页
    ├── home -- 首页
    ├── search -- 全网搜索搜索页
    ├── history -- 历史记录 
    ├── read -- 小说阅读 
    └── like -- 收藏书架
└── pages  已废弃⚠
    ├── home -- 首页
    ├── novel -- 小说阅读
    ├── search -- 全网搜索
    ├── category -- 小说分类
    ├── detail_novel -- 小说详情
    ├── book_novel -- 书架、站源
    └── collect_novel -- 小说收藏
├── route -- 路由
└── theme -- 主题管理
    └── themes -- 主题颜色-9种颜色
├── tools -- 工具类 、日志、防抖。。。
└── widget -- 自定义组件、工具 、加载、状态、图片 等。。。。。。
```

## 使用框架

|                                | 版本
|------------------------------- | ---------------------------
| FlutterSDK                     |  3.24.0
| DartSDK                        |  3.5.0
|--------------------------------|----------------------------
| pull_to_refresh_notification   |  刷新^3.1.0
| extended_image                 |  图片^8.3.0
| extended_text                  |  文本^14.1.0
| flutter_smart_dialog           |  弹窗提示^4.9.8+1
| image_editor                   |  图片编辑 ^1.5.1
| wechat_assets_picker           |  微信样式选择图片 ^9.3.3
| assets_generator               |  本地资源生成^3.0.5
| logger                         |  日志插件^1.0.8
| auto_route                     |  路由^9.2.2
| dio                            |  网络请求^5.7.0
| flutter_svg                    |  SVG^2.0.10+1
| flutter_staggered_grid_view    |  瀑布流^0.4.1
| shared_preferences             |  本地存储^2.3.2
| flutter_riverpod               |  状态管理^2.5.1
| riverpod_annotation            |  ^2.3.5
| syncfusion_flutter_sliders     |  滑动选择器 ^26.2.14
| carousel_slider                |  轮播^5.0.0
| html                           |  ^0.15.4
| path_provider                  |  本地目录 ^2.1.4
| flex_color_picker              |  颜色选择器^3.6.0
| sliver_head_automatic_adsorption| 自动吸附Sliver ^1.0.8

### 项目截图 《新》

![图片说明](./md/57_1x_shots_so.png)
![图片说明](./md/729_1x_shots_so.png)
![图片说明](./md/360_1x_shots_so.png)
![图片说明](./md/300_1x_shots_so.png)
自定义阅读背景、字体、主题等。
![图片说明](./md/402_1x_shots_so.png)
### 项目截图 《旧》

![图片说明](./md/488_1x_shots_so.png)
![图片说明](./md/660_1x_shots_so.png)
![图片说明](./md/970_1x_shots_so.png)
![图片说明](./md/300_1x_shots_so.png)
![图片说明](./md/305shots_so.png)

### 免责声明

1.本项目提供的源代码仅用学习，请勿用于商业盈利。

2.用户使用本系统从事任何违法违规的事情，一切后果由用户自行承担作者不承担任何法律责任。

3.如有侵犯权利，请联系作者删除。

4.下载或使用本站源码则代表你同意上述的免责声明协议
