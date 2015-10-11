package ;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Mark
 */
class TileSprite extends FlxSprite
{
	static var TILESIZE:Int = 32;
	
	public var xTile:Int = 0;
	public var yTile:Int = 0;
	
	var gameState:GameState;
	
	var moveDuration:Float = .05;
	var moveTimer:Float = 0;
	var movingDir:Int = 0;

	public override function new(tX:Int, tY:Int, game:GameState) 
	{		
		super(tX * TILESIZE, tY * TILESIZE);
		xTile = tX;
		yTile = tY;
		gameState = game;
	}
	
	public override function update() {
		if (moveTimer > 0) {
			moveTimer -= FlxG.elapsed;
			moveTimer = Math.max(0, moveTimer);
			switch(movingDir) {
				case 0:
					x = xTile * TILESIZE;
					y = yTile * TILESIZE + TILESIZE * (moveTimer / moveDuration);
					false;
				case 2:
					x = xTile * TILESIZE;
					y = yTile * TILESIZE - TILESIZE * (moveTimer / moveDuration);
					false;
				case 3:
					x = xTile * TILESIZE + TILESIZE * (moveTimer / moveDuration);
					y = yTile * TILESIZE;
					false;
				case 1:
					x = xTile * TILESIZE - TILESIZE * (moveTimer / moveDuration);
					y = yTile * TILESIZE;
					false;
			}
		} 
		else {
			x = xTile * TILESIZE;
			y = yTile * TILESIZE;
		}
		super.update();		
	}
}