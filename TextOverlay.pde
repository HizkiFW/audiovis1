import java.nio.file.*;

class TextOverlay implements Overlay {
    private float xpos = Config.textPosX;
    private float ypos = Config.textPosY;
    
    private final float textSizeOriginal = Config.fontSize;
    private float textSize = Config.fontSize;
    private float textSizeAuto = Config.fontSize;
    private boolean textAutoSize = false;
    private boolean allCaps = true;
    private int textFadeOutDuration = 5;
    
    private String fileLocation;
    private String text;
    private String textLast;
    private PFont font;
    private int skipTextUpdates = 0;
    
    private ArrayList<Message> messageQueue;
    
    public TextOverlay(ArrayList<Message> messageQueue) {
        this(messageQueue, null);
    }
    public TextOverlay(ArrayList<Message> messageQueue, String fileLocation) {
        this.messageQueue = messageQueue;
        this.fileLocation = fileLocation;
        text = "";
        font = createFont(Config.fontFile, textSize);
    }
    
    private void autoSize() {
        if(text.trim().length() < 1)
          return;
        while(textWidth(text) < width*.9) {
            textSize++;
            textSize(textSize);
        }
        while(textWidth(text) > width*.9) {
            textSize--;
            textSize(textSize);
        }
        Config.fontSize = textSize;
        textSizeAuto = textSize;
    }
    
    public void update() {
        
        if(messageQueue.size() > 0) {
            Message m = messageQueue.get(0);
            if(messageQueue.get(0).type == MessageType.FONT_SIZE) {
                textSize = (float) m.message;
            } else if(messageQueue.get(0).type == MessageType.TEXT_POSITION) {
                xpos = ((float[]) m.message)[0];
                ypos = ((float[]) m.message)[1];
            } else if(messageQueue.get(0).type == MessageType.TEXT_AUTOSIZE) {
                textAutoSize = !textAutoSize;
                if(!textAutoSize) {
                    Config.fontSize = textSizeOriginal;
                    textSize = textSizeOriginal;
                } else autoSize();
            }
        }
        
        if(textAutoSize)
            textSize = textSizeAuto;
        
        if(fileLocation != null) {
            Path path = Paths.get(fileLocation);
            try {
                String textFile = new String(Files.readAllBytes(path));
                
                skipTextUpdates--;
                if(text.trim().length() > 0 && textFile.trim().length() < 1 && skipTextUpdates < 0) {
                    skipTextUpdates = textFadeOutDuration;
                }
                    
                if(skipTextUpdates < 1 || textFile.trim().length() > 0) {
                    text = textFile;                    
                }
                
                if(allCaps)
                    text = text.toUpperCase();
                 
                 if(!text.equals(textLast) || skipTextUpdates == textFadeOutDuration) {
                     // Glitch out text
                     float textHeight = 2 * textSize;
                     
                     // Glitch(boolean progressive, float col, float size, float amount, float colEnd, float speed)
                     Glitch g1 = new Glitch(true, ypos-textHeight, textHeight/2, 30, ypos, 10);
                     Message m1 = new Message(MessageType.GLITCH, g1);
                     messageQueue.add(m1);
                     
                     Glitch g2 = new Glitch(true, ypos-textHeight, textHeight/4, -40, ypos, 15);
                     Message m2 = new Message(MessageType.GLITCH, g2);
                     messageQueue.add(m2);
                     
                     //Glitch g3 = new Glitch(true, 0, textHeight/8, 50, ypos, 20);
                     //Message m3 = new Message(MessageType.GLITCH, g3);
                     //messageQueue.add(m3);
                     
                     // Resize text
                     if(textAutoSize)
                         autoSize();
                     
                     textLast = text;
                 }
            } catch(IOException e) {
                // silently ignore
            }
        }
    }
    
    public void draw() {
        textFont(font, textSize);
        textAlign(CENTER, CENTER);
        textLeading(textSize*Config.lineSpacing);
        //fill(1.0f);
        text(text, xpos, ypos);
    }
}