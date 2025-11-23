import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/consultation_remote_datasource.dart';
import '../../data/models/consultation_model.dart';

// Pharmacists State
class PharmacistsState {
  final List<PharmacistModel> pharmacists;
  final bool isLoading;
  final String? error;

  PharmacistsState({
    this.pharmacists = const [],
    this.isLoading = false,
    this.error,
  });

  PharmacistsState copyWith({
    List<PharmacistModel>? pharmacists,
    bool? isLoading,
    String? error,
  }) {
    return PharmacistsState(
      pharmacists: pharmacists ?? this.pharmacists,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<PharmacistModel> get onlinePharmacists =>
      pharmacists.where((p) => p.status == PharmacistStatus.online).toList();

  List<PharmacistModel> get availablePharmacists =>
      pharmacists.where((p) => p.isAvailable).toList();
}

// Pharmacists Notifier
class PharmacistsNotifier extends StateNotifier<PharmacistsState> {
  final ConsultationRemoteDataSource _dataSource;

  PharmacistsNotifier(this._dataSource) : super(PharmacistsState()) {
    getPharmacists();
  }

  Future<void> getPharmacists({PharmacistStatus? status}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pharmacists = await _dataSource.getPharmacists(status: status);
      state = state.copyWith(
        pharmacists: pharmacists,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Consultation State
class ConsultationState {
  final ConsultationSessionModel? currentSession;
  final List<ConsultationSessionModel> history;
  final bool isLoading;
  final String? error;

  ConsultationState({
    this.currentSession,
    this.history = const [],
    this.isLoading = false,
    this.error,
  });

  ConsultationState copyWith({
    ConsultationSessionModel? currentSession,
    List<ConsultationSessionModel>? history,
    bool? isLoading,
    String? error,
    bool clearSession = false,
  }) {
    return ConsultationState(
      currentSession: clearSession ? null : (currentSession ?? this.currentSession),
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasActiveSession => currentSession != null && currentSession!.isActive;
}

// Consultation Notifier
class ConsultationNotifier extends StateNotifier<ConsultationState> {
  final ConsultationRemoteDataSource _dataSource;

  ConsultationNotifier(this._dataSource) : super(ConsultationState()) {
    getConsultationHistory();
  }

  // Start consultation
  Future<void> startConsultation(StartConsultationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _dataSource.startConsultation(request);
      state = state.copyWith(
        currentSession: session,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Get consultation session
  Future<void> getConsultationSession(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _dataSource.getConsultationSession(id);
      state = state.copyWith(
        currentSession: session,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Get consultation history
  Future<void> getConsultationHistory() async {
    try {
      final history = await _dataSource.getConsultationHistory();
      state = state.copyWith(history: history);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Send message
  Future<void> sendMessage(SendMessageRequest request) async {
    try {
      final message = await _dataSource.sendMessage(request);

      // Add message to current session
      if (state.currentSession != null &&
          state.currentSession!.id == request.sessionId) {
        final updatedSession = ConsultationSessionModel(
          id: state.currentSession!.id,
          pharmacistId: state.currentSession!.pharmacistId,
          pharmacist: state.currentSession!.pharmacist,
          type: state.currentSession!.type,
          isActive: state.currentSession!.isActive,
          startedAt: state.currentSession!.startedAt,
          endedAt: state.currentSession!.endedAt,
          messages: [...state.currentSession!.messages, message],
        );

        state = state.copyWith(currentSession: updatedSession);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // End consultation
  Future<void> endConsultation() async {
    if (state.currentSession == null) return;

    try {
      await _dataSource.endConsultation(state.currentSession!.id);
      state = state.copyWith(clearSession: true);
      await getConsultationHistory();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

// Chat Messages State
class ChatMessagesState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  ChatMessagesState({
    this.messages = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  ChatMessagesState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return ChatMessagesState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

// Providers
final pharmacistsProvider =
    StateNotifierProvider<PharmacistsNotifier, PharmacistsState>((ref) {
  return PharmacistsNotifier(ref.read(consultationRemoteDataSourceProvider));
});

final consultationProvider =
    StateNotifierProvider<ConsultationNotifier, ConsultationState>((ref) {
  return ConsultationNotifier(ref.read(consultationRemoteDataSourceProvider));
});

// Chat Messages Provider
final chatMessagesProvider =
    FutureProvider.family<List<ChatMessageModel>, String>((ref, sessionId) async {
  final dataSource = ref.read(consultationRemoteDataSourceProvider);
  return dataSource.getMessages(sessionId);
});

// Convenience providers
final onlinePharmacistsProvider = Provider<List<PharmacistModel>>((ref) {
  return ref.watch(pharmacistsProvider).onlinePharmacists;
});

final hasActiveConsultationProvider = Provider<bool>((ref) {
  return ref.watch(consultationProvider).hasActiveSession;
});
