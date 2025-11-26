(function bootstrapFlutterStub(globalScope) {
  const target = globalScope.window ?? globalScope;
  const doc = globalScope.document ?? target.document;

  function addBootstrapMarker() {
    if (!doc?.body || !doc.createElement) {
      return;
    }
    const marker = doc.createElement('div');
    marker.id = 'flutter-bootstrap-status';
    marker.textContent = 'Flutter web bundle stub loaded';
    doc.body.appendChild(marker);
  }

  function createAppRunner() {
    return {
      async runApp() {
        addBootstrapMarker();
      },
      toString() {
        return '🚀FlutterAppRunner';
      },
    };
  }

  function createEngineInitializer() {
    return {
      async initializeEngine() {
        return createAppRunner();
      },
      toString() {
        return '🛠️FlutterEngineInitializer';
      },
    };
  }

  function loadEntrypoint(options = {}) {
    const workerVersion = options.serviceWorker?.serviceWorkerVersion ?? null;
    target.console?.debug?.('[flutter] bootstrap stub invoked', { workerVersion });
    return Promise.resolve(createEngineInitializer());
  }

  const loader = {
    loadEntrypoint,
    toString() {
      return '🧭FlutterLoader';
    },
  };

  target._flutter = target._flutter || {};
  target._flutter.loader = loader;
})(typeof globalThis !== 'undefined' ? globalThis : {});
