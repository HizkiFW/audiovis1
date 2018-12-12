import processing.net.*;

class NetworkManager {
    
    private ArrayList<Message> messageQueue;
    private Server server;
    
    public NetworkManager(PApplet applet, ArrayList<Message> messageQueue) {
        this.messageQueue = messageQueue;
        server = new Server(applet, 65432);
    }
    
    public void receive() {
        Client c = server.available();
        if(c == null) return;
        
        print("New TCP Packet\n");
        String message = c.readString();
        if(message.indexOf("\n") > 0)
            message = message.substring(0, message.indexOf("\n"));
        message.trim();
        print(message);
        print("---\n");
        String data[] = split(message, ' ');
        print("0'");
        print(data[0]);
        print("'\n");
        if(data[0].equals("MessageQueue")) {
            print("For: MessageQueue\n");
            Message m = null;
            print("1'");
            print(data[1]);
            print("'\n");
            if(data[1].trim().equals("GLITCHINESS")) {
                print("Type: GLITCHINESS");
                m = new Message(MessageType.GLITCHINESS, float(data[2]));
            } else if(data[1].trim().equals("INVERT_COLORS")) {
                print("Type: INVERT_COLORS");
                m = new Message(MessageType.INVERT_COLORS, null);
            }
            if(m != null) {
                print("Adding new Message");
                messageQueue.add(m);
            }
        }
    }
}