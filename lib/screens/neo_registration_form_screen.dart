import 'package:flutter/material.dart';
import '../models/user_registration.dart';
import '../theme/neo_brutalist_pastel_theme.dart';

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  // Form Key for field validations
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State Variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  String? _termsError;

  String _selectedRole = 'Software Engineer';
  String _selectedMembershipTier = 'Pro Builder';
  Color _selectedPastelColor = NeoTheme.pastelMint;

  final List<String> _roles = [
    'Software Engineer',
    'UI/UX Designer',
    'Product Lead',
    'Data Scientist',
    'Mobile Developer',
  ];

  final List<String> _membershipTiers = [
    'Standard Access',
    'Pro Builder',
    'Enterprise VIP',
  ];

  final List<Map<String, dynamic>> _pastelOptions = [
    {'name': 'Mint', 'color': NeoTheme.pastelMint},
    {'name': 'Lilac', 'color': NeoTheme.pastelLilac},
    {'name': 'Peach', 'color': NeoTheme.pastelPeach},
    {'name': 'Butter', 'color': NeoTheme.pastelButter},
    {'name': 'Sky', 'color': NeoTheme.pastelSky},
    {'name': 'Rose', 'color': NeoTheme.pastelRose},
  ];

  // Submission handler with full validation
  void _submitForm() {
    setState(() {
      _termsError = _agreedToTerms ? null : 'You must accept the community terms & code of conduct.';
    });

    if (_formKey.currentState!.validate() && _agreedToTerms) {
      // Create registered user data model
      final newUser = UserRegistration(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        role: _selectedRole,
        membershipTier: _selectedMembershipTier,
        pastelAccent: _selectedPastelColor,
      );

      // Named Route Navigation passing UserRegistration model as argument: '/form' -> '/detail'
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: newUser,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.background,
      appBar: AppBar(
        title: const Text('MEMBER REGISTRATION 📝'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: NeoTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Introduction Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: NeoTheme.neoBox(
                  color: NeoTheme.pastelButter,
                  radius: 16,
                  borderWidth: 2.2,
                  shadowOffset: 3.5,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 24, color: NeoTheme.black),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'All fields are strictly validated with null-safety and client-side regex checks.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: NeoTheme.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 1. FULL NAME FIELD (Required, >= 3 chars)
              // ==========================================
              _buildFieldLabel('FULL NAME', isRequired: true),
              const SizedBox(height: 6),
              _buildNeoTextField(
                controller: _nameController,
                hintText: 'e.g. Satoshi Nakamoto',
                icon: Icons.person_outline_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  if (val.trim().length < 3) {
                    return 'Full name must be at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==========================================
              // 2. EMAIL ADDRESS FIELD (Required, regex)
              // ==========================================
              _buildFieldLabel('EMAIL ADDRESS', isRequired: true),
              const SizedBox(height: 6),
              _buildNeoTextField(
                controller: _emailController,
                hintText: 'e.g. satoshi@bitcoin.org',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Email address is required';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Enter a valid email address (e.g. name@domain.com)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==========================================
              // 3. PASSWORD FIELD (Required, >= 8 chars)
              // ==========================================
              _buildFieldLabel('PASSWORD', isRequired: true),
              const SizedBox(height: 6),
              _buildNeoTextField(
                controller: _passwordController,
                hintText: 'Minimum 8 characters',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: NeoTheme.black,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password is required';
                  }
                  if (val.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==========================================
              // 4. CONFIRM PASSWORD (Must match password)
              // ==========================================
              _buildFieldLabel('CONFIRM PASSWORD', isRequired: true),
              const SizedBox(height: 6),
              _buildNeoTextField(
                controller: _confirmPasswordController,
                hintText: 'Re-enter your password',
                icon: Icons.lock_reset_rounded,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: NeoTheme.black,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (val != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // ==========================================
              // 5. ROLE SELECTION
              // ==========================================
              _buildFieldLabel('COMMUNITY ROLE', isRequired: true),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _roles.map((role) {
                  final isSelected = _selectedRole == role;
                  return InkWell(
                    onTap: () => setState(() => _selectedRole = role),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? NeoTheme.pastelMint : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: NeoTheme.black, width: 2),
                        boxShadow: isSelected ? NeoTheme.hardShadow(x: 2.5, y: 2.5) : null,
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                          color: NeoTheme.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // 6. MEMBERSHIP TIER DROPDOWN
              // ==========================================
              _buildFieldLabel('MEMBERSHIP TIER', isRequired: true),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: NeoTheme.neoBox(
                  color: Colors.white,
                  radius: 12,
                  borderWidth: 2,
                  shadowOffset: 3,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMembershipTier,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NeoTheme.black),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: NeoTheme.black,
                    ),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMembershipTier = val);
                    },
                    items: _membershipTiers.map((tier) {
                      return DropdownMenuItem(value: tier, child: Text(tier));
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // 7. BADGE PASTEL COLOR PALETTE
              // ==========================================
              _buildFieldLabel('ID BADGE PASTEL THEME', isRequired: false),
              const SizedBox(height: 8),
              Row(
                children: _pastelOptions.map((opt) {
                  final color = opt['color'] as Color;
                  final isSelected = _selectedPastelColor == color;
                  return Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedPastelColor = color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: NeoTheme.black,
                            width: isSelected ? 3 : 1.8,
                          ),
                          boxShadow: isSelected ? NeoTheme.hardShadow(x: 2, y: 2) : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded, size: 18, color: NeoTheme.black)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 8. TERMS & CONDITIONS CHECKBOX
              // ==========================================
              InkWell(
                onTap: () => setState(() {
                  _agreedToTerms = !_agreedToTerms;
                  if (_agreedToTerms) _termsError = null;
                }),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _agreedToTerms ? NeoTheme.pastelLime.withValues(alpha: 0.3) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _termsError != null ? Colors.red : NeoTheme.black,
                      width: 1.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _agreedToTerms ? NeoTheme.black : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: NeoTheme.black, width: 2),
                        ),
                        child: _agreedToTerms
                            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'I agree to the Community Code of Conduct & verified identity terms.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: NeoTheme.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_termsError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 6),
                  child: Text(
                    _termsError!,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.red),
                  ),
                ),

              const SizedBox(height: 26),

              // ==========================================
              // 9. NEO-BRUTALIST SUBMIT BUTTON
              // ==========================================
              InkWell(
                onTap: _submitForm,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: NeoTheme.neoBox(
                    color: NeoTheme.pastelMint,
                    radius: 16,
                    borderWidth: 2.5,
                    shadowOffset: 4.0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.badge_rounded, size: 22, color: NeoTheme.black),
                      SizedBox(width: 8),
                      Text(
                        'Generate Official ID Pass ➔',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w900,
                          color: NeoTheme.black,
                          letterSpacing: 0.4,
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
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: NeoTheme.black,
            letterSpacing: 0.5,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
          ),
      ],
    );
  }

  Widget _buildNeoTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: NeoTheme.neoBox(
        color: Colors.white,
        radius: 14,
        borderWidth: 2.0,
        shadowOffset: 3.0,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: NeoTheme.black,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: NeoTheme.black, size: 20),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF888888),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: InputBorder.none,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
