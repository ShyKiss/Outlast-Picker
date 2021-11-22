Class PickerInput extends OLPlayerInput within PickerController
    Config(Input);

var PrivateWrite IntPoint MousePos;
var array<Name> Keys;
var Vector2D Movement, Turning;
var Bool bSpacePressed;

Event PlayerInput(Float DeltaTime) {
    if(myHUD != None && PickerHud(HUD).ToggleHUD) {
        MousePos.X = Clamp(MousePos.X + aMouseX, 0, myHUD.SizeX);
        MousePos.Y = Clamp(MousePos.Y - aMouseY, 0, myHUD.SizeY);
    }
    Super.PlayerInput(DeltaTime);
    Movement=Vect2D(aBaseY, aStrafe);
    Turning=Vect2D(aMouseX, aMouseY);
}

Function Bool Key(Int ControllerId, Name Key, EInputEvent Event, Float AmountDepressed = 1.f, Bool bGamepad=false) {
    if(ContainsName(Keys, Key)) {
        Keys.RemoveItem(Key);
        return false;
    }
    Keys.AddItem(Key);
    if(PickerHud(HUD).ToggleHUD) {
        Switch(Key) {
            case 'LeftMouseButton':
                PickerHud(HUD).Click();
                break;
            case 'RightMouseButton':
                PickerHud(HUD).Back();
                break;
            case 'Enter':
                PickerHud(HUD).Commit();
                break;
            case 'Delete':
                PickerHud(HUD).Command = "";
                break;
            case 'Backspace':
                PickerHud(HUD).Command = Left(PickerHud(HUD).Command, Len(PickerHud(HUD).Command)-1);
                break;
            case 'Tilde':
                ConsoleCommand("TogglePickerMenu false");
                break;
        }
        return true;
    }
    else {
        Switch(Key) {
            case 'Space':
                bSpacePressed = true;
            Default:
                bSpacePressed = false;
        }
    }
    return false;
}

Function Bool Char(Int ControllerId, String Unicode) {
    local Int Character;

    Character = Asc(Left(Unicode, 1));
    if(PickerHud(HUD).ToggleHUD) {
        if(Character >= 0x20 && Character < 0x100 && Unicode!="`") {
            PickerHud(HUD).Command = PickerHud(HUD).Command $ Unicode;
        }
        return true;
    }
    return false;
}

Function Bool ContainsName(Array<Name> Array, Name Find) {
    Switch(Array.Find(Find)) {
        case -1:
            return false;
            break;
        Default:
            return true;
            break;
    }
}

DefaultProperties
{
    OnReceivedNativeInputKey=Key
    OnReceivedNativeInputChar=Char
}