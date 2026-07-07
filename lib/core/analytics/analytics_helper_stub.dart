import 'analytics_helper.dart';

class AnalyticsHelperImpl implements AnalyticsHelper {
  @override
  void trackGameStart(String mode) {}

  @override
  void trackPageVisit(String pageName) {}

  @override
  void trackGameWon(String mode, int attempts) {}

  @override
  void trackGameLost(String mode, int attempts) {}
}

AnalyticsHelper getAnalyticsHelper() => AnalyticsHelperImpl();
