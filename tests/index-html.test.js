const { strict: assert } = require('node:assert');
const { test } = require('node:test');
const { readFileSync } = require('node:fs');
const { resolve } = require('node:path');

function loadHtml() {
    const htmlPath = resolve(__dirname, '..', 'web', 'index.html');
    return readFileSync(htmlPath, 'utf8');
}

function getFlutterPanel(html) {
    return html.match(/<section[^>]*id="tab-flutter"[^>]*>[\s\S]*?<\/section>/);
}

test('includes the shared CSS/JS assets for the shell', () => {
    const html = loadHtml();
    assert.ok(html.includes('<link rel="stylesheet" href="styles.css"'), 'styles.css link is missing');
    assert.ok(html.includes('<script src="app.js" defer></script>'), 'app.js script is missing');
});

test('exposes a Flutter tab with an embedded frame', () => {
    const html = loadHtml();
    assert.ok(html.includes('data-tab-target="tab-flutter"'), 'Flutter tab button should exist');

    const flutterPanel = getFlutterPanel(html);
    assert.ok(flutterPanel, 'Flutter tab content should exist');
    assert.ok(/id="flutter-app-frame"/.test(flutterPanel[0]), 'Flutter frame id is missing');
    assert.ok(
        /src="\/client\/web\/index.html"/.test(flutterPanel[0]),
        'Flutter frame should point to the absolute web build path so it resolves from /web/index.html'
    );
});
