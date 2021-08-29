class PickerGame extends OLGame
    Config(Tool);

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal) { return Default.class; }

DefaultProperties
{
    PlayerControllerClass=Class'Picker.PickerController'
    HUDType=Class'Picker.PickerHud'
    DefaultPawnClass=Class'Picker.PickerHero'
}