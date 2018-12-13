import processing.net.*;

class NetworkManager {
    
    private ArrayList<Message> messageQueue;
    private Server server;
    private String lastString = "";
    
    public NetworkManager(PApplet applet, ArrayList<Message> messageQueue) {
        this.messageQueue = messageQueue;
        server = new Server(applet, 65432);
    }
    
    public void receive() {
        Client c = server.available();
        if(c == null) return;
        
        print("New TCP Packet\n");
        String message = c.readString();
        lastString += message;
        while(true) {
            if(lastString.indexOf("\n") < 0) {
                print("Message chunk!\n");
                return;
            } else {
                print("Found complete message: ");
                message = lastString.substring(0, lastString.indexOf("\n"));
                lastString = message.substring(lastString.indexOf("\n")).trim();
                print(message);
                print("\nAnd leftovers: ");
                print(lastString);
                print("\n\n/////////////");
            }
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
                } else if(data[1].trim().equals("GLITCH")) {
                    print("Type: GLITCH");
                    m = new Message(MessageType.GLITCH, new Glitch(true, 0, 10, 40*round(random(-1, 1)), height, 15));
                    messageQueue.add(m);
                    messageQueue.add(m);
                } else if(data[1].trim().equals("FONT_SIZE")) {
                    print("Type: FONT_SIZE");
                    Config.fontSize = float(data[2]);
                    m = new Message(MessageType.FONT_SIZE, float(data[2]));
                } else if(data[1].trim().equals("TEXT_AUTOSIZE")) {
                    print("Type: TEXT_AUTOSIZE");
                    m = new Message(MessageType.TEXT_AUTOSIZE, null);
                }
                
                if(m != null) {
                    print("Adding new Message");
                    messageQueue.add(m);
                }
            }
        }
    }
}