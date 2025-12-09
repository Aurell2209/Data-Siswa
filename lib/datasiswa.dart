import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanKetiga extends StatefulWidget {
  const HalamanKetiga({super.key});

  @override
  State<HalamanKetiga> createState() => _HalamanKetigaState();
}

class _HalamanKetigaState extends State<HalamanKetiga> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final List<String> _prodiList = ['Informatika', 'Mesin', 'Sipil', 'Arsitek'];
  final List<String> _kelasList = ['A', 'B', 'C', 'D', 'E'];
  String? _selectedKelas;
  String? _selectedProdi;
  String _jenisKelamin = 'Pria';

  List<Map<String, dynamic>> _items = [];
  static const String _prefsKey = 'submissions';

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _npmController.dispose();
    _nomorController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? raw = prefs.getStringList(_prefsKey);
    if (raw != null) {
      setState(() {
        _items = raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = _items.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList(_prefsKey, raw);
  }

  void _addOrUpdateItem() {
    final email = _emailController.text.trim();
    final nama = _namaController.text.trim();
    final alamat = _alamatController.text.trim();
    final npm = _npmController.text.trim();
    final nomor = _nomorController.text.trim();

    if (nama.isEmpty || npm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama dan NPM wajib diisi')));
      return;
    }

    if (_editingIndex == null) {
      final item = {
        'email': email,
        'nama': nama,
        'alamat': alamat,
        'npm': npm,
        'nomor': nomor,
        'kelas': _selectedKelas ?? '-',
        'prodi': _selectedProdi ?? '-',
        'jk': _jenisKelamin,
        'createdAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        _items.insert(0, item);
      });

      _saveAll();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );
    } else {
      final index = _editingIndex!;
      final oldCreatedAt = _items[index]['createdAt'] as String?;

      final updated = {
        'email': email,
        'nama': nama,
        'alamat': alamat,
        'npm': npm,
        'nomor': nomor,
        'kelas': _selectedKelas ?? '-',
        'prodi': _selectedProdi ?? '-',
        'jk': _jenisKelamin,
        'createdAt': oldCreatedAt ?? DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        _items[index] = updated;
        _editingIndex = null;
      });

      _saveAll();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil diperbarui')));
    }

    _clearForm();
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });
    await _saveAll();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data dihapus')));
  }

  void _startEdit(int index) {
    final item = _items[index];
    setState(() {
      _editingIndex = index;
      _emailController.text = item['email'] ?? '';
      _namaController.text = item['nama'] ?? '';
      _alamatController.text = item['alamat'] ?? '';
      _npmController.text = item['npm'] ?? '';
      _nomorController.text = item['nomor'] ?? '';
      _selectedKelas = (item['kelas'] is String)
          ? item['kelas'] as String
          : null;
      _selectedProdi = (item['prodi'] is String)
          ? item['prodi'] as String
          : null;
      _jenisKelamin = (item['jk'] as String?) ?? 'Pria';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mode edit: perbarui form lalu tekan Update'),
      ),
    );
  }

  void _clearForm() {
    _emailController.clear();
    _namaController.clear();
    _alamatController.clear();
    _npmController.clear();
    setState(() {
      _selectedKelas = null;
      _selectedProdi = null;
      _jenisKelamin = 'Pria';
      _editingIndex = null;
    });
  }

  void _showDetail(Map<String, dynamic> item, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detail'),
        content: Text(
          'Email: ${item['email'] ?? '-'}\n'
          'Nama: ${item['nama'] ?? '-'}\n'
          'Alamat: ${item['alamat'] ?? '-'}\n'
          'NPM: ${item['npm'] ?? '-'}\n'
          'Kelas: ${item['kelas'] ?? '-'}\n'
          'Prodi: ${item['prodi'] ?? '-'}\n'
          'Jenis Kelamin: ${item['jk'] ?? '-'}\n'
          'Waktu dibuat: ${item['createdAt'] ?? '-'}\n'
          'Waktu diperbarui: ${item['updatedAt'] ?? '-'}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startEdit(index);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _removeItem(index);
            },
            child: const Text('Hapus'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Siswa', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D255A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _npmController,
              decoration: const InputDecoration(
                labelText: 'NPM',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nomorController,
              decoration: const InputDecoration(
                labelText: 'Nomor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              hint: const Text('Pilih Kelas'),
              decoration: const InputDecoration(
                labelText: 'Kelas',
                border: OutlineInputBorder(),
              ),
              initialValue: _selectedKelas,
              items: _kelasList
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedKelas = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              hint: const Text('Pilih Prodi'),
              decoration: const InputDecoration(
                labelText: 'Prodi',
                border: OutlineInputBorder(),
              ),
              initialValue: _selectedProdi,
              items: _prodiList
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedProdi = v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Jenis Kelamin:'),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Pria',
                      groupValue: _jenisKelamin,
                      onChanged: (v) => setState(() => _jenisKelamin = v!),
                    ),
                    const Text('Pria'),
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Perempuan',
                      groupValue: _jenisKelamin,
                      onChanged: (v) => setState(() => _jenisKelamin = v!),
                    ),
                    const Text('Perempuan'),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addOrUpdateItem,
                      child: Text(_editingIndex == null ? 'Submit' : 'Update'),
                    ),
                  ),
                ),
                if (_editingIndex != null) ...[
                  const SizedBox(width: 8),
                  TextButton(onPressed: _clearForm, child: const Text('Batal')),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Belum ada data'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Dismissible(
                          key: Key(item['createdAt'] ?? index.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete),
                          ),
                          onDismissed: (_) => _removeItem(index),
                          child: ListTile(
                            title: Text(item['nama'] ?? '-'),
                            subtitle: Text(
                              '${item['email']} • ${item['npm'] ?? '-'} • ${item['prodi'] ?? '-'}',
                            ),
                            trailing: Text(item['kelas'] ?? '-'),
                            onTap: () => _showDetail(item, index),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
