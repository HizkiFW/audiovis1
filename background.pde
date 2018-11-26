class Background {
   
    public ArrayList<Overlay> overlays;
    public PImage wallpaper;
   
    public Background() {
        overlays = new ArrayList<Overlay>();
    }
   
    public void update() {
        for(int i = 0; i < overlays.size(); i++) {
            overlays.get(i).update();            
        }
    }
   
    public void draw() {
        for(int i = 0; i < overlays.size(); i++) {
            overlays.get(i).draw();            
        }
    }
}
 
public interface Overlay {
    public void update();
    public void draw();
}