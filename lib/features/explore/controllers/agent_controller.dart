import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/explore/models/agent_model.dart';

class AgentController extends GetxController {
  final Logger log = Logger();
  final ExploreServices exploreServices = Get.find<ExploreServices>();

  // Separate loading states so list-fetch and single-fetch don't clash
  final RxBool isLoadingList = false.obs;
  final RxBool isLoadingAgent = false.obs;

  final RxList<AgentModel> _agents = RxList([]);
  List<AgentModel> get agents => _agents;

  // In-memory cache: agentId → AgentModel
  final Map<int, AgentModel> _agentCache = {};
  AgentModel? getAgent(int id) => _agentCache[id];

  @override
  void onInit() {
    super.onInit();
    fetchAllAgents();
  }

  /// Fetches the full agents list and populates the cache.
  Future<void> fetchAllAgents() async {
    isLoadingList.value = true;
    final result = await exploreServices.getAgents();
    result.fold((l) => log.e('fetchAllAgents error: ${l.message}'), (r) {
      log.d('Fetched ${r.data.agents.length} agents');
      _agents.value = r.data.agents;
      for (final agent in r.data.agents) {
        _agentCache[agent.id] = agent;
      }
    });
    isLoadingList.value = false;
  }

  /// Returns an agent by id — from cache if available, otherwise from API.
  /// Used by the [AgentInfo] FutureBuilder; has its own loading flag.
  Future<AgentModel?> fetchAgentById(int id) async {
    // Fast path: already cached
    if (_agentCache.containsKey(id)) {
      log.d('Agent $id served from cache');
      return _agentCache[id];
    }

    // Slow path: fetch from API
    isLoadingAgent.value = true;
    AgentModel? agent;
    try {
      final result = await exploreServices.getAgentDetails(id);
      result.fold((l) => log.e('fetchAgentById($id) error: ${l.message}'), (r) {
        agent = AgentModel.fromAgentDetailModel(r.data);
        _agentCache[id] = agent!; // cache for future calls
        log.d('Fetched agent $id: ${r.data.name}');
      });
    } finally {
      isLoadingAgent.value = false;
    }
    return agent;
  }

  // refresh agents
  Future<void> refreshAgents() async {
    _agents.clear();
    _agentCache.clear();
    await fetchAllAgents();
  }
}
