int size = 40;
int h = 20;
int w = 30;
int[][] grid;
int mines;
int flags;
boolean gameWon = false;
boolean gameStarted = false;

void setup() {
  size(1600,900);
  background(0,50,100);
  grid = new int[w][h];
  mines = w*h/5;
  flags = mines;
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      square(i*size, j*size, size);
    }
  }
  displayNumber();
}

void generateMines (int mines, int xPos, int yPos) {
  for (int i = 0; i < mines; i++) {
    int x = (int)random(w);
    int y = (int)random(h);
    if (grid[x][y] != -1 && (x > xPos+1 || x < xPos - 1) && (y > yPos+1 || y < yPos-1))
      grid[x][y] = -1;
    else i--;
  }
}

void displayNumber() {
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      if (grid[i][j] == -1) {
        textAlign(CENTER);
        textSize(20);
        text("-1", i*size + size/2, j*size + size/2);
        fill(0,0,0);
      }
    }
  }  
}

void mouseClicked() {
  if (mouseButton == LEFT && mouseX < w * size && mouseY < h * size) {
    if (gameStarted == false) {
       generateMines(mines, mouseX/size, mouseY/size);
       int[][] nextGrid = new int[w][h];
       for(int i = 0; i < w; i++) {
         for (int j = 0; j < h; j++) {
         nextGrid[i][j] = numAdjacent(grid, i, j);
         }
        }
       grid = nextGrid;
       gameStarted = true;
    }
    
    if (grid[mouseX/size][mouseY/size] == -1) {
      fill(255,0,0);
      rect(mouseX/size*size, mouseY/size*size, size, size);
      fill(0,0,0);
      circle(mouseX/size*size+ size/2, mouseY/size*size+ size/2, size);
      }
      else if (grid[mouseX/size][mouseY/size] > 0) {
        int display = numAdjacent(grid, mouseX/size, mouseY/size);
        textAlign(CENTER);
        textSize(20);
        fill(0,0,0);
        text(display, mouseX/size*size + size/2, mouseY/size*size + size/2);
      }
      else { //safe cell propagation
      textAlign(CENTER);
        textSize(20);
        fill(0,0,0);
        text(0, mouseX/size*size + size/2, mouseY/size*size + size/2);
      }
  }
  if (mouseButton == RIGHT && mouseX < w * size && mouseY < h * size) {
    // if cell isn't flagged or revealed else unflag
    fill (255, 255, 0);
    triangle(mouseX/size*size, mouseY/size*size, mouseX/size*size, 
             mouseY/size*size + size, mouseX/size*size + size, mouseY/size*size + size/2);
             flags--;
  }
}

void keyPressed() {
  if (gameStarted == false) {
    if (key == CODED) {
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
  grid = new int[w][h];
  mines = w*h/5;
  flags = mines;
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      square(i*size, j*size, size);
    }
  }
  displayNumber();
}
}

int numAdjacent(int[][] grid, int x, int y) {
  int counter = 0;
  
  if (grid[x][y] == -1)
    return -1;
  else {
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        int xPos = x + i;
        int yPos = y + j;
        if (xPos >= 0 && xPos < w && yPos >= 0 && yPos < h) {
          if (grid[xPos][yPos] == -1)
          counter++;
        }
      }
    }
  }
  return counter;
}
