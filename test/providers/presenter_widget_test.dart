import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final provider = UseCaseProvider((_) => TestUseCase());
void main() {
  testWidgets('Presenter initial load', (tester) async {
    final presenter = TestPresenter(
      builder: (TestViewModel viewModel) {
        return Text(viewModel.foo, key: Key('foo'));
      },
    );

    await ProviderTester().pumpWidget(tester, MaterialApp(home: presenter));

    expect(find.byKey(Key('foo')), findsOneWidget);
    expect(find.text('INITIAL'), findsOneWidget);

    await tester.pump();
    expect(find.text('A'), findsOneWidget);

    expect(presenter.outputUpdateLogs, ['a']);

    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('B'), findsOneWidget);

    expect(presenter.outputUpdateLogs, ['a', 'b']);
  });

  testWidgets(
    'didUpdatePresenter test',
    (tester) async {
      final widget = MaterialApp(
        home: FutureBuilder<int>(
          initialData: 1,
          future: Future.delayed(const Duration(milliseconds: 100), () => 2),
          builder: (context, snapshot) {
            return TestPresenter(
              count: snapshot.data,
              builder: (viewModel) => Text(viewModel.foo, key: Key('foo')),
            );
          },
        ),
      );

      await ProviderTester().pumpWidget(tester, widget);

      final testPresenterFinder = find.byType(TestPresenter);
      expect(testPresenterFinder, findsOneWidget);

      var presenter = tester.widget<TestPresenter>(testPresenterFinder);
      expect(presenter.didUpdatePresenterLogs, isEmpty);

      await tester.pump(const Duration(milliseconds: 100));
      presenter = tester.widget<TestPresenter>(testPresenterFinder);
      expect(presenter.didUpdatePresenterLogs.first.previous, 1);
      expect(presenter.didUpdatePresenterLogs.first.next, 2);
    },
  );
}

class TestPresenter extends Presenter<TestViewModel, TestOutput, TestUseCase> {
  TestPresenter({required PresenterBuilder<TestViewModel> builder, this.count})
      : super(provider: provider, builder: builder);

  final int? count;

  final List<String> outputUpdateLogs = [];
  final List<PresenterData> didUpdatePresenterLogs = [];

  @override
  void onLayoutReady(BuildContext context, TestUseCase useCase) {
    super.onLayoutReady(context, useCase);
    useCase.fetch();
  }

  @override
  TestViewModel createViewModel(_, output) => TestViewModel.fromOutput(output);

  @override
  void onOutputUpdate(BuildContext context, TestOutput output) {
    super.onOutputUpdate(context, output);
    outputUpdateLogs.add(output.foo);
  }

  @override
  void didUpdatePresenter(
    BuildContext context,
    TestPresenter old,
    TestUseCase useCase,
  ) {
    super.didUpdatePresenter(context, old, useCase);
    didUpdatePresenterLogs.add(PresenterData(old.count, count));
  }
}

class TestUseCase extends UseCase<EntityFake> {
  TestUseCase()
      : super(
          entity: EntityFake(),
          outputFilters: {
            TestOutput: (EntityFake entity) => TestOutput(entity.value),
          },
        );

  Future<void> fetch() async {
    entity = EntityFake(value: 'a');

    await Future.delayed(const Duration(milliseconds: 100));

    entity = EntityFake(value: 'b');
  }
}

class TestOutput extends Output {
  final String foo;

  TestOutput(this.foo);

  @override
  List<Object?> get props => [foo];
}

class TestViewModel extends ViewModel {
  final String foo;

  TestViewModel(this.foo);

  TestViewModel.fromOutput(TestOutput output) : foo = output.foo.toUpperCase();

  @override
  List<Object?> get props => [foo];
}

class PresenterData {
  PresenterData(this.previous, this.next);

  final int? previous;
  final int? next;
}
