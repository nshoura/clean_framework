import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphQLExternalInterface success response', () {
    final interface = GraphQLExternalInterface(link: link, gatewayConnections: gatewayConnections)
  });
}

class GraphQLServiceFake extends Fake implements GraphQLService {
  Map<String, dynamic> _json;

  set response(Map<String, dynamic> newJson) => _json = newJson;

  GraphQLServiceFake(this._json);

  @override
  Future<Map<String, dynamic>> request(
      {required GraphQLMethod method,
      required String document,
      Map<String, dynamic>? variables}) async {
    if (_json.isEmpty) throw 'service exception';
    return _json;
  }
}

class GatewayFake
    extends GraphQLGateway {
  GatewayFake(UseCase useCase) : super(useCase: useCase);

  @override
  buildRequest(output) {
    return TestRequest();
  }

  @override
  SuccessInput onSuccess(GraphQLSuccessResponse response) {
    return SuccessInput();
  }
}
