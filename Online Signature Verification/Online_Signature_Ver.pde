String [] signature1;
String [] signature2;
int index=1;

void setup()
{
signature1=loadStrings("U1S7.TXT");
signature2=loadStrings("U1S1.TXT");
String Str1 = StrEle (signature1);
String Str2 = StrEle (signature2);
float Min_Dis = LD(Str1,Str2); //<>//
println (Min_Dis);
}


// function to represent signature as a string
String StrEle (String [] signature)
{
int [] XCor = new int[signature.length];
int [] YCor = new int[signature.length];
String [] XStr = new String[signature.length];
String [] YStr = new String[signature.length];

//loop to store the values for X and Y coordinates
while (index<signature.length){
String[]coordinates=split(signature[index],' ');
if(coordinates.length>=2){
int x=int(coordinates[0])/20;
int y=int(coordinates[0])/20;
XCor[index] = x;
YCor[index] = y;
index = index+1;
}
}

// loop for calculating the string of X coordinates of the signature
for (int i = 1; i<signature.length; i++)
{
  if (i == 1)  //for the first element
 {   if (XCor[i] > XCor[i+1])
        XStr[i] = "Xmax";
    else if (XCor[i] < XCor[i+1])
        XStr[i] = "Xmin";
    else if (XCor[i] == XCor[i+1] && XCor[i+1] < XCor[i+2])
        XStr[i] = "Xmin";
    else
        XStr[i] = "Xmax";
 }
   
   else if (i == signature.length -1) //for the last element
{    if (XCor[i] > XCor[i-1])
        XStr[i] = "Xmax";
    else if (XCor[i] < XCor[i-1])
        XStr[i] = "Xmin";
    else if (XCor[i] == XCor[i-1] && XCor[i-1] < XCor[i-2])
        XStr[i] = "Xmin";
    else
        XStr[i] = "Xmax";  
}       
    else // for rest of the list
 {    if (XCor[i] < XCor[i-1] && XCor[i] < XCor[i+1])
        XStr[i] = "Xmin";
      else if (XCor[i] > XCor[i-1] && XCor[i] > XCor[i+1])
        XStr[i] = "Xmax";
      else
        XStr[i] = "0";
 }
}

// for calculating the string of Y cordinates of the image
for (int i = 1; i<signature.length; i++)
{
  if (i == 1)  //for the first element
 {   if (YCor[i] > YCor[i+1])
        YStr[i] = "Ymax";
    else if (YCor[i] < YCor[i+1])
        YStr[i] = "Ymin";
    else if (YCor[i] == YCor[i+1] && YCor[i+1] < YCor[i+2])
        YStr[i] = "Ymin";
    else
        YStr[i] = "Ymax";
 }
   
   else if (i == signature.length -1) //for the last element
{    if (YCor[i] > YCor[i-1])
        YStr[i] = "Ymax";
    else if (YCor[i] < YCor[i-1])
        YStr[i] = "Ymin";
    else if (YCor[i] == YCor[i-1] && YCor[i-1] < YCor[i-2])
        YStr[i] = "Ymin";
    else
        YStr[i] = "Ymax";  
}       
    else //for rest of the image
 {    if (YCor[i] < YCor[i-1] && YCor[i] < YCor[i+1])
        YStr[i] = "Ymin";
      else if (YCor[i] > YCor[i-1] && YCor[i] > YCor[i+1])
        YStr[i] = "Ymax";
      else
        YStr[i] = "0";
 }
}

// merging the strings for X and Y coordinates of the signature file
for (int i = 1; i<signature.length; i++)
{
  XStr[i] = XStr[i]+YStr[i];
    if (XStr[i].equals("Xmin") == true)
      XStr[i] = "a";
    else if (XStr[i].equals("Xmax") == true)
      XStr[i] = "b";   
    else if (XStr[i].equals("Ymin") == true)
      XStr[i] = "c";
    else if (XStr[i].equals("Ymax") == true)
      XStr[i] = "d";
    else if (XStr[i].equals("XminYmin") == true)
      XStr[i] = "e";
    else if (XStr[i].equals("XminYmax") == true)
      XStr[i] = "f";
    else if (XStr[i].equals("XmaxYmin") == true)
      XStr[i] = "g";
    else if (XStr[i].equals("XmaxYmax") == true)
      XStr[i] = "h";
    else 
      XStr[i] = "0";
}

String Str = ""; // string to obtain only non zero values of the string array
for (int i = 1; i<signature.length; i++)
{
  if (XStr[i].equals ("0") == false)
  Str = Str+XStr[i];
}

return Str; // returns the string representing the signature
}


//Function to calculate minimum edit distance
float LD (String Strg1, String Strg2)
{
 float [][] dist= new float[Strg1.length()+1][Strg2.length()+1]; 
  
 //initialising the array along y axis
  for (int row = 0; row<= Strg1.length(); row++ )  
  {
    if (row == 0)
    dist [0][0] = 0;
    else   
{ char s= Strg1.charAt(row-1);
  if (s == 'a' || s == 'b' || s == 'c' || s == 'd' )
      dist [row][0]= dist [row-1][0]+1;
     else
      dist [row][0]= dist [row-1][0]+2;
}
  }
  
  //initialising the array along y axis 
  for (int col = 0; col<= Strg2.length(); col++ )  
  {
    if (col == 0)
    dist [0][0] = 0;
    else   
{ char s= Strg2.charAt(col-1);
  if (s == 'a' || s == 'b' || s == 'c' || s == 'd')
      dist [0][col]= dist [0][col]+1;
     else
      dist [0][col]= dist [0][col-1]+2;
}
  }
 // code for calculating the values of minimum edit distance table 
  for (int row = 0; row< Strg1.length(); row++ )  
      for (int col = 0; col< Strg2.length(); col++ )
  {
       char a = Strg1.charAt(row);
       char b = Strg2.charAt(col);
       int edit = 0, del = 0, ins= 0;
       
       if (a== b) //when the characters are equal
       { edit =0;
         if ((a == 'a' || a == 'b' || a == 'c' || a == 'd' ) && (b == 'a' || b == 'b' || b == 'c' || b == 'd'))
       {
       del = 1;
       ins = 1;
       }
       else
       {
       del = 2;
       ins = 2;
       }
       }
       else   // when the charactes are not equal
       { // assigning the value of cost for insert, delete and edit
       if ( a == 'a') 
        {  if(b == 'b' || b == 'c' ||b == 'd' ||b == 'e' ||b == 'f')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
       else if ( a == 'b')
        {  if(b == 'a' || b == 'c' ||b == 'd' ||b == 'g' ||b == 'h')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
       else if ( a == 'c')
        {  if(b == 'a' || b == 'b' ||b == 'd' ||b == 'g' ||b == 'e')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
       else if ( a == 'd')
        {  if(b == 'a' || b == 'c' ||b == 'b' ||b == 'f' ||b == 'h')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
       else if ( a == 'e')
        {  if(b == 'a' || b == 'c')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
       
       else if ( a == 'f')
        {  if(b == 'a' || b == 'd')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
        
        else if ( a == 'g')
        {  if(b == 'b' || b == 'c')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
        }
        
        else
        {  if(b == 'b' || b == 'd')
          {
           edit = 1; del = 1; ins =1;
          }
          else
          {
           edit =2; ins = 2; del = 2;
          }
         }
    } // end of else
     //string the minimum value
    dist[row+1][col+1] = min(dist[row][col+1]+ins,dist[row+1][col]+del,dist[row][col]+edit);  
   
} // end for for loop
//println (dist[Strg1.length()][Strg2.length()]);
//println(Strg1.length());
//println(Strg2.length());
float Nor_Dist = dist[Strg1.length()][Strg2.length()]/(Strg1.length()+Strg2.length());
 return (Nor_Dist) ; 
}
