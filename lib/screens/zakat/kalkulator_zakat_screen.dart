import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class KalkulatorZakatScreen extends StatefulWidget {
  const KalkulatorZakatScreen({super.key});

  @override
  State<KalkulatorZakatScreen> createState() => _KalkulatorZakatScreenState();
}

class _KalkulatorZakatScreenState extends State<KalkulatorZakatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- ZAKAT FITRAH STATE ---
  int _jumlahJiwa = 1;
  final double _hargaBerasPerKg = 18000; // Standar per kg beras (Rp 18.000)
  // Standar BAZNAS: 2.5 kg atau setara uang (Rp 45.000 / jiwa)
  bool _useUangCustom = false;
  final TextEditingController _fitrahNominalController = TextEditingController(
    text: '45.000',
  );

  // --- ZAKAT PENGHASILAN (PROFESI) STATE ---
  final TextEditingController _gajiController = TextEditingController();
  final TextEditingController _pendapatanLainController =
      TextEditingController();
  final TextEditingController _pengeluaranPokokController =
      TextEditingController();
  double _hargaEmasPerGram = 1350000; // Standar harga emas terkini per gram
  final TextEditingController _hargaEmasPenghasilanController =
      TextEditingController(text: '1.350.000');
  bool _potongKebutuhanPokok = true;

  // --- ZAKAT MAAL (HARTA/SIMPANAN) STATE ---
  final TextEditingController _tabunganController = TextEditingController();
  final TextEditingController _emasPerakController = TextEditingController();
  final TextEditingController _asetDagangController = TextEditingController();
  final TextEditingController _hutangJatuhTempoController =
      TextEditingController();
  final TextEditingController _hargaEmasMaalController = TextEditingController(
    text: '1.350.000',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fitrahNominalController.dispose();
    _gajiController.dispose();
    _pendapatanLainController.dispose();
    _pengeluaranPokokController.dispose();
    _hargaEmasPenghasilanController.dispose();
    _tabunganController.dispose();
    _emasPerakController.dispose();
    _asetDagangController.dispose();
    _hutangJatuhTempoController.dispose();
    _hargaEmasMaalController.dispose();
    super.dispose();
  }

  // --- HELPER FORMATTING ---
  static String formatRupiah(num number) {
    final str = number.round().abs().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    final formatted = buffer.toString().split('').reversed.join('');
    final sign = number < 0 ? '-' : '';
    return '$sign Rp $formatted';
  }

  static String formatNumberOnly(num number) {
    final str = number.round().abs().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    final formatted = buffer.toString().split('').reversed.join('');
    return number < 0 ? '-$formatted' : formatted;
  }

  static double parseRupiahInput(String text) {
    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) return 0;
    return double.tryParse(clean) ?? 0;
  }

  void _onCurrencyFieldChanged(
    TextEditingController controller,
    String value, {
    VoidCallback? onDone,
  }) {
    final numVal = parseRupiahInput(value);
    final formatted = numVal == 0 ? '' : formatNumberOnly(numVal);

    if (controller.text != formatted) {
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    setState(() {});
    if (onDone != null) onDone();
  }

  // --- PERHITUNGAN ZAKAT FITRAH ---
  double get _totalBerasKg => _jumlahJiwa * 2.5;

  double get _totalZakatFitrahRp {
    if (_useUangCustom) {
      final perJiwa = parseRupiahInput(_fitrahNominalController.text);
      return _jumlahJiwa * perJiwa;
    } else {
      return _totalBerasKg * _hargaBerasPerKg;
    }
  }

  // --- PERHITUNGAN ZAKAT PENGHASILAN ---
  // Nishab per tahun: 85 gram emas. Nishab per bulan = (85 * hargaEmas) / 12
  double get _nishabPenghasilanBulanan => (_hargaEmasPerGram * 85) / 12;

  double get _totalPendapatanBulanan {
    final gaji = parseRupiahInput(_gajiController.text);
    final lain = parseRupiahInput(_pendapatanLainController.text);
    return gaji + lain;
  }

  double get _pengeluaranPokok =>
      parseRupiahInput(_pengeluaranPokokController.text);

  double get _penghasilanBersihKenaZakat {
    if (_potongKebutuhanPokok) {
      final bersih = _totalPendapatanBulanan - _pengeluaranPokok;
      return bersih > 0 ? bersih : 0;
    }
    return _totalPendapatanBulanan;
  }

  bool get _isWajibZakatPenghasilan {
    if (_totalPendapatanBulanan <= 0) return false;
    return _penghasilanBersihKenaZakat >= _nishabPenghasilanBulanan;
  }

  double get _totalZakatPenghasilanBulanan {
    if (!_isWajibZakatPenghasilan) return 0;
    return _penghasilanBersihKenaZakat * 0.025; // 2.5%
  }

  double get _totalZakatPenghasilanTahunan =>
      _totalZakatPenghasilanBulanan * 12;

  // --- PERHITUNGAN ZAKAT MAAL ---
  // Nishab: 85 gram emas
  double get _nishabMaal => _hargaEmasPerGram * 85;

  double get _totalHartaSimpanan {
    final tabungan = parseRupiahInput(_tabunganController.text);
    final emas = parseRupiahInput(_emasPerakController.text);
    final aset = parseRupiahInput(_asetDagangController.text);
    return tabungan + emas + aset;
  }

  double get _totalHutangMaal =>
      parseRupiahInput(_hutangJatuhTempoController.text);

  double get _totalHartaBersihMaal {
    final bersih = _totalHartaSimpanan - _totalHutangMaal;
    return bersih > 0 ? bersih : 0;
  }

  bool get _isWajibZakatMaal {
    if (_totalHartaSimpanan <= 0) return false;
    return _totalHartaBersihMaal >= _nishabMaal;
  }

  double get _totalZakatMaal {
    if (!_isWajibZakatMaal) return 0;
    return _totalHartaBersihMaal * 0.025; // 2.5%
  }

  void _showInfoAsnafDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: context.isDark ? AppColors.darkCardSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.isDark ? AppColors.darkBorder : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? AppColors.darkCardElevated
                          : const Color(0xFF0F3A26).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volunteer_activism_rounded,
                      color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '8 Golongan Penerima Zakat (Asnaf)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.isDark ? AppColors.darkTextPrimary : const Color(0xFF0F3A26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Berdasarkan QS. At-Taubah ayat 60, zakat hanya disalurkan kepada:',
                style: TextStyle(fontSize: 13, color: context.textSecondary),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 320,
                child: ListView(
                  children: const [
                    _AsnafItem(
                      no: '1',
                      title: 'Fakir',
                      desc: 'Orang yang tidak memiliki harta dan penghasilan cukup untuk makan pokok harian.',
                    ),
                    _AsnafItem(
                      no: '2',
                      title: 'Miskin',
                      desc: 'Orang yang memiliki penghasilan namun tidak mencukupi standar kebutuhan primer.',
                    ),
                    _AsnafItem(
                      no: '3',
                      title: 'Amil',
                      desc: 'Petugas atau panitia yang mengumpulkan dan menyalurkan zakat secara resmi.',
                    ),
                    _AsnafItem(
                      no: '4',
                      title: 'Mualaf',
                      desc: 'Orang yang baru memeluk Islam atau dilembutkan hatinya untuk memperkuat keimanan.',
                    ),
                    _AsnafItem(
                      no: '5',
                      title: 'Riqab',
                      desc: 'Upaya pembebasan hamba sahaya atau korban perdagangan manusia (human trafficking).',
                    ),
                    _AsnafItem(
                      no: '6',
                      title: 'Gharimin',
                      desc: 'Orang yang terjerat hutang untuk kebutuhan mendesak yang halal dan tak sanggup melunasi.',
                    ),
                    _AsnafItem(
                      no: '7',
                      title: 'Fisabilillah',
                      desc: 'Pejuang di jalan Allah untuk dakwah Islam, pendidikan, dan kemaslahatan umat.',
                    ),
                    _AsnafItem(
                      no: '8',
                      title: 'Ibnu Sabil',
                      desc: 'Musafir yang kehabisan bekal dalam perjalanan ketaatan/kebaikan.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26),
                    foregroundColor: context.isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Saya Mengerti',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copySummary(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
        content: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFE2B75A),
              size: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Rincian zakat berhasil disalin ke clipboard!',
                style: TextStyle(color: Colors.white, fontSize: 13),
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
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Kalkulator Zakat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.isDark ? AppColors.darkTextPrimary : Colors.white,
          ),
        ),
        backgroundColor: context.isDark ? AppColors.darkCardSurface : const Color(0xFF0F3A26),
        foregroundColor: context.isDark ? AppColors.darkTextPrimary : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: context.isDark ? const Color(0xFFE2B75A) : Colors.white,
            ),
            tooltip: '8 Golongan Penerima Zakat',
            onPressed: _showInfoAsnafDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFE2B75A),
          indicatorWeight: 3,
          labelColor: context.isDark ? const Color(0xFFE2B75A) : Colors.white,
          unselectedLabelColor: context.isDark ? AppColors.darkTextSecondary : Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.volunteer_activism_rounded, size: 20),
              text: 'Zakat Fitrah',
            ),
            Tab(
              icon: Icon(Icons.account_balance_wallet_rounded, size: 20),
              text: 'Penghasilan',
            ),
            Tab(
              icon: Icon(Icons.savings_rounded, size: 20),
              text: 'Zakat Maal',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildZakatFitrahTab(),
          _buildZakatPenghasilanTab(),
          _buildZakatMaalTab(),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: ZAKAT FITRAH
  // ==========================================
  Widget _buildZakatFitrahTab() {
    final summaryText =
        'Perhitungan Zakat Fitrah (Zelixa Islamic):\n'
        '- Jumlah Jiwa: $_jumlahJiwa orang\n'
        '- Berat Beras: ${_totalBerasKg.toStringAsFixed(1)} kg\n'
        '- Total Nilai Uang: ${formatRupiah(_totalZakatFitrahRp)}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Hasil Fitrah
          _buildResultHeader(
            title: 'Total Zakat Fitrah',
            amountText: formatRupiah(_totalZakatFitrahRp),
            subAmountText:
                'Setara ${_totalBerasKg.toStringAsFixed(1)} kg beras ($_jumlahJiwa jiwa x 2.5 kg)',
            statusBadge: 'Wajib Menjelang Idul Fitri',
            statusColor: const Color(0xFF10B981),
            onCopy: () => _copySummary(summaryText),
          ),
          const SizedBox(height: 16),

          // Pengaturan Jiwa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah Anggota Keluarga (Jiwa)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dihitung untuk diri sendiri dan seluruh tanggungan keluarga.',
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildCounterButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (_jumlahJiwa > 1) {
                          setState(() => _jumlahJiwa--);
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: context.isDark
                              ? AppColors.darkCardElevated
                              : const Color(0xFF0F3A26).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.isDark
                                ? context.borderColor
                                : const Color(0xFF0F3A26).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$_jumlahJiwa',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                              ),
                            ),
                            Text(
                              'Jiwa / Orang',
                              style: TextStyle(
                                fontSize: 11,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildCounterButton(
                      icon: Icons.add,
                      onPressed: () {
                        setState(() => _jumlahJiwa++);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Pilihan Standar Uang vs Beras
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildChoiceChip(
                        title: 'Standar Beras',
                        subtitle: 'Rp 18.000 / kg',
                        selected: !_useUangCustom,
                        onTap: () => setState(() => _useUangCustom = false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildChoiceChip(
                        title: 'Ketetapan Tunai',
                        subtitle: 'BAZNAS / DKM',
                        selected: _useUangCustom,
                        onTap: () => setState(() => _useUangCustom = true),
                      ),
                    ),
                  ],
                ),
                if (_useUangCustom) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Nominal Uang per Jiwa (Rp)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildMoneyTextField(
                    controller: _fitrahNominalController,
                    hint: '45.000',
                    onChanged: (val) =>
                        _onCurrencyFieldChanged(_fitrahNominalController, val),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [40000, 45000, 50000, 55000].map((nominal) {
                      return ActionChip(
                        label: Text('Rp ${formatNumberOnly(nominal)}'),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFFF1F5F9),
                        side: BorderSide(color: context.borderColor),
                        onPressed: () {
                          _fitrahNominalController.text = formatNumberOnly(
                            nominal,
                          );
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Kartu Edukasi Zakat Fitrah
          _buildEducationCard(
            title: 'Ketentuan Zakat Fitrah',
            description: 'Zakat Fitrah diwajibkan atas setiap jiwa muslim yang hidup pada bulan Ramadhan hingga sebelum pelaksanaan shalat Idul Fitri. Besarannya adalah 1 sha\' atau setara 2.5 kg beras (makanan pokok) atau uang senilai standar yang ditetapkan BAZNAS setempat.',
            dalil: '"Rasulullah SAW mewajibkan zakat fitrah sebanyak satu sha\' kurma atau satu sha\' gandum atas setiap muslim merdeka atau hamba sahaya, laki-laki atau perempuan." (HR. Bukhari & Muslim)',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: ZAKAT PENGHASILAN (PROFESI)
  // ==========================================
  Widget _buildZakatPenghasilanTab() {
    final summaryText =
        'Perhitungan Zakat Penghasilan (Zelixa Islamic):\n'
        '- Total Pendapatan Bulanan: ${formatRupiah(_totalPendapatanBulanan)}\n'
        '- Pengeluaran Pokok: ${formatRupiah(_pengeluaranPokok)}\n'
        '- Penghasilan Bersih: ${formatRupiah(_penghasilanBersihKenaZakat)}\n'
        '- Nishab Bulanan: ${formatRupiah(_nishabPenghasilanBulanan)}\n'
        '- Status: ${_isWajibZakatPenghasilan ? "Wajib Zakat" : "Belum Wajib"}\n'
        '- Zakat Bulanan: ${formatRupiah(_totalZakatPenghasilanBulanan)}\n'
        '- Zakat Tahunan: ${formatRupiah(_totalZakatPenghasilanTahunan)}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Hasil Penghasilan
          _buildResultHeader(
            title: 'Kewajiban Zakat Penghasilan',
            amountText: _isWajibZakatPenghasilan
                ? formatRupiah(_totalZakatPenghasilanBulanan)
                : 'Rp 0',
            subAmountText: _isWajibZakatPenghasilan
                ? 'atau ${formatRupiah(_totalZakatPenghasilanTahunan)} per tahun (2.5%)'
                : 'Penghasilan bersih belum mencapai nishab bulanan',
            statusBadge: _isWajibZakatPenghasilan
                ? 'Wajib Zakat (Nishab Tercapai)'
                : 'Belum Wajib (Dianjurkan Infaq/Sedekah)',
            statusColor: _isWajibZakatPenghasilan
                ? const Color(0xFF10B981)
                : const Color(0xFFF59E0B),
            onCopy: () => _copySummary(summaryText),
          ),
          const SizedBox(height: 16),

          // Form Input Pendapatan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pendapatan Bulanan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gaji Pokok & Tunjangan Rutin (Rp)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                _buildMoneyTextField(
                  controller: _gajiController,
                  hint: 'Contoh: 10.000.000',
                  onChanged: (val) =>
                      _onCurrencyFieldChanged(_gajiController, val),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pendapatan Lain / Bonus / Freelance (Rp)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                _buildMoneyTextField(
                  controller: _pendapatanLainController,
                  hint: 'Opsional (Contoh: 2.000.000)',
                  onChanged: (val) =>
                      _onCurrencyFieldChanged(_pendapatanLainController, val),
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: context.borderColor),
                const SizedBox(height: 12),

                // Opsi Pemotongan Kebutuhan Pokok
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Potong Kebutuhan Pokok',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            'Menurut Fatwa MUI, kebutuhan primer dan hutang jatuh tempo dapat dikurangkan terlebih dahulu.',
                            style: TextStyle(fontSize: 11, color: context.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _potongKebutuhanPokok,
                      activeTrackColor: context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26),
                      onChanged: (val) {
                        setState(() => _potongKebutuhanPokok = val);
                      },
                    ),
                  ],
                ),
                if (_potongKebutuhanPokok) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Biaya Kebutuhan Pokok & Hutang Bulanan (Rp)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  _buildMoneyTextField(
                    controller: _pengeluaranPokokController,
                    hint: 'Contoh: 3.500.000',
                    onChanged: (val) => _onCurrencyFieldChanged(
                      _pengeluaranPokokController,
                      val,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Acuan Nishab Emas
          _buildNishabCard(
            controller: _hargaEmasPenghasilanController,
            hargaEmas: _hargaEmasPerGram,
            nishabNilai: _nishabPenghasilanBulanan,
            labelNishab: 'Nishab Penghasilan Bulanan (85g emas / 12)',
            onPriceChanged: (newPrice) {
              setState(() {
                _hargaEmasPerGram = newPrice;
              });
            },
          ),
          const SizedBox(height: 16),

          // Kartu Edukasi Zakat Penghasilan
          _buildEducationCard(
            title: 'Ketentuan Zakat Penghasilan',
            description: 'Zakat Penghasilan (profesi) ditunaikan dari pendapatan rutin setiap bulan bila telah mencapai nishab setara 85 gram emas per tahun (sekitar 7.08 gram emas/bulan). Kadar zakatnya adalah 2.5% dari penghasilan bersih.',
            dalil: '"Hai orang-orang yang beriman, nafkahkanlah sebagian dari hasil usahamu yang baik-baik dan sebagian dari apa yang Kami keluarkan dari bumi untuk kamu." (QS. Al-Baqarah: 267)',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: ZAKAT MAAL (HARTA & SIMPANAN)
  // ==========================================
  Widget _buildZakatMaalTab() {
    final summaryText =
        'Perhitungan Zakat Maal (Zelixa Islamic):\n'
        '- Total Tabungan & Giro: ${formatRupiah(parseRupiahInput(_tabunganController.text))}\n'
        '- Emas, Perak & Logam Mulia: ${formatRupiah(parseRupiahInput(_emasPerakController.text))}\n'
        '- Aset Perdagangan: ${formatRupiah(parseRupiahInput(_asetDagangController.text))}\n'
        '- Hutang Jatuh Tempo: ${formatRupiah(_totalHutangMaal)}\n'
        '- Harta Bersih: ${formatRupiah(_totalHartaBersihMaal)}\n'
        '- Nishab Maal (85g Emas): ${formatRupiah(_nishabMaal)}\n'
        '- Status: ${_isWajibZakatMaal ? "Wajib Zakat" : "Belum Wajib"}\n'
        '- Total Zakat Maal (2.5%): ${formatRupiah(_totalZakatMaal)}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Hasil Maal
          _buildResultHeader(
            title: 'Kewajiban Zakat Maal',
            amountText: _isWajibZakatMaal
                ? formatRupiah(_totalZakatMaal)
                : 'Rp 0',
            subAmountText: _isWajibZakatMaal
                ? 'Telah mencapai haul (1 tahun) & nishab 85g emas (2.5%)'
                : 'Total harta bersih belum mencapai nishab 85g emas',
            statusBadge: _isWajibZakatMaal
                ? 'Wajib Zakat Maal (Nishab Tercapai)'
                : 'Belum Wajib (Nishab Belum Tercapai)',
            statusColor: _isWajibZakatMaal
                ? const Color(0xFF10B981)
                : const Color(0xFFF59E0B),
            onCopy: () => _copySummary(summaryText),
          ),
          const SizedBox(height: 16),

          // Form Input Harta Maal
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harta yang Dimiliki Selama 1 Tahun (Haul)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tabungan, Deposito & Giro (Rp)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                _buildMoneyTextField(
                  controller: _tabunganController,
                  hint: 'Contoh: 120.000.000',
                  onChanged: (val) =>
                      _onCurrencyFieldChanged(_tabunganController, val),
                ),
                const SizedBox(height: 12),
                Text(
                  'Emas, Logam Mulia & Surat Berharga (Rp)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                _buildMoneyTextField(
                  controller: _emasPerakController,
                  hint: 'Contoh: 30.000.000',
                  onChanged: (val) =>
                      _onCurrencyFieldChanged(_emasPerakController, val),
                ),
                const SizedBox(height: 12),
                Text(
                  'Aset Lancar Usaha / Perdagangan (Rp)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                _buildMoneyTextField(
                  controller: _asetDagangController,
                  hint: 'Opsional (Contoh: 50.000.000)',
                  onChanged: (val) =>
                      _onCurrencyFieldChanged(_asetDagangController, val),
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: context.borderColor),
                const SizedBox(height: 12),
                const Text(
                  'Hutang Jangka Pendek / Jatuh Tempo (Rp)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 6),
                _buildMoneyTextField(
                  controller: _hutangJatuhTempoController,
                  hint: 'Pengurang kewajiban (Contoh: 10.000.000)',
                  onChanged: (val) =>
                      _onCurrencyFieldChanged(_hutangJatuhTempoController, val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Acuan Nishab Maal (85 gram)
          _buildNishabCard(
            controller: _hargaEmasMaalController,
            hargaEmas: _hargaEmasPerGram,
            nishabNilai: _nishabMaal,
            labelNishab: 'Nishab Zakat Maal (85 gram emas)',
            onPriceChanged: (newPrice) {
              setState(() {
                _hargaEmasPerGram = newPrice;
              });
            },
          ),
          const SizedBox(height: 16),

          // Kartu Edukasi Zakat Maal
          _buildEducationCard(
            title: 'Ketentuan Zakat Maal',
            description: 'Zakat Maal (harta simpanan) wajib dikeluarkan apabila kepemilikan harta telah mencapai 1 tahun hijriah (Haul) dan jumlah totalnya mencapai batas minimal (Nishab) setara 85 gram emas murni. Besaran zakat adalah 2.5% dari total harta bersih.',
            dalil: '"Ambillah zakat dari sebagian harta mereka, dengan zakat itu kamu membersihkan dan mensucikan mereka..." (QS. At-Taubah: 103)',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // REUSABLE WIDGETS
  // ==========================================

  Widget _buildResultHeader({
    required String title,
    required String amountText,
    required String subAmountText,
    required String statusBadge,
    required Color statusColor,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isDark
              ? [const Color(0xFF142820), const Color(0xFF1A382B)]
              : [const Color(0xFF0F3A26), const Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: context.isDark ? Border.all(color: context.borderColor) : null,
        boxShadow: [
          BoxShadow(
            color: context.isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F3A26).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: onCopy,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_rounded, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'Salin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amountText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subAmountText,
            style: const TextStyle(
              color: Color(0xFFE2B75A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: statusColor, size: 14),
                const SizedBox(width: 6),
                Text(
                  statusBadge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
          borderRadius: BorderRadius.circular(12),
          border: context.isDark ? Border.all(color: context.borderColor) : null,
        ),
        child: Icon(
          icon,
          color: context.isDark ? const Color(0xFFE2B75A) : Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? (context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26).withValues(alpha: 0.08))
              : (context.isDark ? context.cardColor : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? (context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26))
                : context.borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? (context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26))
                      : context.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected
                        ? (context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26))
                        : context.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: selected
                      ? (context.isDark ? AppColors.emeraldLight : const Color(0xFF0F3A26).withValues(alpha: 0.8))
                      : context.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyTextField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
        color: context.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Text(
            'Rp',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
              fontSize: 15,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hint,
        hintStyle: TextStyle(color: context.textSecondary, fontSize: 14),
        filled: true,
        fillColor: context.isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.isDark ? AppColors.primaryLight : const Color(0xFF0F3A26),
            width: 1.5,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildNishabCard({
    required TextEditingController controller,
    required double hargaEmas,
    required double nishabNilai,
    required String labelNishab,
    required ValueChanged<double> onPriceChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: Color(0xFFD97706),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Harga Acuan Emas Terkini',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: context.isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Text(
                'Per gram',
                style: TextStyle(fontSize: 11, color: context.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMoneyTextField(
            controller: controller,
            hint: '1.350.000',
            onChanged: (val) {
              final newPrice = parseRupiahInput(val);
              _onCurrencyFieldChanged(
                controller,
                val,
                onDone: () {
                  if (newPrice > 0) onPriceChanged(newPrice);
                },
              );
            },
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.isDark ? const Color(0xFF2A200B) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: context.isDark ? 0.4 : 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    labelNishab,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                    ),
                  ),
                ),
                Text(
                  formatRupiah(nishabNilai),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: context.isDark ? const Color(0xFFF59E0B) : const Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard({
    required String title,
    required String description,
    required String dalil,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF0F3A26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.borderColor),
            ),
            child: Text(
              dalil,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                height: 1.4,
                color: context.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AsnafItem extends StatelessWidget {
  final String no;
  final String title;
  final String desc;

  const _AsnafItem({required this.no, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkCardElevated : const Color(0xFF0F3A26),
              shape: BoxShape.circle,
              border: context.isDark ? Border.all(color: context.borderColor) : null,
            ),
            child: Text(
              no,
              style: TextStyle(
                color: context.isDark ? const Color(0xFFE2B75A) : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: context.isDark ? const Color(0xFFE2B75A) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
