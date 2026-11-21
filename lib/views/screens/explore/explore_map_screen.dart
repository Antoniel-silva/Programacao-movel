import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controllers/explore_map_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/marker_helper.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../../core/helpers/place_icon_helper.dart';
import '../../../core/helpers/location_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/meeting_point.dart';
import '../../../models/pet_place.dart';
import '../../../routes/app_routes.dart';
import '../../components/petto_bottom_nav_bar.dart';
import '../../components/petto_search_field.dart';
import 'create_meeting_point_screen.dart';

/// Tela de exploração com mapa, locais pet friendly e pontos de encontro.
class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  final ExploreMapController _controller = ExploreMapController();
  final TextEditingController _searchController = TextEditingController();

  GoogleMapController? _mapController;
  Set<Marker> _markers = <Marker>{};

  /// Ícones de rótulo já gerados (cache por local).
  final Map<String, BitmapDescriptor> _labelIcons =
      <String, BitmapDescriptor>{};
  final Set<String> _generatingIcons = <String>{};

  PetPlace? _selectedPlace;
  int _lastSearchVersion = 0;
  bool _movedToUser = false;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: AppConstants.mapInitialZoom,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;

    final newSearch = _controller.searchVersion != _lastSearchVersion;
    if (newSearch) {
      _lastSearchVersion = _controller.searchVersion;
      // Seleciona automaticamente o primeiro resultado da nova busca.
      _selectedPlace = _controller.places.isNotEmpty
          ? _controller.places.first
          : null;
    }

    setState(_rebuildMarkers);

    if (newSearch) _moveAfterSearch();
  }

  /// Centraliza o mapa nos resultados ou na posição do usuário.
  void _moveAfterSearch() {
    if (_controller.query.trim().isNotEmpty && _controller.places.isNotEmpty) {
      _moveTo(_controller.places.first, AppConstants.mapPlaceZoom);
    } else if (!_movedToUser && _controller.userPosition != null) {
      _movedToUser = true;
      final position = _controller.userPosition!;
      _moveToPosition(
        position.latitude,
        position.longitude,
        AppConstants.mapInitialZoom + 3,
      );
    }
  }

  void _moveTo(PetPlace place, double zoom) =>
      _moveToPosition(place.latitude, place.longitude, zoom);

  void _moveToPosition(double latitude, double longitude, double zoom) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), zoom),
    );
  }

  /// Centraliza o mapa na posição do usuário (botão de localização).
  void _recenter() {
    final position = _controller.userPosition;
    if (position != null) {
      _moveToPosition(
        position.latitude,
        position.longitude,
        AppConstants.mapInitialZoom + 3,
      );
    } else {
      _moveToPosition(
        AppConstants.defaultLatitude,
        AppConstants.defaultLongitude,
        AppConstants.mapInitialZoom,
      );
    }
  }

  /// Monta os marcadores de locais e de pontos de encontro.
  void _rebuildMarkers() {
    _markers = <Marker>{
      for (final place in _controller.places)
        Marker(
          markerId: MarkerId('place_${place.id}'),
          position: LatLng(place.latitude, place.longitude),
          icon: _iconForPlace(place) ?? BitmapDescriptor.defaultMarker,
          zIndexInt: 1,
          onTap: () => setState(() => _selectedPlace = place),
        ),
      for (final point in _controller.meetingPoints)
        Marker(
          markerId: MarkerId('meeting_${point.id}'),
          position: LatLng(point.latitude, point.longitude),
          icon:
              _iconForMeetingPoint(point) ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          zIndexInt: 2,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.meetingPointDetails,
            arguments: point,
          ),
        ),
    };
  }

  /// Retorna o rótulo do local, iniciando a geração quando necessário.
  BitmapDescriptor? _iconForPlace(PetPlace place) {
    final key = 'place_${place.id}';
    final cached = _labelIcons[key];
    if (cached != null) return cached;

    _generateLabelIcon(
      key: key,
      label: place.name,
      badgeIcon: PlaceIconHelper.of(place.category),
      badgeColor: AppColors.primary,
    );
    return null;
  }

  /// Retorna o rótulo do ponto de encontro, iniciando a geração se preciso.
  BitmapDescriptor? _iconForMeetingPoint(MeetingPoint point) {
    final key = 'meeting_${point.id}';
    final cached = _labelIcons[key];
    if (cached != null) return cached;

    _generateLabelIcon(
      key: key,
      label: point.name,
      badgeIcon: Icons.flag,
      badgeColor: AppColors.secondary,
    );
    return null;
  }

  Future<void> _generateLabelIcon({
    required String key,
    required String label,
    required IconData badgeIcon,
    required Color badgeColor,
  }) async {
    if (!_generatingIcons.add(key)) return;

    final icon = await MarkerHelper.labelMarker(
      label: label,
      badgeIcon: badgeIcon,
      badgeColor: badgeColor,
      backgroundColor: AppColors.surface,
      borderColor: AppColors.primaryLight,
      textColor: AppColors.primaryDark,
    );

    _generatingIcons.remove(key);
    _labelIcons[key] = icon;

    if (mounted) setState(_rebuildMarkers);
  }

  Future<void> _goCreateMeetingPoint() async {
    final latitude =
        _controller.userPosition?.latitude ?? AppConstants.defaultLatitude;
    final longitude =
        _controller.userPosition?.longitude ?? AppConstants.defaultLongitude;

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.createMeetingPoint,
      arguments: CreateMeetingPointArgs(
        latitude: latitude,
        longitude: longitude,
      ),
    );

    if (result is MeetingPoint && mounted) {
      await _controller.loadMeetingPoints();
      if (!mounted) return;
      setState(_rebuildMarkers);
      _moveToPosition(
        result.latitude,
        result.longitude,
        AppConstants.mapPlaceZoom,
      );
    }
  }

  void _handleLocationAction() {
    if (_controller.locationStatus == LocationStatus.denied) {
      _controller.retryLocation();
    } else if (_controller.locationServiceDisabled) {
      _controller.openLocationSettings();
    } else {
      _controller.openAppSettings();
    }
  }

  void _onNavTap(int index) {
    NavigationHelper.goToMainTab(context, index, 1);
  }

  String _radiusLabel(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km == km.roundToDouble() ? km.toInt() : km} km';
    }
    return '${meters.toInt()} m';
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  'Raio de busca',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              for (final radius in AppConstants.searchRadiusOptions)
                ListTile(
                  leading: Icon(
                    _controller.filter.radiusMeters == radius
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppColors.primary,
                  ),
                  title: Text(_radiusLabel(radius)),
                  onTap: () {
                    _controller.setRadius(radius);
                    Navigator.pop(sheetContext);
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.filter_alt_off,
                  color: AppColors.textSecondary,
                ),
                title: const Text('Limpar filtros'),
                onTap: () {
                  _controller.clearFilters();
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            if (_controller.locationDenied ||
                _controller.locationServiceDisabled)
              _locationBanner(),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: _initialCamera,
                      onMapCreated: (controller) => _mapController = controller,
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      onTap: (_) => setState(() => _selectedPlace = null),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: _filterChips(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_mapActions(), _sheet()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PettoBottomNavBar(currentIndex: 1, onTap: _onNavTap),
    );
  }

  /// Cabeçalho: título, localização e busca com botão de filtro.
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A turma está por perto.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _controller.locationLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PettoSearchField(
                  hint: 'Parques, praças e amigos',
                  controller: _searchController,
                  borderRadius: 16,
                  onChanged: _controller.setQuery,
                  onSubmitted: (_) => _controller.submitQuery(),
                ),
              ),
              const SizedBox(width: 10),
              _filterButton(),
            ],
          ),
        ],
      ),
    );
  }

  /// Botão quadrado de filtros ao lado da busca.
  Widget _filterButton() {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _showFilterSheet,
        child: const SizedBox(
          width: 54,
          height: 54,
          child: Icon(Icons.tune, color: AppColors.white),
        ),
      ),
    );
  }

  /// Banner exibido quando a localização está indisponível.
  Widget _locationBanner() {
    final denied = _controller.locationDenied;
    final serviceDisabled = _controller.locationServiceDisabled;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, size: 20, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              serviceDisabled
                  ? 'Ative os serviços de localização para ver locais próximos.'
                  : 'Permita o acesso à localização para ver locais próximos.',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: _handleLocationAction,
            child: Text(
              denied ? 'Permitir' : 'Abrir',
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Chips de filtro sobrepostos ao topo do mapa.
  Widget _filterChips() {
    final category = _controller.filter.category;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (category != null)
          _mapChip(
            label: category.label,
            onRemove: () => _controller.setCategory(null),
          ),
        _mapChip(
          label: 'Até ${_radiusLabel(_controller.filter.radiusMeters)}',
          onTap: _showFilterSheet,
        ),
      ],
    );
  }

  Widget _mapChip({
    required String label,
    VoidCallback? onTap,
    VoidCallback? onRemove,
  }) {
    return GestureDetector(
      onTap: onTap ?? onRemove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 6),
              const Icon(Icons.close, size: 16, color: AppColors.primaryDark),
            ],
          ],
        ),
      ),
    );
  }

  /// Botões flutuantes à direita, acima da folha inferior.
  Widget _mapActions() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _mapButton(
            icon: Icons.add_location_alt,
            tooltip: 'Cadastrar ponto de encontro',
            onTap: _goCreateMeetingPoint,
            primary: true,
          ),
          const SizedBox(width: 10),
          _mapButton(
            icon: Icons.my_location,
            tooltip: 'Minha localização',
            onTap: _recenter,
            primary: false,
          ),
        ],
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required bool primary,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: primary ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              icon,
              size: 24,
              color: primary ? AppColors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  /// Folha inferior com o local selecionado ou o status da busca.
  Widget _sheet() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 340),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ..._sheetContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Conteúdo exibido na folha inferior.
  List<Widget> _sheetContent() {
    if (_controller.isLoading) {
      return <Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Buscando locais próximos...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ];
    }

    if (_controller.errorMessage != null) {
      return <Widget>[
        const Text(
          'Não foi possível buscar locais',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _controller.errorMessage!,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _controller.search,
          child: const Text(
            'Tentar novamente',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ];
    }

    final place = _selectedPlace;
    if (place == null) {
      final noResults = _controller.places.isEmpty;
      return <Widget>[
        Text(
          noResults ? 'Nenhum local encontrado' : 'Toque em um marcador',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          noResults
              ? 'Tente outra categoria ou amplie o raio de busca.'
              : 'Veja os detalhes e o check-in dos locais pet friendly.',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
      ];
    }

    return _placeContent(place);
  }

  /// Conteúdo da folha para o local selecionado.
  List<Widget> _placeContent(PetPlace place) {
    final distance = _controller.distanceLabel(place.latitude, place.longitude);
    final subtitle = <String>[
      ?distance,
      if (place.rating != null) '★ ${place.rating!.toStringAsFixed(1)}',
    ];

    return <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          place.category.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        place.name,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.15,
        ),
      ),
      if (subtitle.isNotEmpty) ...[
        const SizedBox(height: 6),
        Text(
          subtitle.join(' · '),
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
      const SizedBox(height: 10),
      const Text(
        'Seu pet vai adorar conhecer essa turma.',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 16),
      _detailsButton(place),
    ];
  }

  /// Botão principal da folha: abre os detalhes do local.
  Widget _detailsButton(PetPlace place) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.meetingPointDetails,
          arguments: place,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ver detalhes do local',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 18, color: AppColors.primaryDark),
            ],
          ),
        ),
      ),
    );
  }
}
