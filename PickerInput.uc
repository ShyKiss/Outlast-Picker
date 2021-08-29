class PickerInput extends OLPlayerInput
    Config(Tool);

var PrivateWrite IntPoint MousePos;
var array<Name> Keys;
var vector2D Movement, Turning;

Event PlayerInput(float DeltaTime) {

    if (myHUD != None /*&& PickerHud(HUD).ToggleHUD==true*/) {

        MousePos.X = Clamp(MousePos.X + aMouseX, 0, myHUD.SizeX);
        MousePos.Y = Clamp(MousePos.Y - aMouseY, 0, myHUD.SizeY);
    }

    Super.PlayerInput(DeltaTime);
    Movement=vect2d(aBaseY, aStrafe);
    Turning=vect2d(aMouseX, aMouseY);
}

Function bool Key(Int ControllerId, Name Key, EInputEvent Event, Float AmountDepressed = 1.f, bool bGamepad=false) {

    if (ContainsName(Keys, Key)) {
        Keys.RemoveItem(Key);
        return false;
    }

    Keys.additem(Key);
    if (PickerHud(HUD).ToggleHUD==true) {
        switch (key) {
            Case 'LeftMouseButton':
                PickerHud(HUD).Click();
                break;

            case 'Enter':
                PickerHud(HUD).Commit();
                break;

            case 'Backspace':
                PickerHud(HUD).Command = Left(PickerHud(HUD).Command, len(PickerHud(HUD).Command)-1);
                break;

            case 'Tilde':
                ConsoleCommand("TogglePickerMenu False");
                break;
        }

        return true;
    }

    return false;
}

Function Bool Char(Int ControllerId, string Unicode) {
    local int Character;

    Character = Asc(Left(Unicode, 1));

    if (PickerHud(HUD).ToggleHUD==true) {
        if (Character >= 0x20 && Character < 0x100 && Unicode!="`") {
            PickerHud(HUD).Command = PickerHud(HUD).Command $ Unicode;
        }
        return true;
    }
    return false;
}

Function Bool ContainsName(Array<Name> Array, Name find) {
    Switch(Array.Find(find))
    {
        case -1:
            return False;
        break;

        default:
            return true;
        break;
    }
}

Defaultproperties
{
    OnReceivedNativeInputKey=Key
    OnReceivedNativeInputChar=Char
}