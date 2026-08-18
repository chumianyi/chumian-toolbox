import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ImageTools {
  static final List<Map<String, dynamic>> tools = [
    {'id': 'img_compress', 'name': '图片压缩', 'desc': '压缩图片大小', 'icon': Icons.compress},
    {'id': 'img_convert', 'name': '格式转换', 'desc': 'PNG/JPG/WebP转换', 'icon': Icons.swap_horiz},
    {'id': 'img_crop', 'name': '图片裁剪', 'desc': '裁剪图片区域', 'icon': Icons.crop},
    {'id': 'img_rotate', 'name': '图片旋转', 'desc': '旋转图片角度', 'icon': Icons.rotate_90_degrees_cw},
    {'id': 'img_filter', 'name': '图片滤镜', 'desc': '灰度/怀旧/反色等', 'icon': Icons.filter},
    {'id': 'img_stitch', 'name': '图片拼接', 'desc': '长截图拼接', 'icon': Icons.stacked_line_chart},
    {'id': 'img_grid', 'name': '九宫格切图', 'desc': '切成九宫格', 'icon': Icons.grid_view},
    {'id': 'img_to_base64', 'name': '图片转Base64', 'desc': '图片编码为Base64', 'icon': Icons.code},
    {'id': 'base64_to_img', 'name': 'Base64转图片', 'desc': 'Base64解码为图片', 'icon': Icons.image},
    {'id': 'img_color_picker', 'name': '图片取色器', 'desc': '从图片取色', 'icon': Icons.colorize},
    {'id': 'img_resize', 'name': '分辨率修改', 'desc': '调整图片尺寸', 'icon': Icons.photo_size_select_large},
    {'id': 'img_watermark', 'name': '图片加水印', 'desc': '添加文字水印', 'icon': Icons.branding_watermark},
    {'id': 'img_meme', 'name': '表情包制作', 'desc': '制作表情包', 'icon': Icons.emoji_emotions},
    {'id': 'gif_tool', 'name': 'GIF分解/合成', 'desc': 'GIF处理工具', 'icon': Icons.gif_box},
  ];
}

class ImageToBase64Page extends StatefulWidget {
  const ImageToBase64Page({super.key});
  @override
  State<ImageToBase64Page> createState() => _ImageToBase64PageState();
}

class _ImageToBase64PageState extends State<ImageToBase64Page> {
  final TextEditingController _controller = TextEditingController();
  String? _previewImage;

  void _convert() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() => _previewImage = text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图片转Base64')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('选择图片'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请在真机上选择图片')));
              },
            ),
            const SizedBox(height: 16),
            const Text('或粘贴Base64编码预览:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'data:image/png;base64,...', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _convert, child: const Text('预览')),
            const SizedBox(height: 16),
            if (_previewImage != null)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                  child: _previewImage!.startsWith('data:')
                      ? Image.memory(base64Decode(_previewImage!.split(',')[1]), fit: BoxFit.contain)
                      : const Center(child: Text('无效的Base64数据')),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Base64ToImagePage extends StatefulWidget {
  const Base64ToImagePage({super.key});
  @override
  State<Base64ToImagePage> createState() => _Base64ToImagePageState();
}

class _Base64ToImagePageState extends State<Base64ToImagePage> {
  final TextEditingController _controller = TextEditingController();
  Uint8List? _imageBytes;
  String _error = '';

  void _convert() {
    try {
      String data = _controller.text.trim();
      if (data.contains(',')) data = data.split(',')[1];
      final bytes = base64Decode(data);
      setState(() {
        _imageBytes = bytes;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = '解码失败: $e';
        _imageBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base64转图片')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Base64编码', border: OutlineInputBorder(), hintText: '粘贴Base64字符串...'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(icon: const Icon(Icons.image), label: const Text('转换为图片'), onPressed: _convert),
            if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 16),
            Expanded(
              child: _imageBytes != null
                  ? Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                      child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                    )
                  : const Center(child: Text('输入Base64编码后点击转换', style: TextStyle(color: Colors.grey))),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageFilterPage extends StatefulWidget {
  const ImageFilterPage({super.key});
  @override
  State<ImageFilterPage> createState() => _ImageFilterPageState();
}

class _ImageFilterPageState extends State<ImageFilterPage> {
  final List<String> _filters = ['原图', '灰度', '怀旧', '反色', '黑白', '亮度+', '对比度+', '模糊'];
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图片滤镜')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 250, height: 250,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: ColorFiltered(
                    colorFilter: _getFilter(_selectedFilter),
                    child: const Icon(Icons.image, size: 100, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(16), child: Text('选择滤镜效果:', style: TextStyle(fontSize: 16))),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _selectedFilter == i ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(_filters[i], style: TextStyle(color: _selectedFilter == i ? Colors.white : Colors.black))),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(icon: const Icon(Icons.save), label: const Text('保存图片'), onPressed: () {}),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  ColorFilter _getFilter(int index) {
    switch (index) {
      case 1: return const ColorFilter.matrix([0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]);
      case 2: return const ColorFilter.matrix([0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534, 0.131, 0, 0, 0, 0, 0, 1, 0]);
      case 3: return const ColorFilter.matrix([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]);
      case 4: return const ColorFilter.matrix([0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 1, 0]);
      default: return const ColorFilter.mode(Colors.transparent, BlendMode.multiply);
    }
  }
}

class ImageRotatePage extends StatefulWidget {
  const ImageRotatePage({super.key});
  @override
  State<ImageRotatePage> createState() => _ImageRotatePageState();
}

class _ImageRotatePageState extends State<ImageRotatePage> {
  double _rotation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图片旋转')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform.rotate(
                angle: _rotation * 3.14159 / 180,
                child: Container(width: 200, height: 200, color: Colors.blue[100], child: const Icon(Icons.image, size: 100, color: Colors.blue)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('旋转角度: ${_rotation.toInt()}°', style: const TextStyle(fontSize: 18)),
                Slider(value: _rotation, min: 0, max: 360, onChanged: (v) => setState(() => _rotation = v)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () => setState(() => _rotation = (_rotation - 90) % 360), child: const Text('左转90°')),
                    ElevatedButton(onPressed: () => setState(() => _rotation = (_rotation + 90) % 360), child: const Text('右转90°')),
                    ElevatedButton(onPressed: () => setState(() => _rotation = 0), child: const Text('重置')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageResizePage extends StatefulWidget {
  const ImageResizePage({super.key});
  @override
  State<ImageResizePage> createState() => _ImageResizePageState();
}

class _ImageResizePageState extends State<ImageResizePage> {
  final TextEditingController _width = TextEditingController(text: '1920');
  final TextEditingController _height = TextEditingController(text: '1080');
  bool _keepRatio = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('分辨率修改')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _width, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '宽度 (px)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _height, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '高度 (px)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SwitchListTile(title: const Text('保持宽高比'), value: _keepRatio, onChanged: (v) => setState(() => _keepRatio = v)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: [
                _presetButton('1080p', '1920', '1080'),
                _presetButton('720p', '1280', '720'),
                _presetButton('4K', '3840', '2160'),
                _presetButton('正方形', '1080', '1080'),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(icon: const Icon(Icons.save), label: const Text('调整并保存'), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _presetButton(String label, String w, String h) {
    return ElevatedButton(
      onPressed: () => setState(() {
        _width.text = w;
        _height.text = h;
      }),
      child: Text(label),
    );
  }
}

class ImageWatermarkPage extends StatefulWidget {
  const ImageWatermarkPage({super.key});
  @override
  State<ImageWatermarkPage> createState() => _ImageWatermarkPageState();
}

class _ImageWatermarkPageState extends State<ImageWatermarkPage> {
  final TextEditingController _text = TextEditingController(text: '初眠工具箱');
  double _opacity = 0.5;
  double _fontSize = 24;
  String _position = '右下角';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图片加水印')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.image, size: 100, color: Colors.blue)),
                    Positioned(
                      right: 16, bottom: 16,
                      child: Opacity(
                        opacity: _opacity,
                        child: Text(_text.text, style: TextStyle(fontSize: _fontSize, color: Colors.white, fontWeight: FontWeight.bold, shadows: const [Shadow(color: Colors.black, blurRadius: 4)])),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _text, decoration: const InputDecoration(labelText: '水印文字', border: OutlineInputBorder()), onChanged: (_) => setState(() {})),
            const SizedBox(height: 12),
            Text('透明度: ${(_opacity * 100).toInt()}%'),
            Slider(value: _opacity, onChanged: (v) => setState(() => _opacity = v)),
            Text('字号: ${_fontSize.toInt()}'),
            Slider(value: _fontSize, min: 12, max: 72, onChanged: (v) => setState(() => _fontSize = v)),
            const SizedBox(height: 12),
            ElevatedButton.icon(icon: const Icon(Icons.save), label: const Text('保存图片'), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class SimpleImagePage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  const SimpleImagePage({super.key, required this.title, required this.message, required this.icon});
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
