import processing.sound.*;

class SoundGraphOverlay implements Overlay {
    
    private FFT fft;
    private Amplitude amp;
    private AudioIn ain;
    
    float min_size = 200;
    float threshold = 0.1;
    int bass_range = 5;
     
    int scale = 1,
        bands = 128,
        b_mult = 8;
     
    float r_width;
    float[] spectr = new float[bands*b_mult];
    float ave;
    float smooth_factor = .2;
    
    public SoundGraphOverlay(ArrayList<Message> messageQueue, PApplet sketch) {
        r_width = width/float(bands);
        ain = new AudioIn(sketch, 0);
        ain.start();
        fft = new FFT(sketch, bands*b_mult);
        fft.input(ain);
        amp = new Amplitude(sketch);
        amp.input(ain);
    }
    
    public void update() {
        fft.analyze(spectr);
        
        // Bass avg amplitude
        int divisor = bass_range + 2; // +2 because one is to divide the average and the other one to keep it going down
        for(int i = 0; i < bass_range; i++) {
            if(spectr[i] > threshold)
                ave += spectr[i];
             else
                 divisor--;
        }
        ave /= divisor;
        if(ave > circle_size) {
            circle_size = (circle_size + ave*3) / 4;
            size_increasing = 2;
        } else {
            if(size_increasing > 0)
                size_increasing--;
            else
                circle_size *= .9;
        }
    }
    
    public void draw() {
        for(int i = 0; i < bands-1; i++) {
            int j = i; // * b_mult;
            // Smooth FFT data
            spectr[j] += (fft.spectrum[j] - spectr[j]) * smooth_factor;
            
            // Draw FFT
            stroke(1);
            strokeWeight(1);
            line(i*r_width, (spectr[i])*height*scale, (i+1)*r_width, (spectr[i+1])*height*scale);
            //text(i, i*r_width, 10+(10*(i%4)));
        }
        
        fill(color(0xffffff, 0.05f));
        //ellipse(width/2, height/2, circle_size*height*scale+min_size, circle_size*height*scale+min_size);
    }
}