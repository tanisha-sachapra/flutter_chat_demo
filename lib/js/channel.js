class Channel {
    constructor() {
        this.connection = null;
        this.listeners = [];
    }

    connect(channelName) {
        this.connection = `Connected to ${channelName}`;
        console.log(this.connection);
    }

    disconnect() {
        this.connection = null;
        console.log("Disconnected from channel");
    }

    onMessage(callback) {
        this.listeners.push(callback);
    }

    receiveMessage(message) {
        this.listeners.forEach(callback => callback(message));
    }
}

// Expose to window for Dart JS interop
window.gossipChannel = new Channel();
window.gossipConnect = (channelName) => window.gossipChannel.connect(channelName);
window.gossipDisconnect = () => window.gossipChannel.disconnect();
window.gossipReceiveMessage = (message) => window.gossipChannel.receiveMessage(message);