// Maze Generation using Depth First Search
// by https://github.com/7ubi
// Sources:
// https://www.algosome.com/articles/maze-generation-depth-first.html
// https://en.wikipedia.org/wiki/Maze_generation_algorithm
// https://en.wikipedia.org/wiki/A*_search_algorithm
import java.util.Stack;

int rows = 12;
int cols = 12;
int cellWidth;
int cellHeight;
final boolean animated = false;

boolean generated = false;

Cell[][] cells;
Stack<Cell> path;
Cell current;

// Path finding
Cell start = null;
Cell end = null;
ArrayList<Cell> openList;
ArrayList<Cell> closedList;
ArrayList<Cell> pathList;

// Save system
final int[] saveStates = {8, 4, 2, 1};
String saveFile = "";

void setup(){
  size(600, 600);
  
  pathList = new ArrayList<Cell>();
  openList = new ArrayList<Cell>();
  closedList = new ArrayList<Cell>();
  
  if(saveFile == ""){
    cellWidth = width / rows;
    cellHeight = height / cols;
    
    cells = new Cell[rows][cols];
    for(int x = 0; x < rows; x++){
      for(int y = 0; y < cols; y++){
        cells[x][y] = new Cell(x, y);
      }
    }
    
    path = new Stack<Cell>();
    current = cells[0][0];
    current.visited = true;
    path.add(current);
    
    if(!animated){
      while(true){
        if(generate())break; 
      }
    }
  }else{
    try{
      loadMaze();
    }catch(Exception e){
      saveFile = "";
      println("FILE DOES NOT EXIST");
      setup();
    }
  }
}

void draw(){
  background(53);
  
  if(generated){
    display();
    hoverCell();
    
    //draw path if a path was calculated
    if(pathList.size() > 0){
      for(Cell cell: pathList){
        noStroke();
        fill(168, 111, 30);
        rect(cell.x, cell.y, cellWidth, cellHeight);
      }
    }
    
    //draw start
    if(start != null){
      noStroke();
      fill(50, 168, 82);
      rect(start.x, start.y, cellWidth, cellHeight);
    }
    //draw end
    if(end != null){
      noStroke();
      fill(156, 48, 52);
      rect(end.x, end.y, cellWidth, cellHeight);
    }
    displayWalls();
  }else if(animated){
    if(!generate())current.setHighlight(true);
    display();
    displayWalls();
  }
}

boolean generate(){
  //GET NEXT CELL
  Cell next = current.getNeighbor();
  current.setHighlight(false);
  
  if(next != null){
    removeWalls(current, next);
    current = next;
    current.visited = true;
    path.add(current);
  }else{
    if(!path.isEmpty()){
      current = path.pop();
    }else{
      //MAZE DONE
      generated = true;
      return true;
    }
  }
  return false;
}

void hoverCell(){
  int x = mouseX - mouseX % cellWidth;
  int y = mouseY - mouseY % cellHeight;
  
  noStroke();
  fill(255, 255, 255, 50);
  rect(x, y, cellWidth, cellHeight);
}

void calculatePath(){
  while(openList.size() > 0){
      //get Cell with lowest F
      Cell current = openList.get(0);
      
      for(Cell cell : openList){
        if(cell.f < current.f){
          current = cell;
        }
      }
      
      if(current == end){
        createPath(current);
        return;
      }
      
      openList.remove(current);
      closedList.add(current);
      
      //add neighbors 
      for(Cell cell: current.getPathNeighbor()){
        if(closedList.contains(cell)) continue;
        float g = current.g + 
        dist(current.x, current.y, cell.x, cell.y);   
        
        boolean newPath = false;
        if(openList.contains(cell)){
          if(g < cell.g){
            cell.g = g;
            newPath = true;
          }
        }else{
          cell.g = g;
          openList.add(cell);
          newPath = true;
        }
        
        if(newPath){
          cell.calculateCost(current);
        }
      }
    }
}

void createPath(Cell current){
  pathList.clear();
  while(current.parent != null){
    pathList.add(current.parent);
    current = current.parent;
  }
}

void keyPressed(){
  //SAVE IMAGE OF MAZE
  if(generated){
    if(key == 'p' || key == 'P'){
      saveFrame("maze-####.png");
    }
    
    if(key == 'r' || key == 'R'){
      setup();
      start = null;
      end = null;
    }
    
    if(key == 's' || key == 'S'){
      saveMaze();
    }
  }
}

void mousePressed(){
  int x = mouseX - mouseX % (width/rows);
  int y = mouseY - mouseY % (height/cols);
  int i = x / (width/rows);
  int j = y / (height/cols);
  
  if(mouseButton == LEFT){
    //set start
    start = start != cells[i][j] ? cells[i][j]: null;
    
    resetAstar();
    
    if(start != null && end != null){
      calculatePath();
    }
  }
  
  if(mouseButton == RIGHT){
    //set end
    end = end != cells[i][j] ? cells[i][j]: null;
    
    if(end == null) resetAstar();
    if(start != null && end != null){
      resetAstar();
      calculatePath();
    }
  }
}

void saveMaze(){
  byte[] walls = new byte[rows * cols + 2];
  
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[x].length; y++){
      walls[x + y * rows] = cells[x][y].getSave();
    }
  }
  
  walls[walls.length - 2] = (byte) rows;
  walls[walls.length - 1] = (byte) cols;
  
  saveBytes("data/maze-" + day()
  + "-" + month() + "-" + year() +
  "-" + hour() + "-" + minute() + "-" + second() + ".dat", walls);
}

void loadMaze(){
   byte[] data = loadBytes(saveFile);
   
   rows = (int) data[data.length - 2];
   cols = (int) data[data.length - 1];
   
   cellWidth = width / rows;
   cellHeight = height / cols;
   
   cells = new Cell[rows][cols];
   
   for(int i = 0; i < data.length - 2; i++){
     int x = i % rows;
     int y = (int) i / rows;
     
     cells[x][y] = convertToCell(x, y, data[i]);
     cells[x][y].visited = true;
   }
   generated = true;
}

Cell convertToCell(int x, int y, byte data){
  Cell cell = new Cell(x, y);
  
  for(int i = 0; i < saveStates.length; i++){
    int a = data^saveStates[i];
    if(a < data){
      cell.walls[i] = true;
    }else{
      cell.walls[i] = false;
    }
  }
  
  return cell;
}

void resetAstar(){
  pathList.clear();
  openList.clear();
  openList.add(start);
  closedList.clear();
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[x].length; y++){
      cells[x][y].resetAstar();
    }
  }
}
