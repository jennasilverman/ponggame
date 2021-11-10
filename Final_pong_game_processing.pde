import processing.serial.*;

Serial myPort;

Ball ball;
Paddle player1;
Paddle player2;

int pot1 = 0;
int pot2 = 0;

int player1Score = 0;
int player2Score = 0;

void setup() {
  println(Serial.list());
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort  =  new Serial (this, "/dev/cu.usbmodem144101",  9600); // Set the com port and the baud rate according to the Arduino IDE

  myPort.bufferUntil('\n');
  
  size(1000, 700);
  background(5);
  fill(107, 5, 27);
  ball = new Ball();
  player1 = new Paddle(1);
  player2 = new Paddle(2);
  textSize(80);
}

void draw() {
  background(1, 102, 11);
  ball.update();
  ball.display();
  player1.update();
  player1.display();
  player2.update();
  player2.display();
  
  text(player1Score, width/2-50, 100);
  text(player2Score, width/2+50, 100);
}

void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    int[] sensors = int(split(inString, ","));
    if (sensors.length >= 2) {
      pot1 = sensors[0];
      pot2 = sensors[1];
    }
    
  }
  
  
}

class Ball {
  PVector position;
  PVector vel;
  
  Ball() {
    position = new PVector(width/2, height/2);
    vel = new PVector(9, random(-5,5));
  }
  
  void contact() {
    position.x = position.x - vel.x;
    vel = new PVector(-vel.x, random(-5,5));
  }
  
  void update() {
    if (position.x < 0) {
      player2Score++;
      position = new PVector(width/2, height/2);
      vel = new PVector(-9, random(-5,5));
    }
    if (position.x > width) {
      player1Score++;    
      position = new PVector(width/2, height/2);
      vel = new PVector(9, random(-5,5));
    }
    if (position.y < 0 || position.y > height) {
      vel.y = -vel.y;
    }
    position.add(vel);
  }
  
  void display() {
    rectMode(CENTER);
    rect(position.x, position.y, 20, 20);
  }
  
}

class Paddle {
  int numberOfPlayer;
  float x;
  float y;
  
  Paddle(int player) {
    numberOfPlayer = player;
    if (numberOfPlayer == 1) {
      x = 30;
    } else if (numberOfPlayer == 2) {
      x = width - 30;
    }
    y = height/2;
  }
  
  void update() {
    //y = mouseY;
    if (numberOfPlayer == 1) {
      y = map(pot1, 0, 1024, 0, height);
    } else if (numberOfPlayer == 2) {
      y = map(pot2, 0, 1024, 0, height);
    }
    
    if (ball.position.x > x-10 && ball.position.x < x+10) {
       if (ball.position.y > y-50 && ball.position.y < y+50) {
          ball.contact(); 
       }
    }    
  }
  
  void display() {
    rectMode(CENTER);
    rect(x,y,20,100);
  }
  
}

//resources: https://github.com/hjlam1/Pong-ProcessingArduino/blob/master/Pong/Pong.pde
//https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing/all
//https://www.instructables.com/Pong-With-Processing/
//https://www.youtube.com/watch?v=m6H6SHIdAhQ
