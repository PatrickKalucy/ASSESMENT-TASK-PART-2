// P_3_1_3_02.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * analysing and sorting the letters of a text 
 * connecting subsequent letters with lines
 *
 * MOUSE
 * position x          : interpolate between normal text and sorted position
 *
 * KEYS
 * 1                   : toggle lines on/off
 * 2                   : toggle text on/off
 * 3                   : switch all letters off
 * 4                   : switch all letters on
 * a-z                 : switch letter on/off
 * ctrl                : save png + pdf
 */

import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

PFont font;
String[] lines;
String joinedText;

String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß,.;:!? ";
int[] counters = new int[alphabet.length()];
boolean[] drawLetters = new boolean[alphabet.length()];

float charSize;
color charColor = 0;
int posX = 20;
int posY = 50;

boolean drawLines = false;
boolean drawText = true;


void setup() {
  size(1000, 800);
  lines = loadStrings("HEAPS.txt");  //laden des zu analysierenden textes
  joinedText = join(lines, " ");
  println("Changed size and changed background.");

  font = createFont("AvenirNextCondensed-DemiBold-30.vlw", 10);

  for (int i = 0; i < alphabet.length(); i++) {
    drawLetters[i] = true;
  }

  countCharacters();
}


void draw() {
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");


  textFont(font);
  background(141, 151, 152);
  noStroke();
  smooth();

  { 
PImage img; 
img = loadImage ("rat.jpeg");
image (img, 0, 0, 1000, 800); 
}

  posX = 20;
  posY = 200;
  float oldX = 0;
  float oldY = 0;

  // go through all characters in the text to draw them  
  for (int i = 0; i < joinedText.length(); i++) {
    // again, find the index of the current letter in the alphabet
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if (index < 0) continue;

    fill(87, 35, 129);
    textSize(20);
    

    float sortY = index*20+40;
    float m = map(mouseX, 50,width-50, 0,1);
    m = constrain(m, 0, 1);
    float interY = lerp(posY, sortY, m);

    if (drawLetters[index]) {
      if (drawLines) {
        if (oldX!=0 && oldY!=0) {
          stroke(181, 157, 0, 100);
          line(oldX,oldY, posX,interY);
        }
        oldX = posX;
        oldY = interY;
      }

      if (drawText) text(joinedText.charAt(i), posX, interY);
    } 
    else {
      oldX = 0;
      oldY = 0;
    }

    posX += textWidth(joinedText.charAt(i));
    if (posX >= width-200 && uppercaseChar == ' ') {
      posY += 50;
      posX = 50;
    }
  }

  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}


void countCharacters(){
  for (int i = 0; i < joinedText.length(); i++) {
    // get one char from the text, convert it to a string and turn it to uppercase
    String s = str(joinedText.charAt(i)).toUpperCase();
    // convert it back to a char
    char uppercaseChar = s.charAt(0);
    // get the position of this char inside the alphabet string
    int index = alphabet.indexOf(uppercaseChar);
    // increase the respective counter
    if (index >= 0) counters[index]++;
  }
}




void keyReleased(){
  if (keyCode == CONTROL) {
    saveFrame(timestamp()+"_##.png");
    savePDF = true;
  }

  if (key == '1') drawLines = !drawLines;
  if (key == '2') drawText = !drawText;

  if (key == '3') {
    for (int i = 0; i < alphabet.length(); i++) {
      drawLetters[i] = false;
    }
  }
  if (key == '4') {
    drawText = true;
    for (int i = 0; i < alphabet.length(); i++) {
      drawLetters[i] = true;
    }
  }
  String s = str(key).toUpperCase();
  char uppercaseKey = s.charAt(0);
  int index = alphabet.indexOf(uppercaseKey);
  if (index >= 0) {
    drawLetters[index] = !drawLetters[index];
  }

}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}





























