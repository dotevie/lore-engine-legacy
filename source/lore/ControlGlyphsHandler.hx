package lore;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.input.gamepad.FlxGamepadManager;

class ControlGlyphsHandler {
    public static var controlType(get, null):String;
    public static function get_controlType():String {
        if (!ClientPrefs.controllerMode) return "keyboard";
        if (FlxG.gamepads.firstActive == null) return "xbox";
        switch (FlxG.gamepads.firstActive.model) {
            case PS4:
                return "ps";
            case SWITCH_PRO | SWITCH_JOYCON_LEFT | SWITCH_JOYCON_RIGHT:
                return "switch";
            default:
                return "xbox";
        }
        return "xbox";
    }

    public static function glyph(key:String):FlxGraphic {
        return Paths.image('controlGlyphs/${controlType}/${key}');
    }
    
    public static function getGlyphArray(keyboardKeys:Array<String>, controllerKeys:Array<String>):Array<FlxGraphic> {
        var retVal:Array<FlxGraphic> = [];
        if (controlType == "keyboard") {
            for (key in keyboardKeys) {
                if (ClientPrefs.keyBinds.get(key) != null) {
                    retVal.push(glyph(ClientPrefs.keyBinds.get(key)[0].toString()));
                }
                else retVal.push(glyph(key) ?? glyph("QUESTIONMARK"));
            }
        } else {
            for (key in controllerKeys) {
                retVal.push(glyph(key) ?? Paths.image('controlGlyphs/keyboard/QUESTIONMARK'));
            }
        }
        return retVal;
    }

}