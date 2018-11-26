import java.nio.file.*;

class TextOverlay implements Overlay {
    private float xpos = width/2;
    private float ypos = height*0.9;
    
    private float textSize = 40;
    private boolean allCaps = true;
    
    private String fileLocation;
    private String text;
    private String textLast;
    private PFont font;
    
    private ArrayList<Message> messageQueue;
    
    public TextOverlay(ArrayList<Message> messageQueue) {
        this(messageQueue, null);
    }
    public TextOverlay(ArrayList<Message> messageQueue, String fileLocation) {
        this.messageQueue = messageQueue;
        this.fileLocation = fileLocation;
        text = "";
        font = createFont("fonts/Raleway-Regular.ttf", textSize);
    }
    
    public void update() {
        if(fileLocation != null) {
            Path path = Paths.get(fileLocation);
            try {
                text = new String(Files.readAllBytes(path));
                if(allCaps)
                    text = text.toUpperCase();
                 
                 if(!text.equals(textLast)) {
                     // Glitch out text
                     float textHeight = 2 * (textAscent() + textDescent());
                     
                     // Glitch(boolean progressive, float col, float size, float amount, float colEnd, float speed)
                     Glitch g1 = new Glitch(true, ypos-textHeight, textHeight/2, 10, ypos, 10);
                     Message m1 = new Message(MessageType.GLITCH, g1);
                     messageQueue.add(m1);
                     
                     Glitch g2 = new Glitch(true, ypos-textHeight, textHeight/4, -20, ypos, 15);
                     Message m2 = new Message(MessageType.GLITCH, g2);
                     messageQueue.add(m2);
                     
                     Glitch g3 = new Glitch(true, 0, textHeight/8, 20, ypos, 20);
                     Message m3 = new Message(MessageType.GLITCH, g3);
                     messageQueue.add(m3);
                     
                     textLast = text;
                 }
            } catch(IOException e) {
                // silently ignore
            }
        }
    }
    
    public void draw() {
        textFont(font, textSize);
        fill(1.0f);
        textAlign(CENTER, BOTTOM);
        textLeading(textSize);
        text(text, xpos, ypos);
    }
}