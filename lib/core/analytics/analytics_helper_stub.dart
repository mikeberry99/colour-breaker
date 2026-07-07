import 'analytics_helper.dart';

class AnalyticsHelperImpl implements AnalyticsHelper {
  @override
  void trackGameStart(String mode) {}

  @override
  void trackPageVisit(String pageName) {}
}

AnalyticsHelper getAnalyticsHelper() => AnalyticsHelperImpl();
