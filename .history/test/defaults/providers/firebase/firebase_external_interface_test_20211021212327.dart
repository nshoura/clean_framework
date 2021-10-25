import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/tests/gateway_fake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FirebaseClientFake firebaseClient;
  final testContent = {'foo': 'bar'};

  firebaseClient = FirebaseClientFake(testContent);

  tearDownAll(() {
    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface watch id request', () async {
    // to cover the internal initialize
    FirebaseExternalInterface(gatewayConnections: []);

    final gateWay =
        WatcherGatewayFake<FirebaseWatchIdRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(testContent));

    //TODO Find out why this verify doesn't work
    // verify(() =>
    //     firebaseClient.watch(path: any(named: 'path'), id: any(named: 'id')));

    if (gateWay.hasYielded.isCompleted)
      expect(gateWay.successResponse, FirebaseSuccessResponse(testContent));
    else
      expectLater(gateWay.hasYielded.future,
          completion(FirebaseSuccessResponse(testContent)));
  });

  test('FirebaseExternalInterface watch all request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseWatchAllRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result =
        await gateWay.transport(FirebaseWatchAllRequest(path: 'fake path'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(testContent));

    if (gateWay.hasYielded.isCompleted)
      expect(gateWay.successResponse, FirebaseSuccessResponse(testContent));
    else
      expectLater(gateWay.hasYielded.future,
          completion(FirebaseSuccessResponse(testContent)));

    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface read id request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseReadIdRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseReadIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(testContent));
  });

  test('FirebaseExternalInterface read all request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseReadAllRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result =
        await gateWay.transport(FirebaseReadAllRequest(path: 'fake path'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(testContent));
  });

  test('FirebaseExternalInterface write request', () async {
    final firebaseClient = FirebaseClientFake(testContent);
    final gateWay =
        WatcherGatewayFake<FirebaseWriteRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWriteRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse({'id': 'id'}));
  });

  test('FirebaseExternalInterface update request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseUpdateRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseUpdateRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse({}));
  });

  test('FirebaseExternalInterface delete request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseDeleteRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseDeleteRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse({}));
  });

  test('FirebaseExternalInterface read id no content', () async {
    firebaseClient = FirebaseClientFake({});

    final gateWay =
        WatcherGatewayFake<FirebaseReadIdRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseReadIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isLeft, isTrue);
    expect(result.left, NoContentFirebaseFailureResponse());

    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface read all request', () async {
    firebaseClient = FirebaseClientFake({});

    final gateWay =
        WatcherGatewayFake<FirebaseReadAllRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result =
        await gateWay.transport(FirebaseReadAllRequest(path: 'fake path'));
    expect(result.isLeft, isTrue);
    expect(result.left, NoContentFirebaseFailureResponse());

    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface write request', () async {
    final firebaseClient = FirebaseClientFake(testContent);
    final gateWay =
        WatcherGatewayFake<FirebaseWriteRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWriteRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse({'id': 'id'}));
  });
}
