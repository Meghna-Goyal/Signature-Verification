//write a program that reads two handwritten signature images and compute their similarity

PImage img1;
PImage img2;

void setup() {
float [] grad_32CC_DS_img1= new float[2593];
float [] grad_32CC_DS_img2= new float[2593];
float Sim=0;

size(381, 132);

img1 = loadImage("images.jpg");
loadPixels(); 
img1.loadPixels();
grad_32CC_DS_img1 = gradient_feature(img1);

img2 = loadImage("images.jpg");
loadPixels(); 
img2.loadPixels();
grad_32CC_DS_img2 = gradient_feature(img2);

Sim = Cos_Sim(grad_32CC_DS_img1,grad_32CC_DS_img2); //<>//
println("Cosine Similarity is=" ,Sim );
} 

float [] gradient_feature (PImage img)
{
//Matrices required to in the task to store different values

float [][] gradx= new float[img.height][img.width]; // to store gradient feature vector for x axis
float [][] grady= new float[img.height][img.width]; // to store gradient feature vector for y axis
float [][] grad= new float[img.height][img.width]; // to store gradient feature vector
float [][] angle= new float[img.height][img.width]; //to store gradient feature vector angle
float [] grad_32CC= new float[img.height*img.width*32]; //to store features extracted using Method 1 of Chain Code for 4 elements
float [] grad_32CC_DS= new float[2593]; //to store Features after downsampling for Method 1


float[][] fx =      {{ -1,  0, 1 }, 
                    { -2, 0, 2 }, 
                    { -1,  0, 1 }};
                    
float[][] fy =      {{ -1,  -2, -1 }, 
                    { 0, 0, 0 }, 
                    { 1,  2, 1 }};
                    
for (int y = 1; y < img.height-1; y++) 
  for (int x = 1; x < img.width-1; x++) {
    float gx = 0, gy = 0 ; 
    for (int ky = -1; ky <= 1; ky++) 
      for (int kx = -1; kx <= 1; kx++) {
        int index = (y + ky) * img.width + (x + kx);
        float r = brightness(img.pixels[index]);
        gx += fx[ky+1][kx+1] * r;
        gy += fy[ky+1][kx+1] * r;
      }
      gradx [y][x] = gx;
      grady [y][x] = gy;
      grad [y][x] = sqrt(sq(gx) + sq(gy) );  //Gradient feature (Intensity)
  }


//to calculate the angles of the Gradient Feature vector
// checking all the possible values for the angles, evaluating and storing them in the 2D array

for (int h = 1; h < img.height-1; h++) 
  for (int w = 1; w < img.width-1; w++) 
{    
  if (gradx[h][w] >0)
  angle [h][w] = atan(grady[h][w]/gradx[h][w]);
  else if (gradx[h][w] <0)
   angle [h][w] = atan(grady[h][w]/gradx[h][w])+PI;
  else if (gradx[h][w] ==0 && grady[h][w] >0)
  angle [h][w] = PI/2;
   else if (gradx[h][w] ==0 && grady[h][w] <0)
   angle [h][w] = 3*PI/2;
   else if (grady[h][w] ==0 && gradx[h][w] >0)
  angle [h][w] = 0;
  else
  //else if (grady1[h][w] ==0 && gradx1[h][w] <0)
   angle [h][w] = PI;
  
  // for checking the values of negative angles
   if (angle [h][w] <0)
   angle [h][w] = angle [h][w] + 2*PI;
}

// Decomposition of Gradient Vector using Method 2 (32 chain Code Direction)
int x=1;
for (int k = 1; k < img.height-1; k++) 
  for (int l = 1; l < img.width-1; l++) 
{
  int pos = int(angle [k][l]/11.25);
  pos = pos+1; // to make first element as (1,1)
  pos = pos +(k-1)*img.width*32+ (l-1)*32; // to get the position of the non zero element of chain code
   for (int i=x; i<32+x; i++) // assigning the values of elements in the tuples 
   {
     if (i == pos)
     grad_32CC [i] = grad [k][l];
      else
      grad_32CC [i] = 0;  
   }
   x =x+32;
   
}


// Downsampling -- converting the image into 9*9 for Method 2
int r3 = img.height/9, r4 = img.width/9*32;
int pos3=0;
int wdt1 = 1;
float [] g= new float[33];             // for storing the sum of tuples for a block of 9*9
       for (int h=1 ; h<= r3*9; h= h+img.height/9) // loop for starting point of block traversing the pixels of  whole image of height*width*32 
       for (int w=1 ; w<= r4*9; w = w+r4){
            for (int ky = h; ky <= h+r3; ky++)  // loop for calculating sum of tuples for a pixel for a block
            for (int kx = w; kx <= w+r4/32; kx++) {
                pos3= (ky-1)*r4 +(kx-1)*32;
                int ind=1;
                for (int i = pos3+1 ; i<=pos3+32; i++) //for storing the sum of elements in the tuples
                {
                  g[ind] = g[ind] + grad_32CC[i];
                }
                
            }
            //Writing into the matrix 9*9 for 32 chain code direction
            for (int ind1 = 1 ; ind1<=32; ind1++)
                {
                  grad_32CC_DS [wdt1] = g[ind1];
                  wdt1 = wdt1 + 1;
                  g[ind1] =0;
                  
                }
              
 }
return (grad_32CC_DS);
}

float Cos_Sim(float [] grad_1, float [] grad_2)
{
  float sim1 =0.0, sim3 =0.0, sim2 =0.0, sim =0.0;
  
  for (int i = 1; i<325; i++)
  {
    sim1 = sim1 + grad_1[i]*grad_2[i];
    sim2 = sim2 + sq(grad_1[i]);
    sim3 = sim3 + sq(grad_2[i]);
  }
  sim = sim1/(sqrt(sim2)*sqrt(sim3));
  
  return sim;
}
