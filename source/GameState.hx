package ;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
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
	
	public static var TILESIZE:Int = 16;
	public static var WIDTH:Int = 20;
	public static var DEPTH:Int = 15;
	
	static var TOPHEIGHT:Int = 3;
	static var BOTTOMHEIGHT:Int = -1;
	
	var player:Player;
	
	var waveGroup:FlxTypedGroup<Wave>;
	
	override public function create():Void {
		
		heightMap = new Array<Array<Int>>();
		for (x in 0 ... WIDTH) {
			heightMap[x] = new Array<Int>();
			for (y in 0 ... DEPTH) {
				heightMap[x][y] = getEdgeHeight(x, y) + FlxRandom.intRanged(0, 1);
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
		buildTileMap();
		
		waveGroup = new FlxTypedGroup<Wave>();
		add(waveGroup);
		
		player = new Player(10, 7, this);
		add(player);
		
		super.create();
	}
	
	public function digTile(x:Int, y:Int, amount:Int, manual:Bool) {
		if (x < 0 || x >= WIDTH || y < 0 || y >= DEPTH)
			return;
		heightMap[x][y] += amount;
		heightMap[x][y] = cast(Math.min(heightMap[x][y], TOPHEIGHT), Int);
		heightMap[x][y] = cast(Math.max(heightMap[x][y], BOTTOMHEIGHT), Int);
		if (manual) {
			erode();
			buildTileMap();
		}
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
				
				if (tileHeight == -1) {
					tileConversion[x * 2][y * 2] = 17;
					tileConversion[x * 2 + 1][y * 2] = 17;
					tileConversion[x * 2][y * 2 + 1] = 17;
					tileConversion[x * 2 + 1][y * 2 + 1] = 17;
				}
			}
		}
		for (x in 0 ... WIDTH * 2) {
			for (y in 0 ... DEPTH * 2) {
				tileMap[x][y].animation.frameIndex = tileConversion[x][y];
			}
		}
	}
	
	function erode() {
		var eroded:Bool = false;
		for (x in 0 ... WIDTH) {
			Math.max(0.1, 0.2);
			for (y in 0 ... DEPTH) {
				//get adjacent tiles
				var nT:Int = getHeight(x, y - 1);
				var sT:Int = getHeight(x, y + 1);
				var eT:Int = getHeight(x + 1, y);
				var wT:Int = getHeight(x - 1, y);
				//find lowest adjacent tile
				var minAdjacent = Math.min(nT, sT);
				minAdjacent = Math.min(minAdjacent, eT);
				minAdjacent = Math.min(minAdjacent, wT);
				if (minAdjacent + 1 < getHeight(x, y)) {
					eroded = true;
					digTile(x, y, -1, false);
					//move that sand to a downhill tile, prioritizing south tiles
					var cT:Int = heightMap[x][y];
					if (sT < cT) {
						digTile(x, y + 1, 1, false);
					}
					else if (eT < cT || wT < cT) {
						//randomly prioritize east or west
						if (FlxRandom.chanceRoll(50)) {
							if (eT < cT) {
								digTile(x + 1, y, 1, false);
							} else {
								digTile(x - 1, y, 1, false);
							}
						} else {
							if (wT < cT) {
								digTile(x - 1, y, 1, false);
							} else {
								digTile(x + 1, y, 1, false);
							}
						}
					} else if(nT < cT) {
						digTile(x, y - 1, 1, false);
					}
				}
			}
		}
		//keep eroding until we've reached stabilitiy.
		if (eroded)
			erode();
	}
	
	function getHeight(x:Int, y:Int) {
		if (x < 0 || y < 0 || x >= WIDTH || y >= DEPTH) {
			return getEdgeHeight(x, y);
		}
		return heightMap[x][y];
	}
	
	function getEdgeHeight(x:Int, y:Int) {
		if (y >= DEPTH) 
			return TOPHEIGHT;
		if (y < 0) {
			return BOTTOMHEIGHT;
		}
		return Math.floor((y / DEPTH) * TOPHEIGHT);
	}
	
	public function moveWave(wave:Wave)
	{
		wave.move(wave.xTile, wave.yTile + 1, 2);
		if (getHeight(wave.xTile, wave.yTile) > getHeight(wave.xTile, wave.yTile - 1)){
			wave.hit();
			digTile(wave.xTile, wave.yTile, -1, true);
		}
	}
	
	override public function update():Void {
		if (FlxG.keys.anyJustPressed(["ENTER", "ESCAPE"])) {
			FlxG.switchState(new GameState());
		}
		
		if (FlxRandom.chanceRoll(10)) {
			var w:Wave = new Wave(FlxRandom.intRanged(0, WIDTH - 1), -1, this);
			waveGroup.add(w);
		}
		
		super.update();
	}
	
}