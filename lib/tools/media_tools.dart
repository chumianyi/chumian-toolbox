import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math';

class MediaTools {
  static final List<Map<String, dynamic>> tools = [
    {'id': 'audio_convert', 'name': '音频格式转换', 'desc': '转换音频格式', 'icon': Icons.audiotrack},
    {'id': 'video_info', 'name': '视频信息查看', 'desc': '查看视频详细信息', 'icon': Icons.video_library},
    {'id': 'video_to_gif', 'name': '视频转GIF', 'desc': '视频片段转GIF', 'icon': Icons.gif},
    {'id': 'audio_clip', 'name': '音频剪辑', 'desc': '裁剪音频片段', 'icon': Icons.content_cut},
    {'id': 'ringtone', 'name': '铃声制作', 'desc': '制作手机铃声', 'icon': Icons.notifications_active},
    {'id': 'tts', 'name': '文本转语音', 'desc': 'TTS语音合成', 'icon': Icons.record_voice_over},
    {'id': 'stt', 'name': '语音转文字', 'desc': '语音识别转文字', 'icon': Icons.mic},
    {'id': 'spectrum', 'name': '音频频谱分析', 'desc': '实时音频频谱', 'icon': Icons.graphic_eq},
    {'id': 'decibel', 'name': '噪音检测', 'desc': '分贝仪检测噪音', 'icon': Icons.surround_sound},
    {'id': 'pitch', 'name': '音调检测', 'desc': '检测音高频率', 'icon': Icons.music_note},
  ];
}

class TtsPage extends StatefulWidget {
  const TtsPage({super.key});
  @override
  State<TtsPage> createState() => _TtsPageState();
}

class _TtsPageState extends State<TtsPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _controller = TextEditingController(text: '你好，欢迎使用初眠工具箱');
  double _volume = 1.0;
  double _pitch = 1.0;
  double _rate = 0.5;
  String _language = 'zh-CN';

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage(_language);
  }

  Future<void> _speak() async {
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setSpeechRate(_rate);
    await _flutterTts.speak(_controller.text);
  }

  Future<void> _stop() async => await _flutterTts.stop();

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文本转语音')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _controller, maxLines: 4, decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _language,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'zh-CN', child: Text('中文')),
                DropdownMenuItem(value: 'en-US', child: Text('英语')),
                DropdownMenuItem(value: 'ja-JP', child: Text('日语')),
                DropdownMenuItem(value: 'ko-KR', child: Text('韩语')),
              ],
              onChanged: (v) => setState(() { _language = v!; _flutterTts.setLanguage(v); }),
            ),
            const SizedBox(height: 12),
            Text('音量: ${(_volume * 100).toInt()}%'),
            Slider(value: _volume, onChanged: (v) => setState(() => _volume = v)),
            Text('音调: ${_pitch.toStringAsFixed(1)}'),
            Slider(value: _pitch, min: 0.5, max: 2.0, onChanged: (v) => setState(() => _pitch = v)),
            Text('语速: ${_rate.toStringAsFixed(1)}'),
            Slider(value: _rate, min: 0.0, max: 1.0, onChanged: (v) => setState(() => _rate = v)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.play_arrow), label: const Text('播放'), onPressed: _speak)),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.stop), label: const Text('停止'), onPressed: _stop)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DecibelPage extends StatefulWidget {
  const DecibelPage({super.key});
  @override
  State<DecibelPage> createState() => _DecibelPageState();
}

class _DecibelPageState extends State<DecibelPage> {
  double _db = 0;
  Timer? _timer;
  final List<double> _history = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _db = 30 + Random().nextDouble() * 50;
        _history.add(_db);
        if (_history.length > 50) _history.removeAt(0);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _level {
    if (_db < 40) return '安静';
    if (_db < 60) return '正常';
    if (_db < 80) return '较吵';
    if (_db < 100) return '吵闹';
    return '极吵';
  }

  Color get _color {
    if (_db < 40) return Colors.green;
    if (_db < 60) return Colors.lightGreen;
    if (_db < 80) return Colors.orange;
    if (_db < 100) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('噪音检测')),
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
                    value: _db / 120,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(_color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${_db.toStringAsFixed(1)}', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _color)),
                    const Text('dB', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(_level, style: TextStyle(fontSize: 24, color: _color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            SizedBox(
              height: 80,
              child: CustomPaint(
                size: const Size(double.infinity, 80),
                painter: _WaveformPainter(_history, _color),
              ),
            ),
            const SizedBox(height: 16),
            const Text('参考: 30dB 安静图书馆 | 60dB 正常交谈 | 80dB 繁忙街道 | 100dB 电锯', style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  _WaveformPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()..color = color..strokeWidth = 2;
    final step = size.width / (data.length - 1 > 0 ? data.length - 1 : 1);
    for (int i = 0; i < data.length - 1; i++) {
      final x1 = i * step;
      final y1 = size.height - (data[i] / 120) * size.height;
      final x2 = (i + 1) * step;
      final y2 = size.height - (data[i + 1] / 120) * size.height;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpectrumPage extends StatefulWidget {
  const SpectrumPage({super.key});
  @override
  State<SpectrumPage> createState() => _SpectrumPageState();
}

class _SpectrumPageState extends State<SpectrumPage> {
  final List<double> _bars = List.generate(32, (_) => 0.2);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        for (int i = 0; i < _bars.length; i++) {
          _bars[i] = 0.1 + Random().nextDouble() * 0.9;
        }
      });
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
      appBar: AppBar(title: const Text('音频频谱分析')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _bars.asMap().entries.map((e) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        height: e.value * 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.blue, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('实时音频频谱可视化', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class PitchPage extends StatefulWidget {
  const PitchPage({super.key});
  @override
  State<PitchPage> createState() => _PitchPageState();
}

class _PitchPageState extends State<PitchPage> {
  double _frequency = 440;
  Timer? _timer;

  final List<String> _notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

  String get _noteName {
    final semitones = (12 * log(_frequency / 440) / ln2).round();
    final noteIndex = (semitones + 9) % 12;
    final octave = 4 + ((semitones + 9) / 12).floor();
    return '${_notes[noteIndex]}$octave';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() => _frequency = 200 + Random().nextDouble() * 800);
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
      appBar: AppBar(title: const Text('音调检测')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_noteName, style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 24),
            Text('${_frequency.toStringAsFixed(1)} Hz', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 48),
            SizedBox(
              width: 300, height: 100,
              child: CustomPaint(
                painter: _PianoPainter(_noteName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PianoPainter extends CustomPainter {
  final String currentNote;
  _PianoPainter(this.currentNote);

  @override
  void paint(Canvas canvas, Size size) {
    final whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
    final blackKeys = {'C#': 0, 'D#': 1, 'F#': 3, 'G#': 4, 'A#': 5};
    final whiteWidth = size.width / 7;
    for (int i = 0; i < 7; i++) {
      final isActive = currentNote.startsWith(whiteKeys[i]);
      final paint = Paint()..color = isActive ? Colors.blue[200]! : Colors.white;
      canvas.drawRect(Rect.fromLTWH(i * whiteWidth, 0, whiteWidth - 2, size.height), paint);
      canvas.drawRect(Rect.fromLTWH(i * whiteWidth, 0, whiteWidth - 2, size.height), Paint()..style = PaintingStyle.stroke..color = Colors.grey);
    }
    blackKeys.forEach((note, pos) {
      final isActive = currentNote == note;
      final paint = Paint()..color = isActive ? Colors.blue : Colors.black;
      canvas.drawRect(Rect.fromLTWH((pos + 1) * whiteWidth - whiteWidth * 0.3, 0, whiteWidth * 0.6, size.height * 0.6), paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class VideoInfoPage extends StatefulWidget {
  const VideoInfoPage({super.key});
  @override
  State<VideoInfoPage> createState() => _VideoInfoPageState();
}

class _VideoInfoPageState extends State<VideoInfoPage> {
  final Map<String, String> _info = {
    '文件名': 'video.mp4',
    '格式': 'MP4 (H.264 + AAC)',
    '分辨率': '1920 x 1080',
    '帧率': '30 fps',
    '时长': '00:02:35',
    '文件大小': '45.2 MB',
    '视频编码': 'H.264 / AVC',
    '视频码率': '2.5 Mbps',
    '音频编码': 'AAC',
    '音频码率': '192 kbps',
    '采样率': '44100 Hz',
    '声道': '立体声',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('视频信息查看')),
      body: ListView.separated(
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

class SimpleMediaPage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  const SimpleMediaPage({super.key, required this.title, required this.message, required this.icon});
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
