import 'package:get/get.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/agent_services.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/agent/models/agent_model.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';

enum FavoriteType { property, agent, developer }

class FavoriteController extends GetxController {
  final Logger log = Logger();
  final PropertyServices propertyServices = Get.find<PropertyServices>();
  final AgentServices agentServices = Get.find<AgentServices>();

  final RxList<AgentModel> _savedAgents = RxList<AgentModel>();
  List<AgentModel> get savedAgents => _savedAgents;

  final RxList<FavoriteProperty> _savedProperties = RxList<FavoriteProperty>();
  List<FavoriteProperty> get savedProperties => _savedProperties;

  final RxBool isFavorite = false.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<Failure> _error = Rxn<Failure>();
  Failure? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await _fetchSavedProperties();
    await _fetchSavedAgents();
  }

  Future<void> refreshSavedProperties() async {
    await _fetchSavedProperties();
    await _fetchSavedAgents();
  }

  void fetchSavedProperties() async {
    await _fetchSavedProperties();
  }

  void toggleFavoriteProperty(FavoriteProperty property) async {
    await _toggleFavoriteItem(
      id: property.id!,
      type: FavoriteType.property,
      property: property,
    );
    // updateFavorite(property);
  }

  void toggleFavoriteAgent(AgentModel agent) async {
    await _toggleFavoriteItem(
      id: agent.id,
      type: FavoriteType.agent,
      agent: agent,
    );
  }

  void updateFavorite(FavoriteProperty property) async {
    Get.find<PropertyController>().updateFavoriteData(property.id!);

    toggleFavoriteItem(
      id: property.id!,
      type: FavoriteType.property,
      property: property,
    );
  }

  void _toggleProperty(FavoriteProperty property) {
    final index = _savedProperties.indexWhere((e) => e.id == property.id);

    if (index != -1) {
      _savedProperties.removeAt(index);
    } else {
      _savedProperties.add(property);
    }
  }

  void _toggleAgent(AgentModel agent) {
    final index = _savedAgents.indexWhere((e) => e.id == agent.id);

    if (index != -1) {
      _savedAgents.removeAt(index);
    } else {
      _savedAgents.add(agent);
    }
  }

  Future<void> _fetchSavedProperties() async {
    _isLoading.value = true;
    final result = await propertyServices.getSavedProperties();
    result.fold(
      (failure) {
        _isLoading.value = false;
        _error.value = failure;
        log.e("Failed to fetch saved properties: ${failure.message}");
      },
      (res) {
        log.d("Saved properties: ${res.data.properties.length}");
        _savedProperties.value = res.data.properties;
        _isLoading.value = false;
      },
    );
  }

  Future<void> _fetchSavedAgents() async {
    _isLoading.value = true;
    final result = await propertyServices.getSavedProperties();
    result.fold(
      (failure) {
        _isLoading.value = false;
        _error.value = failure;
        log.e("Failed to fetch saved agents: ${failure.message}");
      },
      (res) {
        log.d("Saved agents: ${res.data.agents.length}");
        _savedAgents.value = res.data.agents;
        _isLoading.value = false;
      },
    );
  }

  void toggleFavoriteItem({
    required int id,
    required FavoriteType type,
    FavoriteProperty? property,
    AgentModel? agent,
  }) async {
    await _toggleFavoriteItem(
      id: id,
      type: type,
      property: property,
      agent: agent,
    );
  }

  Future<void> _toggleFavoriteItem({
    required int id,
    required FavoriteType type,
    FavoriteProperty? property,
    AgentModel? agent,
  }) async {
    if (type == FavoriteType.property && property != null) {
      _toggleProperty(property);
    }

    if (type == FavoriteType.agent && agent != null) {
      _toggleAgent(agent);
    }

    final result = await propertyServices.toggleFavoriteProperty(
      type: type.name,
      propertyId: id,
    );

    result.fold(
      (failure) {
        _error.value = failure;
        log.e("Favorite API failed: ${failure.message}");
      },
      (_) {
        log.d("Favorite updated on server");
      },
    );
  }
}
