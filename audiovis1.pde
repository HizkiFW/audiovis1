Background bg;
ArrayList<Message> overlayMessageQueue;
 
void setup() {
    // replace with fullScreen() to go fullscreen
    size(1280, 720, P2D);
    //fullScreen(P2D, 2)
    smooth();
    frameRate(60);
    colorMode(RGB, 1.0f);
    
    overlayMessageQueue = new ArrayList<Message>();
    
    bg = new Background();
    bg.overlays.add(new SoundGraphOverlay(overlayMessageQueue, this));
    bg.overlays.add(new SnowOverlay(overlayMessageQueue));
    bg.overlays.add(new TextOverlay(overlayMessageQueue, "D:/EZWorship.txt"));
    bg.overlays.add(new GlitchOverlay(overlayMessageQueue));
}
 
float circle_size = 0;
int size_increasing = 0;
 
void draw() {
    background(0);
    fill(1);
    
    bg.update();
    bg.draw();
}