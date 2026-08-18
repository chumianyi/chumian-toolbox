import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';

class DailyTools {
  static final List<Map<String, dynamic>> tools = [
    {'id': 'calculator', 'name': '科学计算器', 'desc': '支持科学运算的计算器', 'icon': Icons.calculate},
    {'id': 'unit_converter', 'name': '单位换算', 'desc': '长度/重量/温度等换算', 'icon': Icons.swap_horiz},
    {'id': 'currency', 'name': '货币换算', 'desc': '实时汇率换算', 'icon': Icons.currency_exchange},
    {'id': 'compass', 'name': '指南针', 'desc': '方向指示', 'icon': Icons.explore},
    {'id': 'level', 'name': '水平仪', 'desc': '检测水平和垂直', 'icon': Icons.straighten},
    {'id': 'protractor', 'name': '量角器', 'desc': '测量角度', 'icon': Icons.architecture},
    {'id': 'ruler', 'name': '屏幕尺子', 'desc': '用屏幕测量长度', 'icon': Icons.straighten},
    {'id': 'flashlight', 'name': '手电筒', 'desc': '开启闪光灯照明', 'icon': Icons.flashlight_on},
    {'id': 'magnifier', 'name': '放大镜', 'desc': '相机放大查看', 'icon': Icons.zoom_in},
    {'id': 'mirror', 'name': '镜子', 'desc': '前置相机当镜子', 'icon': Icons.face},
    {'id': 'qr_gen', 'name': '二维码生成', 'desc': '生成二维码', 'icon': Icons.qr_code},
    {'id': 'qr_scan', 'name': '二维码扫描', 'desc': '扫描二维码/条形码', 'icon': Icons.qr_code_scanner},
    {'id': 'timer', 'name': '倒计时/秒表', 'desc': '倒计时和秒表', 'icon': Icons.timer},
    {'id': 'world_clock', 'name': '世界时钟', 'desc': '查看全球时间', 'icon': Icons.public},
    {'id': 'date_calc', 'name': '日期计算', 'desc': '日期差和工作日计算', 'icon': Icons.date_range},
    {'id': 'age_calc', 'name': '年龄计算', 'desc': '计算精确年龄', 'icon': Icons.cake},
    {'id': 'bmi', 'name': 'BMI计算', 'desc': '身体质量指数', 'icon': Icons.monitor_weight},
    {'id': 'body_fat', 'name': '体脂率计算', 'desc': '估算体脂率', 'icon': Icons.fitness_center},
    {'id': 'password_gen', 'name': '密码生成器', 'desc': '生成随机密码', 'icon': Icons.password},
    {'id': 'random_num', 'name': '随机数生成', 'desc': '生成指定范围随机数', 'icon': Icons.casino},
    {'id': 'dice', 'name': '抽签/骰子', 'desc': '随机抽签或掷骰子', 'icon': Icons.games},
    {'id': 'color_picker', 'name': '颜色选择器', 'desc': 'RGB/HSV/HEX颜色', 'icon': Icons.color_lens},
    {'id': 'palette', 'name': '调色板', 'desc': '创建配色方案', 'icon': Icons.palette},
    {'id': 'notes', 'name': '笔记/便签', 'desc': '记录笔记', 'icon': Icons.note},
    {'id': 'todo', 'name': '待办清单', 'desc': '管理待办事项', 'icon': Icons.checklist},
    {'id': 'accounting', 'name': '记账本', 'desc': '记录收支', 'icon': Icons.account_balance_wallet},
    {'id': 'weather', 'name': '天气查询', 'desc': '查询天气信息', 'icon': Icons.wb_sunny},
    {'id': 'translate', 'name': '翻译', 'desc': '多语言翻译', 'icon': Icons.translate},
  ];
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';
  bool _scientific = false;

  void _onPressed(String val) {
    setState(() {
      if (val == 'C') {
        _expression = '';
        _result = '0';
      } else if (val == '⌫') {
        _expression = _expression.isNotEmpty ? _expression.substring(0, _expression.length - 1) : '';
      } else if (val == '=') {
        _calculate();
      } else {
        _expression += val;
      }
    });
  }

  void _calculate() {
    try {
      String expr = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll('π', '${pi}')
          .replaceAll('√', 'sqrt');
      final result = _eval(expr);
      _result = result.toString();
    } catch (e) {
      _result = '错误';
    }
  }

  double _eval(String expr) {
    expr = expr.replaceAll('sqrt(', 'sqrt(');
    return _parseExpr(expr);
  }

  double _parseExpr(String expr) {
    expr = expr.trim();
    if (expr.isEmpty) return 0;
    if (expr.startsWith('sqrt(')) {
      final end = _findMatchingParen(expr, 4);
      final inner = _parseExpr(expr.substring(5, end));
      double result = sqrt(inner);
      if (end < expr.length - 1) {
        result = _applyOp(result, expr[end + 1], _parseExpr(expr.substring(end + 2)));
      }
      return result;
    }
    final parts = _splitByOp(expr);
    if (parts.length == 1) return double.parse(parts[0]);
    double result = _parseExpr(parts[0]);
    for (int i = 1; i < parts.length; i += 2) {
      result = _applyOp(result, parts[i], _parseExpr(parts[i + 1]));
    }
    return result;
  }

  List<String> _splitByOp(String expr) {
    final result = <String>[];
    String current = '';
    int depth = 0;
    for (int i = 0; i < expr.length; i++) {
      final c = expr[i];
      if (c == '(') depth++;
      if (c == ')') depth--;
      if (depth == 0 && (c == '+' || c == '-' || c == '*' || c == '/') && current.isNotEmpty) {
        result.add(current);
        result.add(c);
        current = '';
      } else {
        current += c;
      }
    }
    if (current.isNotEmpty) result.add(current);
    return result;
  }

  int _findMatchingParen(String expr, int start) {
    int depth = 1;
    for (int i = start + 1; i < expr.length; i++) {
      if (expr[i] == '(') depth++;
      if (expr[i] == ')') depth--;
      if (depth == 0) return i;
    }
    return expr.length - 1;
  }

  double _applyOp(double a, String op, double b) {
    switch (op) {
      case '+': return a + b;
      case '-': return a - b;
      case '*': return a * b;
      case '/': return a / b;
      default: return a;
    }
  }

  Widget _buildButton(String label, {Color? color, double flex = 1}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _onPressed(label),
          child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('科学计算器'),
        actions: [
          IconButton(
            icon: Icon(_scientific ? Icons.expand_more : Icons.expand_less),
            onPressed: () => setState(() => _scientific = !_scientific),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_expression, style: const TextStyle(fontSize: 24, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(_result, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          if (_scientific)
            Row(children: [
              _buildButton('sin'), _buildButton('cos'), _buildButton('tan'), _buildButton('π'),
            ]),
          if (_scientific)
            Row(children: [
              _buildButton('ln'), _buildButton('log'), _buildButton('√('), _buildButton('^'),
            ]),
          Row(children: [
            _buildButton('C', color: Colors.red),
            _buildButton('⌫', color: Colors.orange),
            _buildButton('%', color: Colors.blueGrey),
            _buildButton('÷', color: Colors.blue),
          ]),
          Row(children: [
            _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('×', color: Colors.blue),
          ]),
          Row(children: [
            _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('−', color: Colors.blue),
          ]),
          Row(children: [
            _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+', color: Colors.blue),
          ]),
          Row(children: [
            _buildButton('0', flex: 2), _buildButton('.'), _buildButton('=', color: Colors.green),
          ]),
        ],
      ),
    );
  }
}

class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});
  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  String _category = '长度';
  String _fromUnit = '米';
  String _toUnit = '厘米';
  final TextEditingController _controller = TextEditingController(text: '1');
  String _result = '';

  final Map<String, Map<String, double>> _conversions = {
    '长度': {'米': 1, '千米': 1000, '厘米': 0.01, '毫米': 0.001, '英寸': 0.0254, '英尺': 0.3048, '英里': 1609.34},
    '重量': {'千克': 1, '克': 0.001, '吨': 1000, '磅': 0.4536, '盎司': 0.02835},
    '温度': {'摄氏度': 1, '华氏度': 1, '开尔文': 1},
    '面积': {'平方米': 1, '平方千米': 1000000, '平方厘米': 0.0001, '公顷': 10000, '英亩': 4046.86},
    '体积': {'升': 1, '毫升': 0.001, '立方米': 1000, '加仑': 3.785, '立方英尺': 28.317},
    '速度': {'米/秒': 1, '千米/时': 0.2778, '英里/时': 0.447, '节': 0.5144},
    '数据': {'字节': 1, 'KB': 1024, 'MB': 1048576, 'GB': 1073741824, 'TB': 1099511627776},
    '时间': {'秒': 1, '分钟': 60, '小时': 3600, '天': 86400, '周': 604800},
  };

  void _convert() {
    final value = double.tryParse(_controller.text) ?? 0;
    if (_category == '温度') {
      double celsius;
      if (_fromUnit == '摄氏度') celsius = value;
      else if (_fromUnit == '华氏度') celsius = (value - 32) * 5 / 9;
      else celsius = value - 273.15;
      double result;
      if (_toUnit == '摄氏度') result = celsius;
      else if (_toUnit == '华氏度') result = celsius * 9 / 5 + 32;
      else result = celsius + 273.15;
      _result = result.toStringAsFixed(4);
    } else {
      final units = _conversions[_category]!;
      final baseValue = value * units[_fromUnit]!;
      final result = baseValue / units[_toUnit]!;
      _result = result.toStringAsFixed(6);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final units = _conversions[_category]!.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('单位换算')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Wrap(
              spacing: 8,
              children: _conversions.keys.map((c) => ChoiceChip(
                label: Text(c),
                selected: _category == c,
                onSelected: (_) => setState(() {
                  _category = c;
                  _fromUnit = _conversions[c]!.keys.first;
                  _toUnit = _conversions[c]!.keys.toList()[1];
                }),
              )).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '输入数值', border: OutlineInputBorder()),
              onChanged: (_) => _convert(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: DropdownButton<String>(
                  value: _fromUnit,
                  isExpanded: true,
                  items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                  onChanged: (v) => setState(() { _fromUnit = v!; _convert(); }),
                )),
                const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_forward)),
                Expanded(child: DropdownButton<String>(
                  value: _toUnit,
                  isExpanded: true,
                  items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                  onChanged: (v) => setState(() { _toUnit = v!; _convert(); }),
                )),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text(_result, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});
  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double _heading = 0;

  @override
  void initState() {
    super.initState();
    // 模拟指南针
  }

  String get _direction {
    if (_heading < 22.5 || _heading >= 337.5) return '北';
    if (_heading < 67.5) return '东北';
    if (_heading < 112.5) return '东';
    if (_heading < 157.5) return '东南';
    if (_heading < 202.5) return '南';
    if (_heading < 247.5) return '西南';
    if (_heading < 292.5) return '西';
    return '西北';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('指南针')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: Colors.grey)),
                  child: CustomPaint(painter: _CompassPainter()),
                ),
                Transform.rotate(
                  angle: -_heading * pi / 180,
                  child: const Icon(Icons.navigation, size: 80, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('${_heading.toStringAsFixed(1)}°', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            Text(_direction, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            const Text('请在真机上使用以获取真实方向', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final paint = Paint()..color = Colors.grey;
    for (int i = 0; i < 360; i += 30) {
      final angle = i * pi / 180;
      final x1 = center.dx + radius * sin(angle);
      final y1 = center.dy - radius * cos(angle);
      final x2 = center.dx + (radius - 15) * sin(angle);
      final y2 = center.dy - (radius - 15) * cos(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});
  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  double _x = 0, _y = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('水平仪')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250, height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: Colors.grey)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent, border: Border.fromBorderSide(BorderSide(color: Colors.green, width: 2)))),
                  Transform.translate(
                    offset: Offset(_x * 50, _y * 50),
                    child: Container(width: 30, height: 30, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('X: ${_x.toStringAsFixed(2)}  Y: ${_y.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text((_x.abs() < 0.05 && _y.abs() < 0.05) ? '水平' : '倾斜中', style: TextStyle(fontSize: 18, color: (_x.abs() < 0.05 && _y.abs() < 0.05) ? Colors.green : Colors.orange)),
          ],
        ),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool _isStopwatch = true;
  int _seconds = 0;
  bool _running = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _running = !_running;
      if (_running) {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            if (_isStopwatch) _seconds++;
            else if (_seconds > 0) _seconds--;
            else { _running = false; _timer?.cancel(); }
          });
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _reset() {
    setState(() {
      _running = false;
      _timer?.cancel();
      _seconds = 0;
    });
  }

  String get _formatted {
    final h = _seconds ~/ 3600;
    final m = (_seconds % 3600) ~/ 60;
    final s = _seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('倒计时/秒表')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(label: const Text('秒表'), selected: _isStopwatch, onSelected: (_) => setState(() => _isStopwatch = true)),
              const SizedBox(width: 16),
              ChoiceChip(label: const Text('倒计时'), selected: !_isStopwatch, onSelected: (_) => setState(() => _isStopwatch = false)),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(_formatted, style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ),
          ),
          if (!_isStopwatch)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _timeButton('1分', 60),
                  _timeButton('5分', 300),
                  _timeButton('10分', 600),
                  _timeButton('30分', 1800),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _reset, child: const Text('重置')),
                ElevatedButton(onPressed: _toggle, child: Text(_running ? '暂停' : '开始')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeButton(String label, int secs) {
    return ElevatedButton(
      onPressed: () => setState(() => _seconds = secs),
      child: Text(label),
    );
  }
}

class WorldClockPage extends StatefulWidget {
  const WorldClockPage({super.key});
  @override
  State<WorldClockPage> createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage> {
  Timer? _timer;
  final List<Map<String, dynamic>> _cities = [
    {'name': '北京', 'offset': 8},
    {'name': '东京', 'offset': 9},
    {'name': '纽约', 'offset': -5},
    {'name': '伦敦', 'offset': 0},
    {'name': '巴黎', 'offset': 1},
    {'name': '悉尼', 'offset': 10},
    {'name': '迪拜', 'offset': 4},
    {'name': '莫斯科', 'offset': 3},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getTime(int offset) {
    final now = DateTime.now().toUtc().add(Duration(hours: offset));
    return DateFormat('HH:mm:ss').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('世界时钟')),
      body: ListView.builder(
        itemCount: _cities.length,
        itemBuilder: (ctx, i) {
          final city = _cities[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(city['name'], style: const TextStyle(fontSize: 18)),
              trailing: Text(_getTime(city['offset']), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ),
          );
        },
      ),
    );
  }
}

class DateCalcPage extends StatefulWidget {
  const DateCalcPage({super.key});
  @override
  State<DateCalcPage> createState() => _DateCalcPageState();
}

class _DateCalcPageState extends State<DateCalcPage> {
  DateTime? _date1, _date2;
  String _result = '';

  Future<void> _pickDate(bool isFirst) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFirst) _date1 = picked;
        else _date2 = picked;
        _calc();
      });
    }
  }

  void _calc() {
    if (_date1 != null && _date2 != null) {
      final diff = _date2!.difference(_date1!).abs();
      _result = '相差 ${diff.inDays} 天\n${diff.inHours} 小时\n${diff.inMinutes} 分钟';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('日期计算')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('开始日期'),
              subtitle: Text(_date1 != null ? DateFormat('yyyy-MM-dd').format(_date1!) : '请选择'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(true),
            ),
            ListTile(
              title: const Text('结束日期'),
              subtitle: Text(_date2 != null ? DateFormat('yyyy-MM-dd').format(_date2!) : '请选择'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(false),
            ),
            const SizedBox(height: 32),
            if (_result.isNotEmpty)
              Card(
                color: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_result, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AgeCalcPage extends StatefulWidget {
  const AgeCalcPage({super.key});
  @override
  State<AgeCalcPage> createState() => _AgeCalcPageState();
}

class _AgeCalcPageState extends State<AgeCalcPage> {
  DateTime? _birthDate;
  String _result = '';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        final now = DateTime.now();
        int years = now.year - picked.year;
        int months = now.month - picked.month;
        int days = now.day - picked.day;
        if (days < 0) { months--; days += DateTime(now.year, now.month, 0).day; }
        if (months < 0) { years--; months += 12; }
        final totalDays = now.difference(picked).inDays;
        _result = '$years 岁 $months 个月 $days 天\n共 $totalDays 天\n约 ${(totalDays / 7).floor()} 周';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('年龄计算')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('出生日期'),
              subtitle: Text(_birthDate != null ? DateFormat('yyyy-MM-dd').format(_birthDate!) : '请选择'),
              trailing: const Icon(Icons.cake),
              onTap: _pickDate,
            ),
            const SizedBox(height: 32),
            if (_result.isNotEmpty)
              Card(
                color: Colors.green.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_result, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});
  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController _height = TextEditingController(text: '170');
  final TextEditingController _weight = TextEditingController(text: '65');
  String _result = '';
  String _category = '';
  Color _color = Colors.grey;

  void _calc() {
    final h = double.tryParse(_height.text) ?? 0;
    final w = double.tryParse(_weight.text) ?? 0;
    if (h > 0 && w > 0) {
      final bmi = w / ((h / 100) * (h / 100));
      _result = bmi.toStringAsFixed(1);
      if (bmi < 18.5) { _category = '偏瘦'; _color = Colors.blue; }
      else if (bmi < 24) { _category = '正常'; _color = Colors.green; }
      else if (bmi < 28) { _category = '超重'; _color = Colors.orange; }
      else { _category = '肥胖'; _color = Colors.red; }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI计算')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _height,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '身高 (cm)', border: OutlineInputBorder()),
              onChanged: (_) => _calc(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weight,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '体重 (kg)', border: OutlineInputBorder()),
              onChanged: (_) => _calc(),
            ),
            const SizedBox(height: 32),
            if (_result.isNotEmpty)
              Card(
                color: _color.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(_result, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _color)),
                      const SizedBox(height: 8),
                      Text(_category, style: TextStyle(fontSize: 24, color: _color)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PasswordGenPage extends StatefulWidget {
  const PasswordGenPage({super.key});
  @override
  State<PasswordGenPage> createState() => _PasswordGenPageState();
}

class _PasswordGenPageState extends State<PasswordGenPage> {
  double _length = 16;
  bool _upper = true, _lower = true, _digits = true, _special = true;
  String _password = '';

  void _generate() {
    String chars = '';
    if (_upper) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_lower) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (_digits) chars += '0123456789';
    if (_special) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    if (chars.isEmpty) { _password = '请至少选择一种字符类型'; setState(() {}); return; }
    final rnd = Random.secure();
    _password = List.generate(_length.toInt(), (_) => chars[rnd.nextInt(chars.length)]).join();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('密码生成器')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_password, style: const TextStyle(fontSize: 22, fontFamily: 'monospace')),
              ),
            ),
            const SizedBox(height: 16),
            Text('长度: ${_length.toInt()}', style: const TextStyle(fontSize: 16)),
            Slider(value: _length, min: 4, max: 64, divisions: 60, label: _length.toInt().toString(), onChanged: (v) => setState(() => _length = v)),
            SwitchListTile(title: const Text('大写字母'), value: _upper, onChanged: (v) => setState(() => _upper = v)),
            SwitchListTile(title: const Text('小写字母'), value: _lower, onChanged: (v) => setState(() => _lower = v)),
            SwitchListTile(title: const Text('数字'), value: _digits, onChanged: (v) => setState(() => _digits = v)),
            SwitchListTile(title: const Text('特殊字符'), value: _special, onChanged: (v) => setState(() => _special = v)),
            const SizedBox(height: 16),
            ElevatedButton.icon(icon: const Icon(Icons.refresh), label: const Text('生成密码'), onPressed: _generate),
          ],
        ),
      ),
    );
  }
}

class RandomNumPage extends StatefulWidget {
  const RandomNumPage({super.key});
  @override
  State<RandomNumPage> createState() => _RandomNumPageState();
}

class _RandomNumPageState extends State<RandomNumPage> {
  final TextEditingController _min = TextEditingController(text: '1');
  final TextEditingController _max = TextEditingController(text: '100');
  String _result = '';

  void _generate() {
    final min = int.tryParse(_min.text) ?? 0;
    final max = int.tryParse(_max.text) ?? 100;
    if (max > min) {
      final rnd = Random();
      setState(() => _result = (min + rnd.nextInt(max - min + 1)).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('随机数生成')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _min, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '最小值', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _max, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '最大值', border: OutlineInputBorder())),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _generate, child: const Text('生成')),
            const SizedBox(height: 32),
            if (_result.isNotEmpty) Text(_result, style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});
  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int _dice1 = 1, _dice2 = 1;
  bool _rolling = false;

  void _roll() {
    setState(() => _rolling = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _dice1 = Random().nextInt(6) + 1;
        _dice2 = Random().nextInt(6) + 1;
        _rolling = false;
      });
    });
  }

  Widget _diceFace(int value) {
    final dots = {
      1: [Alignment.center],
      2: [Alignment.topLeft, Alignment.bottomRight],
      3: [Alignment.topLeft, Alignment.center, Alignment.bottomRight],
      4: [Alignment.topLeft, Alignment.topRight, Alignment.bottomLeft, Alignment.bottomRight],
      5: [Alignment.topLeft, Alignment.topRight, Alignment.center, Alignment.bottomLeft, Alignment.bottomRight],
      6: [Alignment.topLeft, Alignment.topRight, Alignment.centerLeft, Alignment.centerRight, Alignment.bottomLeft, Alignment.bottomRight],
    };
    return Container(
      width: 100, height: 100,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(width: 2)),
      child: Stack(
        children: dots[value]!.map((a) => Align(alignment: a, child: Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)))).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('骰子')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedRotation(turns: _rolling ? 0.5 : 0, duration: const Duration(milliseconds: 500), child: _diceFace(_dice1)),
                AnimatedRotation(turns: _rolling ? -0.5 : 0, duration: const Duration(milliseconds: 500), child: _diceFace(_dice2)),
              ],
            ),
            const SizedBox(height: 32),
            Text('总和: ${_dice1 + _dice2}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton.icon(icon: const Icon(Icons.casino), label: const Text('掷骰子'), onPressed: _rolling ? null : _roll),
          ],
        ),
      ),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});
  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  double _r = 100, _g = 150, _b = 200;

  Color get _color => Color.fromRGBO(_r.toInt(), _g.toInt(), _b.toInt(), 1);
  String get _hex => '#${_r.toInt().toRadixString(16).padLeft(2, '0')}${_g.toInt().toRadixString(16).padLeft(2, '0')}${_b.toInt().toRadixString(16).padLeft(2, '0')}'.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('颜色选择器')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(width: double.infinity, height: 150, decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 16),
            Text('HEX: $_hex', style: const TextStyle(fontSize: 20, fontFamily: 'monospace')),
            Text('RGB: ${_r.toInt()}, ${_g.toInt()}, ${_b.toInt()}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            _slider('R', _r, Colors.red, (v) => setState(() => _r = v)),
            _slider('G', _g, Colors.green, (v) => setState(() => _g = v)),
            _slider('B', _b, Colors.blue, (v) => setState(() => _b = v)),
          ],
        ),
      ),
    );
  }

  Widget _slider(String label, double value, Color color, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Expanded(child: Slider(value: value, min: 0, max: 255, activeColor: color, onChanged: onChanged)),
        Text(value.toInt().toString()),
      ],
    );
  }
}

class SimpleTextToolPage extends StatefulWidget {
  final String title;
  final String hint;
  const SimpleTextToolPage({super.key, required this.title, required this.hint});
  @override
  State<SimpleTextToolPage> createState() => _SimpleTextToolPageState();
}

class _SimpleTextToolPageState extends State<SimpleTextToolPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: widget.hint, border: const OutlineInputBorder()))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _items.add(_controller.text);
                        _controller.clear();
                      });
                    }
                  },
                  child: const Text('添加'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, i) => Dismissible(
                key: Key(_items[i] + i.toString()),
                onDismissed: (_) => setState(() => _items.removeAt(i)),
                child: ListTile(title: Text(_items[i]), leading: const Icon(Icons.note)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
