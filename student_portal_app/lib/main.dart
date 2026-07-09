import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const StudentPortalApp());
}

class StudentPortalApp extends StatelessWidget {
  const StudentPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe31837)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff6f7fb),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const StartupScreen(),
    );
  }
}

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'student_portal.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return _database!;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        program TEXT NOT NULL,
        balance REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE subjects(
        subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL,
        name TEXT NOT NULL,
        semester INTEGER NOT NULL,
        credit INTEGER NOT NULL,
        day TEXT NOT NULL,
        time TEXT NOT NULL,
        venue TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE transactions(
        transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE applications(
        application_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        reason TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE clubs(
        club_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        phone TEXT NOT NULL,
        person_in_charge TEXT NOT NULL
      )
    ''');

    await db.insert('users', {
      'id': 'MILLER2026',
      'name': 'MILLER FOO',
      'password': '123456',
      'program': 'Bachelor of IT',
      'balance': 4500.0,
    });
    await db.insert('transactions', {
      'user_id': 'MILLER2026',
      'date': '2026-01-01',
      'description': 'Semester Fee',
      'amount': 4500.0,
      'type': 'Debit',
    });

    final subjects = [
      ['BIT1013', 'Intro to Programming', 1, 3, 'Monday', '09:00 AM', 'Lab A'],
      ['BIT2023', 'Web Development I', 2, 3, 'Tuesday', '11:00 AM', 'Room B2'],
      ['BIT2034', 'Database Systems', 2, 4, 'Wednesday', '02:00 PM', 'Lab C'],
      ['BIT3013', 'Advanced Database', 3, 3, 'Friday', '09:00 AM', 'Hall A'],
      ['ENG1022', 'Academic English', 2, 2, 'Thursday', '10:00 AM', 'Room D1'],
    ];
    for (final item in subjects) {
      await db.insert('subjects', {
        'code': item[0],
        'name': item[1],
        'semester': item[2],
        'credit': item[3],
        'day': item[4],
        'time': item[5],
        'venue': item[6],
      });
    }

    final clubs = [
      ['Robotics', 'Build and program autonomous robots.', '+6019-222 3333', 'Dr. Tan'],
      ['Debate', 'Practice critical thinking and public speaking.', '+6016-777 8888', 'Ms. Priya'],
      ['Badminton', 'Join weekly training and friendly matches.', '+6011-123 4567', 'Coach Lee'],
      ['Music', 'Jam sessions, acoustic nights, and concerts.', '+6018-987 6543', 'Mr. David'],
    ];
    for (final club in clubs) {
      await db.insert('clubs', {
        'name': club[0],
        'description': club[1],
        'phone': club[2],
        'person_in_charge': club[3],
      });
    }
  }

  Future<Map<String, Object?>?> login(String id, String password) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [id, password],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, Object?>?> getUser(String id) async {
    final db = await database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> registerUser(String id, String name, String password) async {
    final db = await database;
    await db.insert('users', {
      'id': id,
      'name': name,
      'password': password,
      'program': 'Bachelor of IT',
      'balance': 3000.0,
    });
    await db.insert('transactions', {
      'user_id': id,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'description': 'Opening Balance',
      'amount': 3000.0,
      'type': 'Debit',
    });
  }

  Future<List<Map<String, Object?>>> getSubjects() async {
    final db = await database;
    return db.query('subjects', orderBy: 'semester ASC, code ASC');
  }

  Future<List<Map<String, Object?>>> getTransactions(String userId) async {
    final db = await database;
    return db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'transaction_id DESC',
    );
  }

  Future<void> addPayment(String userId, double amount, String description) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('transactions', {
        'user_id': userId,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'description': description,
        'amount': amount,
        'type': 'Credit',
      });
      await txn.rawUpdate('UPDATE users SET balance = balance - ? WHERE id = ?', [amount, userId]);
    });
  }

  Future<void> updateTransaction(int id, String description, double amount) async {
    final db = await database;
    await db.update(
      'transactions',
      {'description': description, 'amount': amount},
      where: 'transaction_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'transaction_id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> getApplications(String userId) async {
    final db = await database;
    return db.query(
      'applications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'application_id DESC',
    );
  }

  Future<void> addApplication(String userId, String type, String reason) async {
    final db = await database;
    await db.insert('applications', {
      'user_id': userId,
      'type': type,
      'reason': reason,
      'status': 'Pending',
      'created_at': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });
  }

  Future<void> updateApplication(int id, String reason) async {
    final db = await database;
    await db.update('applications', {'reason': reason}, where: 'application_id = ?', whereArgs: [id]);
  }

  Future<void> deleteApplication(int id) async {
    final db = await database;
    await db.delete('applications', where: 'application_id = ?', whereArgs: [id]);
  }

  Future<void> updateProfile(String id, String name, String program) async {
    final db = await database;
    await db.update('users', {'name': name, 'program': program}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> getClubs() async {
    final db = await database;
    return db.query('clubs', orderBy: 'name ASC');
  }
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await DatabaseHelper.instance.database;
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('currentUserId');
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => id == null ? const LoginScreen() : MainShell(userId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController(text: 'MILLER2026');
  final _password = TextEditingController(text: '123456');
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final user = await DatabaseHelper.instance.login(_id.text.trim().toUpperCase(), _password.text);
    setState(() => _loading = false);
    if (!mounted) return;
    if (user == null) {
      _showMessage(context, 'Login failed. Check your student ID and password.');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUserId', user['id'] as String);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainShell(userId: user['id'] as String)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.school, size: 80, color: Color(0xffe31837)),
            const SizedBox(height: 20),
            Text('Student Portal', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Login to manage your campus life.', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _id,
                    decoration: const InputDecoration(labelText: 'Student ID', prefixIcon: Icon(Icons.badge_outlined)),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Student ID is required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                    validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _loading ? null : _login,
                    child: Text(_loading ? 'Loading...' : 'Login'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Create new account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final id = _id.text.trim().toUpperCase();
    final existing = await DatabaseHelper.instance.getUser(id);
    if (!mounted) return;
    if (existing != null) {
      _showMessage(context, 'Registration failed. Student ID already exists.');
      return;
    }
    await DatabaseHelper.instance.registerUser(id, _name.text.trim().toUpperCase(), _password.text);
    if (!mounted) return;
    _showMessage(context, 'Registration successful. You can login now.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(controller: _id, decoration: const InputDecoration(labelText: 'Student ID'), validator: _required),
            const SizedBox(height: 14),
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name'), validator: _required),
            const SizedBox(height: 14),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _register, child: const Text('Create Account')),
          ],
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.userId});

  final String userId;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(userId: widget.userId, onOpenTab: (index) => setState(() => _index = index)),
      const AcademicScreen(),
      FinanceScreen(userId: widget.userId),
      ApplicationScreen(userId: widget.userId),
      ProfileScreen(userId: widget.userId),
      const ClubScreen(),
    ];
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Academic'),
          NavigationDestination(icon: Icon(Icons.payments_outlined), selectedIcon: Icon(Icons.payments), label: 'Finance'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Apply'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Clubs'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.userId, required this.onOpenTab});

  final String userId;
  final ValueChanged<int> onOpenTab;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, Object?>? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _user = await DatabaseHelper.instance.getUser(widget.userId);
    if (mounted) setState(() {});
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?['name']?.toString() ?? 'Student';
    final balance = (_user?['balance'] as num?)?.toDouble() ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text('Welcome, $name', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            InfoCard(title: 'Outstanding Balance', value: 'RM ${balance.toStringAsFixed(2)}', icon: Icons.account_balance_wallet, color: Colors.red),
            InfoCard(title: 'Next Class', value: 'Database Systems, Wed 2:00 PM', icon: Icons.event, color: Colors.blue),
            InfoCard(title: 'Attendance Average', value: '92%', icon: Icons.check_circle, color: Colors.green),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ActionChip(label: const Text('Academic'), avatar: const Icon(Icons.menu_book), onPressed: () => widget.onOpenTab(1)),
                ActionChip(label: const Text('Pay Fees'), avatar: const Icon(Icons.payments), onPressed: () => widget.onOpenTab(2)),
                ActionChip(label: const Text('Apply Zakat'), avatar: const Icon(Icons.assignment), onPressed: () => widget.onOpenTab(3)),
                ActionChip(label: const Text('Profile'), avatar: const Icon(Icons.person), onPressed: () => widget.onOpenTab(4)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  late Future<List<Map<String, Object?>>> _subjects;

  @override
  void initState() {
    super.initState();
    _subjects = DatabaseHelper.instance.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Academic')),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _subjects,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const SectionTitle('Subject Structure & Class Schedule'),
              ...rows.map((subject) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(subject['semester'].toString())),
                      title: Text('${subject['code']} - ${subject['name']}'),
                      subtitle: Text('${subject['day']} | ${subject['time']} | ${subject['venue']}'),
                      trailing: Text('${subject['credit']} cr'),
                    ),
                  )),
              const SizedBox(height: 20),
              const SectionTitle('Attendance'),
              const InfoCard(title: 'Current Attendance', value: '92% - Eligible for final exam', icon: Icons.fact_check, color: Colors.green),
              const SectionTitle('Learning Materials'),
              const ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Database Systems - Chapter 1.pdf')),
              const ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Web Development - Lecture Slides.pdf')),
            ],
          );
        },
      ),
    );
  }
}

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key, required this.userId});

  final String userId;

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  Map<String, Object?>? _user;
  List<Map<String, Object?>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _user = await DatabaseHelper.instance.getUser(widget.userId);
    _transactions = await DatabaseHelper.instance.getTransactions(widget.userId);
    if (mounted) setState(() {});
  }

  Future<void> _showPaymentDialog() async {
    final amount = TextEditingController();
    final desc = TextEditingController(text: 'Online Payment');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
            const SizedBox(height: 12),
            TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(amount.text);
              if (value == null || value <= 0 || desc.text.trim().isEmpty) {
                _showMessage(context, 'Enter a valid amount and description.');
                return;
              }
              await DatabaseHelper.instance.addPayment(widget.userId, value, desc.text.trim());
              if (context.mounted) Navigator.pop(context);
              await _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editTransaction(Map<String, Object?> row) async {
    final desc = TextEditingController(text: row['description'].toString());
    final amount = TextEditingController(text: (row['amount'] as num).toStringAsFixed(2));
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(amount.text);
              if (value == null || value <= 0 || desc.text.trim().isEmpty) {
                _showMessage(context, 'Enter valid transaction details.');
                return;
              }
              await DatabaseHelper.instance.updateTransaction(row['transaction_id'] as int, desc.text.trim(), value);
              if (context.mounted) Navigator.pop(context);
              await _load();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final balance = (_user?['balance'] as num?)?.toDouble() ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Finance')),
      floatingActionButton: FloatingActionButton.extended(onPressed: _showPaymentDialog, icon: const Icon(Icons.add), label: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          InfoCard(title: 'Outstanding Balance', value: 'RM ${balance.toStringAsFixed(2)}', icon: Icons.payments, color: Colors.red),
          const SectionTitle('Transaction Ledger'),
          ..._transactions.map((row) => Card(
                child: ListTile(
                  title: Text(row['description'].toString()),
                  subtitle: Text('${row['date']} | ${row['type']}'),
                  trailing: Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('RM ${(row['amount'] as num).toStringAsFixed(2)}'),
                      IconButton(onPressed: () => _editTransaction(row), icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () => _deleteTransaction(row['transaction_id'] as int), icon: const Icon(Icons.delete_outline)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  List<Map<String, Object?>> _applications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _applications = await DatabaseHelper.instance.getApplications(widget.userId);
    if (mounted) setState(() {});
  }

  Future<void> _showApplicationDialog([Map<String, Object?>? row]) async {
    final type = TextEditingController(text: row?['type']?.toString() ?? 'Zakat');
    final reason = TextEditingController(text: row?['reason']?.toString() ?? '');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(row == null ? 'Submit Application' : 'Update Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: type, decoration: const InputDecoration(labelText: 'Type')),
            const SizedBox(height: 12),
            TextField(controller: reason, minLines: 3, maxLines: 4, decoration: const InputDecoration(labelText: 'Reason')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (type.text.trim().isEmpty || reason.text.trim().isEmpty) {
                _showMessage(context, 'Type and reason are required.');
                return;
              }
              if (row == null) {
                await DatabaseHelper.instance.addApplication(widget.userId, type.text.trim(), reason.text.trim());
              } else {
                await DatabaseHelper.instance.updateApplication(row['application_id'] as int, reason.text.trim());
              }
              if (context.mounted) Navigator.pop(context);
              await _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Applications')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showApplicationDialog(), icon: const Icon(Icons.add), label: const Text('Apply')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Submit Zakat, financial assistance, or student support applications.'),
          const SizedBox(height: 16),
          ..._applications.map((row) => Card(
                child: ListTile(
                  title: Text(row['type'].toString()),
                  subtitle: Text('${row['reason']}\n${row['created_at']} | ${row['status']}'),
                  isThreeLine: true,
                  trailing: Wrap(
                    children: [
                      IconButton(onPressed: () => _showApplicationDialog(row), icon: const Icon(Icons.edit)),
                      IconButton(
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteApplication(row['application_id'] as int);
                          await _load();
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _program = TextEditingController();
  Map<String, Object?>? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _user = await DatabaseHelper.instance.getUser(widget.userId);
    _name.text = _user?['name']?.toString() ?? '';
    _program.text = _user?['program']?.toString() ?? '';
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _program.text.trim().isEmpty) {
      _showMessage(context, 'Name and program are required.');
      return;
    }
    await DatabaseHelper.instance.updateProfile(widget.userId, _name.text.trim(), _program.text.trim());
    await _load();
    if (!mounted) return;
    _showMessage(context, 'Profile updated.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 48)),
          const SizedBox(height: 16),
          Center(child: Text(widget.userId, style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: 20),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name')),
          const SizedBox(height: 14),
          TextField(controller: _program, decoration: const InputDecoration(labelText: 'Program')),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: const Text('Update Profile')),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Digital Student Card', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Name: ${_user?['name'] ?? '-'}'),
                  Text('ID: ${_user?['id'] ?? '-'}'),
                  Text('Program: ${_user?['program'] ?? '-'}'),
                  const Text('Valid Thru: DEC 2029'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  late Future<List<Map<String, Object?>>> _clubs;

  @override
  void initState() {
    super.initState();
    _clubs = DatabaseHelper.instance.getClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clubs')),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _clubs,
        builder: (context, snapshot) {
          final clubs = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(18),
            children: clubs
                .map((club) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.groups),
                        title: Text(club['name'].toString()),
                        subtitle: Text('${club['description']}\nPIC: ${club['person_in_charge']} | ${club['phone']}'),
                        isThreeLine: true,
                        trailing: FilledButton.tonal(onPressed: () => _showMessage(context, 'Interest registered.'), child: const Text('Join')),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.14), child: Icon(icon, color: color)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

String? _required(String? value) {
  return value == null || value.trim().isEmpty ? 'This field is required' : null;
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
