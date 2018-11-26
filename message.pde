public static enum MessageType {
    GLITCH
}

class Message {
    public MessageType type;
    public Object message;
    public boolean isStale;
    
    public Message(MessageType type, Object message) {
        this.type = type;
        this.message = message;
        this.isStale = false;
    }
}