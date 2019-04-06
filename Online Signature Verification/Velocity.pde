String [] signature;

int index=1;

signature=loadStrings("U1S7.TXT");

//Arrays required to store the values for velocity, acceleration and direction
int [] Xvelocity = new int[signature.length];
int [] Yvelocity = new int[signature.length];
int [] Xacc = new int[signature.length];
int [] Yacc = new int[signature.length];
String [] Xdir = new String[signature.length];;
String [] Ydir = new String[signature.length];;


while (index<signature.length-1){
String[]coordinates=split(signature[index],' ');
String[]coordinates1=split(signature[index+1],' ');
if(coordinates.length>=2){
int x1=int(coordinates[0])/20;
int x2=int(coordinates1[0])/20;
int y1=height - int(coordinates[0])/20;
int y2=height - int(coordinates1[0])/20;
int x = x2-x1;
int y = y2-y1;

// for calculating the values for Velocity
Xvelocity[index+1] = x; //<>//
Yvelocity[index+1] = y;   //<>//

// for calculating the values for Direction
if (Xvelocity[index+1] >0)
Xdir[index+1] = "Right";
else
Xdir[index+1] = "Left";

if (Yvelocity[index+1] >0)
Ydir[index+1] = "Up";
else
Ydir[index+1] = "Down";
index = index+1;
}
}

// loop for calculating the values for acceleration
 for (int i = 2; i<signature.length-1; i++)
 {
   Xacc[i+1] = Xvelocity [i+1] - Xvelocity[i];
   Yacc[i+1] = Yvelocity [i+1] - Yvelocity[i];
 } 
 
 // for printing the values for velocity, acceleration and direction
 println ( " \tXVel\tYVel\tXAcc\tYAcc\tXDir\tYDir\n");
 for (int i = 1; i<signature.length; i++)
 {
  println ( i , "\t" +Xvelocity [i], "\t" +Yvelocity [i], "\t" + Xacc[i], "\t" + Yacc[i], "\t" + Xdir[i],  "\t" + Ydir[i]);
 }
