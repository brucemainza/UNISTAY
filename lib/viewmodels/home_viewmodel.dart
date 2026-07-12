part of '../main.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({HouseRepository? repository})
      : _repository = repository ?? const HouseRepository();

  final HouseRepository _repository;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  List<House> _allHouses = [];
  List<House> _filteredHouses = [];
  UniversityOption? _selectedUniversity;
  final Set<String> _activeFilters = {};
  bool _loading = true;
  String? _error;
  int _adPage = 0;

  List<House> get houses => _filteredHouses;
  bool get loading => _loading;
  String? get error => _error;
  UniversityOption? get selectedUniversity => _selectedUniversity;
  Set<String> get activeFilters => _activeFilters;
  int get adPage => _adPage;

  Future<void> loadHouses() async {
    _loading = true;
    _error = null;
    _notify();

    try {
      _allHouses = await _repository.fetchHouses();
      _applyFilters();
    } on Object catch (e) {
      _error = 'Failed to load houses: $e';
    } finally {
      _loading = false;
      _notify();
    }
  }

  void selectUniversity(UniversityOption? university) {
    _selectedUniversity = university;
    _applyFilters();
  }

  void setFilters(List<String> filters) {
    _activeFilters
      ..clear()
      ..addAll(filters);
    _applyFilters();
  }

  void removeFilter(String filter) {
    if (!_activeFilters.contains(filter)) return;
    _activeFilters.remove(filter);
    _applyFilters();
  }

  void setAdPage(int page) {
    if (_adPage == page) return;
    _adPage = page;
    _notify();
  }

  void _applyFilters() {
    _filteredHouses = _repository.filterHouses(
      _allHouses,
      university: _selectedUniversity,
      filters: _activeFilters,
    );
    _notify();
  }
}
