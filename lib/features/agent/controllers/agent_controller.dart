import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/agent_services.dart';
import 'package:real_estate_app/features/agent/models/agent_model.dart';

class AgentController extends GetxController {
  final Logger log = Logger();
  final AgentServices services = Get.find<AgentServices>();

  final RxBool _isLoadingList = false.obs;
  final RxBool isLoadingMore = false.obs;
  bool get isLoadingList => _isLoadingList.value;

  final Rxn<Failure> _error = Rxn<Failure>();
  Failure? get error => _error.value;

  final RxList<AgentModel> _agents = RxList([]);
  List<AgentModel> get agents => _agents;

  final Map<int, AgentModel> agentCache = {};
  AgentModel? getAgent(int id) => agentCache[id];

  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt totalAgents = 0.obs;
  final RxInt perPage = 10.obs;

  bool get hasMorePages => currentPage.value < lastPage.value;

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxString location = ''.obs;
  final RxString rating = ''.obs;
  final RxString experience = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchAgents(resetPage: true);
    ever(_isLoadingList, (value) {
      log.d('isLoadingList: $value');
    });

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    debounce(searchQuery, (query) {
      services.search.value = query;
      _fetchAgents(resetPage: true);
    }, time: const Duration(milliseconds: 500));

    scrollController.addListener(() {
      final atBottom =
          scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200;
      if (atBottom &&
          !_isLoadingList.value &&
          !isLoadingMore.value &&
          hasMorePages) {
        _loadMore();
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void handleSearch() {
    _isLoadingList.value = true;
    _fetchAgents(resetPage: true);
    _isLoadingList.value = false;
  }

  Future<void> _fetchAgents({bool resetPage = false}) async {
    if (resetPage) {
      services.page.value = 1;
      _isLoadingList.value = true;
    } else {
      isLoadingMore.value = true;
    }

    final result = await services.getAgents();
    result.fold(
      (l) {
        log.e('fetchAgents error: ${l.message}');
        _error.value = l; // Set the error value
      },
      (r) {
        _error.value = null; // Clear any previous error on success
        final pagination = r.data.pagination;
        currentPage.value = pagination.currentPage;
        lastPage.value = pagination.lastPage;
        totalAgents.value = pagination.total;
        perPage.value = pagination.perPage;

        if (resetPage) {
          _agents.assignAll(r.data.agents);
          agentCache.clear();
        } else {
          _agents.addAll(r.data.agents);
        }

        for (final agent in r.data.agents) {
          agentCache[agent.id] = agent;
        }

        log.d(
          'Page ${pagination.currentPage}/${pagination.lastPage} — '
          '${r.data.agents.length} agents loaded (total: ${pagination.total})',
        );
      },
    );

    _isLoadingList.value = false;
    isLoadingMore.value = false;
  }

  Future<void> _loadMore() async {
    services.page.value = currentPage.value + 1;
    await _fetchAgents(resetPage: false);
  }

  Future<void> refreshAgents() async {
    agentCache.clear();
    await _fetchAgents(resetPage: true);
  }

  void initializeFilters() {
    location.value = services.location.value;
    rating.value = services.minRating.value;
    experience.value = services.experience.value;
  }

  void applyFilters() {
    services.location.value = location.value;
    services.minRating.value = rating.value;
    services.experience.value = experience.value;
    _fetchAgents(resetPage: true);
    Get.back();
  }

  void clearFilters() {
    location.value = '';
    rating.value = '';
    experience.value = '';
    services.location.value = '';
    services.minRating.value = '';
    services.experience.value = '';
    _fetchAgents(resetPage: true);
  }

  void toggleAgentFav() {}
}
