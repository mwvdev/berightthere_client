import 'package:berightthere_client/redux/location.dart';
import 'package:berightthere_client/redux/report_status.dart';

class HandledLocation {
  final ReportStatus reportStatus;

  final Location location;

  HandledLocation(this.location, this.reportStatus);
}
