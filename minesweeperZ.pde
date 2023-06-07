int size = 40;
int h = 16;
int w = 30;
Board grid;
int mines;
int flags;
boolean gameWon = false;
boolean gameOver = false;
boolean gameStarted = false;

void setup() {
  size(1600,900);
  background(0,50,100);
  frameRate(60);
  grid = new Board(w,h);
  
  mines = w*h/4 - 4;
  flags = mines;
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      square(i*size, j*size, size);
    }
  }
}

void generateMines (int mines, int xPos, int yPos) {
  for (int i = 0; i < mines; i++) {
    int x = (int)random(w);
    int y = (int)random(h);
    if (grid.getCell(x,y).getAdjacent() != -1 && (x > xPos+1 || x < xPos - 1) || (y > yPos+1 || y < yPos-1)) {
      grid.getCell(x,y).setAdjacent(-1);
    }
    else i--;
  }
}

void displayMines() {
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      if (grid.getCell(i,j).isMine()) {
        fill(255,255,255);
        square(i*size, j*size, size);
        fill(0,0,0);
        circle(i*size + size/2, j*size + size/2, size);
      }
    }
  }  
}

void recursiveReveal(int x, int y) {
  for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        int xPos = x + i;
        int yPos = y + j;
        if (xPos >= 0 && xPos < w && yPos >= 0 && yPos < h) {
          if (!grid.getCell(xPos,yPos).isRevealed() && grid.getCell(xPos,yPos).numAdjacent == 0) {
            grid.getCell(xPos,yPos).reveal();
            textAlign(CENTER);
            textSize(20);
            fill(0,0,0);
            text(grid.getCell(xPos,yPos).numAdjacent, xPos*size + size/2, yPos*size + size/2);
            recursiveReveal(xPos,yPos);}
          else {
            grid.getCell(xPos,yPos).reveal();
            textAlign(CENTER);
            textSize(20);
            fill(0,0,0);
            text(grid.getCell(xPos,yPos).numAdjacent, xPos*size + size/2, yPos*size + size/2);
          }
        }
      }
  }     
}

void mouseClicked() {
  if (mouseButton == LEFT && mouseX < w * size && mouseY < h * size) {
    if (gameStarted == false) {
       generateMines(mines, mouseX/size, mouseY/size);
       Board nextGrid = new Board(w,h);
       for(int i = 0; i < w; i++) {
         for (int j = 0; j < h; j++) {
         nextGrid.getCell(i,j).setAdjacent(numAdjacent(grid, i, j));
         }
        }
       grid = nextGrid;
       fill(255, 255, 0);
       rect(30*size, 100, size * 10, 100); 
       textAlign(RIGHT);
       textSize(100);
       fill(0,0,0);
       text(flags, 40 * size, 100 + 2*size);
       gameStarted = true;
       frameCount = 0;
    }
    
    if (grid.getCell(mouseX/size,mouseY/size).isMine() && 
       !grid.getCell(mouseX/size,mouseY/size).isFlagged()) {
      displayMines();
      fill(255,0,0);
      rect(mouseX/size*size, mouseY/size*size, size, size);
      fill(0,0,0);
      circle(mouseX/size*size+ size/2, mouseY/size*size+ size/2, size);
      gameOver = true;
      }
      else if (grid.getCell(mouseX/size,mouseY/size).getAdjacent() > 0 && 
              !grid.getCell(mouseX/size,mouseY/size).isFlagged()) {
        int display = grid.getCell(mouseX/size,mouseY/size).getAdjacent();
        grid.getCell(mouseX/size,mouseY/size).reveal();
        textAlign(CENTER);
        textSize(20);
        fill(0,0,0);
        text(display, mouseX/size*size + size/2, mouseY/size*size + size/2);
        if (grid.gameWon()) {
          gameWon = true;
      }
      }
      else if (!grid.getCell(mouseX/size,mouseY/size).isFlagged())
      { //safe cell propagation
        recursiveReveal(mouseX/size,mouseY/size);
        if (grid.gameWon()) {
          gameWon = true;
      }
      }
  }
  if (mouseButton == RIGHT && mouseX < w * size && mouseY < h * size) {
    // if cell isn't flagged or revealed else unflag
    if (!grid.getCell(mouseX/size,mouseY/size).isFlagged() && 
        !grid.getCell(mouseX/size,mouseY/size).isRevealed()) {
    grid.getCell(mouseX/size,mouseY/size).flag();
    fill (255, 255, 0);
    triangle(mouseX/size*size, mouseY/size*size, mouseX/size*size, 
             mouseY/size*size + size, mouseX/size*size + size, mouseY/size*size + size/2);
             flags--;
             fill(255, 255, 0);
             rect(30*size, 100, size * 10, 100); 
             textAlign(RIGHT);
             textSize(100);
             fill(0,0,0);
             text(flags, 40 * size, 100 + 2*size);
    }
    else if (grid.getCell(mouseX/size,mouseY/size).isFlagged()) {
      grid.getCell(mouseX/size,mouseY/size).flag();
      fill(255,255,255);
      square(mouseX/size*size, mouseY/size*size, size);
             flags++;
             fill(255, 255, 0);
             rect(30*size, 100, size * 10, 100); 
             textAlign(RIGHT);
             textSize(100);
             fill(0,0,0);
             text(flags, 40 * size, 100 + 2*size);
    }
  }
}

void keyPressed() {
  
  if (key == 'r') {
      gameWon = false;
      gameOver = false;
      gameStarted = false;
    }
  
  if (key == CODED) {
    if (gameStarted == false) {

      if (keyCode == UP && h < 21) {
        h++;
      }
      if (keyCode == DOWN && h > 6) {
        h--;
      }
      if (keyCode == LEFT && w > 6) {
        w--;
      }
      if (keyCode == RIGHT && w < 31) {
        w++;
      }
    }
  }
}

void draw() {
  if (keyPressed && !gameStarted) {
    background(0,50,100);
    grid = new Board(w,h);
    mines = w*h/4 - 4;
    flags = mines;
    for(int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        fill(255,255,255);
        square(i*size, j*size, size);
        }
      }
    }
  else if (gameStarted && !gameOver && !gameWon) {
  fill(100,50,100);
  rect(30*size, 0, size * 10, 100); 
  textAlign(RIGHT);
  textSize(100);
  fill(0,0,0);
  text(frameCount / 60, 40 * size, 2*size);
  }
  
  if (gameWon) {
    int finalFrame = frameCount;
    fill(0,0,0);
    rect(500, 0, 600, 500);
    fill(255,255,255);
    textAlign(LEFT);
    textSize(100);
    text("Game Won", 550, 100);
    text("Time: " + finalFrame / 60, 550, 200);
    fill(0,100,255);
    text("Click r to", 550, 300);
    text("reset board", 550, 400);
    frameCount = finalFrame - 1;
  }
  // if (gameOver)
}

int numAdjacent(Board grid, int x, int y) {
  int counter = 0;
  if (grid.getCell(x,y).isMine())
    return -1;
  else {
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        int xPos = x + i;
        int yPos = y + j;
        if (xPos >= 0 && xPos < w && yPos >= 0 && yPos < h) {
          if (grid.getCell(xPos,yPos).isMine())
          counter++;
        }
      }
    }
  }
  return counter;
}
