const { strict: assert } = require('node:assert');
const { test } = require('node:test');
const { readFileSync } = require('node:fs');
const { resolve } = require('node:path');

function loadWebShell() {
    const htmlPath = resolve(__dirname, '..', 'client', 'web', 'index.html');
    return readFileSync(htmlPath, 'utf8');
}

test('shows a Flutter web fallback message for missing bundles', () => {
    const html = loadWebShell();
    assert.ok(html.includes('data-test="flutter-fallback"'), 'Flutter web fallback container is missing');
    assert.ok(/flutter build web/i.test(html), 'Fallback should instruct how to build the Flutter web bundle');
});
