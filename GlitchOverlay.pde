class GlitchOverlay implements Overlay {
    
    private ArrayList<Glitch> glitches;
    private ArrayList<Message> messageQueue;
    
    public GlitchOverlay(ArrayList<Message> messageQueue) {
        this.messageQueue = messageQueue;
        glitches = new ArrayList<Glitch>();
    }
    
    public void makeGlitch(Glitch glitch) {
        glitches.add(glitch);
    }
    
    public void update() {
        // Check message queue
        if(messageQueue.size() > 0 && messageQueue.get(0).type == MessageType.GLITCH) {
            Message m = messageQueue.remove(0);
            makeGlitch((Glitch) m.message);
        }
        
        // Occasional glitch
        if(millis() % 3000 < 50) {
            makeGlitch(new Glitch(true, random(0, 10), 10, 20, height, 20));
        }
        if(millis() % 7000 < 50) {
            makeGlitch(new Glitch(true, random(0, 10), 10, -20, height, 20)); 
        }
    }
    
    public void draw() {
        
        // Occasional turbulence
        if(millis() % 10000 < 5000)
            glitch(0, height*(millis()%5000)/5000, 5, false);
        
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
    }
    
    private void glitch(float col, float size, float amount, boolean progressive) {
        // arrayCopy(src, srcPosition, dst, dstPosition, length)
        loadPixels();
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
        updatePixels();
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