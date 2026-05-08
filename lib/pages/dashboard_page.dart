import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/login_controller.dart';
import 'laporan_page.dart';
import 'profile_page.dart';
import 'tambah_page.dart';
import '../controllers/history_controller.dart';
import '../models/history_entry.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const Color _blue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _cyan = Color(0xFF06B6D4);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPageIndex = 0;
  String _selectedStatus = 'Semua';
  BaHistoryEntry? _editingEntry;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/img/background.jpeg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _Header(currentPageIndex: _currentPageIndex),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 22, 16, 16),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(child: _buildPageContent()),
                        if (_currentPageIndex != 1)
                          _DashboardBottomNav(
                            currentIndex: _currentPageIndex,
                            onPageSelected: (index) {
                              setState(() {
                                _currentPageIndex = index;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentPageIndex) {
      case 0:
        return _DashboardContent(
          searchQuery: _searchQuery,
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          selectedStatus: _selectedStatus,
          onStatusChanged: (status) {
            setState(() {
              _selectedStatus = status;
            });
          },
          onEdit: (entry) {
            setState(() {
              _editingEntry = entry;
              _currentPageIndex = 1;
            });
          },
        );
      case 1:
        return TambahPage(
          initialEntry: _editingEntry,
          onBack: () {
            setState(() {
              _editingEntry = null;
              _currentPageIndex = 0;
            });
          },
        );
      case 2:
        return const LaporanPage();
      case 3:
        return const ProfilePage();
      default:
        return const SizedBox();
    }
  }
}

class _Header extends StatelessWidget {
  final int currentPageIndex;

  const _Header({required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    final bool isProfilePage = currentPageIndex == 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My FAVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'PT SHS International',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (currentPageIndex != 1)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isProfilePage
                        ? Icons.settings_outlined
                        : Icons.notifications_none_rounded,
                    color: DashboardPage._blue,
                    size: isProfilePage ? 27 : 30,
                  ),
                ),
                if (!isProfilePage)
                  const Positioned(
                    right: 4,
                    top: 5,
                    child: SizedBox(
                      width: 11,
                      height: 11,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFFF4E43),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final String searchQuery;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final Function(BaHistoryEntry) onEdit;

  final _historyController = Get.find<HistoryController>();

  _DashboardContent({
    required this.searchQuery,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onEdit,
  });

  List<BaHistoryEntry> get _filteredEntries {
    final entries = _historyController.historyList;

    // Filter by status first
    var result = entries.toList();
    if (selectedStatus != 'Semua') {
      if (selectedStatus == 'In Progress') {
        result = result.where((e) => e.isInProgress).toList();
      } else {
        result = result.where((e) => e.status == selectedStatus).toList();
      }
    }

    if (searchQuery.isEmpty) {
      return result;
    }

    return result.where((entry) {
      final String searchableText = [
        entry.title,
        entry.customer,
        DateFormat('dd MMM yyyy').format(entry.date),
        entry.status,
      ].join(' ').toLowerCase();

      return searchableText.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _WelcomeCard(),
        const SizedBox(height: 16),
        const _CreateCard(),
        const SizedBox(height: 16),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatCard(
                  icon: Icons.description_outlined,
                  title: 'Total BA',
                  value: _historyController.totalBA.toString(),
                  valueColor: DashboardPage._blue,
                  iconBackground: const Color(0xFFEAF5FF),
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: Icons.edit_note,
                  title: 'Draft',
                  value: _historyController.draftCount.toString(),
                  valueColor: const Color(0xFFFF9700),
                  iconBackground: const Color(0xFFFFF2DF),
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: Icons.sync_rounded,
                  title: 'In Progress',
                  value: _historyController.historyList
                      .where((e) => e.isInProgress)
                      .length
                      .toString(),
                  valueColor: DashboardPage._cyan,
                  iconBackground: const Color(0xFFDEFCFE),
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: Icons.check_circle_outlined,
                  title: 'Selesai',
                  value: _historyController.approvedCount.toString(),
                  valueColor: const Color(0xFF10A83A),
                  iconBackground: const Color(0xFFE8F9EE),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        _LatestHeader(
          searchController: searchController,
          onSearchChanged: onSearchChanged,
          selectedStatus: selectedStatus,
          onStatusChanged: onStatusChanged,
        ),
        const SizedBox(height: 12),
        if (searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Hasil pencarian untuk "$searchQuery"',
              style: const TextStyle(
                color: DashboardPage._mutedText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: Obx(() {
            final entries = _filteredEntries;
            if (entries.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == entries.length - 1 ? 0 : 12,
                  ),
                  child: _BaListItem(
                    title: entry.title,
                    customer: entry.customer,
                    date: DateFormat('dd MMM yyyy').format(entry.date),
                    time: DateFormat('HH:mm').format(entry.date) + ' WIB',
                    status: entry.status,
                    isDraft: entry.isDraft,
                    isInProgress: entry.isInProgress,
                    isApproved: entry.isApproved,
                    onTap: () => onEdit(entry),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    if (searchQuery.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: DashboardPage._mutedText.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ditemukan hasil untuk "$searchQuery"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DashboardPage._mutedText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 48,
            color: DashboardPage._mutedText.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada Berita Acara',
            style: TextStyle(
              color: DashboardPage._mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    final role = controller.role.value;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: DashboardPage._blue,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    color: DashboardPage._mutedText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    color: DashboardPage._darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Semoga harimu produktif!',
                  style: TextStyle(
                    color: DashboardPage._mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/img/document-checked.png', width: 50, height: 50),
        ],
      ),
    );
  }
}

class _CreateCard extends StatelessWidget {
  const _CreateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardPage._blue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.note_add_outlined,
              color: DashboardPage._blue,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buat Berita Acara Baru',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Buat dan catat kegiatan dengan mudah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String? svgAsset;
  final IconData? icon;
  final String title;
  final String value;
  final Color valueColor;
  final Color iconBackground;

  const _StatCard({
    this.svgAsset,
    this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.iconBackground,
  }) : assert(
        svgAsset != null || icon != null,
        'Either svgAsset or icon must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: svgAsset != null
                ? SvgPicture.asset(svgAsset!, fit: BoxFit.scaleDown)
                : Icon(icon, size: 24, color: valueColor),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardPage._mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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

class _LatestHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  static const double _searchBarHeight = 42;

  const _LatestHeader({
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Berita Acara Terbaru',
          style: TextStyle(
            color: DashboardPage._darkBlue,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: _searchBarHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE7ECF3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: DashboardPage._mutedText,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Cari customer / nomor BA',
                          hintStyle: TextStyle(
                            color: DashboardPage._mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          color: DashboardPage._darkBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: onStatusChanged,
              offset: const Offset(0, 45),
              color: const Color(0xFFF8FAFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE7ECF3)),
              ),
              itemBuilder: (context) =>
                  ['Semua', 'Draft', 'In Progress', 'Selesai']
                      .map(
                        (status) => PopupMenuItem(
                          value: status,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: selectedStatus == status
                                  ? DashboardPage._blue.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  status == 'Semua'
                                      ? Icons.list_alt
                                      : (status == 'Draft'
                                            ? Icons.edit_note
                                            : (status == 'In Progress'
                                                  ? Icons.sync_rounded
                                                  : Icons
                                                        .check_circle_outline)),
                                  size: 18,
                                  color: selectedStatus == status
                                      ? DashboardPage._blue
                                      : DashboardPage._mutedText,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selectedStatus == status
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: selectedStatus == status
                                        ? DashboardPage._blue
                                        : DashboardPage._darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
              child: Container(
                width: 42,
                height: _searchBarHeight,
                decoration: BoxDecoration(
                  color: selectedStatus != 'Semua'
                      ? DashboardPage._blue.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedStatus != 'Semua'
                        ? DashboardPage._blue
                        : const Color(0xFFE7ECF3),
                  ),
                ),
                child: Center(
                  child: Icon(
                    selectedStatus != 'Semua'
                        ? Icons.filter_alt
                        : Icons.filter_alt_outlined,
                    color: selectedStatus != 'Semua'
                        ? DashboardPage._blue
                        : DashboardPage._mutedText,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BaListItem extends StatelessWidget {
  final String title;
  final String customer;
  final String date;
  final String time;
  final String status;
  final bool isDraft;
  final bool isInProgress;
  final bool isApproved;
  final VoidCallback? onTap;

  const _BaListItem({
    required this.title,
    required this.customer,
    required this.date,
    required this.time,
    required this.status,
    required this.isDraft,
    this.isInProgress = false,
    this.isApproved = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBackground;
    String displayStatus = status;

    if (isApproved) {
      statusColor = const Color(0xFF10A83A);
      statusBackground = const Color(0xFFE8F9EE);
      displayStatus = 'Approved';
    } else if (isInProgress) {
      statusColor = DashboardPage._cyan;
      statusBackground = const Color(0xFFDEFCFE);
      displayStatus = 'In Progress';
    } else if (isDraft) {
      statusColor = const Color(0xFFFF9700);
      statusBackground = const Color(0xFFFFF2DF);
      displayStatus = 'Draft';
    } else {
      statusColor = const Color(0xFF008CFF);
      statusBackground = const Color(0xFFEAF5FF);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EDF4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_outlined,
                color: DashboardPage._blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DashboardPage._darkBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Customer: $customer',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DashboardPage._mutedText,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: DashboardPage._mutedText,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$date  •  $time',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: DashboardPage._mutedText,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 82,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      displayStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: DashboardPage._mutedText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onPageSelected;

  const _DashboardBottomNav({
    required this.currentIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Dashboard',
            isActive: currentIndex == 0,
            showIndicator: true,
            onTap: () => onPageSelected(0),
          ),
          _NavItem(
            icon: Icons.add_circle,
            label: 'Tambah',
            isActive: currentIndex == 1,
            showIndicator: false,
            alwaysBlue: true,
            onTap: () => onPageSelected(1),
          ),
          _NavItem(
            icon: Icons.insert_chart_outlined_rounded,
            label: 'Laporan',
            isActive: currentIndex == 2,
            showIndicator: true,
            onTap: () => onPageSelected(2),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Akun',
            isActive: currentIndex == 3,
            showIndicator: true,
            onTap: () => onPageSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool showIndicator;
  final bool alwaysBlue;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.showIndicator = true,
    this.alwaysBlue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = (isActive || alwaysBlue)
        ? DashboardPage._blue
        : const Color(0xFF7D8798);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
              child: Center(child: Icon(icon, color: color, size: 25)),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            showIndicator
                ? Container(
                    width: 30,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isActive ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )
                : const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
