import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/explore/models/agent_details_response_model.dart';
import 'package:real_estate_app/features/explore/models/agent_model.dart';

class AgentController extends GetxController {
  final Logger log = Logger();
  final ExploreServices exploreServices = Get.find<ExploreServices>();
  final RxBool isLoading = false.obs;

  final RxList<AgentModel> _agents = RxList([]);
  final Rxn<AgentDetailModel> _agentDetails = Rxn<AgentDetailModel>();

  List<AgentModel> get agents => _agents;
  AgentDetailModel? get agentDetails => _agentDetails.value;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await fetchAgentDetails();
  }

  Future<void> fetchAgentDetails() async {
    isLoading.value = true;
    final result = await exploreServices.getAgents();
    result.fold((l) => log.e(l.message), (r) {
      log.d("Fetched agents: ${r.data.agents.length}");
      _agents.value = r.data.agents;
    });
    isLoading.value = false;
  }

  Future<void> fetchAgentDetailsById(int id) async {
    isLoading.value = true;
    final result = await exploreServices.getAgentDetails(id);
    result.fold((l) => log.e(l.message), (r) {
      // Handle agent details response if needed
      log.d("Fetched agent details: ${r.data.name}");
      _agentDetails.value = r.data;
    });
    isLoading.value = false;
  }
}
