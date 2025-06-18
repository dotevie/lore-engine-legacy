package lore;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import haxe.Exception;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ControlGlyphsGroup extends FlxSpriteGroup {
    public var text(default, set):String;
    public function set_text(text:String):String {
        this.text = text;
        if (!__delayUpdate) updateGlyphs();
        return text;
    }
    public var keyboardKeys:Array<String>;
    public var consoleKeys:Array<String>;
    private var __delayUpdate:Bool = false;
    private var __internalLength:Int = 0;
    private var __glyphs:Array<FlxSprite> = [];
    private var __text:FlxText;

    public override function get_height():Float {
        return 32;
    }
    public override function get_width():Float {
        var totalWidth:Float = 0;
        for (glyph in __glyphs) {
            totalWidth += glyph.width; // 4 pixels spacing
        }
        return totalWidth + __text.width + 4;
    }
    public function new(?x:Float = 0, ?y:Float = 0, text:String, keyboardKeys:Array<String>, consoleKeys:Array<String>) {
        super(x,y);
        __delayUpdate = true;
        this.text = text;
        this.keyboardKeys = keyboardKeys;
        this.consoleKeys = consoleKeys;
        __internalLength = ClientPrefs.controllerMode ? consoleKeys.length : keyboardKeys.length;
        if (keyboardKeys == null || consoleKeys == null) {
            throw new Exception("ControlGlyphsGroup: keyboardKeys and consoleKeys cannot be null.");
        }
        if (keyboardKeys.length == 0) {
            throw new Exception("ControlGlyphsGroup: keyboardKeys and consoleKeys cannot be empty.");
        }
        __delayUpdate = false;
        __text = new FlxText(0, 0).setFormat(Paths.font("SegoeBold.ttf"), 24, FlxColor.WHITE, LEFT);
        __text.scrollFactor.set(0, 0);
        add(__text);
        updateGlyphs();

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (ClientPrefs.controllerMode) {
            if (consoleKeys != null && consoleKeys.length != __internalLength) {
                __internalLength = consoleKeys.length; 
                updateGlyphs();
            }
        }
        else {
            if (keyboardKeys != null && keyboardKeys.length != __internalLength) {
                __internalLength = keyboardKeys.length; 
                updateGlyphs();
            }
        }
    }

    public function updateGlyphs() {
        for (glyph in __glyphs) {
            __glyphs.remove(glyph);
            remove(glyph);
            glyph.destroy();
        }
        var startX:Float = 0;
        var glyphArray = lore.ControlGlyphsHandler.getGlyphArray(keyboardKeys, consoleKeys);
        for (key in glyphArray) {
            var spr = new FlxSprite(startX).loadGraphic(key);
            spr.scale.set(0.5, 0.5);
            spr.updateHitbox();
            __glyphs.push(spr);
            spr.scrollFactor.set(0, 0);
            add(spr);
            startX += spr.width; // 4 pixels spacing
        }
        __text.text = text;
        __text.x = startX + 4;
    }
}