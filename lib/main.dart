import 'package:flutter/material.dart';

void main() {
  runApp(const MangaEmpireUltimateApp());
}

enum Role { owner, headAdmin, superAdmin, adminMonth, admin, translator, editor, member, guest }
enum VipTier { none, goldDragon, emperor }

class MangaEmpireUltimateApp extends StatefulWidget {
  const MangaEmpireUltimateApp({Key? key}) : super(key: key);
  @override
  State<MangaEmpireUltimateApp> createState() => _MangaEmpireUltimateAppState();
}

class _MangaEmpireUltimateAppState extends State<MangaEmpireUltimateApp> {
  Role currentRole = Role.owner;
  VipTier currentVip = VipTier.emperor;
  String appName = "مانجا العرب";
  String logoUrl = "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400";
  int userPoints = 50000;
  bool antiHackShield = true;
  String currentUser = "الفاوندر الأسطوري";
  bool isLoggedIn = true;

  bool allowPublicBrowser = false; // المتصفح محجوب وحصري للمالك فقط
  bool allowExclusiveSourcesToAll = false; // سوات وتيم إكس محجوبة للعامة
  bool doublePointsEnabled = true; // دبل النقاط مفعل

  String discordUrl = "https://discord.gg/manga-alarab";

  final List<String> auditLogs = [
    "[أمان] تم تفعيل درع الحماية ضد الاختراق بنجاح.",
    "[نقاط] تفعيل ميزة مضاعفة النقاط (1000 نقطة لكل 5 فصول) للمالك والداعمين.",
    "[صلاحيات] حظر المتصفح الداخلي وجعله حصرياً للمالك فقط.",
  ];

  void addLog(String log) {
    setState(() {
      auditLogs.insert(0, "[${DateTime.now().hour}:${DateTime.now().minute}] $log");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07070C),
        cardColor: const Color(0xFF11111B),
        primaryColor: const Color(0xFFFFB703),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFB703),
          secondary: Color(0xFFE63946),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainAppDashboard(
          appName: appName,
          logoUrl: logoUrl,
          currentRole: currentRole,
          currentVip: currentVip,
          userPoints: userPoints,
          antiHackShield: antiHackShield,
          currentUser: currentUser,
          isLoggedIn: isLoggedIn,
          allowPublicBrowser: allowPublicBrowser,
          allowExclusiveSourcesToAll: allowExclusiveSourcesToAll,
          doublePointsEnabled: doublePointsEnabled,
          discordUrl: discordUrl,
          auditLogs: auditLogs,
          onRoleChanged: (r) {
            setState(() => currentRole = r);
            addLog("تم تغيير الرتبة إلى: $r");
          },
          onNameChanged: (n) {
            setState(() => appName = n);
            addLog("تم تعديل اسم التطبيق إلى: $n");
          },
          onLogoChanged: (l) {
            setState(() => logoUrl = l);
            addLog("تم تحديث رابط الشعار");
          },
          onPointsChanged: (p) => setState(() => userPoints += p),
          onDiscordChanged: (d) {
            setState(() => discordUrl = d);
            addLog("تم تحديث رابط ديسكورد إلى: $d");
          },
          onToggleBrowser: (v) {
            setState(() => allowPublicBrowser = v);
            addLog("تم ${v ? 'إتاحة' : 'حظر'} المتصفح للعامة");
          },
          onToggleExclusiveSources: (v) {
            setState(() => allowExclusiveSourcesToAll = v);
            addLog("تم ${v ? 'إتاحة' : 'حظر'} مصادر سوات وتيم إكس للعامة");
          },
          onToggleDoublePoints: (v) {
            setState(() => doublePointsEnabled = v);
            addLog("تم ${v ? 'تفعيل' : 'تعطيل'} ميزة دبل النقاط");
          },
        ),
      ),
    );
  }
}

class MainAppDashboard extends StatefulWidget {
  final String appName;
  final String logoUrl;
  final Role currentRole;
  final VipTier currentVip;
  final int userPoints;
  final bool antiHackShield;
  final String currentUser;
  final bool isLoggedIn;
  final bool allowPublicBrowser;
  final bool allowExclusiveSourcesToAll;
  final bool doublePointsEnabled;
  final String discordUrl;
  final List<String> auditLogs;
  final Function(Role) onRoleChanged;
  final Function(String) onNameChanged;
  final Function(String) onLogoChanged;
  final Function(int) onPointsChanged;
  final Function(String) onDiscordChanged;
  final Function(bool) onToggleBrowser;
  final Function(bool) onToggleExclusiveSources;
  final Function(bool) onToggleDoublePoints;

  const MainAppDashboard({
    Key? key,
    required this.appName,
    required this.logoUrl,
    required this.currentRole,
    required this.currentVip,
    required this.userPoints,
    required this.antiHackShield,
    required this.currentUser,
    required this.isLoggedIn,
    required this.allowPublicBrowser,
    required this.allowExclusiveSourcesToAll,
    required this.doublePointsEnabled,
    required this.discordUrl,
    required this.auditLogs,
    required this.onRoleChanged,
    required this.onNameChanged,
    required this.onLogoChanged,
    required this.onPointsChanged,
    required this.onDiscordChanged,
    required this.onToggleBrowser,
    required this.onToggleExclusiveSources,
    required this.onToggleDoublePoints,
  }) : super(key: key);

  @override
  State<MainAppDashboard> createState() => _MainAppDashboardState();
}

class _MainAppDashboardState extends State<MainAppDashboard> {
  int _navIndex = 0;

  bool get canSeeBrowser => widget.currentRole == Role.owner || widget.allowPublicBrowser;

  String getRoleBadge(Role r) {
    switch (r) {
      case Role.owner: return "👑 الفاوندر (المالك)";
      case Role.headAdmin: return "⚡ هيد ادمن";
      case Role.superAdmin: return "🛡️ سوبر ادمن";
      case Role.adminMonth: return "⭐ ادمن الشهر";
      case Role.admin: return "🔰 ادمن";
      case Role.translator: return "✍️ مترجم";
      case Role.editor: return "🎨 محرر";
      case Role.member: return "👤 عضو";
      case Role.guest: return "👀 ضيف";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildHomeView(),
      if (canSeeBrowser) _buildExclusiveBrowserView(),
      _buildTopSupportersView(),
      _buildVipPackagesView(),
      _buildProfileView(),
      if (widget.currentRole == Role.owner) _buildEngineeringRoom(),
    ];

    List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "الرئيسية"),
      if (canSeeBrowser)
        const BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: "المتصفح"),
      const BottomNavigationBarItem(icon: Icon(Icons.military_tech), label: "كبار الداعمين"),
      const BottomNavigationBarItem(icon: Icon(Icons.diamond), label: "باقات VIP"),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "بروفايلي"),
      if (widget.currentRole == Role.owner)
        const BottomNavigationBarItem(icon: Icon(Icons.engineering), label: "غرفة الهندسة"),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFB703), width: 2),
                image: DecorationImage(image: NetworkImage(widget.logoUrl), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.appName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFFB703))),
                Text(getRoleBadge(widget.currentRole), style: const TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<Role>(
            icon: const Icon(Icons.security, color: Colors.amber),
            tooltip: "تبديل الرتبة للتجربة",
            onSelected: widget.onRoleChanged,
            itemBuilder: (ctx) => Role.values.map((r) => PopupMenuItem(value: r, child: Text(getRoleBadge(r)))).toList(),
          ),
        ],
      ),
      body: pages[_navIndex >= pages.length ? 0 : _navIndex],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF5865F2),
        icon: const Icon(Icons.discord, color: Colors.white),
        label: const Text("مجتمع ديسكورد"),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("الرابط المعتمد: ${widget.discordUrl}")),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex >= navItems.length ? 0 : _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        backgroundColor: const Color(0xFF0C0C14),
        selectedItemColor: const Color(0xFFFFB703),
        unselectedItemColor: Colors.white30,
        type: BottomNavigationBarType.fixed,
        items: navItems,
      ),
    );
  }

  Widget _buildHomeView() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(widget.logoUrl), fit: BoxFit.cover),
          ),
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
            child: const Text("مانجا العرب - الإمبراطورية الرسمية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        const Text("الفصول والمصادر الحصرية 🔥", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildMangaCard("سولو ليفلينج: راجناروك", "سوات مانجا (حصري)", true),
        _buildMangaCard("تيم إكس: صعود الحاكم المطلق", "تيم إكس (حصري)", true),
        _buildMangaCard("مانجاليك: مغامرات الصياد العظيم", "مانجاليك (عام)", false),
      ],
    );
  }

  Widget _buildMangaCard(String title, String source, bool isExclusive) {
    bool hasAccess = !isExclusive || widget.currentRole == Role.owner || widget.allowExclusiveSourcesToAll || widget.currentVip != VipTier.none;

    return Card(
      color: const Color(0xFF12121E),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.auto_stories, color: Colors.amber, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(source, style: TextStyle(color: isExclusive ? Colors.redAccent : Colors.greenAccent, fontSize: 12)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: hasAccess ? Colors.amber : Colors.grey.shade800),
          onPressed: () {
            if (!hasAccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("هذا المصدر محجوب! خاص بالمالك وباقات VIP فقط.")),
              );
            } else {
              int earnedPoints = widget.doublePointsEnabled ? 1000 : 500;
              widget.onPointsChanged(earnedPoints);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("تم فتح الفصل بنجاح! كسبت $earnedPoints نقطة 🪙")),
              );
            }
          },
          child: Text(hasAccess ? "قراءة" : "مقفل 🔒", style: TextStyle(color: hasAccess ? Colors.black : Colors.white60)),
        ),
      ),
    );
  }

  Widget _buildExclusiveBrowserView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.lock_open, color: Colors.cyanAccent),
            SizedBox(width: 8),
            Text("المتصفح الإمبراطوري وأدوات الوكيل 🤖", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
          ],
        ),
        const SizedBox(height: 6),
        const Text("أداة حصرية للمالك: سحب الفصول، ترجمة النصوص OCR، وتبييض الفقاعات."),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ActionChip(label: const Text("سحب فصول سوات"), onPressed: () {}),
            ActionChip(label: const Text("تبييض الفقاعات"), onPressed: () {}),
            ActionChip(label: const Text("ترجمة ذكية"), onPressed: () {}),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF0F0F18), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: const Text("محرك التصفح السري نشط ويعمل بأوامرك فقط يا فاوندر.", style: TextStyle(color: Colors.white54)),
          ),
        ),
      ],
    );
  }

  Widget _buildTopSupportersView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("لائحة شرف أكبر الداعمين 🏆", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
        SizedBox(height: 4),
        Text("الأبطال الذين ساهموا في دعم مانجا العرب:", style: TextStyle(color: Colors.white60, fontSize: 13)),
        SizedBox(height: 14),
        ListTile(tileColor: Color(0xFF131322), leading: Text("🥇 1"), title: Text("سياف المانهو"), subtitle: Text("دعم بـ 250,000 نقطة"), trailing: Icon(Icons.diamond, color: Colors.cyanAccent)),
        SizedBox(height: 8),
        ListTile(tileColor: Color(0xFF131322), leading: Text("🥈 2"), title: Text("إمبراطور الظلال"), subtitle: Text("دعم بـ 180,000 نقطة"), trailing: Icon(Icons.star, color: Colors.amber)),
        SizedBox(height: 8),
        ListTile(tileColor: Color(0xFF131322), leading: Text("🥉 3"), title: Text("صائد الفصول"), subtitle: Text("دعم بـ 95,000 نقطة"), trailing: Icon(Icons.workspace_premium, color: Colors.deepOrange)),
      ],
    );
  }

  Widget _buildVipPackagesView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("باقات الدلع والاشتراكات الملكية 💎", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 14),
        _buildPackageCard("باقة التنين الذهبي (Dragon VIP)", "هالة ذهبية للبروفايل + قراءة مصادر سوات وتيم إكس + شارة ذهبية", Colors.amber),
        const SizedBox(height: 12),
        _buildPackageCard("باقة إمبراطور المانجا (Emperor Ultra)", "دبل نقاط دائم (1000 نقطة كل 5 فصول) + خط ملون بالتعليقات", Colors.purpleAccent),
      ],
    );
  }

  Widget _buildPackageCard(String name, String perks, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131322),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text(perks, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("تم تفعيل ميزات $name بنجاح!")),
              );
            },
            child: const Text("تفعيل الباقة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          tileColor: const Color(0xFF131322),
          leading: CircleAvatar(backgroundImage: NetworkImage(widget.logoUrl)),
          title: Text(widget.currentUser, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          subtitle: Text("الرتبة: ${getRoleBadge(widget.currentRole)} | الرصيد: ${widget.userPoints} 🪙"),
        ),
        const SizedBox(height: 14),
        const Text("الميزات النشطة بحسابك:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ListTile(
          tileColor: const Color(0xFF131322),
          title: const Text("ميزة دبل النقاط"),
          trailing: Text(widget.doublePointsEnabled ? "مفعلة (1000 نقطة / 5 فصول)" : "معطلة", style: const TextStyle(color: Colors.greenAccent)),
        ),
      ],
    );
  }

  Widget _buildEngineeringRoom() {
    final discordCtrl = TextEditingController(text: widget.discordUrl);
    final nameCtrl = TextEditingController(text: widget.appName);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("غرفة الهندسة والتحكم المطلق (للمالك فقط) ⚙️👑", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        const SizedBox(height: 14),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("إتاحة المتصفح والوكيل للأعضاء"),
          subtitle: const Text("حالياً مخصص للمالك فقط ومحجوب عن باقي الرتب"),
          value: widget.allowPublicBrowser,
          onChanged: widget.onToggleBrowser,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("إتاحة مصادر (سوات وتيم إكس) للجميع"),
          subtitle: const Text("حالياً محصورة للمالك والمشتركين فقط"),
          value: widget.allowExclusiveSourcesToAll,
          onChanged: widget.onToggleExclusiveSources,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("مضاعفة النقاط (دبل نقاط)"),
          subtitle: const Text("1000 نقطة لكل 5 فصول بدلاً من 10"),
          value: widget.doublePointsEnabled,
          onChanged: widget.onToggleDoublePoints,
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("تعديل رابط الديسكورد المعتمد"),
          subtitle: Text(widget.discordUrl),
          trailing: const Icon(Icons.edit, color: Colors.amber),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF1A1A2E),
                title: const Text("رابط ديسكورد الجديد:"),
                content: TextField(controller: discordCtrl, style: const Tex
