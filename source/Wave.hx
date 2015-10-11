package ;
import flixel.FlxSprite;

/**
 * ...
 * @author Mark
 */
class Wave extends TileSprite
{
	var hitpoints:Int = 3;
	
	public override function new(tX:Int, tY:Int, game:GameState) {
		super(tX, tY, game);
		loadGraphic("assets/wave.png", true, 32, 32);
		animation.add("1", [0,1], 6, true);
		animation.add("2", [2,3], 6, true);
		animation.add("3", [4,5], 6, true);
		animation.play("3");
		moveDuration = .5;
	}
	
	public override function update() {
		if (moveTimer == 0) {
			gameState.moveWave(this);
		}
		
		switch(hitpoints) {
			case 1:
				animation.play("1");
			case 2:
				animation.play("2");
			case 3:
				animation.play("3");
		}
		
		super.update();
	}
	
	public function move(mX:Int, mY:Int , dir:Int) {
		xTile = mX;
		yTile = mY;
		movingDir = dir;
		moveTimer = moveDuration;
	}
	
	public function hit() {
		hitpoints--;
		if (hitpoints == 0)
			kill();
	}
}