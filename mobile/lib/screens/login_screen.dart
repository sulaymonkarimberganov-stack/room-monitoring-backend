import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (_usernameCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      _showError('Username va parolni kiriting');
      return;
    }
    setState(() => _loading = true);
    final error = await context
        .read<AuthProvider>()
        .login(_usernameCtrl.text.trim(), _passwordCtrl.text);
    setState(() => _loading = false);
    if (error != null && mounted) _showError(error);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.hotel,
                      size: 60, color: Color(0xFF1565C0)),
                ),
                const SizedBox(height: 20),
                const Text('Room Monitoring',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const Text('Xonalar nazorat tizimi',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 36),

                // Card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Parol',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          onSubmitted: (_) => _login(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Kirish',
                                    style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
