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
	
	public override function new(tX:Int, tY:Int, game:GameState) {
		super(tX, tY, game);
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
		} 
		else {
			animation.play("hover");
		}
		super.update();
	}
}