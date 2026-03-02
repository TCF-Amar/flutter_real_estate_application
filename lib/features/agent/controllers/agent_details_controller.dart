import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/services/agent_services.dart';
import 'package:real_estate_app/features/agent/models/agent_details_response_model.dart';

class AgentDetailsController extends GetxController {
  final Logger log = Logger();
  late final AgentServices agentServices;

  RxBool isLoading = false.obs;
  final Rx<AgentDetailModel?> _agentDetails = Rxn<AgentDetailModel>();
  AgentDetailModel? get agentDetails => _agentDetails.value;

  @override
  void onInit() {
    super.onInit();
    agentServices = Get.find<AgentServices>();
    final id = Get.arguments != null ? Get.arguments['id'] as int? : null;
    if (id != null) {
      _fetchAgentById(id);
    } else {
      log.e('No agent id provided in arguments');
    }
  }

  void _fetchAgentById(int id) async {
    final result = await agentServices.getAgentDetails(id);
    result.fold(
      (l) {
        log.e("Error fetching agent details: ${l.message}");
      },
      (r) {
        _agentDetails.value = r;
        log.d("Fetched agent details: ${r.graphData?.propertyCityStats}");
      },
    );
  }


}
