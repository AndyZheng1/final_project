int size = 40;
int w = 9;
int h = 9;
int[] grid = new int[w * h];
int mines = 40;

void setup() {
  size(1600,900);
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      square(i*size, j*size, size);
    }
  }
  generateMines(mines);
  displayNumber();
}

void generateMines (int mines) {
  for (int i = 0; i < mines; i++) {
    int x = (int)random(w);
    int y = (int)random(h);
    if (grid[x + w * y] != -1)
      grid[x + w * y] = -1;
    else i--;
}
}

void displayNumber() {
  for(int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      if (grid[i + w * j] == -1) {
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
    if (grid[mouseX/size + mouseY/size * w] == -1) {
      fill(255,0,0);
      rect(mouseX/size*size, mouseY/size*size, size, size);
      fill(0,0,0);
      circle(mouseX/size*size+ size/2, mouseY/size*size+ size/2, size);
      }
  }
  if (mouseButton == RIGHT && mouseX < w * size && mouseY < h * size) {
    //flag
  }
}

void draw() {
}
