const { strict: assert } = require('node:assert');
const { readFileSync } = require('node:fs');
const { resolve } = require('node:path');
const { test } = require('node:test');
const vm = require('node:vm');

function loadAsset(relativePath) {
  const assetPath = resolve(__dirname, '..', 'client', 'web', relativePath);
  return { assetPath, content: readFileSync(assetPath, 'utf8') };
}

function createDocumentDouble() {
  const body = {
    children: [],
    appendChild(node) {
      this.children.push(node);
    },
  };

  return {
    body,
    createElement(tagName) {
      return { tagName, attributes: {}, setAttribute() {}, id: '', textContent: '', children: [] };
    },
    querySelector() {
      return null;
    },
  };
}

test('flutter web build artifacts are present', () => {
  const { content: flutterContent } = loadAsset('flutter.js');
  assert.ok(flutterContent.trim().length > 0, 'flutter.js should not be empty');

  const { content: mainContent } = loadAsset('main.dart.js');
  assert.ok(mainContent.trim().length > 0, 'main.dart.js should not be empty');
});

test('flutter loader stub boots without crashing', async () => {
  const { content } = loadAsset('flutter.js');
  const documentDouble = createDocumentDouble();
  const context = { window: {}, document: documentDouble, console };

  vm.runInNewContext(content, context, { filename: 'flutter.js' });

  const loader = context.window._flutter?.loader;
  assert.ok(loader, 'loader should be attached to window._flutter');
  const engineInitializer = await loader.loadEntrypoint({ serviceWorker: { serviceWorkerVersion: null } });
  assert.ok(engineInitializer, 'loader should resolve with an engine initializer');

  const appRunner = await engineInitializer.initializeEngine();
  assert.ok(appRunner, 'engine initializer should resolve with an app runner');

  await appRunner.runApp();
  const appendedIds = documentDouble.body.children.map((node) => node.id);
  assert.ok(appendedIds.includes('flutter-bootstrap-status'), 'bootstrap marker should be appended to the DOM');
});
