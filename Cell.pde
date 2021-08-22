class Cell{
  private int x;
  private int y;
  private int i;
  private int j;
  private float g = 0f;
  private float h = 0f;
  private float f = 0f;
  private Cell parent;
  public boolean[] walls = {true, true, true, true};
  private boolean visited = false;
  private boolean highlight = false;
  
  Cell(int i, int j){
    this.i = i;
    this.j = j;
    
    x = i * cellWidth;
    y = j * cellHeight;
  }
  
  Cell getNeighbor(){
    ArrayList<Cell> neighbor = new ArrayList<Cell>();
    
    if(i - 1 >= 0){
      if(!cells[i - 1][j].visited) neighbor.add(cells[i - 1][j]);
    }
    if(j - 1 >= 0){
      if(!cells[i][j - 1].visited) neighbor.add(cells[i][j - 1]);
    }
    if(i + 1 < rows){
      if(!cells[i + 1][j].visited) neighbor.add(cells[i + 1][j]);
    }
    if(j + 1 < cols){
      if(!cells[i][j + 1].visited) neighbor.add(cells[i][j + 1]);
    }
    
    return neighbor.size() > 0 ? neighbor.get(
    (int) random(neighbor.size())) : null;
  }
  
  ArrayList<Cell> getPathNeighbor(){
    ArrayList<Cell> neighbor = new ArrayList<Cell>();
    
    if(!walls[0]) neighbor.add(cells[i][j - 1]);
    if(!walls[1]) neighbor.add(cells[i + 1][j]);
    if(!walls[2]) neighbor.add(cells[i][j + 1]);
    if(!walls[3]) neighbor.add(cells[i - 1][j]);
    
    return neighbor;
  }
  
  void show(){
    //DRAW CELL
    if(highlight){
      fill(53, 122, 64);
      noStroke();
      rect(x, y, cellWidth, cellHeight);
    }else if(visited){
      fill(40, 75, 99);
      noStroke();
      rect(x, y, cellWidth, cellHeight);
    }
  }
  
  void showWalls(){
    //DRAW WALLS
    strokeWeight(1);
    stroke(255);
    //up
    if(walls[0]){
      line(x, y, x + cellWidth, y);
    }
    //right
    if(walls[1]){
      line(x + cellWidth, y, x + cellWidth, y + cellHeight);
    }
    //down
    if(walls[2]){
      line(x, y + cellHeight, x + cellWidth, y + cellHeight);
    }
    //left
    if(walls[3]){
      line(x, y, x, y + cellHeight);
    }
  }
  
  void setHighlight(boolean val){
    highlight = val;
  }
  
  void calculateCost(Cell parent){
    this.parent = parent;
    
    g = this.parent.g +
      dist(this.parent.getI(), this.parent.getJ(), i, j);
    h = dist(i, j, end.getI(), end.getJ());
    f = g + h;
  }
  
  void resetAstar(){
    g = 0;
    h = 0;
    f = 0;
    parent = null;
  }
  
  int getI(){
    return i;
  }
  
  int getJ(){
    return j;
  }
  
  float getG(){
    return g;
  }
  
  float getH(){
    return h;
  }

  float getF(){
    return f;
  }
}

void display(){
  //DISPLAY ALL CELLS
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[x].length; y++){
      cells[x][y].show();
    }
  }
}

void displayWalls(){
  //DISPLAY ALL WALLS
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[x].length; y++){
      cells[x][y].showWalls();
    }
  }
}

void removeWalls(Cell cur, Cell nex){
  if(cur.getI() - nex.getI() == 1){
    cur.walls[3] = false;
    nex.walls[1] = false;
  }else if(cur.getI() - nex.getI() == -1){
    cur.walls[1] = false;
    nex.walls[3] = false;
  }
  
  if(cur.getJ() - nex.getJ() == 1){
    cur.walls[0] = false;
    nex.walls[2] = false;
  }else if(cur.getJ() - nex.getJ() == -1){
    cur.walls[2] = false;
    nex.walls[0] = false;
  }
}
