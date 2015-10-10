package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.tile.FlxTilemap;
import flixel.FlxG;

/**
 * ...
 * @author Mark
 */
class GameState extends FlxState
{
	var heightMap:Array<Array<Int>>;
	var tileMap:Array<Array<FlxSprite>>;
	
	static var TILESIZE:Int = 16;
	static var WIDTH:Int = 16;
	static var DEPTH:Int = 16;
	
	static var TOPHEIGHT:Int = 4;
	static var BOTTOMHEIGHT:Int = 0;
	
	override public function create():Void {
		
		heightMap = new Array<Array<Int>>();
		for (x in 0 ... WIDTH) {
			heightMap[x] = new Array<Int>();
			for (y in 0 ... DEPTH) {
				heightMap[x][y] = FlxRandom.intRanged(0, 1) + getEdgeHeight(x, y);
			}
		}
		
		tileMap = new Array<Array<FlxSprite>>();
		for ( tx in 0 ... WIDTH * 2) {
			tileMap[tx] = new Array<FlxSprite>();
			for ( ty in 0 ... DEPTH * 2) {
				var tSprite:FlxSprite = new FlxSprite(tx * 16, ty * 16);
				tileMap[tx][ty] = tSprite;
				tSprite.loadGraphic("assets/tiles.png", true, TILESIZE, TILESIZE);
				tSprite.animation.add("a", [for (i in 0 ... 17) i], 0, false);
				tSprite.animation.play("a");
				tSprite.animation.pause();
				add(tSprite);
			}
		}
		erode();
		erode();
		erode();
		buildTileMap();
		
		super.create();
	}
	
	function buildTileMap() {
		var tileConversion:Array<Array<Int>> = new Array<Array<Int>>();
		for (x in 0 ... WIDTH * 2) {
			tileConversion[x] = new Array<Int>();
			for (y in 0 ... DEPTH * 2) {
				tileConversion[x][y] = 0;
			}
		}
		
		for (x in 0 ... WIDTH) {
			for (y in 0 ... DEPTH) {
				var tileHeight:Int = heightMap[x][y];
				var tileArea:Array<Array<Bool>> = new Array<Array<Bool>>();
				for (ax in 0 ... 3) {
					tileArea[ax] = new Array<Bool>();
					for (ay in 0 ... 3) {
						tileArea[ax][ay] = getHeight(x + ax - 1, y + ay - 1) >= tileHeight;
					}
				}
				
				//we split this up into 4 corner tiles for each heightmap point.
				//each tile can have 1 of 6 states: \
				//filled, outer corner, inner corner,
				//horizontal wall, vertical wall, outer corner with inner corner on lower tile.
				
				//NW tile
				if (!tileArea[0][1] && !tileArea[1][0]){
					if(getHeight(x - 1, y - 1) + 1 >= tileHeight)
						tileConversion[x * 2][y * 2] = 0; //outer corner
					else
						tileConversion[x * 2][y * 2] = 5; //outer corner with lower inner corner
				}
				else if (tileArea[0][1] && !tileArea[1][0])
					tileConversion[x * 2][y * 2] = 1; //horiz wall
				else if (!tileArea[0][1] && tileArea[1][0])
					tileConversion[x * 2][y * 2] = 6; //vert wall
				else if (tileArea[0][1] && tileArea[1][0] && tileArea[0][0])
					tileConversion[x * 2][y * 2] = 7; //filled
				else 
					tileConversion[x * 2][y * 2] = 10; //inner corner
				//NE tile
				if (!tileArea[2][1] && !tileArea[1][0]){
					if(getHeight(x + 1, y - 1) + 1 >= tileHeight)
						tileConversion[x * 2 + 1][y * 2] = 2; //outer corner
					else
						tileConversion[x * 2 + 1][y * 2] = 15; //outer corner with lower inner corner
				}
				else if (tileArea[2][1] && !tileArea[1][0])
					tileConversion[x * 2 + 1][y * 2] = 1; //horiz wall
				else if (!tileArea[2][1] && tileArea[1][0])
					tileConversion[x * 2 + 1][y * 2] = 8; //vert wall
				else if (tileArea[2][1] && tileArea[1][0] && tileArea[2][0])
					tileConversion[x * 2 + 1][y * 2] = 7; //filled
				else 
					tileConversion[x * 2 + 1][y * 2] = 9; //inner corner
				//SW tile
				if (!tileArea[0][1] && !tileArea[1][2]){
					if(getHeight(x - 1, y + 1) + 1 >= tileHeight)
						tileConversion[x * 2][y * 2 + 1] = 12; //outer corner
					else
						tileConversion[x * 2][y * 2 + 1] = 11; //outer corner with lower inner corner
				}
				else if (tileArea[0][1] && !tileArea[1][2])
					tileConversion[x * 2][y * 2 + 1] = 13; //horiz wall
				else if (!tileArea[0][1] && tileArea[1][2])
					tileConversion[x * 2][y * 2 + 1] = 6; //vert wall
				else if (tileArea[0][1] && tileArea[1][2] && tileArea[0][2])
					tileConversion[x * 2][y * 2 + 1] = 7; //filled
				else 
					tileConversion[x * 2][y * 2  +1] = 4; //inner corner
				//SE tile
				if (!tileArea[2][1] && !tileArea[1][2]){
					if(getHeight(x + 1, y + 1) + 1 >= tileHeight)
						tileConversion[x * 2 + 1][y * 2 + 1] = 14; //outer corner
					else
						tileConversion[x * 2 + 1][y * 2 + 1] = 16; //outer corner with lower inner corner
				}
				else if (tileArea[2][1] && !tileArea[1][2])
					tileConversion[x * 2 + 1][y * 2 + 1] = 13; //horiz wall
				else if (!tileArea[2][1] && tileArea[1][2])
					tileConversion[x * 2 + 1][y * 2 + 1] = 8; //vert wall
				else if (tileArea[2][1] && tileArea[1][2] && tileArea[2][2])
					tileConversion[x * 2 + 1][y * 2 + 1] = 7; //filled
				else 
					tileConversion[x * 2 + 1][y * 2 + 1] = 3; //inner corner
					
				tileConversion[x * 2][y * 2] += tileHeight * 18;
				tileConversion[x * 2 + 1][y * 2] += tileHeight * 18;
				tileConversion[x * 2][y * 2 + 1] += tileHeight * 18;
				tileConversion[x * 2 + 1][y * 2 + 1] += tileHeight * 18;
			}
		}
		for (x in 0 ... WIDTH * 2) {
			for (y in 0 ... DEPTH * 2) {
				tileMap[x][y].animation.frameIndex = tileConversion[x][y];
			}
		}
	}
	
	function erode() {
		for (x in 0 ... WIDTH) {
			Math.max(0.1, 0.2);
			for (y in 0 ... DEPTH) {
				var minAdjacent = Math.min(getHeight(x - 1, y), getHeight(x + 1, y));
				minAdjacent = Math.min(minAdjacent, getHeight(x, y - 1));
				minAdjacent = Math.min(minAdjacent, getHeight(x, y + 1));
				//Math.max(Math.max(getHeight(x - 1, y), getHeight(x + 1, y)) Math.max(getHeight(x, y - 1), getHeight(x, y + 1)))
				if (minAdjacent + 1 < getHeight(x, y)) {
					FlxG.log.add("Before " + heightMap[x][y]);
					heightMap[x][y]--;
					FlxG.log.add("After " + heightMap[x][y]);
				}
			}
		}
	}
	
	function getHeight(x:Int, y:Int) {
		if (x < 0 || y < 0 || x >= WIDTH || y >= DEPTH) {
			return getEdgeHeight(x, y);
		}
		return heightMap[x][y];
	}
	
	function getEdgeHeight(x:Int, y:Int) {
		return Math.round((y / DEPTH) * TOPHEIGHT);
	}
	
	override public function update():Void {
		if (FlxG.keys.anyJustPressed(["ENTER", "SPACE"])) {
			FlxG.switchState(new GameState());
		}
		super.update();
	}
	
}