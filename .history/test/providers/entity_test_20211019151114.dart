import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Entity test', () {
    final entity = EntityFake();
    expect(entity.toString(), '');
  });
}

class EntityFake extends Entity {
  @override
  List<Object?> get props => [];
}
