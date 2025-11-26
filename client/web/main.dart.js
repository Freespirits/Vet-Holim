(function attachFlutterMain(globalScope) {
  const target = globalScope.window ?? globalScope;
  const note = 'Flutter web main stub ready';
  target.console?.info?.('[flutter] ' + note);
  const mainEntrypoint = () => note;
  mainEntrypoint.toString = () => '✨FlutterMain';
  target.__vetHolimFlutterMain = mainEntrypoint;
})(typeof globalThis !== 'undefined' ? globalThis : {});
