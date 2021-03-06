class GlitchOverlay implements Overlay {
    
    private ArrayList<Glitch> glitches;
    private ArrayList<Message> messageQueue;
    private float multiplier;
    
    public GlitchOverlay(ArrayList<Message> messageQueue) {
        this.messageQueue = messageQueue;
        glitches = new ArrayList<Glitch>();
        multiplier = 1;
    }
    
    public void makeGlitch(Glitch glitch) {
        glitches.add(glitch);
    }
    
    public void update() {
        // Check message queue
        if(messageQueue.size() > 0) {
            Message m = messageQueue.get(0);
            if(messageQueue.get(0).type == MessageType.GLITCH) {
                makeGlitch((Glitch) m.message);
                glitchText();
                glitchColors();
            } else if(messageQueue.get(0).type == MessageType.GLITCHINESS) {
                multiplier = (float) m.message;
            } else if(messageQueue.get(0).type == MessageType.GLITCH_COLORS) {
                glitchColors();
            } else if(messageQueue.get(0).type == MessageType.ULTRAGLITCH) {
                glitchText();
                glitchText();
                glitchText();
                glitchText();
                glitchText();
                glitch(5, height-10, random(10, 20), true);
                makeGlitch(new Glitch(true, 0, 50, 500*(floor(random(0, 2)) == 0 ? -1 : 1), height, 20));
                makeGlitch(new Glitch(true, 5, 50, 500*(floor(random(0, 2)) == 0 ? -1 : 1), height, 15));
                makeGlitch(new Glitch(true, 10, 50, 500*(floor(random(0, 2)) == 0 ? -1 : 1), height, 10));
                glitchColors();
            }
        }
        
        // Occasional glitch
        if(millis() % 3000 < 30 * multiplier) {
            makeGlitch(new Glitch(false, random(0, 10), 10, 20, height, 20));
        }
        if(millis() % 7000 < 30 * multiplier) {
            makeGlitch(new Glitch(false, random(0, 10), 10, -20, height, 20)); 
        }
        
        // FRICKIN WILD GLITCHAZZ!!
        if(millis() % 250 < 30 * multiplier) {
            makeGlitch(new Glitch(false, random(5, 15), 20, random(-1, 1)*50, height, random(15, 30)));
        }
        
        if(random(1, 100) < 5 * multiplier && multiplier > 0.5) {
            glitchText();
        }
    }
    
    public void draw() {
        loadPixels();
        
        // Occasional turbulence
        if(millis() % 10000 < 5000)
            glitch(0, height*(millis()%5000)/5000, 20, false);
        
        if(glitches.size() > 0) {
            for(int i = 0; i < glitches.size(); i++) {
                Glitch g = glitches.get(i);
                glitch(g.col, g.size, g.amount, g.progressive);
                
                glitches.get(i).col += glitches.get(i).speed;
                if(glitches.get(i).col > glitches.get(i).colEnd) {
                    glitches.remove(i);
                }
            }
        }
        
        updatePixels();
    }
    
    private void glitch(float col, float size, float amount, boolean progressive) {
        // arrayCopy(src, srcPosition, dst, dstPosition, length)
        amount *= multiplier;
        if(progressive) {
            for(int i = (int) size; i > 1; i /= 2) {
                try {
                    arrayCopy(pixels, Math.round(width*(col+(size-i))), pixels, Math.round(width*(col+(size-i)) + amount), Math.round(width*i));
                } catch(ArrayIndexOutOfBoundsException e) {
                    // Ignore ArrayIndexOutOfBoundsException
                }
            }
        } else {
            try {
                arrayCopy(pixels, Math.round(width*(col)), pixels, Math.round(width*(col) + amount), Math.round(width*size));
            } catch(ArrayIndexOutOfBoundsException e) {
                // Ignore ArrayIndexOutOfBoundsException
            }
        }
        
        if(random(0, 100) < 2*multiplier && multiplier > 0.7) {
            glitchColors();
        }
    }
    
    private void glitchText() {
        messageQueue.add(new Message(MessageType.FONT_SIZE, Config.fontSize * random(1.0f, multiplier*3.0f)));
        messageQueue.add(new Message(MessageType.FONT_SIZE, Config.fontSize));
        
        messageQueue.add(new Message(MessageType.GLITCH_COLORS, null));
        
        messageQueue.add(new Message(MessageType.TEXT_POSITION, new float[] {random(0, width), random(0, height)}));
        messageQueue.add(new Message(MessageType.TEXT_POSITION, new float[] {Config.textPosX, Config.textPosY}));
    }
    
    private void glitchColors() {
        float rand_y = random(-1.0f, 1.0f);
        PImage screen = get();
        blendMode(SCREEN);
        tint(0, 0.5, 1);
        image(screen, 100*multiplier, 10*multiplier*rand_y);
        tint(1, 0.25, 0);
        image(screen, -100*multiplier, -10*multiplier*rand_y);
        noTint();
        blendMode(REPLACE);
    }
}

public class Glitch {
    // Glitch parameters
    public boolean progressive;
    public float col, size, amount;
    
    // Automation
    public float colEnd;
    public float speed;
    
    public Glitch() {
        
    }
    
    public Glitch(boolean progressive, float col, float size, float amount, float colEnd, float speed) {
        this.progressive = progressive;
        this.col = col;
        this.size = size;
        this.amount = amount;
        this.colEnd = colEnd;
        this.speed = speed;
    }
}