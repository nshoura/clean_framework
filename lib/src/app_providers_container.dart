import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProvidersContainer extends StatelessWidget {
  final Widget child;
  final ProvidersContext _providersContext;

  final Function(BuildContext, ProvidersContext)? _onBuild;

  AppProvidersContainer({
    Key? key,
    required this.child,
    ProvidersContext? providersContext,
    required Function(BuildContext, ProvidersContext)? onBuild,
  })  : _providersContext = providersContext ?? ProvidersContext(),
        _onBuild = onBuild,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _onBuild?.call(context, _providersContext);
    return UncontrolledProviderScope(
      container: _providersContext(),
      child: child,
    );
  }
}

class ProvidersContext {
  final ProviderContainer _container;

  ProvidersContext([List<Override> overrides = const []])
      : _container = ProviderContainer(overrides: overrides);

  ProviderContainer call() => _container;

  void dispose() {
    _container.dispose();
  }
}
