class PickerHero extends OLHero
    Config(Tool);

var PickerController Controller;
var PickerInput Input;
var OLAnimBlendBySpeed AnimBlendBySpeed;
var bool GodMode;
var bool GodModeInNoclip;
var bool DisableWater;

Event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if(!DisableWater) {
        if((NewVolume != none) && NewVolume.bWaistDeepWater) {OnEnterDeepWater(NewVolume);}  
    }
}

Event Landed(Vector HitNormal, Actor FloorActor)
{
    local Vector Impulse;
    if (!Controller.bBhop)
    {
        super.Landed(HitNormal, FloorActor);
        return;
    }
    TakeFallingDamage();
}

Function PossessedBy(Controller C, bool bVehicleTransition)
{
    LogInternal("Player Respawned");
    PickerController(C).InitPlayerModel();
    super.PossessedBy(C, bVehicleTransition);    
    Controller=PickerController(C);
    Input = PickerInput(Controller.Playerinput);
}

Event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{if(GodMode) {return;} else if(GodModeInNoclip) {return;} else {Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);}}

Function TakeFallingDamage() {if(GodMode) {return;} else if(GodModeInNoclip) {return;} else {NativeTakeFallingDamage();}}

Event RespawnHero()
{
    ConsoleCommand("TogglePickerMenu 0");
    super.RespawnHero();
}

simulated Event FellOutOfWorld(class<DamageType> dmgType)
{
    if (!GodModeInNoclip)
    {
        ConsoleCommand("TogglePickerMenu 0");
        super.FellOutOfWorld(dmgType);
    }
}

singular simulated Event OutsideWorldBounds()
{
    if (!GodModeInNoclip)
    {
        ConsoleCommand("TogglePickerMenu 0");
        RespawnHero();
    }
}
DefaultProperties
{
    begin object name=MyLightEnvironment
        bEnabled=True
        bUseBooleanEnvironmentShadowing=false
        bSynthesizeSHLight=true
        bIsCharacterLightEnvironment=true
        bForceNonCompositeDynamicLights=true
    End Object
    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)

    begin object name=WPawnSkeletalMeshComponent
        LightEnvironment=MyLightEnvironment
    End Object

    //This is what is used for the shadow.
    begin object name=ShadowProxyComponent
        LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
    End Object

    // This is the head mesh seen in the shadow. 
    begin object name=HeadMeshComp
        LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
    End Object
}