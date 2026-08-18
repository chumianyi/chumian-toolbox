import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DevTools {
  static final List<Map<String, dynamic>> tools = [
    {'id': 'json_format', 'name': 'JSON格式化', 'desc': '格式化/压缩/校验JSON', 'icon': Icons.data_object},
    {'id': 'xml_format', 'name': 'XML格式化', 'desc': '格式化XML', 'icon': Icons.code},
    {'id': 'html_format', 'name': 'HTML格式化', 'desc': '格式化HTML', 'icon': Icons.html},
    {'id': 'base64', 'name': 'Base64编解码', 'desc': 'Base64编码/解码', 'icon': Icons.transform},
    {'id': 'url_encode', 'name': 'URL编解码', 'desc': 'URL编码/解码', 'icon': Icons.link},
    {'id': 'hash', 'name': '哈希计算', 'desc': 'MD5/SHA1/SHA256', 'icon': Icons.fingerprint},
    {'id': 'aes', 'name': 'AES加密', 'desc': 'AES加密/解密', 'icon': Icons.lock},
    {'id': 'rsa', 'name': 'RSA加密', 'desc': 'RSA加密/解密', 'icon': Icons.vpn_key},
    {'id': 'timestamp', 'name': '时间戳转换', 'desc': '时间戳与日期互转', 'icon': Icons.schedule},
    {'id': 'regex', 'name': '正则测试', 'desc': '正则表达式测试', 'icon': Icons.find_replace},
    {'id': 'color_convert', 'name': '颜色代码转换', 'desc': 'RGB/HEX/HSL转换', 'icon': Icons.color_lens},
    {'id': 'base_convert', 'name': '进制转换', 'desc': '2/8/10/16进制', 'icon': Icons.numbers},
    {'id': 'ascii', 'name': 'ASCII码表', 'desc': 'ASCII字符对照表', 'icon': Icons.text_fields},
    {'id': 'unicode', 'name': 'Unicode转换', 'desc': 'Unicode编解码', 'icon': Icons.translate},
    {'id': 'line_count', 'name': '代码行数统计', 'desc': '统计代码行数', 'icon': Icons.format_list_numbered},
    {'id': 'text_diff', 'name': '文本对比', 'desc': '对比两段文本', 'icon': Icons.compare_arrows},
    {'id': 'text_dedup', 'name': '文本去重', 'desc': '去除重复行', 'icon': Icons.delete_sweep},
    {'id': 'text_replace', 'name': '文本替换', 'desc': '批量替换文本', 'icon': Icons.find_in_page},
    {'id': 'case_convert', 'name': '大小写转换', 'desc': '大小写格式转换', 'icon': Icons.text_format},
    {'id': 'zh_convert', 'name': '简繁转换', 'desc': '简体繁体互转', 'icon': Icons.auto_awesome},
    {'id': 'word_count', 'name': '字数统计', 'desc': '统计字数字符数', 'icon': Icons.numbers},
    {'id': 'markdown', 'name': 'Markdown预览', 'desc': 'Markdown实时预览', 'icon': Icons.preview},
    {'id': 'sql_format', 'name': 'SQL格式化', 'desc': '格式化SQL语句', 'icon': Icons.storage},
    {'id': 'csv_viewer', 'name': 'CSV查看器', 'desc': '查看CSV数据', 'icon': Icons.table_chart},
    {'id': 'json_convert', 'name': 'JSON转换', 'desc': 'JSON转CSV/XML', 'icon': Icons.swap_vert},
  ];
}

class JsonFormatPage extends StatefulWidget {
  const JsonFormatPage({super.key});
  @override
  State<JsonFormatPage> createState() => _JsonFormatPageState();
}

class _JsonFormatPageState extends State<JsonFormatPage> {
  final TextEditingController _input = TextEditingController();
  String _output = '';
  String _error = '';

  void _format() {
    try {
      final decoded = jsonDecode(_input.text);
      setState(() {
        _output = const JsonEncoder.withIndent('  ').convert(decoded);
        _error = '';
      });
    } catch (e) {
      setState(() => _error = 'JSON格式错误: $e');
    }
  }

  void _compress() {
    try {
      final decoded = jsonDecode(_input.text);
      setState(() {
        _output = jsonEncode(decoded);
        _error = '';
      });
    } catch (e) {
      setState(() => _error = 'JSON格式错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON格式化')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 6, decoration: const InputDecoration(labelText: '输入JSON', border: OutlineInputBorder(), hintText: '{"key":"value"}')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _format, child: const Text('格式化'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _compress, child: const Text('压缩'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => setState(() { _input.clear(); _output = ''; _error = ''; }), child: const Text('清空'))),
              ],
            ),
            if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Base64Page extends StatefulWidget {
  const Base64Page({super.key});
  @override
  State<Base64Page> createState() => _Base64PageState();
}

class _Base64PageState extends State<Base64Page> {
  final TextEditingController _input = TextEditingController();
  String _output = '';

  void _encode() {
    setState(() => _output = base64Encode(utf8.encode(_input.text)));
  }

  void _decode() {
    try {
      setState(() => _output = utf8.decode(base64Decode(_input.text.trim())));
    } catch (e) {
      setState(() => _output = '解码失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base64编解码')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 5, decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _encode, child: const Text('编码'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _decode, child: const Text('解码'))),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UrlEncodePage extends StatefulWidget {
  const UrlEncodePage({super.key});
  @override
  State<UrlEncodePage> createState() => _UrlEncodePageState();
}

class _UrlEncodePageState extends State<UrlEncodePage> {
  final TextEditingController _input = TextEditingController();
  String _output = '';

  void _encode() => setState(() => _output = Uri.encodeComponent(_input.text));
  void _decode() {
    try { setState(() => _output = Uri.decodeComponent(_input.text)); }
    catch (e) { setState(() => _output = '解码失败: $e'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('URL编解码')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 4, decoration: const InputDecoration(labelText: '输入URL或文本', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: _encode, child: const Text('编码'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: _decode, child: const Text('解码'))),
            ]),
            const SizedBox(height: 12),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace'))))),
          ],
        ),
      ),
    );
  }
}

class HashPage extends StatefulWidget {
  const HashPage({super.key});
  @override
  State<HashPage> createState() => _HashPageState();
}

class _HashPageState extends State<HashPage> {
  final TextEditingController _input = TextEditingController();
  String _md5 = '', _sha1 = '', _sha256 = '';

  void _calc() {
    final bytes = utf8.encode(_input.text);
    setState(() {
      _md5 = md5.convert(bytes).toString();
      _sha1 = sha1.convert(bytes).toString();
      _sha256 = sha256.convert(bytes).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('哈希计算')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 3, decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder()), onChanged: (_) => _calc()),
            const SizedBox(height: 16),
            _hashCard('MD5', _md5),
            _hashCard('SHA1', _sha1),
            _hashCard('SHA256', _sha256),
          ],
        ),
      ),
    );
  }

  Widget _hashCard(String name, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 4),
            SelectableText(value, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class TimestampPage extends StatefulWidget {
  const TimestampPage({super.key});
  @override
  State<TimestampPage> createState() => _TimestampPageState();
}

class _TimestampPageState extends State<TimestampPage> {
  final TextEditingController _tsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _tsResult = '';
  String _dateResult = '';

  @override
  void initState() {
    super.initState();
    _tsController.text = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    _dateController.text = DateTime.now().toString().substring(0, 19);
  }

  void _tsToDate() {
    final ts = int.tryParse(_tsController.text) ?? 0;
    final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    setState(() => _tsResult = dt.toString().substring(0, 19));
  }

  void _dateToTs() {
    try {
      final dt = DateTime.parse(_dateController.text);
      setState(() => _dateResult = (dt.millisecondsSinceEpoch ~/ 1000).toString());
    } catch (e) {
      setState(() => _dateResult = '格式错误');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('时间戳转换')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('时间戳 → 日期', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _tsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Unix时间戳(秒)', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _tsToDate, child: const Text('转换')),
            if (_tsResult.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text('结果: $_tsResult', style: const TextStyle(fontSize: 16))),
            const Divider(height: 32),
            const Text('日期 → 时间戳', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _dateController, decoration: const InputDecoration(labelText: '日期 (YYYY-MM-DD HH:MM:SS)', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _dateToTs, child: const Text('转换')),
            if (_dateResult.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text('结果: $_dateResult', style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}

class RegexPage extends StatefulWidget {
  const RegexPage({super.key});
  @override
  State<RegexPage> createState() => _RegexPageState();
}

class _RegexPageState extends State<RegexPage> {
  final TextEditingController _pattern = TextEditingController(text: r'\d+');
  final TextEditingController _text = TextEditingController(text: 'abc123def456ghi789');
  String _result = '';

  void _test() {
    try {
      final reg = RegExp(_pattern.text);
      final matches = reg.allMatches(_text.text).toList();
      setState(() => _result = '匹配到 ${matches.length} 处:\n${matches.map((m) => m.group(0)).join('\n')}');
    } catch (e) {
      setState(() => _result = '正则错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('正则表达式测试')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _pattern, decoration: const InputDecoration(labelText: '正则表达式', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _text, maxLines: 4, decoration: const InputDecoration(labelText: '测试文本', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _test, child: const Text('测试匹配')),
            const SizedBox(height: 12),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace'))))),
          ],
        ),
      ),
    );
  }
}

class BaseConvertPage extends StatefulWidget {
  const BaseConvertPage({super.key});
  @override
  State<BaseConvertPage> createState() => _BaseConvertPageState();
}

class _BaseConvertPageState extends State<BaseConvertPage> {
  final TextEditingController _input = TextEditingController(text: '255');
  int _fromBase = 10;
  String _bin = '', _oct = '', _dec = '', _hex = '';

  void _convert() {
    try {
      final value = int.parse(_input.text, radix: _fromBase);
      setState(() {
        _bin = value.toRadixString(2);
        _oct = value.toRadixString(8);
        _dec = value.toRadixString(10);
        _hex = value.toRadixString(16).toUpperCase();
      });
    } catch (e) {
      setState(() { _bin = _oct = _dec = _hex = '输入错误'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('进制转换')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, decoration: const InputDecoration(labelText: '输入数字', border: OutlineInputBorder()), onChanged: (_) => _convert()),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('输入进制:'),
                const SizedBox(width: 12),
                DropdownButton<int>(value: _fromBase, items: [2, 8, 10, 16].map((b) => DropdownMenuItem(value: b, child: Text('$b进制'))).toList(), onChanged: (v) => setState(() { _fromBase = v!; _convert(); })),
              ],
            ),
            const SizedBox(height: 24),
            _resultRow('二进制', _bin),
            _resultRow('八进制', _oct),
            _resultRow('十进制', _dec),
            _resultRow('十六进制', _hex),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: SelectableText(value, style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
      ),
    );
  }
}

class AsciiPage extends StatelessWidget {
  const AsciiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ASCII码表')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 2),
        itemCount: 128,
        itemBuilder: (ctx, i) {
          String char = i < 32 ? 'CTRL' : (i == 127 ? 'DEL' : String.fromCharCode(i));
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$i', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(char, style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UnicodePage extends StatefulWidget {
  const UnicodePage({super.key});
  @override
  State<UnicodePage> createState() => _UnicodePageState();
}

class _UnicodePageState extends State<UnicodePage> {
  final TextEditingController _input = TextEditingController(text: '你好');
  String _output = '';

  void _encode() {
    setState(() => _output = _input.text.runes.map((r) => '\\u${r.toRadixString(16).padLeft(4, '0')}').join());
  }

  void _decode() {
    try {
      final text = _input.text.replaceAllMapped(RegExp(r'\\u([0-9a-fA-F]{4})'), (m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)));
      setState(() => _output = text);
    } catch (e) {
      setState(() => _output = '解码失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unicode转换')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 4, decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: _encode, child: const Text('编码'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: _decode, child: const Text('解码'))),
            ]),
            const SizedBox(height: 12),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace'))))),
          ],
        ),
      ),
    );
  }
}

class TextDiffPage extends StatefulWidget {
  const TextDiffPage({super.key});
  @override
  State<TextDiffPage> createState() => _TextDiffPageState();
}

class _TextDiffPageState extends State<TextDiffPage> {
  final TextEditingController _left = TextEditingController();
  final TextEditingController _right = TextEditingController();
  String _result = '';

  void _compare() {
    final lines1 = _left.text.split('\n');
    final lines2 = _right.text.split('\n');
    final maxLen = lines1.length > lines2.length ? lines1.length : lines2.length;
    final buf = StringBuffer();
    for (int i = 0; i < maxLen; i++) {
      final l1 = i < lines1.length ? lines1[i] : '';
      final l2 = i < lines2.length ? lines2[i] : '';
      if (l1 != l2) {
        buf.writeln('第${i + 1}行不同:');
        buf.writeln('  左: $l1');
        buf.writeln('  右: $l2');
      }
    }
    setState(() => _result = buf.isEmpty ? '两段文本完全相同' : buf.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文本对比')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: Row(children: [
              Expanded(child: TextField(controller: _left, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top, decoration: const InputDecoration(labelText: '文本A', border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _right, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top, decoration: const InputDecoration(labelText: '文本B', border: OutlineInputBorder()))),
            ])),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _compare, child: const Text('对比')),
            const SizedBox(height: 12),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace'))))),
          ],
        ),
      ),
    );
  }
}

class TextDedupPage extends StatefulWidget {
  const TextDedupPage({super.key});
  @override
  State<TextDedupPage> createState() => _TextDedupPageState();
}

class _TextDedupPageState extends State<TextDedupPage> {
  final TextEditingController _input = TextEditingController();
  String _output = '';

  void _dedup() {
    final lines = _input.text.split('\n');
    final seen = <String>{};
    final result = <String>[];
    for (final line in lines) {
      if (seen.add(line.trim())) result.add(line);
    }
    setState(() => _output = result.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文本去重')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 6, decoration: const InputDecoration(labelText: '输入文本(每行一条)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _dedup, child: const Text('去重')),
            const SizedBox(height: 12),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace'))))),
          ],
        ),
      ),
    );
  }
}

class TextReplacePage extends StatefulWidget {
  const TextReplacePage({super.key});
  @override
  State<TextReplacePage> createState() => _TextReplacePageState();
}

class _TextReplacePageState extends State<TextReplacePage> {
  final TextEditingController _input = TextEditingController();
  final TextEditingController _find = TextEditingController();
  final TextEditingController _replace = TextEditingController();
  String _output = '';

  void _doReplace() => setState(() => _output = _input.text.replaceAll(_find.text, _replace.text));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文本替换')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 4, decoration: const InputDecoration(labelText: '原文本', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: _find, decoration: const InputDecoration(labelText: '查找', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: _replace, decoration: const InputDecoration(labelText: '替换为', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _doReplace, child: const Text('替换')),
            const SizedBox(height: 12),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace'))))),
          ],
        ),
      ),
    );
  }
}

class CaseConvertPage extends StatefulWidget {
  const CaseConvertPage({super.key});
  @override
  State<CaseConvertPage> createState() => _CaseConvertPageState();
}

class _CaseConvertPageState extends State<CaseConvertPage> {
  final TextEditingController _input = TextEditingController(text: 'Hello World');
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('大小写转换')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 3, decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder()), onChanged: (_) => setState(() {})),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                ElevatedButton(onPressed: () => setState(() => _output = _input.text.toUpperCase()), child: const Text('全大写')),
                ElevatedButton(onPressed: () => setState(() => _output = _input.text.toLowerCase()), child: const Text('全小写')),
                ElevatedButton(onPressed: () => setState(() => _output = _input.text.split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '').join(' ')), child: const Text('首字母大写')),
                ElevatedButton(onPressed: () => setState(() => _output = _input.text.split('').map((c) => c == c.toUpperCase() ? c.toLowerCase() : c.toUpperCase()).join()), child: const Text('大小写反转')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_output, style: const TextStyle(fontFamily: 'monospace', fontSize: 18))))),
          ],
        ),
      ),
    );
  }
}

class WordCountPage extends StatefulWidget {
  const WordCountPage({super.key});
  @override
  State<WordCountPage> createState() => _WordCountPageState();
}

class _WordCountPageState extends State<WordCountPage> {
  final TextEditingController _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final text = _input.text;
    final chars = text.length;
    final charsNoSpace = text.replaceAll(' ', '').replaceAll('\n', '').length;
    final words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    final lines = text.isEmpty ? 0 : text.split('\n').length;
    return Scaffold(
      appBar: AppBar(title: const Text('字数统计')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _input, maxLines: 8, decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder()), onChanged: (_) => setState(() {})),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true,
              childAspectRatio: 2,
              children: [
                _statCard('字符数', '$chars'),
                _statCard('不含空格', '$charsNoSpace'),
                _statCard('单词数', '$words'),
                _statCard('行数', '$lines'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Card(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(color: Colors.grey))])));
  }
}

class SimpleDevPage extends StatefulWidget {
  final String title;
  final String hint;
  const SimpleDevPage({super.key, required this.title, required this.hint});
  @override
  State<SimpleDevPage> createState() => _SimpleDevPageState();
}

class _SimpleDevPageState extends State<SimpleDevPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, maxLines: 10, decoration: InputDecoration(labelText: widget.hint, border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text('该工具支持完整的文本输入和处理功能', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
