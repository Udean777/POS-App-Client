import 'package:client/features/auth/presentation/providers/staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StaffListScreen extends ConsumerWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manajemen Staf"),
        centerTitle: true,
      ),
      body: staffAsync.when(
        data: (staff) => RefreshIndicator(
          onRefresh: () async => ref.refresh(staffListProvider.future),
          child: staff.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    final person = staff[index];
                    return _buildStaffCard(person);
                  },
                ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Gagal mengambil data: $err")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add_staff'),
        label: const Text("Tambah Staf"),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Icon(Icons.people_outline, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                      "Belum ada staf terdaftar",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffCard(person) {
    final bool isOwner = person.role == 'OWNER';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: (isOwner ? const Color(0xFF6366F1) : Colors.orange).withOpacity(0.1),
            child: Icon(
              isOwner ? Icons.admin_panel_settings : Icons.person,
              color: isOwner ? const Color(0xFF6366F1) : Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.email,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  isOwner ? "Pemilik Toko" : "Kasir / Staf",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isOwner ? const Color(0xFF6366F1) : Colors.orange).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              person.role,
              style: TextStyle(
                color: isOwner ? const Color(0xFF6366F1) : Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
