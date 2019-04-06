//it performs the preprocessing of the given images such as converting to grayscale and Contrast stretching

PImage img = loadImage("Meghna.jpg");
size(1280, 832);
loadPixels(); 
img.loadPixels();
 
 int[] h = new int [256];
int[] heq = new int [256];

 // gray scale conversion and contrast stretching
for (int y = 0; y < img.height; y++)
  for (int x = 0; x < img.width; x++) {
    int imgIndex = x + y * img.width;
    int r = int(brightness(img.pixels[imgIndex]));
    pixels[imgIndex] =  color(r);
   h[r]++;
  }
  int temp =0;
  for(int i=0; i<256; i++)
  {
    temp+= h[i];
   heq[i] = (int) 255* temp/(img.width *img.height); 
    
  } 
for (int y=0; y<img.height; y++) //reading the image
  for (int x=0; x<img.width; x++)
  {
    int imgIndex = x+y*img.width; //setting the pixel position in 1D array
    int r = int (brightness(img.pixels[imgIndex]));//taking the color of the picture in img.pixel
   pixels [imgIndex] = color (heq[r]);
  }

updatePixels() ;
 save("mod_Sig1.jpg");
