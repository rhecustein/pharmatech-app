import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/prescription_remote_datasource.dart';
import '../../data/models/prescription_model.dart';

// Prescriptions State
class PrescriptionsState {
  final List<PrescriptionModel> prescriptions;
  final bool isLoading;
  final String? error;

  PrescriptionsState({
    this.prescriptions = const [],
    this.isLoading = false,
    this.error,
  });

  PrescriptionsState copyWith({
    List<PrescriptionModel>? prescriptions,
    bool? isLoading,
    String? error,
  }) {
    return PrescriptionsState(
      prescriptions: prescriptions ?? this.prescriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<PrescriptionModel> getPrescriptionsByStatus(PrescriptionStatus status) {
    return prescriptions
        .where((prescription) => prescription.status == status)
        .toList();
  }

  int get pendingCount =>
      prescriptions.where((p) => p.status == PrescriptionStatus.pending).length;

  int get approvedCount =>
      prescriptions.where((p) => p.status == PrescriptionStatus.approved).length;

  int get rejectedCount =>
      prescriptions.where((p) => p.status == PrescriptionStatus.rejected).length;
}

// Prescriptions Notifier
class PrescriptionsNotifier extends StateNotifier<PrescriptionsState> {
  final PrescriptionRemoteDataSource _dataSource;

  PrescriptionsNotifier(this._dataSource) : super(PrescriptionsState()) {
    getPrescriptions();
  }

  // Get prescriptions
  Future<void> getPrescriptions({PrescriptionStatus? status}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prescriptions = await _dataSource.getPrescriptions(status: status);
      state = state.copyWith(
        prescriptions: prescriptions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Upload prescription
  Future<PrescriptionModel> uploadPrescription(
    UploadPrescriptionRequest request,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prescription = await _dataSource.uploadPrescription(request);
      state = state.copyWith(
        prescriptions: [prescription, ...state.prescriptions],
        isLoading: false,
      );
      return prescription;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Refresh prescriptions
  Future<void> refresh() async {
    await getPrescriptions();
  }
}

// Provider
final prescriptionsProvider =
    StateNotifierProvider<PrescriptionsNotifier, PrescriptionsState>((ref) {
  return PrescriptionsNotifier(ref.read(prescriptionRemoteDataSourceProvider));
});

// Prescription Detail Provider
final prescriptionDetailProvider =
    FutureProvider.family<PrescriptionModel, String>((ref, id) async {
  final dataSource = ref.read(prescriptionRemoteDataSourceProvider);
  return dataSource.getPrescriptionById(id);
});

// Convenience providers
final pendingPrescriptionsCountProvider = Provider<int>((ref) {
  return ref.watch(prescriptionsProvider).pendingCount;
});
