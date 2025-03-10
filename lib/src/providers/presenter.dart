import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Presenter<V extends ViewModel, O extends Output,
    U extends UseCase> extends ConsumerStatefulWidget {
  final UseCaseProvider _provider;
  final PresenterBuilder<V> builder;

  Presenter({required UseCaseProvider provider, required this.builder})
      : _provider = provider;

  @override
  _PresenterState<V, O, U> createState() => _PresenterState<V, O, U>();

  @protected
  V createViewModel(U useCase, O output);

  /// Called when this presenter is inserted into the tree.
  @protected
  void onLayoutReady(BuildContext context, U useCase) {}

  /// Called whenever the [output] updates.
  @protected
  void onOutputUpdate(BuildContext context, O output) {}

  /// Called whenever the presenter configuration changes.
  @protected
  void didUpdatePresenter(
    BuildContext context,
    covariant Presenter<V, O, U> old,
    U useCase,
  ) {}

  @visibleForTesting
  O subscribe(WidgetRef ref) => _provider.subscribe<O>(ref);
}

class _PresenterState<V extends ViewModel, O extends Output, U extends UseCase>
    extends ConsumerState<Presenter<V, O, U>> {
  U? _useCase;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      widget.onLayoutReady(context, _useCase!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useCase ??= widget._provider.getUseCase(ref) as U;
  }

  @override
  void didUpdateWidget(covariant Presenter<V, O, U> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdatePresenter(context, oldWidget, _useCase!);
  }

  @override
  Widget build(BuildContext context) {
    widget._provider.listen<O>(ref, _onOutputChanged);
    final output = widget.subscribe(ref);
    return widget.builder(widget.createViewModel(_useCase!, output));
  }

  void _onOutputChanged(O? previous, O next) {
    if (previous != next) widget.onOutputUpdate(context, next);
  }
}

typedef PresenterBuilder<V extends ViewModel> = Widget Function(V viewModel);
