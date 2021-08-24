# Maze Generation
 Maze Generation with the Depth First Algorithm using Processing

## How to use

### Maze
- Change the number of rows and columns in Maze_Generation.pde line 9 + 10

```processing
final int rows = 25;
final int cols = 25;
```
- Change if the maze generation is animated in Maze_Generation.pde line 13

```processing
final boolean animated = true;
```

### Pathfinding

- Press 'p' to save an image of the maze in the current directory
- Press 'r' to make a new maze
- If a maze has been made, you can calculate the quickest path between to points
  - Use the left mouse button to set a start point
  - Use the right mouse button to set an end point
  - Delete the start / end point by clicking with the same mouse button on the cell, where the start/end currently is

### Save system

- Save maze to .dat file by pressing 's'
- To load a saved file change the save file in Maze_Generation.pde line 30 (the save file has to be in the "/data" folder)
```processing
String saveFile = "maze-24-8-2021-17-32-38.dat";
```

## Example

![Alt Text](/example.png)

![Alt Text](/maze-0372.png)

## How to run
Run code using [Processing](https://processing.org/)
