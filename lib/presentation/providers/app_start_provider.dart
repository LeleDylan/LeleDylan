import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntajepro/data/firebase/firebase_question_data_source.dart';
import 'package:puntajepro/data/local/local_question_data_source.dart';
import 'package:puntajepro/data/repositories/auth_repository_impl.dart';
import 'package:puntajepro/data/repositories/progress_repository_impl.dart';
import 'package:puntajepro/data/repositories/question_repository_impl.dart';
import 'package:puntajepro/data/repositories/subscription_repository_impl.dart';
import 'package:puntajepro/domain/repositories/auth_repository.dart';
import 'package:puntajepro/domain/repositories/progress_repository.dart';
import 'package:puntajepro/domain/repositories/question_repository.dart';
import 'package:puntajepro/domain/repositories/subscription_repository.dart';

final localQuestionDataSourceProvider = Provider<LocalQuestionDataSource>((ref) {
  return LocalQuestionDataSource();
});

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  final local = ref.watch(localQuestionDataSourceProvider);
  final remote = FirebaseQuestionDataSource(FirebaseFirestore.instance);
  return QuestionRepositoryImpl(local, remote);
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(FirebaseFirestore.instance);
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(InAppPurchase.instance);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance, GoogleSignIn());
});

class AppStartState {
  const AppStartState._();

  T when<T>({
    required T Function() loading,
    required T Function() needsOnboarding,
    required T Function() ready,
    required T Function(String message) error,
  }) {
    if (this is AppStartLoading) return loading();
    if (this is AppStartNeedsOnboarding) return needsOnboarding();
    if (this is AppStartReady) return ready();
    return error((this as AppStartError).message);
  }

  T maybeWhen<T>({
    T Function()? loading,
    T Function()? needsOnboarding,
    T Function()? ready,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    if (this is AppStartLoading) return (loading ?? orElse)();
    if (this is AppStartNeedsOnboarding) return (needsOnboarding ?? orElse)();
    if (this is AppStartReady) return (ready ?? orElse)();
    return (error ?? (_) => orElse())((this as AppStartError).message);
  }
}

class AppStartLoading extends AppStartState {
  const AppStartLoading() : super._();
}

class AppStartNeedsOnboarding extends AppStartState {
  const AppStartNeedsOnboarding() : super._();
}

class AppStartReady extends AppStartState {
  const AppStartReady() : super._();
}

class AppStartError extends AppStartState {
  const AppStartError(this.message) : super._();
  final String message;
}

final appStartProvider = StateNotifierProvider<AppStartNotifier, AppStartState>((ref) {
  return AppStartNotifier(ref)..initialize();
});

class AppStartNotifier extends StateNotifier<AppStartState> {
  AppStartNotifier(this._ref) : super(const AppStartLoading());

  final Ref _ref;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await FirebaseAnalytics.instance.logAppOpen();
      await _ref.read(localQuestionDataSourceProvider).init();
      state = const AppStartNeedsOnboarding();
    } catch (e) {
      state = AppStartError(e.toString());
    }
  }

  void completeOnboarding() {
    state = const AppStartReady();
  }
}
