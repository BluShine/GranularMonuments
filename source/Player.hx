package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

/**
 * ...
 * @author Mark
 */
 
class Player extends TileSprite
{
	
	var mode:Int = 0; //shovel up, shovel down, flag.
	static var DIGDURATION:Float = .2;
	var digTimer:Float = 0;
	
	public override function new(tX:Int, tY:Int, game:GameState) {
		super(tX, tY, game);
		loadGraphic("assets/shovel.png", true, 32, 32);
		animation.add("shovelHover", [0, 1], 6, true);
		animation.add("shovelMove", [2], 1, true);
		animation.add("shovelDig", [0, 3, 4, 4, 4], 24, true);
		animation.add("bucketDump", [5, 6, 7, 7, 7], 24, true);
		animation.add("flag", [8], 1, true);
		animation.add("flagPlace", [8, 9, 10, 10, 10], 24, true);
		animation.play("shovelHover");
	}
	
	public override function update() {
		digTimer -= FlxG.elapsed;
		digTimer = Math.max(0, digTimer);
		
		if (moveTimer == 0 &&  digTimer == 0) {
			if(FlxG.keys.anyPressed(["UP", "W"]) || FlxG.keys.anyJustPressed(["UP", "W"])) {
			movingDir = 0;
			moveTimer = moveDuration;
			yTile--;
			if (yTile < 0) 
				yTile = 0;
			} else if (FlxG.keys.anyPressed(["DOWN", "S"]) || FlxG.keys.anyJustPressed(["DOWN", "S"])) {
				movingDir = 2;
				moveTimer = moveDuration;
				yTile++;
				if (yTile > GameState.DEPTH) 
					yTile = GameState.DEPTH;
			} else if (FlxG.keys.anyPressed(["LEFT", "A"]) || FlxG.keys.anyJustPressed(["LEFT", "A"])) {
				movingDir = 3;
				moveTimer = moveDuration;
				xTile--;
				if (xTile < 0)
					xTile = 0;
			} else if (FlxG.keys.anyPressed(["RIGHT", "D"]) || FlxG.keys.anyJustPressed(["RIGHT", "D"])) {
				movingDir = 1;
				moveTimer = moveDuration;
				xTile++;
				if (xTile > GameState.WIDTH)
					xTile = GameState.WIDTH;
			} else if (FlxG.keys.anyJustPressed(["SPACE", "Z", "Q"])) {
				gameState.digTile(xTile, yTile, -1, true);
				digTimer = DIGDURATION;
				mode = 0;
				animation.play("shovelDig", true, 0);
			} else if (FlxG.keys.anyJustPressed(["SHIFT", "X", "E"])) {
				gameState.digTile(xTile, yTile, 1, true);
				digTimer = DIGDURATION;
				mode = 1;
				animation.play("bucketDump", true, 0);
			} else if (FlxG.keys.anyJustPressed(["CONTROL", "C", "R"])) {
				digTimer = DIGDURATION;
				mode = 2;
				animation.play("flagPlace", true, 0);
				gameState.buildCastle(xTile, yTile);
			}
		}
		if (moveTimer > 0) {
			animation.play("shovelMove");
		} 
		else if (digTimer > 0) {
			
		} 
		else {
			animation.play("shovelHover");
		}
		super.update();
	}
}