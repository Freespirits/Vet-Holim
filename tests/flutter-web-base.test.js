const { strict: assert } = require('node:assert');
const { readFileSync } = require('node:fs');
const { resolve } = require('node:path');
const { test } = require('node:test');

function loadFlutterHtml() {
    const htmlPath = resolve(__dirname, '..', 'client', 'web', 'index.html');
    return readFileSync(htmlPath, 'utf8');
}

test('uses a relative base so Flutter assets resolve when embedded', () => {
    const html = loadFlutterHtml();
    const baseMatch = html.match(/<base[^>]*href="([^"]+)"/);
    assert.ok(baseMatch, 'Flutter web shell should declare a <base> tag');
    assert.equal(
        baseMatch[1],
        './',
        'Base href should stay relative so flutter.js and main.dart.js load from the iframe directory'
    );
});
