package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Mark
 */
class GameState extends FlxState
{
	var heightMap:Array<Array<Int>>();
	var tileMap:FlxTilemap;
	
	static var TILESIZE:Int = 16;
	static var WIDTH:Int = 16;
	static var HEIGHT:Int = 16;
	
	override public function create():Void {
		heightMap = [for (x in 0 ... WIDTH) [for (y in 0 ... HEIGHT) 1]];
		for (x in 0 ... WIDTH) {
			for (y in 0 ... HEIGHT) {
				heightMap[x][y] += FlxRandom.int(0, 2);
				tileMap = new FlxTilemap();
				tileMap.setSize(WIDTH, HEIGHT);
				buildTileMap();
			}
		}
		super.create();
	}
	
	function buildTileMap() {
		
	}
	
	override public function update():Void {
		
		super.update();
	}
	
}