import de.bezier.guido.*;

public final static int NUM_ROWS = 19;
public final static int NUM_COLS = 20;
public int numMines = 55;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 650);
    background( 255 );
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int row = 0; row < NUM_ROWS; row++){
      for(int col = 0; col < NUM_COLS; col++) {
        buttons[row][col] = new MSButton(row,col);
      }
    }
    
    
    setMines();
}
public void setMines()
{
  while(mines.size() < 55) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if(mines.contains(buttons[r][c]) == false) {
      mines.add(buttons[r][c]);
    }
  }   
}

public void draw ()
{
    if(isWon() == true)
        displayWinningMessage();
    if (isWon() == false) {
      background(255);
      fill(0);
      textSize(24);
      text("Mines Remaining: " + numMines, 300, 620);
      textSize(12);
      
    }
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++) {
      for(int c = 0; c < NUM_COLS; c++) {
        if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[1][9].myLabel= "Y";
    buttons[1][10].myLabel= "O";
    buttons[1][11].myLabel= "U";
    buttons[2][8].myLabel= "L";
    buttons[2][9].myLabel= "O";
    buttons[2][10].myLabel= "S";
    buttons[2][11].myLabel= "T";
    buttons[2][12].myLabel= "!";
}
public void displayWinningMessage()
{
    buttons[2][7].myLabel= "W";
    buttons[2][8].myLabel= "I";
    buttons[2][9].myLabel= "N";
    buttons[2][10].myLabel= "N";
    buttons[2][11].myLabel= "E";
    buttons[2][12].myLabel= "R";
    buttons[2][13].myLabel= "!";
}
public boolean isValid(int r, int c)
{
  if(r <= NUM_ROWS - 1 && c <= NUM_COLS - 1) {
  if(r >= 0 && c >= 0)
      return true;
  }
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++) {
        for(int c = col-1; c<=col+1;c++)
          if(isValid(r,c) && mines.contains(buttons[r][c]))
            numMines++;
    }
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
          if (flagged == false){
            flagged = true;
            numMines--;
          } 
          else {
             flagged = false;
             clicked = false;
             numMines++;
          }
        }
        else if(clicked && mines.contains(this))
          displayLosingMessage();
        else if(clicked && countMines(myRow, myCol) > 0)
          setLabel(countMines(myRow, myCol));
        else {
          for(int r = myRow-1; r <= myRow+1; r++){
              for(int c = myCol-1; c <= myCol+1; c++){
                if(isValid(r,c) && buttons[r][c].clicked == false){
                  buttons[r][c].mousePressed();
                }
              }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
