import 'dart:js' as js;

void connectToChannel(String channelName) {
  js.context.callMethod('gossipConnect', [channelName]);
}

void disconnectFromChannel() {
  js.context.callMethod('gossipDisconnect');
}

void sendMessageToChannel(String message) {
  js.context.callMethod('gossipReceiveMessage', [message]);
}