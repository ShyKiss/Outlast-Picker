Class PickerGame extends OLGame
    Config(Picker);

static event Class<GameInfo> SetGameType(String MapName, String Options, String Portal) {
    return Default.Class;
}

Event Tick(Float DeltaTime) {
    local OLDoor Door;
    local Float Energy;
    local PickerHero PickerPawn;
    local PickerController Controller;

    Controller = PickerController(GetALocalPlayerController());
    PickerPawn = PickerHero(Controller.Pawn);
    if(PickerPawn == None || Controller == None) {
        return;
    }

    if(PickerInput(Controller.PlayerInput).IsKeyPressed('LeftControl')) {
        PickerInput(Controller.PlayerInput).bCtrlPressed = true;
    }
    else {
        PickerInput(Controller.PlayerInput).bCtrlPressed = false;
    }

    if(Controller.bAutoBunnyHop) {
        Controller.ConsoleCommand("PressedJump");
    }
    Controller.RandSpecialMoveAnims(!Controller.RandomizerState);

    return;

    if(!IsPlayingDLC() && PickerHero(Controller.Pawn).Health == 100) {
        PickerHero(Controller.Pawn).bHobbling = false;
        PickerHero(Controller.Pawn).bLimping = false;
        PickerHero(Controller.Pawn).HobblingIntensity = 0;
        return;
    }
    else if(!IsPlayingDLC() && PickerHero(Controller.Pawn).Health < 100 && PickerHero(Controller.Pawn).Health != 1) {
        PickerHero(Controller.Pawn).bHobbling = true;
        PickerHero(Controller.Pawn).bLimping = false;
        PickerHero(Controller.Pawn).HobblingIntensity = ((100 - PickerHero(Controller.Pawn).Health) / 100) * 2;
    }
    else if(!IsPlayingDLC() && PickerHero(Controller.Pawn).Health == 1) {
        PickerHero(Controller.Pawn).bHobbling = false;
        PickerHero(Controller.Pawn).HobblingIntensity = 0;
        PickerHero(Controller.Pawn).bLimping = true;
    }

    if(PickerHero(Controller.Pawn).CurrentBatterySetEnergy > 0.9899f) {
        Energy = RandRange(0.0599f, 0.9799f);
        PickerHero(Controller.Pawn).CurrentBatterySetEnergy = Energy;
    }
    Foreach AllActors(Class'OLDoor', Door) {
        Door.bFakeUnlocked = true;
    }
    Super.Tick(DeltaTime);
}

DefaultProperties
{
    PlayerControllerClass=Class'Picker.PickerController'
    HUDType=Class'Picker.PickerHud'
  //  HUDType=Class'OLGame.OLHud'
    DefaultPawnClass=Class'Picker.PickerHero'
  //  DefaultPawnClass=Class'OLGame.OLHero'
}