import 'package:flutter/material.dart';
import '../models/tool_item.dart';
import 'system_tools.dart';
import 'daily_tools.dart';
import 'network_tools.dart';
import 'image_tools.dart';
import 'dev_tools.dart';
import 'media_tools.dart';

class ToolRegistry {
  static final List<ToolItem> _allTools = [
    // 系统工具 (20)
    ToolItem(id: 'device_info', name: '设备信息', description: '查看设备硬件和系统信息', icon: Icons.phone_android, category: ToolCategory.system, pageBuilder: (_) => const DeviceInfoPage()),
    ToolItem(id: 'battery_info', name: '电量信息', description: '查看电池状态、温度、电压', icon: Icons.battery_full, category: ToolCategory.system, pageBuilder: (_) => const BatteryInfoPage()),
    ToolItem(id: 'cpu_monitor', name: 'CPU监控', description: '实时查看CPU使用率和核心数', icon: Icons.memory, category: ToolCategory.system, pageBuilder: (_) => const CpuMonitorPage()),
    ToolItem(id: 'memory_monitor', name: '内存监控', description: '查看内存使用情况', icon: Icons.sd_storage, category: ToolCategory.system, pageBuilder: (_) => const MemoryMonitorPage()),
    ToolItem(id: 'storage_info', name: '存储信息', description: '查看内置和SD卡存储', icon: Icons.storage, category: ToolCategory.system, pageBuilder: (_) => const StorageInfoPage()),
    ToolItem(id: 'sensor_viewer', name: '传感器查看器', description: '实时查看各类传感器数据', icon: Icons.sensors, category: ToolCategory.system, pageBuilder: (_) => const SensorViewerPage()),
    ToolItem(id: 'vibration_test', name: '振动测试', description: '测试设备振动功能', icon: Icons.vibration, category: ToolCategory.system, pageBuilder: (_) => const VibrationTestPage()),
    ToolItem(id: 'screen_keep_on', name: '屏幕常亮', description: '保持屏幕常亮不锁屏', icon: Icons.brightness_high, category: ToolCategory.system, pageBuilder: (_) => const ScreenKeepOnPage()),
    ToolItem(id: 'volume_manager', name: '音量管理', description: '调节各通道音量', icon: Icons.volume_up, category: ToolCategory.system, pageBuilder: (_) => const VolumeManagerPage()),
    ToolItem(id: 'brightness', name: '亮度调节', description: '调节屏幕亮度', icon: Icons.brightness_6, category: ToolCategory.system, pageBuilder: (_) => const BrightnessPage()),
    ToolItem(id: 'night_mode', name: '夜间模式', description: '切换深色/浅色主题', icon: Icons.dark_mode, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '夜间模式', content: '在设置页中可切换深色/浅色/跟随系统主题模式', icon: Icons.dark_mode)),
    ToolItem(id: 'app_manager', name: '应用管理', description: '查看已安装应用列表', icon: Icons.apps, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '应用管理', content: '应用管理功能需要系统权限，可查看已安装应用列表、卸载应用、备份APK等', icon: Icons.apps)),
    ToolItem(id: 'file_manager', name: '文件管理', description: '浏览和管理文件', icon: Icons.folder, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '文件管理', content: '文件管理器支持浏览文件、复制/移动/删除、压缩解压等功能', icon: Icons.folder)),
    ToolItem(id: 'storage_cleaner', name: '存储清理', description: '扫描大文件和缓存', icon: Icons.cleaning_services, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '存储清理', content: '存储清理工具可扫描缓存文件、大文件、重复文件，帮助释放存储空间', icon: Icons.cleaning_services)),
    ToolItem(id: 'battery_history', name: '电池历史', description: '记录电池使用历史', icon: Icons.battery_charging_full, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '电池历史', content: '电池历史记录功能可追踪电池使用情况和耗电应用排行', icon: Icons.battery_charging_full)),
    ToolItem(id: 'app_usage', name: '应用使用统计', description: '查看应用使用时长', icon: Icons.timer, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '应用使用统计', content: '应用使用统计需要使用情况访问权限，可查看各应用使用时长和次数', icon: Icons.timer)),
    ToolItem(id: 'process_manager', name: '进程管理', description: '查看运行中的进程', icon: Icons.developer_board, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '进程管理', content: '进程管理器可查看当前运行的进程列表和资源占用情况', icon: Icons.developer_board)),
    ToolItem(id: 'resolution_dpi', name: '分辨率/DPI', description: '查看屏幕分辨率和DPI', icon: Icons.aspect_ratio, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '分辨率/DPI', content: '查看屏幕分辨率、DPI、像素密度等信息。修改分辨率需要Root或Shizuku权限', icon: Icons.aspect_ratio)),
    ToolItem(id: 'immersive_status', name: '沉浸式状态栏', description: '设置沉浸式状态栏', icon: Icons.fullscreen, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '沉浸式状态栏', content: '沉浸式状态栏设置可隐藏状态栏、导航栏，实现全屏体验', icon: Icons.fullscreen)),
    ToolItem(id: 'quick_settings', name: '快捷设置', description: '常用系统设置快捷入口', icon: Icons.settings, category: ToolCategory.system, pageBuilder: (_) => const SimpleInfoPage(title: '快捷设置', content: '快捷设置面板提供WiFi、蓝牙、飞行模式、定位等常用设置的快捷入口', icon: Icons.settings)),

    // 日常工具 (28)
    ToolItem(id: 'calculator', name: '科学计算器', description: '支持科学运算的计算器', icon: Icons.calculate, category: ToolCategory.daily, pageBuilder: (_) => const CalculatorPage()),
    ToolItem(id: 'unit_converter', name: '单位换算', description: '长度/重量/温度等换算', icon: Icons.swap_horiz, category: ToolCategory.daily, pageBuilder: (_) => const UnitConverterPage()),
    ToolItem(id: 'currency', name: '货币换算', description: '实时汇率换算', icon: Icons.currency_exchange, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '货币换算', content: '货币换算工具支持全球主要货币的实时汇率转换', icon: Icons.currency_exchange)),
    ToolItem(id: 'compass', name: '指南针', description: '方向指示', icon: Icons.explore, category: ToolCategory.daily, pageBuilder: (_) => const CompassPage()),
    ToolItem(id: 'level', name: '水平仪', description: '检测水平和垂直', icon: Icons.straighten, category: ToolCategory.daily, pageBuilder: (_) => const LevelPage()),
    ToolItem(id: 'protractor', name: '量角器', description: '测量角度', icon: Icons.architecture, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '量角器', content: '量角器工具可通过摄像头或屏幕测量物体角度', icon: Icons.architecture)),
    ToolItem(id: 'ruler', name: '屏幕尺子', description: '用屏幕测量长度', icon: Icons.straighten, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '屏幕尺子', content: '屏幕尺子工具可在屏幕上显示刻度，测量小物体长度', icon: Icons.straighten)),
    ToolItem(id: 'flashlight', name: '手电筒', description: '开启闪光灯照明', icon: Icons.flashlight_on, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '手电筒', content: '手电筒工具开启设备闪光灯作为照明光源', icon: Icons.flashlight_on)),
    ToolItem(id: 'magnifier', name: '放大镜', description: '相机放大查看', icon: Icons.zoom_in, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '放大镜', content: '放大镜工具通过摄像头放大查看细小物体', icon: Icons.zoom_in)),
    ToolItem(id: 'mirror', name: '镜子', description: '前置相机当镜子', icon: Icons.face, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '镜子', content: '镜子工具使用前置摄像头实时显示画面', icon: Icons.face)),
    ToolItem(id: 'qr_gen', name: '二维码生成', description: '生成二维码', icon: Icons.qr_code, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '二维码生成', content: '输入文本或URL即可生成二维码图片，支持保存和分享', icon: Icons.qr_code)),
    ToolItem(id: 'qr_scan', name: '二维码扫描', description: '扫描二维码/条形码', icon: Icons.qr_code_scanner, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '二维码扫描', content: '扫描二维码和条形码，支持快速识别和结果处理', icon: Icons.qr_code_scanner)),
    ToolItem(id: 'timer', name: '倒计时/秒表', description: '倒计时和秒表', icon: Icons.timer, category: ToolCategory.daily, pageBuilder: (_) => const TimerPage()),
    ToolItem(id: 'world_clock', name: '世界时钟', description: '查看全球时间', icon: Icons.public, category: ToolCategory.daily, pageBuilder: (_) => const WorldClockPage()),
    ToolItem(id: 'date_calc', name: '日期计算', description: '日期差和工作日计算', icon: Icons.date_range, category: ToolCategory.daily, pageBuilder: (_) => const DateCalcPage()),
    ToolItem(id: 'age_calc', name: '年龄计算', description: '计算精确年龄', icon: Icons.cake, category: ToolCategory.daily, pageBuilder: (_) => const AgeCalcPage()),
    ToolItem(id: 'bmi', name: 'BMI计算', description: '身体质量指数', icon: Icons.monitor_weight, category: ToolCategory.daily, pageBuilder: (_) => const BmiPage()),
    ToolItem(id: 'body_fat', name: '体脂率计算', description: '估算体脂率', icon: Icons.fitness_center, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '体脂率计算', content: '根据身高、体重、年龄、性别等参数估算体脂率', icon: Icons.fitness_center)),
    ToolItem(id: 'password_gen', name: '密码生成器', description: '生成随机密码', icon: Icons.password, category: ToolCategory.daily, pageBuilder: (_) => const PasswordGenPage()),
    ToolItem(id: 'random_num', name: '随机数生成', description: '生成指定范围随机数', icon: Icons.casino, category: ToolCategory.daily, pageBuilder: (_) => const RandomNumPage()),
    ToolItem(id: 'dice', name: '抽签/骰子', description: '随机抽签或掷骰子', icon: Icons.games, category: ToolCategory.daily, pageBuilder: (_) => const DicePage()),
    ToolItem(id: 'color_picker', name: '颜色选择器', description: 'RGB/HSV/HEX颜色', icon: Icons.color_lens, category: ToolCategory.daily, pageBuilder: (_) => const ColorPickerPage()),
    ToolItem(id: 'palette', name: '调色板', description: '创建配色方案', icon: Icons.palette, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '调色板', content: '调色板工具可创建、保存和分享配色方案', icon: Icons.palette)),
    ToolItem(id: 'notes', name: '笔记/便签', description: '记录笔记', icon: Icons.note, category: ToolCategory.daily, pageBuilder: (_) => const SimpleTextToolPage(title: '笔记', hint: '输入笔记内容...')),
    ToolItem(id: 'todo', name: '待办清单', description: '管理待办事项', icon: Icons.checklist, category: ToolCategory.daily, pageBuilder: (_) => const SimpleTextToolPage(title: '待办清单', hint: '添加待办事项...')),
    ToolItem(id: 'accounting', name: '记账本', description: '记录收支', icon: Icons.account_balance_wallet, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '记账本', content: '记账本工具可记录每日收支，支持分类统计和图表展示', icon: Icons.account_balance_wallet)),
    ToolItem(id: 'weather', name: '天气查询', description: '查询天气信息', icon: Icons.wb_sunny, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '天气查询', content: '天气查询工具可查看实时天气、预报和空气质量', icon: Icons.wb_sunny)),
    ToolItem(id: 'translate', name: '翻译', description: '多语言翻译', icon: Icons.translate, category: ToolCategory.daily, pageBuilder: (_) => const SimpleInfoPage(title: '翻译', content: '翻译工具支持多种语言互译，调用免费翻译API', icon: Icons.translate)),

    // 网络工具 (15)
    ToolItem(id: 'speed_test', name: '网速测试', description: '测试下载/上传速度', icon: Icons.speed, category: ToolCategory.network, pageBuilder: (_) => const SpeedTestPage()),
    ToolItem(id: 'ip_query', name: 'IP查询', description: '查询本机和公网IP', icon: Icons.public, category: ToolCategory.network, pageBuilder: (_) => const IpQueryPage()),
    ToolItem(id: 'port_scan', name: '端口扫描', description: '扫描目标端口', icon: Icons.radar, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: '端口扫描', content: '端口扫描工具可扫描目标主机的开放端口和服务', icon: Icons.radar)),
    ToolItem(id: 'ping_test', name: 'Ping测试', description: '测试网络延迟', icon: Icons.network_ping, category: ToolCategory.network, pageBuilder: (_) => const PingTestPage()),
    ToolItem(id: 'dns_query', name: 'DNS查询', description: '域名解析查询', icon: Icons.dns, category: ToolCategory.network, pageBuilder: (_) => const DnsQueryPage()),
    ToolItem(id: 'whois', name: 'Whois查询', description: '域名注册信息', icon: Icons.info_outline, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: 'Whois查询', content: 'Whois查询可查看域名注册商、注册时间、过期时间等信息', icon: Icons.info_outline)),
    ToolItem(id: 'site_status', name: '网站状态检测', description: '检测网站是否在线', icon: Icons.monitor_heart, category: ToolCategory.network, pageBuilder: (_) => const SiteStatusPage()),
    ToolItem(id: 'http_test', name: 'HTTP请求测试', description: '自定义GET/POST请求', icon: Icons.http, category: ToolCategory.network, pageBuilder: (_) => const HttpTestPage()),
    ToolItem(id: 'network_info', name: '网络信息', description: 'WiFi和网络详情', icon: Icons.wifi, category: ToolCategory.network, pageBuilder: (_) => const NetworkInfoPage()),
    ToolItem(id: 'hotspot', name: '热点管理', description: '管理移动热点', icon: Icons.wifi_tethering, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: '热点管理', content: '热点管理工具可开启/关闭移动热点，查看连接设备', icon: Icons.wifi_tethering)),
    ToolItem(id: 'bluetooth', name: '蓝牙扫描', description: '扫描蓝牙设备', icon: Icons.bluetooth, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: '蓝牙扫描', content: '蓝牙扫描工具可发现附近蓝牙设备并查看设备信息', icon: Icons.bluetooth)),
    ToolItem(id: 'nfc', name: 'NFC读取', description: '读取NFC标签', icon: Icons.nfc, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: 'NFC读取', content: 'NFC读取工具可读取NFC标签内容（需设备支持NFC）', icon: Icons.nfc)),
    ToolItem(id: 'lan_scan', name: '局域网扫描', description: '扫描局域网设备', icon: Icons.devices, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: '局域网扫描', content: '局域网扫描工具可发现同一网络下的所有设备和IP', icon: Icons.devices)),
    ToolItem(id: 'domain_resolve', name: '域名解析', description: '解析域名IP', icon: Icons.language, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: '域名解析', content: '域名解析工具可将域名解析为IP地址，支持多种记录类型', icon: Icons.language)),
    ToolItem(id: 'reverse_ip', name: '反向IP查询', description: '查询IP对应域名', icon: Icons.swap_vert, category: ToolCategory.network, pageBuilder: (_) => const SimpleInfoPage(title: '反向IP查询', content: '反向IP查询可查找同一IP上托管的所有域名', icon: Icons.swap_vert)),

    // 图片工具 (14)
    ToolItem(id: 'img_compress', name: '图片压缩', description: '压缩图片大小', icon: Icons.compress, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '图片压缩', message: '选择图片后可调整质量和尺寸进行压缩', icon: Icons.compress)),
    ToolItem(id: 'img_convert', name: '格式转换', description: 'PNG/JPG/WebP转换', icon: Icons.swap_horiz, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '格式转换', message: '支持PNG、JPG、WebP等格式互相转换', icon: Icons.swap_horiz)),
    ToolItem(id: 'img_crop', name: '图片裁剪', description: '裁剪图片区域', icon: Icons.crop, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '图片裁剪', message: '自由裁剪图片，支持多种比例预设', icon: Icons.crop)),
    ToolItem(id: 'img_rotate', name: '图片旋转', description: '旋转图片角度', icon: Icons.rotate_90_degrees_cw, category: ToolCategory.image, pageBuilder: (_) => const ImageRotatePage()),
    ToolItem(id: 'img_filter', name: '图片滤镜', description: '灰度/怀旧/反色等', icon: Icons.filter, category: ToolCategory.image, pageBuilder: (_) => const ImageFilterPage()),
    ToolItem(id: 'img_stitch', name: '图片拼接', description: '长截图拼接', icon: Icons.stacked_line_chart, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '图片拼接', message: '将多张图片纵向或横向拼接成长图', icon: Icons.stacked_line_chart)),
    ToolItem(id: 'img_grid', name: '九宫格切图', description: '切成九宫格', icon: Icons.grid_view, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '九宫格切图', message: '将图片切成3x3九宫格，适合社交媒体发布', icon: Icons.grid_view)),
    ToolItem(id: 'img_to_base64', name: '图片转Base64', description: '图片编码为Base64', icon: Icons.code, category: ToolCategory.image, pageBuilder: (_) => const ImageToBase64Page()),
    ToolItem(id: 'base64_to_img', name: 'Base64转图片', description: 'Base64解码为图片', icon: Icons.image, category: ToolCategory.image, pageBuilder: (_) => const Base64ToImagePage()),
    ToolItem(id: 'img_color_picker', name: '图片取色器', description: '从图片取色', icon: Icons.colorize, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '图片取色器', message: '从图片中选取颜色，获取RGB/HEX值', icon: Icons.colorize)),
    ToolItem(id: 'img_resize', name: '分辨率修改', description: '调整图片尺寸', icon: Icons.photo_size_select_large, category: ToolCategory.image, pageBuilder: (_) => const ImageResizePage()),
    ToolItem(id: 'img_watermark', name: '图片加水印', description: '添加文字水印', icon: Icons.branding_watermark, category: ToolCategory.image, pageBuilder: (_) => const ImageWatermarkPage()),
    ToolItem(id: 'img_meme', name: '表情包制作', description: '制作表情包', icon: Icons.emoji_emotions, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: '表情包制作', message: '添加文字到图片，制作个性化表情包', icon: Icons.emoji_emotions)),
    ToolItem(id: 'gif_tool', name: 'GIF分解/合成', description: 'GIF处理工具', icon: Icons.gif_box, category: ToolCategory.image, pageBuilder: (_) => const SimpleImagePage(title: 'GIF工具', message: 'GIF分解为帧图片，或多张图片合成GIF', icon: Icons.gif_box)),

    // 开发工具 (25)
    ToolItem(id: 'json_format', name: 'JSON格式化', description: '格式化/压缩/校验JSON', icon: Icons.data_object, category: ToolCategory.dev, pageBuilder: (_) => const JsonFormatPage()),
    ToolItem(id: 'xml_format', name: 'XML格式化', description: '格式化XML', icon: Icons.code, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'XML格式化', hint: '粘贴XML内容...')),
    ToolItem(id: 'html_format', name: 'HTML格式化', description: '格式化HTML', icon: Icons.html, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'HTML格式化', hint: '粘贴HTML内容...')),
    ToolItem(id: 'base64', name: 'Base64编解码', description: 'Base64编码/解码', icon: Icons.transform, category: ToolCategory.dev, pageBuilder: (_) => const Base64Page()),
    ToolItem(id: 'url_encode', name: 'URL编解码', description: 'URL编码/解码', icon: Icons.link, category: ToolCategory.dev, pageBuilder: (_) => const UrlEncodePage()),
    ToolItem(id: 'hash', name: '哈希计算', description: 'MD5/SHA1/SHA256', icon: Icons.fingerprint, category: ToolCategory.dev, pageBuilder: (_) => const HashPage()),
    ToolItem(id: 'aes', name: 'AES加密', description: 'AES加密/解密', icon: Icons.lock, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'AES加密', hint: '输入明文和密钥...')),
    ToolItem(id: 'rsa', name: 'RSA加密', description: 'RSA加密/解密', icon: Icons.vpn_key, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'RSA加密', hint: '输入明文和公钥/私钥...')),
    ToolItem(id: 'timestamp', name: '时间戳转换', description: '时间戳与日期互转', icon: Icons.schedule, category: ToolCategory.dev, pageBuilder: (_) => const TimestampPage()),
    ToolItem(id: 'regex', name: '正则测试', description: '正则表达式测试', icon: Icons.find_replace, category: ToolCategory.dev, pageBuilder: (_) => const RegexPage()),
    ToolItem(id: 'color_convert', name: '颜色代码转换', description: 'RGB/HEX/HSL转换', icon: Icons.color_lens, category: ToolCategory.dev, pageBuilder: (_) => const ColorPickerPage()),
    ToolItem(id: 'base_convert', name: '进制转换', description: '2/8/10/16进制', icon: Icons.numbers, category: ToolCategory.dev, pageBuilder: (_) => const BaseConvertPage()),
    ToolItem(id: 'ascii', name: 'ASCII码表', description: 'ASCII字符对照表', icon: Icons.text_fields, category: ToolCategory.dev, pageBuilder: (_) => const AsciiPage()),
    ToolItem(id: 'unicode', name: 'Unicode转换', description: 'Unicode编解码', icon: Icons.translate, category: ToolCategory.dev, pageBuilder: (_) => const UnicodePage()),
    ToolItem(id: 'line_count', name: '代码行数统计', description: '统计代码行数', icon: Icons.format_list_numbered, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: '代码行数统计', hint: '粘贴代码...')),
    ToolItem(id: 'text_diff', name: '文本对比', description: '对比两段文本', icon: Icons.compare_arrows, category: ToolCategory.dev, pageBuilder: (_) => const TextDiffPage()),
    ToolItem(id: 'text_dedup', name: '文本去重', description: '去除重复行', icon: Icons.delete_sweep, category: ToolCategory.dev, pageBuilder: (_) => const TextDedupPage()),
    ToolItem(id: 'text_replace', name: '文本替换', description: '批量替换文本', icon: Icons.find_in_page, category: ToolCategory.dev, pageBuilder: (_) => const TextReplacePage()),
    ToolItem(id: 'case_convert', name: '大小写转换', description: '大小写格式转换', icon: Icons.text_format, category: ToolCategory.dev, pageBuilder: (_) => const CaseConvertPage()),
    ToolItem(id: 'zh_convert', name: '简繁转换', description: '简体繁体互转', icon: Icons.auto_awesome, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: '简繁转换', hint: '输入中文文本...')),
    ToolItem(id: 'word_count', name: '字数统计', description: '统计字数字符数', icon: Icons.count, category: ToolCategory.dev, pageBuilder: (_) => const WordCountPage()),
    ToolItem(id: 'markdown', name: 'Markdown预览', description: 'Markdown实时预览', icon: Icons.preview, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'Markdown预览', hint: '输入Markdown内容...')),
    ToolItem(id: 'sql_format', name: 'SQL格式化', description: '格式化SQL语句', icon: Icons.storage, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'SQL格式化', hint: '粘贴SQL语句...')),
    ToolItem(id: 'csv_viewer', name: 'CSV查看器', description: '查看CSV数据', icon: Icons.table_chart, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'CSV查看器', hint: '粘贴CSV数据...')),
    ToolItem(id: 'json_convert', name: 'JSON转换', description: 'JSON转CSV/XML', icon: Icons.swap_vert, category: ToolCategory.dev, pageBuilder: (_) => const SimpleDevPage(title: 'JSON转换', hint: '粘贴JSON...')),

    // 影音工具 (10)
    ToolItem(id: 'audio_convert', name: '音频格式转换', description: '转换音频格式', icon: Icons.audiotrack, category: ToolCategory.media, pageBuilder: (_) => const SimpleMediaPage(title: '音频格式转换', message: '支持MP3、WAV、AAC、FLAC等格式转换', icon: Icons.audiotrack)),
    ToolItem(id: 'video_info', name: '视频信息查看', description: '查看视频详细信息', icon: Icons.video_library, category: ToolCategory.media, pageBuilder: (_) => const VideoInfoPage()),
    ToolItem(id: 'video_to_gif', name: '视频转GIF', description: '视频片段转GIF', icon: Icons.gif, category: ToolCategory.media, pageBuilder: (_) => const SimpleMediaPage(title: '视频转GIF', message: '选择视频片段转换为GIF动图', icon: Icons.gif)),
    ToolItem(id: 'audio_clip', name: '音频剪辑', description: '裁剪音频片段', icon: Icons.content_cut, category: ToolCategory.media, pageBuilder: (_) => const SimpleMediaPage(title: '音频剪辑', message: '裁剪音频片段，支持淡入淡出效果', icon: Icons.content_cut)),
    ToolItem(id: 'ringtone', name: '铃声制作', description: '制作手机铃声', icon: Icons.notifications_active, category: ToolCategory.media, pageBuilder: (_) => const SimpleMediaPage(title: '铃声制作', message: '从音频中截取片段制作手机铃声', icon: Icons.notifications_active)),
    ToolItem(id: 'tts', name: '文本转语音', description: 'TTS语音合成', icon: Icons.record_voice_over, category: ToolCategory.media, pageBuilder: (_) => const TtsPage()),
    ToolItem(id: 'stt', name: '语音转文字', description: '语音识别转文字', icon: Icons.mic, category: ToolCategory.media, pageBuilder: (_) => const SimpleMediaPage(title: '语音转文字', message: '使用系统语音识别将语音转换为文字', icon: Icons.mic)),
    ToolItem(id: 'spectrum', name: '音频频谱分析', description: '实时音频频谱', icon: Icons.graphic_eq, category: ToolCategory.media, pageBuilder: (_) => const SpectrumPage()),
    ToolItem(id: 'decibel', name: '噪音检测', description: '分贝仪检测噪音', icon: Icons.surround_sound, category: ToolCategory.media, pageBuilder: (_) => const DecibelPage()),
    ToolItem(id: 'pitch', name: '音调检测', description: '检测音高频率', icon: Icons.music_note, category: ToolCategory.media, pageBuilder: (_) => const PitchPage()),
  ];

  static List<ToolItem> get allTools => _allTools;

  static List<ToolItem> getByCategory(ToolCategory category) {
    return _allTools.where((t) => t.category == category).toList();
  }

  static ToolItem? getById(String id) {
    try {
      return _allTools.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<ToolItem> search(String query) {
    if (query.isEmpty) return _allTools;
    final q = query.toLowerCase();
    return _allTools.where((t) => t.name.toLowerCase().contains(q) || t.description.toLowerCase().contains(q)).toList();
  }

  static int get totalCount => _allTools.length;
}
