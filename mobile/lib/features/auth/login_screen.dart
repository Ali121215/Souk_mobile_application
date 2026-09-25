import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'auth_providers.dart';
import 'data/app_user.dart';

enum _LoginMode { telephone, email }
enum _LoginStep { identifiant, code }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '+235');
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  _LoginMode _mode = _LoginMode.telephone;
  _LoginStep _step = _LoginStep.identifiant;
  bool _loading = false;
  String? _error;

  String get _identifiant => _mode == _LoginMode.telephone ? _phoneController.text.trim() : _emailController.text.trim();

  Future<void> _submitIdentifiant() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      if (_mode == _LoginMode.telephone) {
        await repo.requestOtp(_identifiant);
      } else {
        await repo.requestOtpEmail(_identifiant);
      }
      setState(() => _step = _LoginStep.code);
    } catch (e) {
      setState(() => _error = "Impossible d'envoyer le code. Vérifiez l'information saisie et votre connexion.");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submitCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = _mode == _LoginMode.telephone
          ? await repo.verifyOtp(_identifiant, _codeController.text.trim())
          : await repo.verifyOtpEmail(_identifiant, _codeController.text.trim());
      await ref.read(authTokenProvider.notifier).setToken(result.token);
      ref.read(currentUserProvider.notifier).state = result.user;
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = 'Code incorrect ou expiré. Réessayez.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_step == _LoginStep.identifiant) ...[
              SegmentedButton<_LoginMode>(
                segments: const [
                  ButtonSegment(value: _LoginMode.telephone, label: Text('Téléphone'), icon: Icon(Icons.sms_outlined)),
                  ButtonSegment(value: _LoginMode.email, label: Text('Email'), icon: Icon(Icons.email_outlined)),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) => setState(() {
                  _mode = selection.first;
                  _error = null;
                }),
              ),
              const SizedBox(height: 16),
              Text(
                _mode == _LoginMode.telephone
                    ? 'Entrez votre numéro. Un code vous sera envoyé par SMS.'
                    : "Le SMS ne passe pas ? Entrez votre email, un code vous sera envoyé à la place.",
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              if (_mode == _LoginMode.telephone)
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                )
              else
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submitIdentifiant,
                child: _loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Recevoir le code'),
              ),
            ] else ...[
              Text(
                'Entrez le code reçu à $_identifiant.',
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(labelText: 'Code à 4 chiffres', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loading ? null : _submitCode,
                child: _loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Valider'),
              ),
              TextButton(
                onPressed: () => setState(() => _step = _LoginStep.identifiant),
                child: const Text('Changer'),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.clay)),
            ],
          ],
        ),
      ),
    );
  }
}