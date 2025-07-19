import 'dart:html' as html;

void listenToResize(Function onResize) {
  html.window.onResize.listen((_) {
    onResize();
  });
}
