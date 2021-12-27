Class PickerInput extends OLPlayerInput within PickerController
    Config(Input);

var PrivateWrite IntPoint MousePos;
var array<Name> Keys;
var Vector2D Movement, Turning;
var Bool bSpacePressed;
var String MathTasksAnswer;
var Bool bCtrlPressed;

Event PlayerInput(Float DeltaTime) {
    if(myHUD != None && PickerHud(HUD).ToggleHUD) {
        MousePos.X = Clamp(MousePos.X + aMouseX, 0, myHUD.SizeX);
        MousePos.Y = Clamp(MousePos.Y - aMouseY, 0, myHUD.SizeY);
    }
    Super.PlayerInput(DeltaTime);
    Movement=Vect2D(aBaseY, aStrafe);
    Turning=Vect2D(aMouseX, aMouseY);
}

Function Bool Key(Int ControllerId, Name Key, EInputEvent Event, Float AmountDepressed=1.f, Bool bGamepad=false) {
    local Name PKName;
    local Int PKIndex;

    /*if(ContainsName(Keys, Key)) {
        Keys.RemoveItem(Key);
        return false;
    }
    Keys.AddItem(Key);*/
    if(PickerHud(HUD).ToggleHUD && Event == IE_Pressed || PickerHud(HUD).ToggleHUD && Event == IE_Repeat) {
        if(bCtrlPressed) {
            Switch(Key) {
                case 'V':
                    SendMsg("Pasted from Clipboard!");
                    PickerHud(HUD).Command = PickerHud(HUD).Command $ PasteFromClipBoard();
                    break;
                case 'C':
                    if(PickerHud(HUD).Command != "") {
                        SendMsg("Copied to Clipboard!");
                        CopyToClipboard(PickerHud(HUD).Command);
                    }
                    else {
                        SendMsg("Nothing to Copy!");
                    }
                    break;
                case 'X':
                    if(PickerHud(HUD).Command != "") {
                        SendMsg("Carved and Copied to Clipboard!");
                        CopyToClipboard(PickerHud(HUD).Command);
                        PickerHud(HUD).Command = "";
                    }
                    else {
                        SendMsg("Nothing to Copy!");
                    }
                    break;
                case 'LeftControl':
                    return false;
                    break;
            }
            return true;
        }
        else {
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
                    TogglePickerMenu(false);
                    break;
                case 'LeftControl':
                    return false;
                    break;
            }
            return true;
        }
    }
    else if(PickerHud(HUD).MathTasksHUD && MathTasksTimer && Event == IE_Pressed || PickerHud(HUD).MathTasksHUD && MathTasksTimer && Event == IE_Repeat) {
        Switch(Key) {
            case 'Delete':
                MathTasksAnswer = "";
                break;
            case 'Backspace':
                MathTasksAnswer = Left(MathTasksAnswer, Len(MathTasksAnswer)-1);
                break;
            case 'LeftControl':
                return false;
                break;
        }
        return true;
    }
    return false;
}

Function Bool Char(Int ControllerId, String Unicode) {
    local Int Character;

    Character = Asc(Left(Unicode, 1));
    //SendMsg(Unicode);
    if(PickerHud(HUD).ToggleHUD) {
        if(Character >= 0x20 && Character < 0x100 && Unicode != "`" || Character >= 0x410 && Character < 0x450 && Unicode != "`") {
            PickerHud(HUD).Command = PickerHud(HUD).Command $ Unicode;
        }
        return true;
    }
    else if(PickerHud(HUD).MathTasksHUD && MathTasksTimer) {
        if(Character >= 0x30 && Character < 0x3A && Unicode != "`") {
            MathTasksAnswer = MathTasksAnswer $ Unicode;
        }
        return true;
    }
    return false;
}

/*Function Bool ContainsName(Array<Name> Array, Name Find) {
    Switch(Array.Find(Find)) {
        case -1:
            return false;
            break;
        Default:
            return true;
            break;
    }
}*/

/*Function Bool CheckReleasedCtrl(Name Key, EInputEvent Event) {
    if(Key == 'LeftControl' && Event == 1 || Key == 'RightControl' && Event == 1 || Key == 'LeftControl' && Event == 2 || Key == 'RightControl' && Event == 2) {
        bCtrlPressed = true;
        return true;
    }
    else {
        bCtrlPressed = false;
        return false;
    }
  /*  if((Key == 'LeftControl') || Key == 'RightControl') {
        if(Event == 0 || Event == 2) {
            bCtrlPressed = true;
        }
        else {
            bCtrlPressed = false;
        }
        ResetInput();*/
      //  return true;
   // }
    //else {
     /*   if(bCtrlPressed) {
            if(Key == 'V') {
                SendMsg("Pasted from clipboard!");
                PickerHud(HUD).Command = PickerHud(HUD).Command $ PasteFromClipBoard();
               // ResetInput();
                return true;
            }
            else if(Key == 'C') {
                SendMsg("Copied to clipboard!");
                CopyToClipboard(PickerHud(HUD).Command);
               // ResetInput();
                return true;
            }
            else if(Key == 'X') {
                if(PickerHud(HUD).Command != "") {
                    CopyToClipboard(PickerHud(HUD).Command);
                    PickerHud(HUD).Command = "";
                }
                else {
                    SendMsg("Nothing to copy!");
                }
              //  ResetInput();
                return true;
            }
        }*/
  //  return false;
}*/

DefaultProperties
{
    OnReceivedNativeInputKey = Key
    OnReceivedNativeInputChar = Char
}