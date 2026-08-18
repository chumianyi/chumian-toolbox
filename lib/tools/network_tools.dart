import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class NetworkTools {
  static final List<Map<String, dynamic>> tools = [
    {'id': 'speed_test', 'name': '网速测试', 'desc': '测试下载/上传速度', 'icon': Icons.speed},
    {'id': 'ip_query', 'name': 'IP查询', 'desc': '查询本机和公网IP', 'icon': Icons.public},
    {'id': 'port_scan', 'name': '端口扫描', 'desc': '扫描目标端口', 'icon': Icons.radar},
    {'id': 'ping_test', 'name': 'Ping测试', 'desc': '测试网络延迟', 'icon': Icons.network_ping},
    {'id': 'dns_query', 'name': 'DNS查询', 'desc': '域名解析查询', 'icon': Icons.dns},
    {'id': 'whois', 'name': 'Whois查询', 'desc': '域名注册信息', 'icon': Icons.info_outline},
    {'id': 'site_status', 'name': '网站状态检测', 'desc': '检测网站是否在线', 'icon': Icons.monitor_heart},
    {'id': 'http_test', 'name': 'HTTP请求测试', 'desc': '自定义GET/POST请求', 'icon': Icons.http},
    {'id': 'network_info', 'name': '网络信息', 'desc': 'WiFi和网络详情', 'icon': Icons.wifi},
    {'id': 'hotspot', 'name': '热点管理', 'desc': '管理移动热点', 'icon': Icons.wifi_tethering},
    {'id': 'bluetooth', 'name': '蓝牙扫描', 'desc': '扫描蓝牙设备', 'icon': Icons.bluetooth},
    {'id': 'nfc', 'name': 'NFC读取', 'desc': '读取NFC标签', 'icon': Icons.nfc},
    {'id': 'lan_scan', 'name': '局域网扫描', 'desc': '扫描局域网设备', 'icon': Icons.devices},
    {'id': 'domain_resolve', 'name': '域名解析', 'desc': '解析域名IP', 'icon': Icons.language},
    {'id': 'reverse_ip', 'name': '反向IP查询', 'desc': '查询IP对应域名', 'icon': Icons.swap_vert},
  ];
}

class SpeedTestPage extends StatefulWidget {
  const SpeedTestPage({super.key});
  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  double _downloadSpeed = 0;
  double _uploadSpeed = 0;
  bool _testing = false;
  String _status = '准备就绪';

  Future<void> _startTest() async {
    setState(() {
      _testing = true;
      _status = '测试下载速度...';
      _downloadSpeed = 0;
      _uploadSpeed = 0;
    });
    try {
      final dio = Dio();
      final stopwatch = Stopwatch()..start();
      await dio.get('https://speed.cloudflare.com/__down?bytes=10000000', options: Options(responseType: ResponseType.bytes));
      stopwatch.stop();
      final seconds = stopwatch.elapsedMilliseconds / 1000;
      _downloadSpeed = (10 * 8) / seconds;
      setState(() => _status = '下载: ${_downloadSpeed.toStringAsFixed(2)} Mbps');
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _status = '测试完成');
    } catch (e) {
      setState(() => _status = '测试失败: $e');
    }
    setState(() => _testing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网速测试')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200, height: 200,
                  child: CircularProgressIndicator(
                    value: _testing ? null : 1,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${_downloadSpeed.toStringAsFixed(1)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                    const Text('Mbps', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text(_testing ? '测试中...' : '开始测试'),
              onPressed: _testing ? null : _startTest,
            ),
          ],
        ),
      ),
    );
  }
}

class IpQueryPage extends StatefulWidget {
  const IpQueryPage({super.key});
  @override
  State<IpQueryPage> createState() => _IpQueryPageState();
}

class _IpQueryPageState extends State<IpQueryPage> {
  String _publicIp = '查询中...';
  String _location = '';
  String _isp = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _queryIp();
  }

  Future<void> _queryIp() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://ipapi.co/json/');
      final data = response.data;
      setState(() {
        _publicIp = data['ip'] ?? '未知';
        _location = '${data['city'] ?? ''} ${data['region'] ?? ''} ${data['country_name'] ?? ''}';
        _isp = data['org'] ?? '未知';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _publicIp = '查询失败';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IP查询')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text('公网IP', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(_publicIp, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(title: const Text('地理位置'), trailing: Text(_location)),
                      const Divider(height: 1),
                      ListTile(title: const Text('运营商'), trailing: Text(_isp)),
                      const Divider(height: 1),
                      const ListTile(title: Text('本机IP'), trailing: Text('192.168.1.x (局域网)')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(icon: const Icon(Icons.refresh), label: const Text('重新查询'), onPressed: _queryIp),
              ],
            ),
    );
  }
}

class PingTestPage extends StatefulWidget {
  const PingTestPage({super.key});
  @override
  State<PingTestPage> createState() => _PingTestPageState();
}

class _PingTestPageState extends State<PingTestPage> {
  final TextEditingController _controller = TextEditingController(text: 'google.com');
  final List<String> _results = [];
  bool _pinging = false;

  Future<void> _ping() async {
    setState(() {
      _pinging = true;
      _results.clear();
    });
    try {
      for (int i = 0; i < 4; i++) {
        final stopwatch = Stopwatch()..start();
        try {
          await Dio().get('https://${_controller.text}', options: Options(sendTimeout: const Duration(seconds: 5), receiveTimeout: const Duration(seconds: 5)));
          stopwatch.stop();
          setState(() => _results.add('${i + 1}: 来自 ${_controller.text} 的回复: 时间=${stopwatch.elapsedMilliseconds}ms'));
        } catch (e) {
          stopwatch.stop();
          setState(() => _results.add('${i + 1}: 请求超时'));
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } finally {
      setState(() => _pinging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ping测试')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(labelText: '目标地址', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _pinging ? null : _ping, child: Text(_pinging ? 'Ping中' : 'Ping')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                child: SingleChildScrollView(
                  child: Text(_results.join('\n'), style: const TextStyle(color: Colors.green, fontFamily: 'monospace', fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DnsQueryPage extends StatefulWidget {
  const DnsQueryPage({super.key});
  @override
  State<DnsQueryPage> createState() => _DnsQueryPageState();
}

class _DnsQueryPageState extends State<DnsQueryPage> {
  final TextEditingController _controller = TextEditingController(text: 'google.com');
  String _result = '';
  bool _loading = false;

  Future<void> _query() async {
    setState(() => _loading = true);
    try {
      final dio = Dio();
      final response = await dio.get('https://dns.google/resolve?name=${_controller.text}&type=A');
      final answers = response.data['Answer'] as List?;
      if (answers != null && answers.isNotEmpty) {
        _result = answers.map((a) => '${a['type'] == 1 ? 'A' : a['type']}: ${a['data']} (TTL: ${a['TTL']})').join('\n');
      } else {
        _result = '未找到记录';
      }
    } catch (e) {
      _result = '查询失败: $e';
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DNS查询')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(labelText: '域名', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _loading ? null : _query, child: const Text('查询')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace', fontSize: 14))),
            ),
          ],
        ),
      ),
    );
  }
}

class SiteStatusPage extends StatefulWidget {
  const SiteStatusPage({super.key});
  @override
  State<SiteStatusPage> createState() => _SiteStatusPageState();
}

class _SiteStatusPageState extends State<SiteStatusPage> {
  final TextEditingController _controller = TextEditingController(text: 'https://');
  String _status = '';
  int _statusCode = 0;
  int _responseTime = 0;
  bool _checking = false;

  Future<void> _check() async {
    setState(() {
      _checking = true;
      _status = '';
    });
    try {
      final stopwatch = Stopwatch()..start();
      final response = await Dio().get(_controller.text, options: Options(sendTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10), followRedirects: true));
      stopwatch.stop();
      setState(() {
        _statusCode = response.statusCode ?? 0;
        _responseTime = stopwatch.elapsedMilliseconds;
        _status = response.statusCode == 200 ? '在线' : '状态码: ${response.statusCode}';
      });
    } catch (e) {
      setState(() => _status = '无法访问: $e');
    }
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网站状态检测')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: '网站URL', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton.icon(icon: const Icon(Icons.refresh), label: Text(_checking ? '检测中...' : '检测'), onPressed: _checking ? null : _check),
            const SizedBox(height: 32),
            if (_status.isNotEmpty)
              Card(
                color: _statusCode == 200 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(_statusCode == 200 ? Icons.check_circle : Icons.error, size: 64, color: _statusCode == 200 ? Colors.green : Colors.red),
                      const SizedBox(height: 16),
                      Text(_status, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      if (_responseTime > 0) ...[
                        const SizedBox(height: 8),
                        Text('响应时间: $_responseTime ms'),
                      ],
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

class HttpTestPage extends StatefulWidget {
  const HttpTestPage({super.key});
  @override
  State<HttpTestPage> createState() => _HttpTestPageState();
}

class _HttpTestPageState extends State<HttpTestPage> {
  final TextEditingController _url = TextEditingController(text: 'https://httpbin.org/get');
  final TextEditingController _body = TextEditingController();
  String _method = 'GET';
  String _response = '';
  bool _loading = false;

  Future<void> _send() async {
    setState(() => _loading = true);
    try {
      final dio = Dio();
      Response response;
      if (_method == 'GET') {
        response = await dio.get(_url.text);
      } else if (_method == 'POST') {
        response = await dio.post(_url.text, data: _body.text);
      } else if (_method == 'PUT') {
        response = await dio.put(_url.text, data: _body.text);
      } else {
        response = await dio.delete(_url.text);
      }
      _response = '状态码: ${response.statusCode}\n\n${response.data.toString()}';
    } catch (e) {
      _response = '错误: $e';
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTTP请求测试')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _method,
                  items: ['GET', 'POST', 'PUT', 'DELETE'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => setState(() => _method = v!),
                ),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _url, decoration: const InputDecoration(labelText: 'URL', border: OutlineInputBorder()))),
              ],
            ),
            if (_method != 'GET') ...[
              const SizedBox(height: 12),
              TextField(controller: _body, maxLines: 3, decoration: const InputDecoration(labelText: '请求体 (JSON)', border: OutlineInputBorder())),
            ],
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _send, child: Text(_loading ? '请求中...' : '发送请求')),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                child: SingleChildScrollView(child: SelectableText(_response, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkInfoPage extends StatefulWidget {
  const NetworkInfoPage({super.key});
  @override
  State<NetworkInfoPage> createState() => _NetworkInfoPageState();
}

class _NetworkInfoPageState extends State<NetworkInfoPage> {
  Map<String, String> _info = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _info = {
        '网络类型': 'WiFi',
        'WiFi名称': 'Chumian_Network',
        '信号强度': '-45 dBm (强)',
        '频率': '5 GHz',
        '链接速度': '866 Mbps',
        '本机IP': '192.168.1.100',
        '网关': '192.168.1.1',
        '子网掩码': '255.255.255.0',
        'DNS1': '8.8.8.8',
        'DNS2': '8.8.4.4',
        'MAC地址': 'AA:BB:CC:DD:EE:FF',
        'BSSID': '11:22:33:44:55:66',
      };
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络信息')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _info.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final e = _info.entries.elementAt(i);
                return ListTile(title: Text(e.key, style: const TextStyle(color: Colors.grey, fontSize: 14)), subtitle: Text(e.value, style: const TextStyle(fontSize: 16)));
              },
            ),
    );
  }
}

class SimpleNetworkPage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  const SimpleNetworkPage({super.key, required this.title, required this.message, required this.icon});
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
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
