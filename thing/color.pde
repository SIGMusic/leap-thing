import java.awt.Color.*;

float[] HSBtoRGB(float h, float s, float b){
    h = h /H_MAX;
    s = s / S_MAX;
    b = b / B_MAX;
    java.awt.Color c = java.awt.Color.getHSBColor(h, s, b);
    float[] rgb = new float[3];
    rgb[0] = c.getRed();
    rgb[1] = c.getGreen();
    rgb[2] = c.getBlue();
    return rgb;
}
