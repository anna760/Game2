//SoundFile file;
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer jingle;

PImage scene,drop,leaf,player; // Variable to store information about an image

int drop_x,drop_y,drop_count;
int leaf_x,leaf_y,leaf_count;

float frame=0;
int player_x=400;
int direction=0;

int score=0, lives=3;
int quit_flag=0;

void setup() // Entry point (start of program), runs once
{
  size(800,600,P2D); // Create a Window, must be same size as scene
  
  // Load a soundfile from the data folder of the sketch and play it back in a loop
 minim = new Minim(this);
 jingle = minim.loadFile("music.wav"); // load the music file into memory
 jingle.loop(); // play the file on a loop 
  
 scene = loadImage("Background.bmp"); // load image and data into scene data structure
 drop=loadImage("Drop.png");
 leaf=loadImage("Leaf.png");
 player=loadImage("Running.png");

 textureMode(NORMAL);
 blendMode(BLEND);
 noStroke();
  
 drop_x=166+(int)random(200);
 drop_y=90;

 float radius=random(128);
 float angle=random(2*PI);
 leaf_x=584+(int)(radius*cos(angle));
 leaf_y=216+(int)(radius*sin(angle));
}

void draw()
{
 background(scene); // Display background image referenced by scene
 float left=frame/16;
 float right=(frame+1)/16;
 
 if(direction==1)
 {
   float temp=left;
   left=right;
   right=temp;
 }
 
 pushMatrix(); // Draw player
 translate(player_x,360);
 beginShape();
 texture(player);
 vertex( 0, 0, left, 0);
 vertex(124, 0, right, 0);
 vertex(124, 124, right, 1);
 vertex( 0, 124, left, 1);
 endShape(CLOSE);
 popMatrix(); // Restore origin (top left 0,0)
 
 pushMatrix(); // Store current location of origin (0,0)
 translate(drop_x,drop_y); // Change origin (0,0) for drawing to (drop_x,drop_y)
 beginShape(); // Open graphics pipeline
 texture(drop); // Tell GPU to use drop to texture the polygon
 vertex( -20, -20, 0, 0); // Load vertex data (x,y) and (U,V) texture data into GPU
 vertex(20, -20, 1, 0); // Square centred on (0,0) of width 40 and height 40
 vertex(20, 20, 1, 1); // Textured with an image of a drop
 vertex( -20, 20, 0, 1);
 endShape(CLOSE); // Tell GPU you have loaded shape into memory.
 popMatrix(); // Recover origin(0,0)means top left hand corner again.
 
 pushMatrix(); // Draw leaf
 translate(leaf_x,leaf_y);
 rotate((float)frameCount/10);
 beginShape(); // Draw Leaf
 texture(leaf);
 vertex( -20, -20, 0, 0);
 vertex(20, -20, 1, 0);
 vertex(20, 20, 1, 1);
 vertex( -20, 20, 0, 1);
 endShape(CLOSE);
 popMatrix();
 
 drop_y+=2; // Make "drop" move down the screen (two pixels at a time)
 if(drop_y>475) // If y value is entering the grass line
 {
 drop_x=166+(int)random(200); // Restart the drop again in the cloud.
 drop_y=90;
 lives--;
 }
 
 leaf_y+=1;
 if(leaf_y>475)
 {
 float radius=random(128); // Chose leaf starting position
 float angle=random(2*PI);
 leaf_x=584+(int)(radius*cos(angle));
 leaf_y=216+(int)(radius*sin(angle));
 lives--;
 }
 
 // Move player
 if (keyPressed == true)
{
 if(keyCode == RIGHT)
 {
 direction=1; // To right 
 player_x+=8; // Increase X position move right
 frame++; // Every step advance the frame
 if(frame>16) frame=0; // If frame is 16 reset it to 0
 }

 if (keyCode == LEFT)
 {
 direction=0; //Set direction to left
 player_x-=8; // Decrease X position move left
 frame++;
 if(frame>16) frame=0;
 }
}
 
 if ((drop_y>368)&&(drop_y<470)) // If drop is on same level as player
 {
  if(abs((drop_x+10)-(player_x+62))<25) // And drop is near player
  {
   drop_count++; // Increase drop count by one (caught)

   drop_x=166+(int)random(200); // Restart a new drop in the cloud
   drop_y=90;
  }
}

 if ((leaf_y>368)&&(leaf_y<470)) // If leaf is on same level as player
{
 if(abs((leaf_x+10)-(player_x+62))<25) // And leaf is near player
 {
   leaf_count++; // Increase leaf count by one (caught)

   float radius=random(128); // Chose leaf starting position
   float angle=random(2*PI);
   leaf_x=584+(int)(radius*cos(angle));
   leaf_y=216+(int)(radius*sin(angle));
  }
} 

 textSize(18); // Display score information on the screen
 fill(0,0,255);
 text("Drop:"+drop_count, 540, 20);

 fill(0,255,0);
 text("Leaf:"+leaf_count, 620, 20); 
 
 fill(255,0,0);
 text("Lives:"+lives, 700, 20);

 fill(0,0,0);
 text("Score:"+score, 620, 60);

 // Scoring and game logic
 if (lives<1) text("Game over", 120, 300); // Score of 0 display game over
 score++;

 if(leaf_count>5) // Every five leaves increase lives by one
 {
 leaf_count-=5;
 lives++;
 }

 if(drop_count>5) // Every five drops increase lives by one
 {
 drop_count-=5;
 lives++;
 }

 if(quit_flag==1) // Wait five seconds before exiting
 {
 delay(5000);
 exit();
 }

 if (lives<1) // All lives lost so game over but
 { // return to draw one more time to
 quit_flag=1; // allow "Game Over to be displayed.
 } 
}