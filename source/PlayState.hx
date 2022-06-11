package;

import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class PlayState extends FlxState
{
	public var place:String = "forwards";
	public var sanity:Float = 100;
	public var sanitybar:FlxBar;
	public var music:FlxSound = new FlxSound();
	public var creaturehere1:Bool = false;
	public var creaturehere2:Bool = false;
	public var creaturehere3:Bool = false;
	public var cam_forwards:FlxCamera;
	public var cam_window:FlxCamera;
	public var cam_blanket:FlxCamera;
	public var cam_ui:FlxCamera;
	public var creature1_sprite:FlxSprite;
	public var creature2_sprite:FlxSprite;
	public var creature3_sprite:FlxSprite;
	public var light_sprite:FlxSprite;
	public var light_on:Bool = false;
	public var can_turn_on:Bool = true;
	override public function create():Void
	{
		super.create();
		cam_forwards = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(cam_forwards);
		
		cam_window = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		cam_window.visible = false;
		FlxG.cameras.add(cam_window);
		
		cam_blanket = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		cam_blanket.visible = false;
		FlxG.cameras.add(cam_blanket);
		
		cam_ui = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(cam_ui);
		cam_ui.bgColor.alpha = 0;
		
		sanitybar = new FlxBar(5, 5, TOP_TO_BOTTOM, 10, FlxG.height - 10, this, "sanity", 0, 100, true);
		sanitybar.createFilledBar(FlxColor.LIME, FlxColor.GREEN);
		sanitybar.camera = cam_ui;
		add(sanitybar);
		
		creature1_sprite = new FlxSprite(0, 0).loadGraphic("PLACEHOLDERZ/20220528_132712.jpeg");
		creature1_sprite.visible = false;
		
		creature2_sprite = new FlxSprite(0, 0).loadGraphic("PLACEHOLDERZ/caption (2).jpeg");
		creature2_sprite.visible = false;
		
		creature3_sprite = new FlxSprite(creature1_sprite.x + creature1_sprite.width, 0).loadGraphic("PLACEHOLDERZ/FKLOa_qWYAEcbss.jpg");
		creature3_sprite.visible = false;
		
		light_sprite = new FlxSprite(creature3_sprite.x, creature3_sprite.y + creature3_sprite.height).loadGraphic("PLACEHOLDERZ/Capture.PNG");
		light_sprite.visible = false;
		
		creature1_sprite.camera = cam_forwards;
		creature2_sprite.camera = cam_window;
		creature3_sprite.camera = cam_forwards;
		light_sprite.camera = cam_forwards;
		
		add(light_sprite);
		add(creature1_sprite);
		add(creature2_sprite);
		add(creature3_sprite);
		#if !debug 
		new FlxTimer().start(FlxG.random.float(15, 20), function(bob){
		#end //someone other than tim this time lol :troll:
			creature1();
			creature2();
			creature3();
			creaturehere1 = false;
			creaturehere2 = false;
			creaturehere3 = false;
		#if !debug
		});
		#end
		
		music.loadEmbedded("PLACEHOLDERZ/Music_7.ogg");
		FlxG.sound.list.add(music);
		music.looped = false;
		//creature1_sprite.visible = false;
		//creature2_sprite.visible = false;
		//creature3_sprite.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(place == "blanket"){
			sanity -= elapsed * FlxG.random.float(1.2,3);
		}
		if (FlxG.keys.justPressed.SPACE && !light_on && can_turn_on && place == "forwards"){
			trace("light on");
			can_turn_on = false;
			light_sprite.visible = true;
			light_on = true;
			FlxTween.tween(this, {sanity:Math.min(sanity + FlxG.random.float( 12, 17.4),100)}, FlxG.random.float(3,5), {ease: FlxEase.quadOut});
			new FlxTimer().start(FlxG.random.float(10,10.9), function(tim){
				light_sprite.visible = false;
				light_on = false;
				new FlxTimer().start(8,function(bobby){
					can_turn_on = true;
				});
			});
		}else if(FlxG.keys.justPressed.SPACE && place == "window"){
			if (music.playing){
				music.pause();
			}else{
				music.play();
			}
		}
		if(FlxG.keys.justPressed.DOWN){
			transition(place, "blanket");
		}
		if(FlxG.keys.justPressed.LEFT){
			transition(place, "window");
		}
		if(FlxG.keys.justPressed.RIGHT){
			transition(place, "forwards");
		}
	}
	
	public function transition(oldplace:String, newplace:String){
		trace(oldplace);
		trace(newplace);
		if(oldplace == newplace){
			return;
		}
		switch(oldplace){
			case "forwards":
				cam_forwards.visible = false;
			case "window":
				cam_window.visible = false;
			case "blanket":
				cam_blanket.visible = false;
		}
		switch(newplace){
			case "forwards":
				cam_forwards.visible = true;
			case "window":
				cam_window.visible = true;
			case "blanket":
				cam_blanket.visible = true;
		}
		place = newplace;
	}
	
	public function jumpscare(numb:Int = 0){
		trace("jumpscare from " + numb);
	}
	
	public function creature1(?tim:FlxTimer){
		trace("turn nm1");
		if (!light_on && place != "blanket"){
			if (FlxG.random.bool(FlxG.random.float(8, 15)) && !creaturehere1){
				trace("turn nm 1 here");
				creaturehere1 = true;
				creature1_sprite.visible = true;
			}else if (creaturehere1 && FlxG.random.bool(FlxG.random.int(7, 10))){
				jumpscare(1);
				creature1_sprite.visible = false;
				creaturehere1 = false;
			}
		}else{
			if (creaturehere1){
				if (FlxG.random.bool(FlxG.random.float(70, 85))){
					creaturehere1 = false;
					creature1_sprite.visible = false;
				}
			}
		}
		new FlxTimer().start(FlxG.random.float(3.5, 5.9), creature1);
	}
	
	public function creature2(?tim:FlxTimer){
		trace("turn nm2");
		if ((light_on || music.playing) && place != "blanket"){
			if (!creaturehere2 &&  FlxG.random.bool(FlxG.random.int(10, 17))){
				trace("turn nm 2 here");
				creaturehere2 = true;
				creature2_sprite.visible = true;
			}else if(creaturehere2 && FlxG.random.bool(FlxG.random.int(15,(if(FlxG.random.bool(4)) 54 else 45 )))){
				jumpscare(2);
				creature2_sprite.visible = false;
				creaturehere2 = false;
			}
			new FlxTimer().start(FlxG.random.float(7, 9), creature2);
		}else{
			if(creaturehere2){
				if (FlxG.random.bool(FlxG.random.int(60, 75))){
					creaturehere2 = false;
					creature2_sprite.visible = false;
				}
			}
			new FlxTimer().start(FlxG.random.float(3.5, 5.9), creature2);
		}
	}
	
	public function creature3(?tim:FlxTimer){
		trace("turn nm3");
		if (!music.playing && place != "blanket"){
			if (!creaturehere3 && FlxG.random.bool(FlxG.random.int(10, 15))){
				trace("turn nm 3 here");
				creaturehere3 = true;
				creature3_sprite.visible = true;
			}else if(creaturehere3 && FlxG.random.bool(FlxG.random.int(15,54))){
				jumpscare(3);
				creature3_sprite.visible = false;
				creaturehere3 = false;
			}
		}else{
			if (FlxG.random.bool(FlxG.random.int(65, 85))){
					creaturehere3 = false;
					creature3_sprite.visible = false;
				}
		}
		new FlxTimer().start(FlxG.random.float(3.5, 5.9), creature3);
	}
}