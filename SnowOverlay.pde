class SnowOverlay implements Overlay {
    private ArrayList<Snowflake> snowflakes;
    private int fallInterval = 4; // update()s per snowflake
    private int lastFall = 0;
    private float speedMultiplier = 0.03;
    private ArrayList<Message> messageQueue;
   
    public SnowOverlay(ArrayList<Message> messageQueue) {
        this.messageQueue = messageQueue;
        snowflakes = new ArrayList<Snowflake>();
    }
   
    public void update() {
        if(lastFall == 0) {
            snowflakes.add(new Snowflake(speedMultiplier));
            lastFall = fallInterval;
        } else lastFall--;
       
        for(int i = 0; i < snowflakes.size(); i++) {
            if(snowflakes.get(i).y > height)
                snowflakes.remove(i);
            else
                snowflakes.get(i).update();
        }
    }
   
    public void draw() {
        for(int i = 0; i < snowflakes.size(); i++) {
            snowflakes.get(i).draw();
        }
    }
   
    private class Snowflake {
        public float x;
        public float y;
        public float vx;
        public float vy;
        public float fallSpeed;
       
        public Snowflake(float _fallSpeed) {
            this.fallSpeed = _fallSpeed;
            x = random(0, width);
            y = 0;
            vx = random(-5, 5);
            vy = random(10, 50) * this.fallSpeed;
        }
       
        public void update() {
            x += vx;
            y += vy;
        }
       
        public void draw() {
            noStroke();
            for(float i = 10; i > 0; i--) {
                fill(color(0xffffff, (10-i)/100f));
                ellipse(x, y, ((i+1)/11.0f)*(vy/fallSpeed)/2, ((i+1)/11.0f)*(vy/fallSpeed)/2);
            }
        }
    }
}