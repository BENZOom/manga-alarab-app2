import 'package:flutter/material.dart';

void main() {
  runApp(const MangaEmpireApp());
}

enum Role { owner, headAdmin, superAdmin, adminMonth, admin, translator, editor, member, guest }

class MangaEmpireApp extends StatefulWidget {
  const MangaEmpireApp({Key? key}) : super(key: key);
  @override
  State<MangaEmpireApp> createState() => _MangaEmpireAppState();
}

class _MangaEmpireAppState extends State<MangaEmpireApp> {
  Role currentRole = Role.owner;
  String appName = "مانجا العرب";
  String logoUrl = "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400";
  int userPoints = 25400;
  bool antiHackShield = true;
  String currentUser = "الفاوندر الأسطوري";
  bool isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF08080E),
        cardColor: const Color(0xFF13131F),
        primaryColor: const Color(0xFFFFB703),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFB703),
          secondary: Color(0xFFE63946),
          surface: Color(0xFF13131F),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainWrapperScreen(
          appName: appName,
          logoUrl: logoUrl,
          currentRole: currentRole,
          userPoints: userPoints,
          antiHackShield: antiHackShield,
          currentUser: currentUser,
          isLoggedIn: isLoggedIn,
          onRoleChanged: (r) => setState(() => currentRole = r),
          onNameChanged: (n) => setState(() => appName = n),
          onLogoChanged: (l) => setState(() => logoUrl = l),
          onPointsChanged: (p) => setState(() => userPoints += p),
          onAuthChanged: (logged, name) {
            setState(() {
              isLoggedIn = logged;
              currentUser = name;
              currentRole = logged ? Role.member : Role.guest;
            });
          },
        ),
      ),
    );
  }
}

class MainWrapperScreen extends StatefulWidget {
  final String appName;
  final String logoUrl;
  final Role currentRole;
  final int userPoints;
  final bool antiHackShield;
  final String currentUser;
  final bool isLoggedIn;
  final Function(Role) onRoleChanged;
  final Function(String) onNameChanged;
  final Function(String) onLogoChanged;
  final Function(int) onPointsChanged;
  final Function(bool, String) onAuthChanged;

  const MainWrapperScreen({
    Key? key,
    required this.appName,
    required this.logoUrl,
    required this.currentRole,
    required this.userPoints,
    required this.antiHackShield,
    required this.currentUser,
    required this.isLoggedIn,
    required this.onRoleChanged,
    required this.onNameChanged,
    required this.onLogoChanged,
    required this.onPointsChanged,
    required this.onAuthChanged,
  }) : super(key: key);

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _navIndex = 0;
  final List<String> _comments = [
    "الفاوندر: سيتم إضافة فصول سوات مانجا الليلة حصرياً!",
    "محرر السولو: تم تنقية وتبييض الفصل 35 بجودة فائقة.",
    "أوتاكو فخم: شكراً على الترجمة الأسطورية استمروا يا أبطال.",
  ];

  String getRoleBadge(Role r) {
    switch (r) {
      case Role.owner: return "👑 الفاوندر";
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
    final pages = [
      _buildHomeScreen(),
      _buildBrowserAgentScreen(),
      _buildLeaderboardScreen(),
      _buildProfileScreen(),
      if (widget.currentRole == Role.owner) _buildOwnerRoom(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10101C),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFB703), width: 2),
                image: DecorationImage(
                  image: NetworkImage(widget.logoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFFFFB703)),
                ),
                Text(
                  getRoleBadge(widget.currentRole),
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user, color: Colors.cyanAccent),
            tooltip: "حقوق النشر والملكية",
            onPressed: () => _showCopyrightDialog(),
          ),
          IconButton(
            icon: Icon(widget.isLoggedIn ? Icons.account_circle : Icons.login, color: const Color(0xFFFFB703)),
            tooltip: "إدارة الحساب والتسجيل",
            onPressed: () => _showAuthModal(),
          ),
          PopupMenuButton<Role>(
            icon: const Icon(Icons.shield, color: Colors.redAccent),
            tooltip: "اختبار الرتب",
            onSelected: widget.onRoleChanged,
            itemBuilder: (ctx) => Role.values.map((r) => PopupMenuItem(value: r, child: Text(getRoleBadge(r)))).toList(),
          ),
        ],
      ),
      body: pages[_navIndex >= pages.length ? 0 : _navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex >= pages.length ? 0 : _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        backgroundColor: const Color(0xFF0F0F1A),
        selectedItemColor: const Color(0xFFFFB703),
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "الرئيسية"),
          const BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "الوكيل"),
          const BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "المتصدرين"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "الملف الشخصي"),
          if (widget.currentRole == Role.owner)
            const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: "غرفة المالك"),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF6A040F), Color(0xFF03071E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFFFFB703).withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.military_tech, color: Color(0xFFFFB703), size: 28),
                  SizedBox(width: 8),
                  Text("قائمة الفخر والإنجازات 🏆", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "أكثر من 20 مليون مشاهدة هذا الأسبوع! شراكة حصرية مع سوات مانجا وتيم إكس ومانجاليك.",
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("رصيدك: ${widget.userPoints} نقطة 🪙", style: const TextStyle(color: Color(0xFFFFB703), fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703)),
                    onPressed: () {
                      widget.onPointsChanged(500);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم استلام المكافأة اليومية 500 نقطة بنجاح!")));
                    },
                    child: const Text("مكافأة يومية", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("أحدث الفصول الحصرية 🔥", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        _buildMangaItem("سولو ليفلينج: راجناروك", "الفصل 35", "https://images.unsplash.com/photo-1578632767115-351597cf2477?w=400"),
        _buildMangaItem("عودة سيد الطائفة العظيم", "الفصل 114", "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=400"),
      ],
    );
  }

  Widget _buildMangaItem(String title, String chapter, String img) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF131322),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(img, width: 50, height: 70, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.menu_book, color: Colors.amber)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(chapter, style: const TextStyle(color: Colors.white60)),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon: const Icon(Icons.comment, color: Colors.cyanAccent, size: 20),
              onPressed: () => _showCommentsSheet(title),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703)),
              onPressed: () {
                if (widget.currentRole == Role.guest) {
                  _showGuestAlert();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ChapterReaderScreen(title: title, chapter: chapter)),
                  );
                }
              },
              child: const Text("قراءة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(String mangaTitle) {
    final textCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF12121E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("تعليقات: $mangaTitle", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _comments.length,
                    itemBuilder: (ctx, i) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(10)),
                      child: Text(_comments[i], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(hintText: "اكتب تعليقك...", hintStyle: TextStyle(color: Colors.white30)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.amber),
                      onPressed: () {
                        if (textCtrl.text.isNotEmpty) {
                          setState(() => _comments.insert(0, "${widget.currentUser}: ${textCtrl.text}"));
                          setSheetState(() {});
                          textCtrl.clear();
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGuestAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B2A),
        title: const Text("تنبيه الضيف ⛔"),
        content: const Text("رتبة الضيف تتيح تصفح القوائم فقط. يجب تسجيل الدخول لقراءة الفصول."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              Navigator.pop(ctx);
              _showAuthModal();
            },
            child: const Text("تسجيل الدخول الآن", style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }

  void _showCopyrightDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141422),
        title: const Text("حقوق الملكية والنشر (DMCA)"),
        content: const Text(
          "• جميع الحقوق محفوظة لتطبيق مانجا العرب وشركائه الرسميين.\n\n"
          "• الأعمال تعود ملكيتها لمؤلفيها وناشريها الأصليين والترجمة لخدمة القارئ العربي غير الربحي.",
          style: TextStyle(fontSize: 13, height: 1.5, color: Colors.white70),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("موافق", style: TextStyle(color: Colors.amber)))],
      ),
    );
  }

  void _showAuthModal() {
    int tab = 0;
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => AlertDialog(
          backgroundColor: const Color(0xFF141422),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () => setMState(() => tab = 0), child: Text("دخول", style: TextStyle(color: tab == 0 ? Colors.amber : Colors.white54))),
              TextButton(onPressed: () => setMState(() => tab = 1), child: Text("إنشاء حساب", style: TextStyle(color: tab == 1 ? Colors.amber : Colors.white54))),
              TextButton(onPressed: () => setMState(() => tab = 2), child: Text("استعادة", style: TextStyle(color: tab == 2 ? Colors.amber : Colors.white54))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: emailCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "البريد الإلكتروني")),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  widget.onAuthChanged(true, emailCtrl.text.isEmpty ? "أوتاكو ذهبي" : emailCtrl.text.split('@')[0]);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم بنجاح!")));
                },
                child: Text(tab == 0 ? "دخول" : tab == 1 ? "إنشاء حساب" : "إرسال الرابط", style: const TextStyle(color: Colors.black)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrowserAgentScreen() {
    final cmdCtrl = TextEditingController();
    final List<String> logs = ["الوكيل: جاهز لتبييض الفقاعات وسحب فصول سوات ومانجاليك وتيم إكس."];

    return StatefulBuilder(
      builder: (ctx, setBState) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("المتصفح وأدوات المالك والوكيل الذكي 🤖", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(label: const Text("تبييض الفقاعات"), onPressed: () => setBState(() => logs.insert(0, "تم مسح النصوص بنجاح."))),
                ActionChip(label: const Text("ترجمة OCR"), onPressed: () => setBState(() => logs.insert(0, "تمت ترجمة الصفحة للعربية."))),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF11111E), borderRadius: BorderRadius.circular(12)),
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (ctx, i) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(logs[i], style: const TextStyle(color: Colors.white70))),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(child: TextField(controller: cmdCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "أمر الوكيل..."))),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.cyanAccent),
                  onPressed: () {
                    if (cmdCtrl.text.isNotEmpty) {
                      setBState(() => logs.insert(0, "الأمر: ${cmdCtrl.text} (جاري التنفيذ...)"));
                      cmdCtrl.clear();
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardScreen() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("لوحة الصدارة 👑", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
        SizedBox(height: 12),
        ListTile(tileColor: Color(0xFF131320), leading: Text("🥇"), title: Text("الفاوندر الأسطوري"), subtitle: Text("المشرف العام")),
        ListTile(tileColor: Color(0xFF131320), leading: Text("🥈"), title: Text("سياف الظلال"), subtitle: Text("داعم بـ 100,000 نقطة")),
      ],
    );
  }

  Widget _buildProfileScreen() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
