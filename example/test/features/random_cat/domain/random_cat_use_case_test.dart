import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/random_cat/domain/random_cat_entity.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RandomCat UseCase tests |', () {
    tearDown(() {
      resetProvidersContext();
    });

    test('fetch success', () async {
      final useCase = randomCatUseCaseProvider.getUseCaseFromContext(
        providersContext,
      );

      final gateway = randomCatGatewayProvider.getGateway(providersContext);

      gateway.transport = (request) async {
        return Right(RestSuccessResponse(
          data: {
            'id': 420,
            'webpurl':
                'https://thatcopy.github.io/catAPI/imgs/webp/60343c6.webp',
          },
        ));
      };

      expect(
        useCase.stream,
        emitsInOrder(
          [
            RandomCatEntity(isLoading: true),
            RandomCatEntity(
              isLoading: false,
              id: 420,
              url: 'https://thatcopy.github.io/catAPI/imgs/webp/60343c6.webp',
            ),
          ],
        ),
      );

      await useCase.fetch();
      useCase.dispose();
    });

    test('fetch failure', () async {
      final useCase = randomCatUseCaseProvider.getUseCaseFromContext(
        providersContext,
      );

      final gateway = randomCatGatewayProvider.getGateway(providersContext);

      gateway.transport = (request) async {
        return Left(UnknownFailureResponse());
      };

      expect(
        useCase.stream,
        emitsInOrder(
          [
            RandomCatEntity(isLoading: true),
            RandomCatEntity(isLoading: false),
          ],
        ),
      );

      await useCase.fetch();
      useCase.dispose();
    });
  });
}
