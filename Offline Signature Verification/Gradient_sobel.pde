//write a program that reads two handwritten signature images and compute their similarity

PImage img1;
PImage img2;

void setup() {
float [] grad_4CC_DS_img1= new float[325];
float [] grad_4CC_DS_img2= new float[325];
float Sim=0;

size(381, 132);

img1 = loadImage("mod_Sig.jpg");
loadPixels(); 
img1.loadPixels();
grad_4CC_DS_img1 = gradient_feature(img1);

img2 = loadImage("images.jpg");
loadPixels(); 
img2.loadPixels();
grad_4CC_DS_img2 = gradient_feature(img2);

Sim = Cos_Sim(grad_4CC_DS_img1,grad_4CC_DS_img2); //<>//
println("Cosine Similarity is=" ,Sim );
} 

float [] gradient_feature (PImage img)
{
//Matrices required to in the task to store different values

float [][] gradx= new float[img.height][img.width]; // to store gradient feature vector for x axis
float [][] grady= new float[img.height][img.width]; // to store gradient feature vector for y axis
float [][] grad= new float[img.height][img.width]; // to store gradient feature vector
float [][] angle= new float[img.height][img.width]; //to store gradient feature vector angle
float [] grad_4CC= new float[img.height*img.width*4]; //to store features extracted using Method 1 of Chain Code for 4 elements
float [] grad_4CC_DS= new float[325]; //to store Features after downsampling for Method 1


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

// Decomposition  of Gradient Vector using Method 1 (4 chain Code Direction)

int pos1= 0; // to locate the initial point of the tuple in the array 
for (int k = 1; k < img.height-1; k++) 
{ 
  for (int l = 1; l < img.width-1; l++) 
{ 
  if (angle [k][l] >=0 && angle [k][l] <=PI/2) //Gradient feature vector in 1 quadarant
  {
    pos1 = (k-1)*img.width*4+ (l-1)*4;
    grad_4CC[pos1+1] = grad [k][l]* cos (degrees(angle [k][l]));
    grad_4CC[pos1+2] = grad [k][l]* sin (degrees(angle [k][l]));
    grad_4CC[pos1+3] = 0;
    grad_4CC[pos1+4] = 0;
    
  }
   else if (angle [k][l] > PI/2 && angle [k][l] <=PI) //Gradient feature vector in 2 quadarant
   {
    pos1 = (k-1)*img.width*4+ (l-1)*4;
    grad_4CC[pos1+1] = 0;
    grad_4CC[pos1+2] = grad [k][l]* sin (degrees(angle [k][l]));
    grad_4CC[pos1+3] = -1 * grad [k][l]* cos (degrees(angle [k][l]));
    grad_4CC[pos1+4] = 0; 
     
   }
    else if (angle [k][l] > PI && angle [k][l] <=3*PI/2) //Gradient feature vector in 3 quadarant
    {
    pos1 = (k-1)*img.width*4+ (l-1)*4;
    grad_4CC[pos1+1] = 0;
    grad_4CC[pos1+2] = 0;
    grad_4CC[pos1+3] = (-1)*grad [k][l]* cos (degrees(angle [k][l]));
    grad_4CC[pos1+4] = (-1)*grad [k][l]* sin (degrees(angle [k][l]));
  
    }
    else                                            //Gradient feature vector in 3 quadarant
    {
  pos1 = (k-1)*img.width*4+ (l-1)*4;
    grad_4CC[pos1+1] = grad [k][l]* cos (degrees(angle [k][l]));
    grad_4CC[pos1+2] = 0;
    grad_4CC[pos1+3] = 0;
    grad_4CC[pos1+4] = (-1)*grad [k][l]* sin (degrees(angle [k][l]));
  
    }
}
}

// Downsampling -- converting the image into 9*9 for Method 1
int r1 = img.height/9, r2 = img.width/9*4;
int pos2=0;
int wdt = 1;
       for (int h=1 ; h<= r1*9; h= h+img.height/9) // loop for starting point of block traversing the pixels of  whole image of height*width*4
       {  
       for (int w=1 ; w<= r2*9; w = w+r2){
            float g1 = 0, g2 = 0, g3=0, g4 =0 ; // for storing the sum of tuples for a block of 9*9
            for (int ky = h; ky <= h+r1; ky++)  // loop for calculating sum of tuples for a pixel for a block
            for (int kx = w; kx <= w+r2/4; kx++) {
                pos2= (ky-1)*r2 +(kx-1)*4;
                g1= g1+ grad_4CC[pos2+1];  
                g2= g2+ grad_4CC[pos2+2];
                g3= g3+ grad_4CC[pos2+3];
                g4= g4+ grad_4CC[pos2+4];
            }
            //Writing into the matrix 9*9 for 4 chain code direction
            grad_4CC_DS [wdt] = g1;
            wdt = wdt + 1; 
            grad_4CC_DS [wdt] = g2;
            wdt = wdt + 1;
            grad_4CC_DS [wdt] = g3;
            wdt = wdt + 1;
            grad_4CC_DS [wdt] = g4;
            wdt = wdt + 1;
       }  
       
}
return (grad_4CC_DS);
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
  sim = sim1/(sqrt(sim2)*sqrt(sim3)); //<>//
  
  return sim;
}

     
