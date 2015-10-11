package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

/**
 * ...
 * @author Mark
 */
 
class Player extends FlxSprite
{
	static var TILESIZE:Int = 32;
	
	public var xTile:Int = 0;
	public var yTile:Int = 0;
	
	var gameState:GameState;
	
	static var moveDuration:Float = .05;
	var moveTimer:Float = 0;
	var movingDir:Int = 0;
	
	public override function new(tX:Int, tY:Int, game:GameState) {
		super(tX * TILESIZE, tY * TILESIZE);
		gameState = game;
		xTile = tX;
		yTile = tY;
		loadGraphic("assets/shovel.png", true, 32, 32);
		animation.add("hover", [0, 1], 6, true);
		animation.add("move", [2], 1, true);
		animation.play("hover");
	}
	
	public override function update() {
		if (moveTimer == 0 && (FlxG.keys.anyPressed(["UP", "W"]) || FlxG.keys.anyJustPressed(["UP", "W"]))) {
			movingDir = 0;
			moveTimer = moveDuration;
			yTile--;
			if (yTile < 0) 
				yTile = 0;
		} else if (moveTimer == 0 && (FlxG.keys.anyPressed(["DOWN", "S"]) || FlxG.keys.anyJustPressed(["DOWN", "S"]))) {
			movingDir = 2;
			moveTimer = moveDuration;
			yTile++;
			if (yTile > GameState.DEPTH) 
				yTile = GameState.DEPTH;
		} else if (moveTimer == 0 && (FlxG.keys.anyPressed(["LEFT", "A"]) || FlxG.keys.anyJustPressed(["LEFT", "A"]))) {
			movingDir = 3;
			moveTimer = moveDuration;
			xTile--;
			if (xTile < 0)
				xTile = 0;
		} else if (moveTimer == 0 && (FlxG.keys.anyPressed(["RIGHT", "D"]) || FlxG.keys.anyJustPressed(["RIGHT", "D"]))) {
			movingDir = 1;
			moveTimer = moveDuration;
			xTile++;
			if (xTile > GameState.WIDTH)
				xTile = GameState.WIDTH;
		}
		
		if (moveTimer == 0 && FlxG.keys.anyJustPressed(["SPACE", "Z"])) {
			gameState.digTile(xTile, yTile, 1, true);
		} else if (moveTimer == 0 && FlxG.keys.anyJustPressed(["SHIFT", "X"])) {
			gameState.digTile(xTile, yTile, -1, true);
		}
		
		if (moveTimer > 0) {
			animation.play("move");
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
			animation.play("hover");
			x = xTile * TILESIZE;
			y = yTile * TILESIZE;
		}
		super.update();
	}
}