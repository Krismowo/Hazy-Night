package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function creature1(?tim:FlxTimer){
		new FlxTimer().start(FlxG.random.Float(1, 2), creature1);
	}
	
	public function creature2(?tim:FlxTimer){
		new FlxTimer().start(FlxG.random.Float(1, 2), creature2);
		
	}
	
	public function creature3(?tim:FlxTimer){
		new FlxTimer().start(FlxG.random.Float(1, 2), creature3);
		
	}
	
	public function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0){
					if(countByColor.exists(colorOfThisPixel)){
						countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
					}else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}
}