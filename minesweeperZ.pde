int size = 40;
int h = 20;
int w = 30;
Board grid;
int mines;
int flags;
boolean gameWon = false;
boolean gameStarted = false;

void setup() {
  size(1600,900);
  background(0,50,100);
  grid = new Board(w,h);
  mines = w*h/5;
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
    if (grid.getCell(x,y).getAdjacent() != -1 && (x > xPos+1 || x < xPos - 1) && (y > yPos+1 || y < yPos-1)) {
      grid.getCell(x,y).setAdjacent(-1);
    }
    else i--;
  }
}

void displayMines() {
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      if (grid.getCell(i,j).isMine()) {
        fill(0,0,0);
        circle(i*size + size/2, j*size + size/2, size);
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
       gameStarted = true;
       frameCount = 0;
    }
    
    if (grid.getCell(mouseX/size,mouseY/size).isMine()) {
      fill(255,0,0);
      rect(mouseX/size*size, mouseY/size*size, size, size);
      fill(0,0,0);
      circle(mouseX/size*size+ size/2, mouseY/size*size+ size/2, size);
      displayMines();
      }
      else if (grid.getCell(mouseX/size,mouseY/size).getAdjacent() > 0) {
        int display = grid.getCell(mouseX/size,mouseY/size).getAdjacent();
        grid.getCell(mouseX/size,mouseY/size).reveal();
        textAlign(CENTER);
        textSize(20);
        fill(0,0,0);
        text(display, mouseX/size*size + size/2, mouseY/size*size + size/2);
      }
      else { //safe cell propagation
        grid.getCell(mouseX/size,mouseY/size).reveal();
        textAlign(CENTER);
        textSize(20);
        fill(0,0,0);
        text(0, mouseX/size*size + size/2, mouseY/size*size + size/2);
      }
  }
  if (mouseButton == RIGHT && mouseX < w * size && mouseY < h * size) {
    // if cell isn't flagged or revealed else unflag
    if (!grid.getCell(mouseX/size,mouseY/size).isFlagged() && !grid.getCell(mouseX/size,mouseY/size).isRevealed()) {
    grid.getCell(mouseX/size,mouseY/size).flag();
    fill (255, 255, 0);
    triangle(mouseX/size*size, mouseY/size*size, mouseX/size*size, 
             mouseY/size*size + size, mouseX/size*size + size, mouseY/size*size + size/2);
             flags--;
    }
    else if (grid.getCell(mouseX/size,mouseY/size).isFlagged()) {
      grid.getCell(mouseX/size,mouseY/size).flag();
      fill(255,255,255);
      square(mouseX/size*size, mouseY/size*size, size);
             flags++;
    }
  }
}

void keyPressed() {
  
  if (key == 'r') {
      gameStarted = false;
      redraw();
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
  if (keyPressed && gameStarted == false) {
  background(0,50,100);
  grid = new Board(w,h);
  mines = w*h/5;
  flags = mines;
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      fill(255,255,255);
      square(i*size, j*size, size);
      }
    }
  }
  if (gameStarted == true) {
  fill(100,50,100);
  rect(30*size, 0, size * 10, 100); 
  textAlign(RIGHT);
  textSize(100);
  fill(0,0,0);
  text(frameCount / 60, 40 * size, 2*size);
  }
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
