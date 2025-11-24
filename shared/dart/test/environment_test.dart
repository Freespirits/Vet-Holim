import 'package:test/test.dart';
import 'package:vetholim_shared/environment.dart';

void main() {
  test('creates config', () {
    const config = SharedConfig(environment: AppEnvironment.dev, enableAudit: true);
    expect(config.enableAudit, isTrue);
  });
}
