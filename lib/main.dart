import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Cần cho FilteringTextInputFormatter

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F3_231A010375', // 🔴 THAY BẰNG MSSV CỦA BẠN
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0468D7)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ===== 1. Khai báo Form Key & Controller =====
  final _formKey = GlobalKey<FormState>();

  final _hoTenCtrl = TextEditingController();
  final _mssvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // ===== 2. Dữ liệu danh sách & biến trạng thái =====
  static const _monHocs = [
    'Lập trình di động',
    'Cơ sở dữ liệu',
    'Trí tuệ nhân tạo',
    'Kiểm thử phần mềm',
  ];
  static const _buoiHocs = ['Sáng', 'Chiều', 'Tối'];

  String? _monHoc; // Dropdown
  String _heDaoTao = 'Chính quy'; // Radio
  final Set<String> _buoiDaChon = {}; // Checkbox
  DateTime? _ngaySinh;
  bool _nhanThongBao = true; // Switch
  double _soTinChi = 15; // Slider

  // ===== 3. Dọn dẹp bộ nhớ =====
  @override
  void dispose() {
    _hoTenCtrl.dispose();
    _mssvCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // ===== 4. Các hàm Kiểm tra hợp lệ (Validator) =====
  String? _kiemTraHoTen(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập họ tên';
    if (s.length < 3) return 'Họ tên phải có ít nhất 3 ký tự';
    return null; // null = hợp lệ
  }

  String? _kiemTraMssv(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập MSSV';
    if (!RegExp(r'^\d{10}$').hasMatch(s)) {
      return 'MSSV phải gồm đúng 10 chữ số';
    }
    return null;
  }

  String? _kiemTraEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập email';
    if (!RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(s)) {
      return 'Email không đúng định dạng';
    }
    return null;
  }

  String _dinhDangNgaySinh(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  Future<void> _chonNgaySinh() async {
    final ngayChon = await showDatePicker(
      context: context,
      initialDate: _ngaySinh ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (ngayChon != null) {
      setState(() => _ngaySinh = ngayChon);
    }
  }

  // ===== 5. Xử lý Nút Đăng ký =====
  void _dangKy() {
    // Kiểm tra các trường trong Form
    final hopLe = _formKey.currentState!.validate();

    // Kiểm tra các control nằm NGOÀI Form
    if (_buoiDaChon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hãy chọn ít nhất một buổi học')),
      );
      return;
    }

    if (_heDaoTao == 'Vừa làm vừa học' && !_buoiDaChon.contains('Tối')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hệ Vừa làm vừa học bắt buộc chọn buổi Tối'),
        ),
      );
      return;
    }

    if (!hopLe) return;

    // Hiển thị hộp thoại xác nhận
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng ký'),
        content: Text(
          'Họ tên: ${_hoTenCtrl.text.trim()}\n'
          'MSSV: ${_mssvCtrl.text.trim()}\n'
          'Email: ${_emailCtrl.text.trim()}\n'
          'Ngày sinh: ${_ngaySinh == null ? "Chưa chọn" : _dinhDangNgaySinh(_ngaySinh!)}\n'
          'Học phần: $_monHoc\n'
          'Hệ đào tạo: $_heDaoTao\n'
          'Buổi học: ${(_buoiDaChon.toList()..sort()).join(", ")}\n'
          'Số tín chỉ: ${_soTinChi.round()}\n'
          'Nhận thông báo: ${_nhanThongBao ? "Có" : "Không"}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // ===== 6. Xử lý Nút Làm lại =====
  void _lamLai() {
    _formKey.currentState!.reset(); // Xóa form & thông báo lỗi
    _hoTenCtrl.clear();
    _mssvCtrl.clear();
    _emailCtrl.clear();
    setState(() {
      _ngaySinh = null;
      _monHoc = null;
      _heDaoTao = 'Chính quy';
      _buoiDaChon.clear();
      _nhanThongBao = true;
      _soTinChi = 15;
    });
  }

  // ===== 7. Xây dựng Giao diện =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab F3 – Đăng ký học phần'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // --- Họ tên ---
              TextFormField(
                controller: _hoTenCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: _kiemTraHoTen,
              ),
              const SizedBox(height: 12),

              // --- MSSV ---
              TextFormField(
                controller: _mssvCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Mã số sinh viên *',
                  prefixIcon: Icon(Icons.badge_outlined),
                  helperText: 'Gồm đúng 10 chữ số',
                ),
                validator: _kiemTraMssv,
              ),
              const SizedBox(height: 12),

              // --- Email ---
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: _kiemTraEmail,
              ),
              const SizedBox(height: 12),

              // --- Ngày sinh ---
              TextFormField(
                key: ValueKey(_ngaySinh),
                initialValue: _ngaySinh == null
                    ? ''
                    : _dinhDangNgaySinh(_ngaySinh!),
                readOnly: true,
                onTap: _chonNgaySinh,
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  hintText: 'dd/MM/yyyy',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // --- Dropdown Học phần ---
              DropdownButtonFormField<String>(
                key: ValueKey(_monHoc),
                initialValue: _monHoc, // ⚠️ Flutter <3.35: đổi thành value:
                decoration: const InputDecoration(
                  labelText: 'Học phần đăng ký *',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                items: _monHocs
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _monHoc = v),
                validator: (v) => v == null ? 'Hãy chọn một học phần' : null,
              ),
              const SizedBox(height: 20),

              // --- Radio Hệ đào tạo ---
              Text(
                'Hệ đào tạo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RadioGroup<String>(
                groupValue: _heDaoTao,
                onChanged: (v) => setState(() => _heDaoTao = v ?? 'Chính quy'),
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Chính quy',
                      title: Text('Chính quy'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      value: 'Vừa làm vừa học',
                      title: Text('Vừa làm vừa học'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // --- Checkbox Buổi học ---
              Text(
                'Buổi học mong muốn (chọn ≥ 1)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ..._buoiHocs.map(
                (b) => CheckboxListTile(
                  value: _buoiDaChon.contains(b),
                  title: Text(b),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (chon) => setState(() {
                    if (chon == true) {
                      _buoiDaChon.add(b);
                    } else {
                      _buoiDaChon.remove(b);
                    }
                  }),
                ),
              ),
              const SizedBox(height: 8),

              // --- Slider Số tín chỉ ---
              Text(
                'Số tín chỉ đăng ký: ${_soTinChi.round()}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _soTinChi,
                min: 10,
                max: 24,
                divisions: 14,
                label: '${_soTinChi.round()}',
                onChanged: (v) => setState(() => _soTinChi = v),
              ),

              // --- Switch Thông báo ---
              SwitchListTile(
                value: _nhanThongBao,
                title: const Text('Nhận thông báo qua email'),
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _nhanThongBao = v),
              ),

              const SizedBox(height: 16),

              // --- Nút Đăng ký ---
              FilledButton(
                onPressed: _dangKy,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('ĐĂNG KÝ'),
                ),
              ),
              const SizedBox(height: 8),

              // --- Nút Làm lại ---
              OutlinedButton(onPressed: _lamLai, child: const Text('Làm lại')),
            ],
          ),
        ),
      ),
    );
  }
}
