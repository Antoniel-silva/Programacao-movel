import 'package:flutter/material.dart';

import '../../../controllers/meeting_point_details_controller.dart';
import '../../../core/helpers/place_icon_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/meeting_point.dart';
import '../../../models/pet_place.dart';
import '../../components/empty_state.dart';

/// Tela de detalhes de um local pet friendly ou ponto de encontro.
class MeetingPointDetailsScreen extends StatefulWidget {
  const MeetingPointDetailsScreen({super.key});

  @override
  State<MeetingPointDetailsScreen> createState() =>
      _MeetingPointDetailsScreenState();
}

class _MeetingPointDetailsScreenState extends State<MeetingPointDetailsScreen> {
  final MeetingPointDetailsController _controller =
      MeetingPointDetailsController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is PetPlace) {
      _controller.loadPlace(arguments);
    } else if (arguments is MeetingPoint) {
      _controller.showMeetingPoint(arguments);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final place = _controller.place;
        final meetingPoint = _controller.meetingPoint;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              meetingPoint != null ? 'Ponto de Encontro' : 'Detalhes do Local',
            ),
          ),
          body: place != null
              ? _buildPlaceDetails(place)
              : meetingPoint != null
              ? _buildMeetingPointDetails(meetingPoint)
              : const Center(
                  child: EmptyState(
                    title: 'Local não encontrado',
                    message: 'Não foi possível carregar os dados deste local.',
                    icon: Icons.location_off,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildPlaceDetails(PetPlace place) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_controller.isLoading) ...[
            const LinearProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
            ),
            const SizedBox(height: 16),
          ],
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PlaceIconHelper.of(place.category),
                size: 40,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              place.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                place.category.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (place.rating != null)
            _infoRow(
              icon: Icons.star,
              color: AppColors.secondary,
              text:
                  '${place.rating!.toStringAsFixed(1)} de 5'
                  '${place.reviewCount != null ? ' · ${place.reviewCount} avaliações' : ''}',
            ),
          _infoRow(icon: Icons.place, text: place.address),
          if (place.phoneNumber != null)
            _infoRow(icon: Icons.phone, text: place.phoneNumber!),
          if (place.website != null)
            _infoRow(icon: Icons.language, text: place.website!),
          if (place.openingHours.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Horário de funcionamento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            for (final line in place.openingHours)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
          if (_controller.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _controller.errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMeetingPointDetails(MeetingPoint meetingPoint) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flag,
                size: 40,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              meetingPoint.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _infoRow(icon: Icons.place, text: meetingPoint.address),
          const SizedBox(height: 16),
          const Text(
            'Sobre o ponto de encontro',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meetingPoint.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Cadastrado em ${_formatDate(meetingPoint.createdAt)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    Color color = AppColors.primary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
