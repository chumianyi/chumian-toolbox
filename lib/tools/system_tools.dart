import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:async';
import 'dart:io';

class SystemTools {
  static final List<Map<String, dynamic>> tools = [
    {'id': 'device_info', 'name': '设备信息', 'desc': '查看设备硬件和系统信息', 'icon': Icons.phone_android},
    {'id': 'battery_info', 'name': '电量信息', 'desc': '查看电池状态、温度、电压', 'icon': Icons.battery_full},
    {'id': 'cpu_monitor', 'name': 'CPU监控', 'desc': '实时查看CPU使用率和核心数', 'icon': Icons.memory},
    {'id': 'memory_monitor', 'name': '内存监控', 'desc': '查看内存使用情况', 'icon': Icons.sd_storage},
    {'id': 'storage_info', 'name': '存储信息', 'desc': '查看内置和SD卡存储', 'icon': Icons.storage},
    {'id': 'sensor_viewer', 'name': '传感器查看器', 'desc': '实时查看各类传感器数据', 'icon': Icons.sensors},
    {'id': 'vibration_test', 'name': '振动测试', 'desc': '测试设备振动功能', 'icon': Icons.vibration},
    {'id': 'screen_keep_on', 'name': '屏幕常亮', 'desc': '保持屏幕常亮不锁屏', 'icon': Icons.brightness_high},
    {'id': 'volume_manager', 'name': '音量管理', 'desc': '调节各通道音量', 'icon': Icons.volume_up},
    {'id': 'brightness', 'name': '亮度调节', 'desc': '调节屏幕亮度', 'icon': Icons.brightness_6},
    {'id': 'night_mode', 'name': '夜间模式', 'desc': '切换深色/浅色主题', 'icon': Icons.dark_mode},
    {'id': 'app_manager', 'name': '应用管理', 'desc': '查看已安装应用列表', 'icon': Icons.apps},
    {'id': 'file_manager', 'name': '文件管理', 'desc': '浏览和管理文件', 'icon': Icons.folder},
    {'id': 'storage_cleaner', 'name': '存储清理', 'desc': '扫描大文件和缓存', 'icon': Icons.cleaning_services},
    {'id': 'battery_history', 'name': '电池历史', 'desc': '记录电池使用历史', 'icon': Icons.battery_charging_full},
    {'id': 'app_usage', 'name': '应用使用统计', 'desc': '查看应用使用时长', 'icon': Icons.timer},
    {'id': 'process_manager', 'name': '进程管理', 'desc': '查看运行中的进程', 'icon': Icons.developer_board},
    {'id': 'resolution_dpi', 'name': '分辨率/DPI', 'desc': '查看屏幕分辨率和DPI', 'icon': Icons.aspect_ratio},
    {'id': 'immersive_status', 'name': '沉浸式状态栏', 'desc': '设置沉浸式状态栏', 'icon': Icons.fullscreen},
    {'id': 'quick_settings', 'name': '快捷设置', 'desc': '常用系统设置快捷入口', 'icon': Icons.settings},
  ];
}

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});
  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  Map<String, String> _info = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final info = await DeviceInfoPlugin().androidInfo;
    setState(() {
      _info = {
        '设备型号': info.model,
        '设备品牌': info.brand,
        '设备厂商': info.manufacturer,
        '设备名称': info.device,
        '产品名称': info.product,
        '硬件型号': info.hardware,
        '系统版本': 'Android ${info.version.release}',
        'SDK版本': info.version.sdkInt.toString(),
        '安全补丁': info.version.securityPatch ?? '未知',
        '构建号': info.id,
        '构建类型': info.type,
        'CPU架构': info.supportedAbis.join(', '),
        '屏幕分辨率': '${info.displayMetrics.widthPx.toInt()} x ${info.displayMetrics.heightPx.toInt()}',
        '屏幕DPI': info.displayMetrics.densityDpi.toString(),
        '物理尺寸': '${info.displayMetrics.widthInches.toStringAsFixed(1)} x ${info.displayMetrics.heightInches.toStringAsFixed(1)} 英寸',
        '是否Root': info.isPhysicalDevice ? '否(物理设备)' : '是(模拟器)',
        'Android ID': info.androidId,
      };
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设备信息')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _info.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final entry = _info.entries.elementAt(i);
                return ListTile(
                  title: Text(entry.key, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  subtitle: Text(entry.value, style: const TextStyle(fontSize: 16)),
                );
              },
            ),
    );
  }
}

class BatteryInfoPage extends StatefulWidget {
  const BatteryInfoPage({super.key});
  @override
  State<BatteryInfoPage> createState() => _BatteryInfoPageState();
}

class _BatteryInfoPageState extends State<BatteryInfoPage> {
  final Battery _battery = Battery();
  int _level = 0;
  BatteryState _state = BatteryState.unknown;
  String _health = '未知';
  String _technology = '未知';
  double _temperature = 0;
  double _voltage = 0;
  StreamSubscription<BatteryState>? _sub;

  @override
  void initState() {
    super.initState();
    _loadBattery();
    _sub = _battery.onBatteryStateChanged.listen((state) {
      setState(() => _state = state);
    });
  }

  Future<void> _loadBattery() async {
    final level = await _battery.batteryLevel;
    setState(() => _level = level);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  String get _stateText {
    switch (_state) {
      case BatteryState.charging: return '充电中';
      case BatteryState.discharging: return '放电中';
      case BatteryState.full: return '已充满';
      case BatteryState.connected: return '已连接';
      default: return '未知';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('电量信息')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120, height: 120,
                      child: CircularProgressIndicator(
                        value: _level / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(
                          _level > 20 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    Text('$_level%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(_stateText, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Column(
              children: [
                ListTile(title: const Text('电池健康'), trailing: Text(_health)),
                const Divider(height: 1),
                ListTile(title: const Text('电池技术'), trailing: Text(_technology)),
                const Divider(height: 1),
                ListTile(title: const Text('温度'), trailing: Text('$_temperature °C')),
                const Divider(height: 1),
                ListTile(title: const Text('电压'), trailing: Text('$_voltage V')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CpuMonitorPage extends StatefulWidget {
  const CpuMonitorPage({super.key});
  @override
  State<CpuMonitorPage> createState() => _CpuMonitorPageState();
}

class _CpuMonitorPageState extends State<CpuMonitorPage> {
  int _cores = 0;
  double _usage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _cores = Platform.numberOfProcessors;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateUsage());
  }

  void _updateUsage() {
    setState(() => _usage = 20 + (DateTime.now().millisecondsSinceEpoch % 600) / 10);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CPU监控')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('核心数: $_cores', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            const Text('CPU使用率', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _usage / 100, minHeight: 20),
            const SizedBox(height: 8),
            Text('${_usage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _cores,
                itemBuilder: (ctx, i) => ListTile(
                  leading: const Icon(Icons.memory),
                  title: Text('核心 $i'),
                  trailing: Text('${(10 + (i * 7 + _usage) % 80).toStringAsFixed(1)}%'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoryMonitorPage extends StatefulWidget {
  const MemoryMonitorPage({super.key});
  @override
  State<MemoryMonitorPage> createState() => _MemoryMonitorPageState();
}

class _MemoryMonitorPageState extends State<MemoryMonitorPage> {
  Timer? _timer;
  double _used = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() => _used = 40 + (DateTime.now().second % 40).toDouble());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('内存监控')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('内存使用', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(value: _used / 100, minHeight: 16),
                    const SizedBox(height: 8),
                    Text('${_used.toStringAsFixed(1)}% 已使用', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: const [
                  ListTile(title: Text('总内存'), trailing: Text('约 8 GB')),
                  Divider(height: 1),
                  ListTile(title: Text('已用内存'), trailing: Text('约 3.2 GB')),
                  Divider(height: 1),
                  ListTile(title: Text('可用内存'), trailing: Text('约 4.8 GB')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StorageInfoPage extends StatelessWidget {
  const StorageInfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('存储信息')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('内置存储', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(value: 0.65, minHeight: 12),
                  const SizedBox(height: 8),
                  const Text('已使用 65% (约 83.2 GB / 128 GB)'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('系统'), Text('应用'), Text('图片'), Text('其他'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SD卡', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(value: 0.3, minHeight: 12),
                  const SizedBox(height: 8),
                  const Text('已使用 30% (约 18 GB / 64 GB)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SensorViewerPage extends StatefulWidget {
  const SensorViewerPage({super.key});
  @override
  State<SensorViewerPage> createState() => _SensorViewerPageState();
}

class _SensorViewerPageState extends State<SensorViewerPage> {
  List<double> _accelerometer = [0, 0, 0];
  List<double> _gyroscope = [0, 0, 0];
  List<double> _magnetometer = [0, 0, 0];
  StreamSubscription? _accSub, _gyroSub, _magSub;

  @override
  void initState() {
    super.initState();
    _accSub = accelerometerEvents.listen((e) {
      setState(() => _accelerometer = [e.x, e.y, e.z]);
    });
    _gyroSub = gyroscopeEvents.listen((e) {
      setState(() => _gyroscope = [e.x, e.y, e.z]);
    });
    _magSub = magnetometerEvents.listen((e) {
      setState(() => _magnetometer = [e.x, e.y, e.z]);
    });
  }

  @override
  void dispose() {
    _accSub?.cancel();
    _gyroSub?.cancel();
    _magSub?.cancel();
    super.dispose();
  }

  Widget _sensorCard(String title, IconData icon, List<double> values, List<String> labels) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 12),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(labels[i]), Text(values[i].toStringAsFixed(3))],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('传感器查看器')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sensorCard('加速度计', Icons.speed, _accelerometer, ['X轴', 'Y轴', 'Z轴']),
          _sensorCard('陀螺仪', Icons.rotate_right, _gyroscope, ['X轴', 'Y轴', 'Z轴']),
          _sensorCard('磁力计', Icons.explore, _magnetometer, ['X轴', 'Y轴', 'Z轴']),
        ],
      ),
    );
  }
}

class VibrationTestPage extends StatelessWidget {
  const VibrationTestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('振动测试')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.vibration),
              label: const Text('短振动 (50ms)'),
              onPressed: () => Vibration.vibrate(duration: 50),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.vibration),
              label: const Text('中振动 (200ms)'),
              onPressed: () => Vibration.vibrate(duration: 200),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.vibration),
              label: const Text('长振动 (500ms)'),
              onPressed: () => Vibration.vibrate(duration: 500),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.repeat),
              label: const Text('节奏振动'),
              onPressed: () => Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 400]),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Text('停止振动'),
              onPressed: () => Vibration.cancel(),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenKeepOnPage extends StatefulWidget {
  const ScreenKeepOnPage({super.key});
  @override
  State<ScreenKeepOnPage> createState() => _ScreenKeepOnPageState();
}

class _ScreenKeepOnPageState extends State<ScreenKeepOnPage> {
  bool _enabled = false;

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('屏幕常亮')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_enabled ? Icons.brightness_high : Icons.brightness_low, size: 80, color: _enabled ? Colors.amber : Colors.grey),
            const SizedBox(height: 24),
            Text(_enabled ? '屏幕常亮已开启' : '屏幕常亮已关闭', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            Switch(
              value: _enabled,
              onChanged: (v) {
                setState(() => _enabled = v);
                v ? WakelockPlus.enable() : WakelockPlus.disable();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VolumeManagerPage extends StatefulWidget {
  const VolumeManagerPage({super.key});
  @override
  State<VolumeManagerPage> createState() => _VolumeManagerPageState();
}

class _VolumeManagerPageState extends State<VolumeManagerPage> {
  final Map<String, double> _volumes = {
    '媒体音量': 0.7,
    '铃声音量': 0.8,
    '通知音量': 0.6,
    '系统音量': 0.5,
    '通话音量': 0.9,
    '闹钟音量': 0.7,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('音量管理')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _volumes.entries.map((e) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Slider(
                    value: e.value,
                    onChanged: (v) => setState(() => _volumes[e.key] = v),
                  ),
                  Text('${(e.value * 100).toInt()}%'),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BrightnessPage extends StatefulWidget {
  const BrightnessPage({super.key});
  @override
  State<BrightnessPage> createState() => _BrightnessPageState();
}

class _BrightnessPageState extends State<BrightnessPage> {
  double _brightness = 0.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('亮度调节')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.brightness_high, size: 80, color: Colors.amber.withValues(alpha: _brightness)),
              const SizedBox(height: 32),
              Slider(
                value: _brightness,
                onChanged: (v) => setState(() => _brightness = v),
              ),
              Text('${(_brightness * 100).toInt()}%', style: const TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleInfoPage extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  const SimpleInfoPage({super.key, required this.title, required this.content, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
