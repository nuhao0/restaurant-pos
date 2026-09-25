import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'widgets.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;
  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _user;
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        setState(() {
          _user = null;
          _userData = null;
          _loading = false;
        });
      } else {
        setState(() => _user = user);
        _fetchUserData(user);
      }
    });
  }

  Future<void> _fetchUserData(User user) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        // New owner registration
        final isMasterAdmin = user.email == 'mmhouse428@gmail.com';
        
        final data = {
          'email': user.email,
          'role': isMasterAdmin ? 'owner' : 'owner', // Still owner for any new registration currently, but we mark them safely
          'restaurantId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(data);
        setState(() {
          _userData = data;
          _loading = false;
        });
      } else {
        setState(() {
          _userData = doc.data();
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_user == null) {
      return const LoginScreen();
    }
    
    // Explicit override for mmhouse428@gmail.com
    if (_user!.email == 'mmhouse428@gmail.com' && _userData != null) {
      _userData!['role'] = 'owner';
    }

    if (!_user!.emailVerified) {
      return VerifyEmailScreen(user: _user!);
    }
    
    // Inject user data into the app using InheritedWidget or simply pass it if possible.
    // For minimal changes to main.dart, we'll store it globally or use an InheritedWidget.
    return UserProvider(
      user: _user!,
      userData: _userData ?? {},
      child: widget.child,
    );
  }
}

class UserProvider extends InheritedWidget {
  final User user;
  final Map<String, dynamic> userData;

  const UserProvider({
    Key? key,
    required this.user,
    required this.userData,
    required Widget child,
  }) : super(key: key, child: child);

  static UserProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }

  String get role => userData['role'] ?? 'employee';
  String get restaurantId => userData['restaurantId'] ?? '';
  bool get isOwner => role == 'owner' || user.email == 'mmhouse428@gmail.com';

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return user.uid != oldWidget.user.uid || userData != oldWidget.userData;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  String _error = '';

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Authentication failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_emailCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your email first.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailCtrl.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email sent!')));
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy, // beautiful navy background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "MM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      fontFamily: AppFonts.jakarta,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("MM House POS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: AppFonts.jakarta)),
                Text(_isLogin ? 'Login to continue' : 'Register Owner', style: const TextStyle(fontSize: 16, color: AppColors.textMuted, fontFamily: AppFonts.cairo)),
                const SizedBox(height: 32),
                if (_error.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(_error, style: const TextStyle(color: Colors.red, fontFamily: AppFonts.cairo)),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passCtrl,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                _loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.textDark,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(_isLogin ? 'Login' : 'Register', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? 'Create Owner Account' : 'Back to Login', style: const TextStyle(color: AppColors.navy)),
                    ),
                    if (_isLogin)
                      TextButton(
                        onPressed: _resetPassword,
                        child: const Text('Forgot Password?', style: TextStyle(color: AppColors.navy)),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyEmailScreen extends StatelessWidget {
  final User user;
  const VerifyEmailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email address to continue.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => user.sendEmailVerification(),
              child: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _addEmployee() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (email.isEmpty || pass.length < 6) return;

    setState(() => _loading = true);
    try {
      final userProvider = UserProvider.of(context)!;
      
      // Create user using a secondary Firebase app to avoid logging out the owner
      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
      
      UserCredential cred = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: pass);
          
      // Save role to firestore
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'role': 'employee',
        'restaurantId': userProvider.restaurantId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      await app.delete(); // cleanup
      
      _emailCtrl.clear();
      _passCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = UserProvider.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Manage Employees', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(width: 300, child: TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Employee Email', border: OutlineInputBorder()))),
              SizedBox(width: 300, child: TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()))),
              _loading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addEmployee,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20), backgroundColor: AppColors.navy),
                    child: const Text('Add Employee', style: TextStyle(color: Colors.white)),
                  )
            ],
          ),
          const SizedBox(height: 32),
          const Text('Current Employees:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
                  .where('restaurantId', isEqualTo: userProvider.restaurantId)
                  .where('role', isEqualTo: 'employee')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Text('No employees found.');
                
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(data['email'] ?? ''),
                      subtitle: Text('Role: ${data['role']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Optional: delete from firestore, though auth delete needs admin SDK.
                          FirebaseFirestore.instance.collection('users').doc(docs[index].id).delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
