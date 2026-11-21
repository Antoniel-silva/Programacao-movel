import 'package:flutter/material.dart';

import '../../../controllers/create_meeting_point_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/petto_primary_button.dart';
import '../../components/petto_text_field.dart';

/// Argumentos recebidos pela tela de cadastro de ponto de encontro.
class CreateMeetingPointArgs {
  const CreateMeetingPointArgs({
    required this.latitude,
    required this.longitude,
  });

  /// Latitude do local sugerido (posição do usuário ou centro do mapa).
  final double latitude;

  /// Longitude do local sugerido (posição do usuário ou centro do mapa).
  final double longitude;
}

/// Tela de cadastro de um novo ponto de encontro.
class CreateMeetingPointScreen extends StatefulWidget {
  const CreateMeetingPointScreen({super.key});

  @override
  State<CreateMeetingPointScreen> createState() =>
      _CreateMeetingPointScreenState();
}

class _CreateMeetingPointScreenState extends State<CreateMeetingPointScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateMeetingPointController _controller =
      CreateMeetingPointController();

  CreateMeetingPointArgs? _args;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _args =
        ModalRoute.of(context)?.settings.arguments as CreateMeetingPointArgs?;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final args = _args;
    if (args == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    try {
      final point = await _controller.save(
        latitude: args.latitude,
        longitude: args.longitude,
      );
      if (!mounted) return;
      Navigator.pop(context, point);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o ponto de encontro.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = _args;

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Ponto de Encontro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Localização',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                args == null
                    ? 'Posição não informada'
                    : '${args.latitude.toStringAsFixed(5)}, '
                          '${args.longitude.toStringAsFixed(5)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              PettoTextField(
                label: 'Nome',
                hint: 'Ex.: Praça do Bairro',
                controller: _controller.nameController,
                validator: _controller.validateName,
                prefixIcon: Icons.place,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              PettoTextField(
                label: 'Descrição',
                hint: 'Conte como é o local e o que combina com os pets',
                controller: _controller.descriptionController,
                validator: _controller.validateDescription,
                prefixIcon: Icons.notes,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 16),
              PettoTextField(
                label: 'Endereço (opcional)',
                hint: 'Ex.: Rua das Flores, 123 - Centro',
                controller: _controller.addressController,
                prefixIcon: Icons.home,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              PettoPrimaryButton(
                label: 'Salvar ponto de encontro',
                icon: Icons.check,
                isLoading: _isSaving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
