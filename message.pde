public static enum MessageType {
    GLITCH,
    GLITCHINESS,
    INVERT_COLORS,
    FONT_SIZE,
    TEXT_POSITION,
    TEXT_AUTOSIZE
}

class Message {
    public MessageType type;
    public Object message;
    
    public Message(MessageType type, Object message) {
        this.type = type;
        this.message = message;
    }
}