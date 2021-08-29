Class PickerController extends OLPlayerController
    Config(Tool);

/*** MAIN VARS ***/

var Float BBright, RRadius, QHHD, InsanePlusStamina;
var Byte CR, CG, CB, CA;
var PickerHud PickerHud;
var PickerInput PickerInput;
var PickerGame PickerGame;
var OLEnemySurgeon OLEnemySurgeon;
var OLEngine OLEngine;
var OLGame Game;
var OLCheatManager OLCheatManager;
var SoundCue TeleportSound, ButtonSound, MenuMusic;
var SkeletalMesh Current_SkeletalMesh;
var array<MaterialInterface> Materials;
var AudioComponent MenuMusicComponent;

/*** STRING VARS ***/
var String CustomPM;

/*** BOOL VARS ***/
var Bool SShadow, AIDebug, DoorState, FreecamState, LightState, ForceActive, ChrisState, NoclipState, BoolKillEnemy, ForceActiveDoorTypeLocker, 
ForceActiveDoorTypeNormal, ForceActiveDoorStateLock, ForceActiveDoorStateUnlock, ForceKillEnemy, DoorTypeState, PlayerState, DelDoorState, 
ForceDelDoor, ForceDisAI, EverytimeLightState, bBhop, bFlyMode, bResetTimer, bTimer, bDisAI, bAnimFree, bLMFree, bSMFree, bDark, GroomChrisState,
SMRandomState, AllLoadedState, InsanePlusState, RandomizerState, LSMDamage, ResetJumpStam;

/* FLOAT RANDOMIZER VARS */
var Config Float SmallRandomTime, MediumRandomTime, LargeRandomTime;

/* BOOL INSANEPLUS VARS */
var Config Bool OneBatteryMode, FastEnemyMode, DisCamMode, SlowHeroMode,
OneShotMode, BadBatteryMode, LimitedStaminaMode, NoDarkMode,
SmartAIMode, TrainingMode, SkipDeathScreen;

/************************************************FUNCTIONS************************************************/

Exec Function AllCol() {
    local Actor Actor;

    Foreach AllActors(Class'Actor', Actor) {
        Actor.SetCollision(true, true);
    }
}

Exec Function SpawnProp(StaticMesh Meshh, optional Int MatIndex, optional MaterialInstanceConstant Material) {
    local Vector C;
    local Rotator R;
    local PickerProp D;

    R.Pitch = 0;
    R.Yaw = Pawn.Rotation.Yaw - (90 * 182.044449);
    R.Roll = 0;
    C = Pawn.Location + (normal(Vector(Pawn.Rotation)) * 100);//vect(-7090.32,3245.93,550.04);
    D = Spawn(Class'PickerProp',,,C,R);
    D.SetHidden(False);
    if(Material != None) {D.StaticMeshComponent.SetMaterial(MatIndex, Material);}
    D.StaticMeshComponent.SetStaticMesh(Meshh);
    D.SetCollision(true, true);
}

Exec Function ChangeProp(optional PickerProp Prop, optional StaticMesh Mesh, optional Int MatIndex, optional MaterialInstanceConstant Material) {
    local PickerProp D;
    local Bool bAllProps;

    if(Prop == None) {bAllProps=true;}
    Foreach AllActors(Class'PickerProp', D) {
    if(bAllProps) {if(Material != None) {D.StaticMeshComponent.SetMaterial(MatIndex, Material);} if(Mesh != None) {D.StaticMeshComponent.SetStaticMesh(Mesh);}}
    if(!bAllProps) {if(D == Prop) {if(Material != None) {D.StaticMeshComponent.SetMaterial(MatIndex, Material);} if(Mesh != None) {D.StaticMeshComponent.SetStaticMesh(Mesh);}}}
    }
}

Exec Function DeleteProp(optional PickerProp Prop) {
    local PickerProp D;
    local Bool bAllProps;

    if(Prop==None) {bAllProps=true;}
    Foreach AllActors(Class'PickerProp', D) {
    if(bAllProps) {D.Destroy();}
    if(!bAllProps) {if(D == Prop) {D.Destroy();}}
    }
}

/************************RANDOMIZER FUNCTIONS************************/

Exec Function ModifyRandomizer(Byte Modify, Float Time) {
    if(Modify==0) {SmallRandomTime=Time;}
    if(Modify==1) {MediumRandomTime=Time;}
    if(Modify==2) {LargeRandomTime=Time;}
}

Exec Function ToggleRandomizer(optional bool d=false) {RandomizerState=!RandomizerState; if(RandomizerState) {ClientMessage("RANDOMIZER STARTED, ENJOY!"); Randomizer(d); return;} ClientMessage("RANDOMIZER DISABLED!"); Randomizer(false);}
Function Randomizer(Bool FullyRandom) {

if(!RandomizerState) {
    WorldInfo.Game.ClearTimer('RandomizerSmallRandom', Self);
    WorldInfo.Game.ClearTimer('RandomizerMediumRandom', Self);
    WorldInfo.Game.ClearTimer('RandomizerLargeRandom', Self);
    WorldInfo.Game.ClearTimer('RandDoorType', Self);
    return;
}
    WorldInfo.Game.SetTimer(SmallRandomTime, true, 'RandomizerSmallRandom', Self);
    WorldInfo.Game.SetTimer(MediumRandomTime, true, 'RandomizerMediumRandom', Self);
    WorldInfo.Game.SetTimer(LargeRandomTime, true, 'RandomizerLargeRandom', Self);
    WorldInfo.Game.SetTimer(0.5, true, 'RandDoorType', Self);
    //Randomizer();
}

Function RandomizerSmallRandom() {
    local Byte S1R, S2R, S3R, S4R, S5R, S6R, SR;

    SR = RandRange(0, 5);
    `log(string(RandBool()));

    if(SR == 0) {if(RandBool()) {Inputs.bPressedToggleNightVision=!Inputs.bPressedToggleNightVision; return;} Inputs.bPressedToggleCamcorder=!Inputs.bPressedToggleCamcorder;}
    if(SR == 1) {PickerInput.ResetInput(); ClientMessage("Reset");}
    if(SR == 2) {ClientMessage(RandString(6));}
    if(SR == 3) {ClientMessage(RandString(6));}
    if(SR == 4) {ClientMessage(RandString(6));}
    if(SR == 5) {ClientMessage(RandString(6));}
}

Function RandomizerMediumRandom() {
    local Byte M1R, M2R, M3R, M4R, M5R, M6R, MR;

    MR = RandRange(0, 5);

    if(MR == 0) {RandSpawnEnemyCount(1, 3);}
    if(MR == 1) {ClientMessage("Medium 1");}
    if(MR == 2) {ClientMessage("Medium 2");}
    if(MR == 3) {ClientMessage("Medium 3");}
    if(MR == 4) {ClientMessage("Medium 4");}
    if(MR == 5) {ClientMessage("Medium 5");}
}

Function RandomizerLargeRandom() {
    local Byte L1R, L2R, L3R, L4R, L5R, L6R, LR;
    local Bool RSR;

    LR = RandRange(0, 5);

    if(LR == 0) {if(RandRange(0, 100) >= 99) {CP("Admin_Gates"); return;} else {Reload();}}
    if(LR == 1) {GameSpeed(RandRange(0.5, 3));}
    if(LR == 2) {ClientMessage("Large 2");}
    if(LR == 3) {ClientMessage("Large 3");}
    if(LR == 4) {ClientMessage("Large 4");}
    if(LR == 5) {ClientMessage("Large 5");}
}

Exec Function HideObj(bool Hide) {PickerHud(HUD).ObjectiveScreen.SetVisible(Hide);}
Exec Function ShowObj(string ObjectiveText) {if(PickerHud(HUD).ObjectiveScreen == none) {PickerHud(HUD).ObjectiveScreen = new (self) class'OLUIMessage';} if(PickerHud(HUD).ObjectiveScreen != none) {PickerHud(HUD).ObjectiveScreen.Start(false); PickerHud(HUD).ObjectiveScreen.SetMessage(1, "New objective:" @ "" $ (Localize("Objectives", "" $ string(CurrentObjective), "OLGame")));}}

/************************INSANEPLUS FUNCTIONS************************/

Exec Function ModifyInsanePlus(Byte Modify) {
    if(Modify==0) {OneBatteryMode=!OneBatteryMode;}
    if(Modify==1) {FastEnemyMode=!FastEnemyMode;}
    if(Modify==2) {DisCamMode=!DisCamMode;}
    if(Modify==3) {SlowHeroMode=!SlowHeroMode;}
    if(Modify==4) {OneShotMode=!OneShotMode;}
    if(Modify==5) {BadBatteryMode=!BadBatteryMode;}
    if(Modify==6) {LimitedStaminaMode=!LimitedStaminaMode;}
    if(Modify==7) {NoDarkMode=!NoDarkMode;}
    if(Modify==8) {SmartAIMode=!SmartAIMode;}
    if(Modify==9) {TrainingMode=!TrainingMode;}
    if(Modify==10) {SkipDeathScreen=!SkipDeathScreen;}
}

Exec Function ToggleInsanePlus(optional String CPD) {InsanePlusState=!InsanePlusState; InsanePlus(CPD);}
Function InsanePlus(optional String CPD) {
    local PickerGame CGame;
    CGame = PickerGame(WorldInfo.Game);
    if(!InsanePlusState) {
    ConsoleCommand("Set OLAnimBlendBySpeed MaxSpeed 400");
    PickerHero(Pawn).bCameraCracked=false;
    PickerHero(Pawn).DeathScreenDuration=7.50;
    PickerHero(Pawn).NormalWalkSpeed=200;
    PickerHero(Pawn).NormalRunSpeed=450;
    PickerHero(Pawn).CrouchedSpeed=75;
    PickerHero(Pawn).BatteryDuration=150;
    PickerHud(HUD).SetMenu(Normal); CGame.DifficultyMode=EDM_Normal;
    OneBatteryMode=Default.OneBatteryMode; FastEnemyMode=Default.FastEnemyMode; DisCamMode=Default.DisCamMode;
    SlowHeroMode=Default.SlowHeroMode; OneShotMode=Default.OneShotMode; BadBatteryMode=Default.BadBatteryMode;
    LimitedStaminaMode=Default.LimitedStaminaMode; NoDarkMode=Default.NoDarkMode; SmartAIMode=Default.SmartAIMode;
    WorldInfo.Game.ClearTimer('InsanePlusOneBattery', Self);
    WorldInfo.Game.ClearTimer('InsanePlusDisCam', Self);
    WorldInfo.Game.ClearTimer('InsanePlusSlowHero', Self);
    WorldInfo.Game.ClearTimer('InsanePlusFastEnemy', Self);
    WorldInfo.Game.ClearTimer('InsanePlusNoDark', Self);
    WorldInfo.Game.ClearTimer('InsanePlusOneShot', Self);
    WorldInfo.Game.ClearTimer('InsanePlusLimitedStamina', Self);
    WorldInfo.Game.ClearTimer('InsanePlusBadBattery', Self);
    WorldInfo.Game.ClearTimer('InsanePlusSmartAI', Self);
    WorldInfo.Game.ClearTimer('InsanePlusMainFunc', Self);
    ClientMessage("INSANE PLUS DISABLED!"); return;
    }

    PickerHud(HUD).SetMenu(DisInsanePlus);
    if(!TrainingMode) {CGame.DifficultyMode=EDM_Insane;} if(TrainingMode) {CGame.DifficultyMode=EDM_Nightmare;}
    LSMDamage=true;
    WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusMainFunc', Self);
    if(!SlowHeroMode) {InsanePlusSlowHero(true);}
    if(OneBatteryMode) {DefaultNumBatteries=0; NumBatteries=0; NightmareMaxNumBatteries=1; WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusOneBattery', Self);}
    if(DisCamMode) {WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusDisCam', Self);}
    if(SlowHeroMode) {ConsoleCommand("Set OLAnimBlendBySpeed MaxSpeed 360"); WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusSlowHero', Self);}
    if(FastEnemyMode) {WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusFastEnemy', Self);}
    if(NoDarkMode) {WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusNoDark', Self);}
    if(OneShotMode) {WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusOneShot', Self);}
    if(BadBatteryMode) {WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusBadBattery', Self);}
    if(SmartAIMode) {WorldInfo.Game.SetTimer(0.001, true, 'InsanePlusSmartAI', Self);}
    if(LimitedStaminaMode) {InsanePlusStamina=100; WorldInfo.Game.SetTimer(0.01, true, 'InsanePlusLimitedStamina', Self);}
    if(!TrainingMode) {if(CGame.IsPlayingDLC()) {CP("Hospital_Free", false);} if(!CGame.IsPlayingDLC()) {CP("Admin_Gates", false);}}
    if(TrainingMode) {if(CGame.IsPlayingDLC()) {CP(CPD, false);} if(!CGame.IsPlayingDLC()) {CP(CPD, false);}}
    ClientMessage("INSANE PLUS STARTED, ENJOY!");

} // if(InsanePlusState) {ToggleInsanePlus(); ConsoleCommand("open dlc_mainmenugame");}

Function InsanePlusMainFunc() {
    local PickerGame CGame;
    CGame = PickerGame(WorldInfo.Game);
    PickerHero(Pawn).BatteryDuration=90;
    if(SkipDeathScreen) {PickerHero(Pawn).DeathScreenDuration=0.75;}
    PickerHero(Pawn).bCameraCracked=true;
    if(CGame.IsPlayingDLC()) {PickerHero(Pawn).ShatteredCameraGlassCheckpoint='Hospital_Free'; FirstSoldierFindableCheckpoint='Hospital_Free';}
    if(!CGame.IsPlayingDLC()) {PickerHero(Pawn).ShatteredCameraGlassCheckpoint='Admin_Gates'; FirstSoldierFindableCheckpoint='Admin_Basement'; FirstSurgeonFindableCheckpoint='Male_TortureDone';}
}
Function InsanePlusSmartAI() {
    local OLDoor Door;
    local Name Admin_Basement, Male_TortureDone;

    FirstSoldierFindableCheckpoint=Admin_Basement;
    FirstSurgeonFindableCheckpoint=Male_TortureDone;
    Foreach AllActors(Class'OLDoor', Door) {
        Door.bDontBreak=true;
        Door.bAICanUseDoor=true;
        Door.bAlwaysBreak=false;
}
}
Function InsanePlusBadBattery() {
    local Float Energy;
    if(PickerHero(Pawn).CurrentBatterySetEnergy > 0.9) {
        Energy = RandRange(0.05, 0.85);
        PickerHero(Pawn).CurrentBatterySetEnergy=Energy;
}
}

Function InsanePlusLimitedStamina() {
    local Bool IsMoving;
    local PickerInput Input;
    Input = PickerInput(PlayerInput);
    IsMoving=Input.Movement.X!=0 || Input.Movement.Y!=0;
    if(PickerHero(Pawn).LocomotionMode==LM_Walk || PickerHero(Pawn).LocomotionMode==LM_LookBack || PickerHero(Pawn).LocomotionMode==LM_Fall) {
    if(PickerHero(Pawn).IsRunning()) {if(InsanePlusStamina > 0) {InsanePlusStamina -= 0.01;}}
    if(IsMoving && Input.Outer.bDuck==0) { if(IsMoving && !PickerHero(Pawn).bWasUnder) {if(InsanePlusStamina > 0) {InsanePlusStamina -= 0.045;}}}}
    if(PickerHero(Pawn).bJumping) {if(InsanePlusStamina > 0 && !ResetJumpStam) {
        ResetJumpStam=true; InsanePlusStamina -= 25;}}
    if(PickerHero(Pawn).LocomotionMode==LM_Walk && !PickerHero(Pawn).bJumping && ResetJumpStam) {WorldInfo.Game.SetTimer(0.1, false, 'InsanePlusLSAddFunc2', Self);}
    if(PickerHero(Pawn).LocomotionMode!=LM_Walk && PickerHero(Pawn).LocomotionMode!=LM_LookBack && PickerHero(Pawn).LocomotionMode!=LM_Fall) {PickerHero(Pawn).bJumping=false;}
    if(InsanePlusStamina < 0) {InsanePlusStamina=0;}
    if(InsanePlusStamina < 100 && !PickerHero(Pawn).IsRunning() && !PickerHero(Pawn).bJumping) {InsanePlusStamina += 0.08;}

    if(InsanePlusStamina > 15) {
    WorldInfo.Game.ClearTimer('InsanePlusLSAddFunc', Self);
    LSMDamage=true;
    PickerHero(Pawn).ForwardSpeedForJumpWalking=450;
    PickerHero(Pawn).ForwardSpeedForJumpRunning=650;
    PickerHero(Pawn).JumpClearanceWalking=200;
    PickerHero(Pawn).JumpClearanceRunning=300;
    if(SlowHeroMode) {PickerHero(Pawn).NormalRunSpeed=370; return;}
    else {PickerHero(Pawn).NormalRunSpeed=450; return;}
    }
    if(InsanePlusStamina < 15) {
    PickerHero(Pawn).ForwardSpeedForJumpWalking=0;
    PickerHero(Pawn).ForwardSpeedForJumpRunning=0;
    PickerHero(Pawn).JumpClearanceWalking=0;
    PickerHero(Pawn).JumpClearanceRunning=0;
    if(InsanePlusStamina < 5) {
    if(LSMDamage) {WorldInfo.Game.SetTimer(3, false, 'InsanePlusLSAddFunc', Self); LSMDamage=false;}
    if(SlowHeroMode) {PickerHero(Pawn).NormalRunSpeed=135; return;} else {PickerHero(Pawn).NormalRunSpeed=200; return;}}
    if(SlowHeroMode) {PickerHero(Pawn).NormalRunSpeed=250; return;} else {PickerHero(Pawn).NormalRunSpeed=300; return;}}

}
Function InsanePlusLSAddFunc2() {ResetJumpStam=false;}
Function InsanePlusLSAddFunc() {DS(20); LSMDamage=true;}
Function InsanePlusOneBattery() {NightmareMaxNumBatteries=1;}
Function InsanePlusDisCam() {bHasCamcorder=false;}
Function InsanePlusSlowHero(optional bool d=false) {
    local PickerGame CGame;
    local String Checkpoint;
    local Name Lab_BigTowerStairs;

    CGame = PickerGame(WorldInfo.Game);
    Checkpoint = "" $ CGame.CurrentCheckpointName;
    if(d && InsanePlusState) {
        if(PickerHero(Pawn).LocomotionMode==LM_Walk || PickerHero(Pawn).LocomotionMode==LM_LookBack) {PRate(1.11); return;}
        PRate(1);
        InsanePlusSlowHero(true); return;
} else {
        PickerHero(Pawn).NormalWalkSpeed=135;
        PickerHero(Pawn).NormalRunSpeed=370;
        PickerHero(Pawn).CrouchedSpeed=55;
        if(PickerHero(Pawn).LocomotionMode==LM_Walk || PickerHero(Pawn).LocomotionMode==LM_LookBack) {PRate(1.11); return;}
        PRate(1);
        }
}

Function InsanePlusNoDark() {local OLDarknessVolume Darks; Foreach AllActors(Class'OLDarknessVolume', Darks) {Darks.bDark=false;}}
Function InsanePlusFastEnemy() {
    local OLBot Bot;
    local PickerGame CGame;
    local String Checkpoint;
    
    CGame = PickerGame(WorldInfo.Game);
    Checkpoint = "" $ CGame.CurrentCheckpointName;
    if(Checkpoint == "Sewer_Citern2" && SlowHeroMode) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
        Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
        Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=205;
    }return;}
    else if(Checkpoint == "Male_Chase" && SlowHeroMode) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
        Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
        Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=450;
    }return;}
    else if(Checkpoint == "Male_ChasePause" && SlowHeroMode) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
            Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
            Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
            Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=375;
    }return;}
    else if(Checkpoint == "Lab_BigTowerStairs" && SlowHeroMode) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
        Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
        Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=425;
    }return;}
    else if(Checkpoint == "Lab_BigRoomDone" && SlowHeroMode) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
        Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
        Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=360;
    }return;}
    else if(Checkpoint == "Lab_BigTower" && SlowHeroMode) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
        Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
        Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=360;
    }return;}
    else {
        Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
            Bot.EnemyPawn.NormalSpeedValues.PatrolSpeed=200;
            Bot.EnemyPawn.NormalSpeedValues.InvestigateSpeed=245;
            Bot.EnemyPawn.NormalSpeedValues.ChaseSpeed=505;
        }
    }
}

Function InsanePlusOneShot() {
    local OLBot Bot; 
    local OLEnemyPawn Enemy;

    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.AttackNormalDamage=101;
        Bot.EnemyPawn.AttackThrowDamage=101;
        Bot.EnemyPawn.VaultDamage=101;
        Bot.EnemyPawn.DoorBashDamage=101;
    }
}

Exec Function ToggleTimer() {
    bTimer=!bTimer;
}

Exec Function ResetTimer() {
    bResetTimer=true;
}

Exec Function ToggleDeleteDoors(optional bool Force=true) {
    DelDoorState=!DelDoorState;
    if(DelDoorState==false) {if(ForceDelDoor==true) {WorldInfo.Game.ClearTimer('DeleteDoors'); ForceDelDoor=false;} return;}
    if(Force==true) {ForceDelDoor=true;}
    DeleteDoors();
}

Exec Function DeleteDoors() {
    local OLDoor Door;
    Foreach AllActors(Class'OLDoor', Door) {Door.Destroy();}
    if(ForceDelDoor==true) {WorldInfo.Game.SetTimer(0.5, false, 'DeleteDoors', Self);}
}

Exec Function TpEnemy(optional bool Player=false) {
    local OLEnemyPawn Enemy;
    local Vector C;
    local Rotator Rot;
    local Vector D;

    GetPlayerViewPoint(C,Rot);
    C -= vect(0,0,120);
    D = PickerHero(Pawn).Location + vect(0,0,10); //vect(-7090.32,3245.93,550.04);
    Foreach AllActors(Class'OLEnemyPawn', Enemy) {
        Enemy.SetCollision(false,false,false);
        if(Player==true) {Enemy.SetLocation(D);} else {Enemy.SetLocation(C);}
        WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
    }
    if(PickerHud(HUD).DisableTeleportSound==false) {PlaySound(TeleportSound);}
}

Function BackPawnCol() {
    local OLEnemyPawn Enemy;
    Foreach AllActors(Class'OLEnemyPawn', Enemy) {
        Enemy.SetCollision(true,true,true);
        WorldInfo.Game.ClearTimer('BackPawnCol');
    }
}

Exec Function Checkpoint(String Checkpoint, optional bool Save=false) {
    local OLEnemyPawn Enemy;
    local OLCheckpoint OLCheckpoint;
    local PickerGame CGame;

    CGame = PickerGame(WorldInfo.Game);

    Foreach AllActors(Class'OLCheckpoint', OLCheckpoint)
    {
        if(OLCheckpoint.CheckpointName == Name(Checkpoint)) {
            PlayerDied();
            Foreach AllActors(Class'OLEnemyPawn', Enemy) {Enemy.Destroy();}
            if (CGame.IsPlayingDLC()) {ConsoleCommand("StreamMap DLC_Checkpoints");}
            else {ConsoleCommand("StreamMap Intro_Persistent");}
            StartNewGameAtCheckpoint(Checkpoint, Save); return;
        }
    }
    ClientMessage("Wrong Checkpoint!");
}

Exec Function FinishGame(bool Finish=false, optional Byte Game=2) {
    local Byte D;
    local Bool F;
    F=Finish;
    if(F) {D=1;} else {D=0;} if(Game==2) {ProfileSettings.SetProfileSettingValueId(65, D); ProfileSettings.SetProfileSettingValueId(67, D);}
    else if(Game==1) {ProfileSettings.SetProfileSettingValueId(67, D);} else {ProfileSettings.SetProfileSettingValueId(65, D);}
    super.ClientSaveAllPlayerData();
}

Exec Function CP(String CP, optional bool SV=false) {Checkpoint(CP, SV);}
Exec Function Gamma(float GammaValue) {OLCheatManager.SetGamma(GammaValue); PickerHud(HUD).AudioVolume=GammaValue;}
//Exec Function Pause() {super.Pause();}
Exec Function DmgSelf(float Amount) {PickerHero(Pawn).TakeDamage(int(Amount), none, PickerHero(Pawn).Location, vect(0,0,0), none);}
Exec Function DS(float Amount) {DmgSelf(Amount);}
Exec Function Bind(String key, String Command) {ConsoleCommand("setbind " $ Key $ " " $ Command);}
Exec Function Gravity(float Grav) {WorldInfo.WorldGravityZ=Grav;}
Exec Function Tpv() {local CheatManager CheatManager; CheatManager.Teleport();}
Exec Function Paused() {
    PickerInput.ResetInput();
    Game.bSoundOnPause=true;
    //Game.SetPause(PlayerOwner, PickerHud(HUD).CanUnpauseInPauseMenu);
}

Function PlayerDied()
{
    local OLEnemySoldier Enemy;
    ++ NumDeathsSinceLastCheckpoint;
    InventoryManager.ClearGameplayItems();
    InventoryManager.ClearUnsavedBatteries();
    CurrentObjective = 'None';
    PendingRecordingMarker = none;
    if(bDebugGhost) {Superman();}
    if(PickerHero(Pawn).GodMode) {ToggleGodMode();}
    if(FreecamState==true) {ToggleFreecam();}
    ConsoleCommand("TogglePickerMenu False");
    if(InsanePlusState) {LSMDamage=true; InsanePlusStamina=100;}
    if(PlayerState==true) {PickerHero(Pawn).Mesh.SetSkeletalMesh(Current_SkeletalMesh);}
    if(ChrisState==true) {Foreach AllActors(Class'OLEnemySoldier', Enemy) {Enemy.Mesh.SetSkeletalMesh(SkeletalMesh'02_Soldier.Pawn.Soldier-03');} ChrisState=false;}
    if(PickerHud(HUD).TSVBool==true) {ConsoleCommand("TOGGLESTREAMINGVOLUMES"); PickerHud(HUD).TSVBool=false;}
}

Exec Function MadeLight(optional float Bright=0.7, optional float Radius=1024, optional byte R=255, optional byte G=255, optional byte B=255, optional byte A=125, optional bool Shadows=true) {

    local PickerController Controller;
    local Vector C;
    local PickerPointLight L;
    local Rotator Rot;

    GetPlayerViewPoint(C,Rot);
    L = Spawn(Class'PickerPointLight', Self, 'Picklight', C);
    L.OnTurn(true);
    L.SetBrightness(Bright);
    L.SetColor(R,G,B,A);
    L.SetRadius(Radius);
    L.SetCastDynamicShadows(Shadows);
    `log("[Picker] Made a Light!");
}

Exec Function NanoCloudd(SkeletalMesh D) {
    local OLEnemyNanoCloud Cloud;

    Foreach AllActors(Class'OLEnemyNanoCloud', Cloud) {
        Cloud.Mesh.SkeletalMesh=D;
    }
}

Exec Function MadeSpot(optional float Bright=0.7, optional float Radius=1024, optional byte R=255, optional byte G=255, optional byte B=255, optional byte A=125, optional bool Shadows=true) {

    local PickerController Controller;
    local Vector C;
    local PickerSpotLight L;
    local Rotator Rot;

    GetPlayerViewPoint(C,Rot);
    L = Spawn(Class'PickerSpotLight', Self, 'Spotlight', C);
    L.OnTurn(true);
    L.SetBrightness(Bright);
    L.SetColor(R,G,B,A);
    L.SetRadius(Radius);
    L.SetCastDynamicShadows(Shadows);
    `log("[Picker] Made a Spot!");
}

Exec Function RemoveAllPickerPointLights() {

    local PickerPointLight L;
    local PickerSpotLight S;

    L.OnTurn(false);
    S.OnTurn(false);
    Foreach AllActors(Class'PickerPointLight', L) {L.Destroy();}
    Foreach AllActors(Class'PickerSpotLight', S) {S.Destroy();}
    ClientMessage("All Lights Removed!");
}

/************************TOGGLE HUD************************/

Exec Function TogglePickerMenu(Bool Show) {
    Switch(Show) {
    case True:
        PickerHud(HUD).ToggleHUD=true;
        MenuMusicComponent = CreateAudioComponent(MenuMusic);
        if(!PickerHud(HUD).DisableMenuMusic) {MenuMusicComponent.Play();}
        DisableInput(True);
        DebugFreeCamSpeed=0;
        break;

    case False:
        PickerHud(HUD).ToggleHUD=false;
        DisableInput(False);
        PlayerInput.ResetInput();
        MenuMusicComponent.Stop();
        DebugFreeCamSpeed=0.0040;
        break;
    }
    return;
}

Exec Function TPP(Float X, Float Y, Float Z) {local Vector D; D.X=X; D.Y=Y; D.Z=Z; PickerHero(Pawn).SetLocation(D);}
Exec Function SetPlayerOnlyMesh(SkeletalMesh Mesh) {PickerHero(Pawn).Mesh.SetSkeletalMesh(Mesh);}
Exec Function ToggleGodMode() {
    PickerHero(Pawn).GodMode=!PickerHero(Pawn).GodMode;
    if(PickerHero(Pawn).GodMode) {ClientMessage("GodMode ON!"); WorldInfo.Game.SetTimer(0.01, true, 'DisableKillGrab', Self); PickerHero(Pawn).HealthRegenDelay=0.0000000000000001; PickerHero(Pawn).HealthRegenRate=9999999999999999999999999999999999999999;}
    else {ClientMessage("GodMode OFF!"); ResetKillGrab(); PickerHero(Pawn).HealthRegenDelay=PickerHero(Pawn).Default.HealthRegenDelay; PickerHero(Pawn).HealthRegenRate=PickerHero(Pawn).Default.HealthRegenRate;}
}

Exec Function ResetKillGrab() {
    local OLBot Bot;
    local PickerGame CGame;

    CGame = PickerGame(WorldInfo.Game);
    WorldInfo.Game.ClearTimer('DisableKillGrab', Self);
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {if(CGame.DifficultyMode==3 || CGame.DifficultyMode==2 || CGame.DifficultyMode==1) {Bot.EnemyPawn.AttackNormalDamage=Bot.EnemyPawn.HardAttackNormalDamage; Bot.EnemyPawn.AttackThrowDamage=Bot.EnemyPawn.HardAttackThrowDamage;} else if(CGame.DifficultyMode==0) {Bot.EnemyPawn.AttackNormalDamage=Bot.EnemyPawn.NrmAttackNormalDamage; Bot.EnemyPawn.AttackThrowDamage=Bot.EnemyPawn.NrmAttackThrowDamage;} Bot.EnemyPawn.AttackGrabChance=Bot.EnemyPawn.Default.AttackGrabChance; Bot.EnemyPawn.AttackNormalKnockbackPower=Bot.EnemyPawn.Default.AttackNormalKnockbackPower; Bot.EnemyPawn.AttackPushKnockbackPower=Bot.EnemyPawn.Default.AttackPushKnockbackPower;}
}

Exec Function DisableKillGrab() {
    local OLBot Bot;
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) 
    {Bot.EnemyPawn.AttackGrabChance=0; Bot.EnemyPawn.AttackNormalDamage=0; Bot.EnemyPawn.AttackThrowDamage=0; Bot.EnemyPawn.AttackNormalKnockbackPower=0; Bot.EnemyPawn.AttackPushKnockbackPower=0;}
}

Exec Function ToggleLoadLoc() {AllLoadedState=!AllLoadedState; LoadLoc(AllLoadedState);}
Exec Function LoadLoc(bool Load) {
    local PickerController PC;
    local LevelStreamingVolume Volume;
    local int I;

    Foreach AllActors(Class'LevelStreamingVolume', Volume) {Volume.bDisabled=Load;}
    if(Load) {
        Foreach WorldInfo.AllControllers(class'PickerController', PC) {
        I = 0;
        J0xF6:
        if(I < WorldInfo.StreamingLevels.Length) {
        PC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[I].PackageName, true, true, false);
        ++ I;
        goto J0xF6;}
        }
    }
}

Exec Function ChangeDoorsMaterial(String Material) {
    local OLDoor Door;
    local EDoorMaterial M;

    if(Material == "Wood") {M=OLDM_Wood;}
    else if(Material == "Metal") {M=OLDM_Metal;}
    else if(Material == "SecurityDoor") {M=OLDM_SecurityDoor;}
    else if(Material == "BigPrisonDoor") {M=OLDM_BigPrisonDoor;}
    else if(Material == "BigWoodenDoor") {M=OLDM_BigWoodenDoor;}
    ConsoleCommand("Set OLDoor DoorMaterial " $ M);
}

Exec Function ChangeDoorsMeshType(String MeshType) {
    local OLDoor Door;
    local EOLDoorMeshType MT;

    if(MeshType == "Undefined") {MT=DMesh_Undefined;}
    else if(MeshType == "Wooden") {MT=DMesh_Wooden;}
    else if(MeshType == "WoodenOld") {MT=DMesh_WoodenOld;}
    else if(MeshType == "WoodenWindow") {MT=DMesh_WoodenWindow;}
    else if(MeshType == "WoodenWindowSmall") {MT=DMesh_WoodenWindowSmall;}
    else if(MeshType == "WoodenWindowOld") {MT=DMesh_WoodenWindowOld;}
    else if(MeshType == "WoodenWindowOldSmall") {MT=DMesh_WoodenWindowOldSmall;}
    else if(MeshType == "WoodenWindowBig") {MT=DMesh_WoodenWindowBig;}
    else if(MeshType == "Metal") {MT=DMesh_Metal;}
    else if(MeshType == "MetalWindow") {MT=DMesh_MetalWindow;}
    else if(MeshType == "MetalWindowSmall") {MT=DMesh_MetalWindowSmall;}
    else if(MeshType == "Enforced") {MT=DMesh_Enforced;}
    else if(MeshType == "Grid") {MT=DMesh_Grid;}
    else if(MeshType == "Prison") {MT=DMesh_Prison;}
    else if(MeshType == "Entrance") {MT=DMesh_Entrance;}
    else if(MeshType == "Bathroom") {MT=DMesh_Bathroom;}
    else if(MeshType == "IsolatedCell") {MT=DMesh_IsolatedCell;}
    else if(MeshType == "Locker") {MT=DMesh_Locker;}
    else if(MeshType == "LockerRusted") {MT=DMesh_LockerRusted;}
    else if(MeshType == "LockerBeige") {MT=DMesh_LockerBeige;}
    else if(MeshType == "LockerGreen") {MT=DMesh_LockerGreen;}
    else if(MeshType == "Bathroom") {MT=DMesh_Bathroom;}
    else if(MeshType == "Glass") {MT=DMesh_Glass;}
    else if(MeshType == "Fence") {MT=DMesh_Fence;}
    else if(MeshType == "LockerHole") {MT=DMesh_LockerHole;}
    ConsoleCommand("Set OLDoor DoorMeshType " $ MT);
}

Exec Function LoadLevel(name PackageName, optional bool Always=true, optional bool bShouldBeLoaded=true, optional bool bShouldBeVisible=true) {
    local PickerController PC;
    local LevelStreamingVolume Volume;
    local int I;

    Foreach AllActors(Class'LevelStreamingVolume', Volume) {AllLoadedState=!AllLoadedState; Volume.bDisabled=Always;}
    if(PackageName != 'All') {Foreach WorldInfo.AllControllers(class'PickerController', PC) {PC.ClientUpdateLevelStreamingStatus(PackageName, bShouldBeLoaded, bShouldBeVisible, false);}}
    else {
        Foreach WorldInfo.AllControllers(class'PickerController', PC) {
            I = 0;
            J0xF6:
            if(I < WorldInfo.StreamingLevels.Length) {
            PC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[I].PackageName, bShouldBeLoaded, bShouldBeVisible, false);
            ++ I;
            goto J0xF6;}            
        }
    }
}

Exec Function TSVCommand() {
    PickerHud(HUD).TSVBool=!PickerHud(HUD).TSVBool;
    if(PickerHud(HUD).TSVBool) {ClientMessage("Streaming Volumes: Freezed!");}
    else if(!PickerHud(HUD).TSVBool) {ClientMessage("Streaming Volumes: Unfreezed!");}
    ConsoleCommand("TOGGLESTREAMINGVOLUMES");
}

Exec Function ChangeFOV(optional float DefFOV=90, optional float RunFOV=100, optional float CameraFOV=83) {
    local PickerHero Hero;

    Hero = PickerHero(Pawn);
    Hero.DefaultFOV=DefFOV;
    Hero.RunningFOV=RunFOV;
    Hero.CamcorderMaxFOV=CameraFOV;
    Hero.CamcorderNVMaxFOV=CameraFOV;
    ClientMessage("Change FOV: " $ Hero.DefaultFOV $ "/" $ Hero.RunningFOV $ "/" $ Hero.CamcorderMaxFOV $ "!");
}

Exec Function ToggleDisAI() {
    local OLBot Bot;

    bDisAI=!bDisAI;
    ForceDisAI=false;
    if(bDisAI) {ForceDisAI=true; DisAI(); ClientMessage("AI Disabled!");}
    else if(!bDisAI) {ForceDisAI=false; WorldInfo.Game.ClearTimer('DisAI');
        Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
            Bot.EnemyPawn.Modifiers.bShouldAttack = true; Bot.SightComponent.bIgnoreTarget = false;
            Bot.Recalculate(); ClientMessage("AI Enabled!");
        }
    }
}

Function LMFree(bool Free=true) {
    bLMFree=!bLMFree;
    if(bLMFree) {
    PickerHero(Pawn).LocomotionModeParams[1].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[2].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[3].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[4].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[5].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[6].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[7].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[8].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[9].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[10].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[11].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[12].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[13].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[14].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[15].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    return;
    }
    else {
    PickerHero(Pawn).LocomotionModeParams[1].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[2].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).LocomotionModeParams[3].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[4].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Spring;
    PickerHero(Pawn).LocomotionModeParams[5].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[6].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[7].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[8].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[9].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[10].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[11].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[12].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).LocomotionModeParams[13].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[14].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).LocomotionModeParams[15].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    }
}

Function SMFree(bool Free=true) {
    bSMFree=!bSMFree;
    if(bSMFree) {
    PickerHero(Pawn).SpecialMoveParams[1].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[2].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[3].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[4].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[5].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[6].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[7].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[8].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[9].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[10].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[11].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[12].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[13].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[14].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[15].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[16].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[17].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[18].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[19].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[20].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[21].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[22].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[23].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[24].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[25].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[26].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[27].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[28].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[29].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[30].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[31].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[32].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[33].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[34].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[35].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[36].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[37].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[38].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[39].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[40].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[41].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[42].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[43].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[44].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[45].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[46].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[47].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[48].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[49].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[50].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[51].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[52].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[53].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[54].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[55].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[56].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[57].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[58].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[59].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[60].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[61].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[62].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[63].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[64].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[65].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[66].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[67].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[68].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[69].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[70].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;

    /*PickerHero(Pawn).SpecialMoveParams[1].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[2].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[3].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[4].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[5].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[6].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[7].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[8].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[9].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[10].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[11].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[12].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[13].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[14].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[15].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[16].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[17].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[18].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[19].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[20].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[21].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[22].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[23].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[24].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[25].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[26].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[27].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[28].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[29].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[30].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[31].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[32].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[33].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[34].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[35].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[36].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[37].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[38].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[39].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[40].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[41].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[42].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[43].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[44].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[45].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[46].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[47].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[48].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[49].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[50].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[51].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[52].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[53].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[54].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[55].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[56].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[57].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[58].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[59].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[60].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[61].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[62].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[63].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[64].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[65].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[66].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[67].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[68].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[69].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;
    PickerHero(Pawn).SpecialMoveParams[70].AnimName=PickerHero(Pawn).AnimNameJumpOverFromRun;*/
    return;
    }
    else {
    PickerHero(Pawn).SpecialMoveParams[1].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[2].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[3].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[4].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[5].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[6].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[7].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[8].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[9].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[10].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[11].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[12].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[13].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[14].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[15].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[16].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[17].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[18].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[19].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[20].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[21].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[22].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[23].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[24].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[25].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[26].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[27].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[28].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[29].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[30].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[31].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[32].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[33].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[34].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[35].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[36].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[37].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[38].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[39].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[40].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[41].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[42].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[43].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[44].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[45].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[46].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[47].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[48].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[49].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[50].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Locked;
    PickerHero(Pawn).SpecialMoveParams[51].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[52].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[53].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[54].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[55].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[56].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_UserControlled;
    PickerHero(Pawn).SpecialMoveParams[57].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[58].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[59].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[60].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[61].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[62].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[63].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[64].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[65].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[66].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[67].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_Limited;
    PickerHero(Pawn).SpecialMoveParams[68].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[69].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
    PickerHero(Pawn).SpecialMoveParams[70].GP.CameraMode=PickerHero(Pawn).CameraRotationMode.CRM_FullyAnimated;
}
}

Exec Function AnimFree() {
    bAnimFree=!bAnimFree;
    if(bLMFree && bSMFree) {LMFree(false); SMFree(false); return;}
    else {LMFree(true); SMFree(true);}
}

Exec Function DisAI() {
    local OLBot Bot;
    if(ForceDisAI) {
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.Modifiers.bShouldAttack=false; Bot.VisualDisturbance.TimeSinceUpdate=-1.0;
        Bot.AudioDisturbance.TimeSinceUpdate=-1.0; Bot.SightComponent.bIgnoreTarget=true;
        Bot.Recalculate();
    } WorldInfo.Game.SetTimer(0.1, false, 'DisAI', Self);
    }
}

Exec Function ToggleTypeDoors(optional bool Force=true) {
    DoorTypeState=!DoorTypeState;
    if(DoorTypeState==true) {
    ForceActiveDoorTypeNormal=false;
    WorldInfo.Game.ClearTimer('NormalDoors');
    if(Force==true) {ClientMessage("Force All Doors: Locker!"); ForceActiveDoorTypeLocker=true;}
    else if(Force==false) {ClientMessage("All Doors: Locker!"); ForceActiveDoorTypeLocker=false;}
    WorldInfo.Game.SetTimer(0.5, false, 'LockerDoors', Self); return;}
    ForceActiveDoorTypeLocker=false;
    WorldInfo.Game.ClearTimer('LockerDoors');
    if(Force==true) {ClientMessage("Force All Doors: Normal!"); ForceActiveDoorTypeNormal=true;}
    else if(Force==false) {ClientMessage("All Doors: Normal!"); ForceActiveDoorTypeNormal=false;}
    WorldInfo.Game.SetTimer(0.5, false, 'NormalDoors', Self);
}

Exec Function LockerDoors() {
    local OLDoor Door;

    Foreach Allactors(Class'OLDoor', Door) {Door.DoorType=DT_Locker;}
    if(ForceActiveDoorTypeLocker==true) {WorldInfo.Game.SetTimer(0.5, false, 'LockerDoors', Self);}
}

Exec Function NormalDoors() {
    local OLDoor Door;

    Foreach Allactors(Class'OLDoor', Door) {Door.DoorType=DT_Normal;}
    if(ForceActiveDoorTypeNormal==true) {WorldInfo.Game.SetTimer(0.5, false, 'NormalDoors', Self);}
}

Exec Function ToggleDoorsState(optional bool Force=true) {
    DoorState=!DoorState;
    if(DoorState==true) {
    ForceActiveDoorStateLock=false;
    WorldInfo.Game.ClearTimer('LockDoors');
    if(Force==true) {ClientMessage("Force All Doors: Unlocked!"); ForceActiveDoorStateUnlock=true;}
    else if(Force==false) {ClientMessage("All Doors: Unlocked!"); ForceActiveDoorStateUnlock=false;}
    WorldInfo.Game.SetTimer(0.5, false, 'UnlockDoors', Self); return;}
    ForceActiveDoorStateUnlock=false;
    WorldInfo.Game.ClearTimer('UnlockDoors');
    if(Force==true) {ClientMessage("Force All Doors: Locked!");ForceActiveDoorStateLock=true;}
    else if(Force==false) {ClientMessage("All Doors: Locked!"); ForceActiveDoorStateLock=false;}
    WorldInfo.Game.SetTimer(0.5, false, 'LockDoors', Self);
}

Exec Function LockDoors() {
    local OLDoor Door;

    Foreach Allactors(Class'OLDoor', Door) {Door.bLocked=true;}
    if(ForceActiveDoorStateLock==true) {WorldInfo.Game.SetTimer(0.5, false, 'LockDoors', Self);}
}

Exec Function UnlockDoors() {
    local OLDoor Door;

    Foreach Allactors(Class'OLDoor', Door) {Door.bLocked=false; Door.bBlocked=false;}
    if(ForceActiveDoorStateUnlock==true) {WorldInfo.Game.SetTimer(0.5, false, 'UnlockDoors', Self);}
}

Exec Function RandomScale() {
    local Actor A;
    local Float F;
    local TriggerVolume TriggerVolume;
    local LevelStreamingVolume LevelStreamingVolume;
    local OLCheckpoint OLCheckpoint;

    if(PickerHud(HUD).TSVBool==false) {TSVCommand();}

Foreach AllActors(Class'Actor', A) {
    if(A != PickerHero(Pawn) && A != TriggerVolume && A != LevelStreamingVolume && A != OLCheckpoint) {
    F = RandRange(0.5, 3);
    A.SetDrawScale(F);
    }
    }
}

Exec Function LLL() {
local array<Name> AllPersistent;
AllPersistent[0] = 'Sewer_Persistent';
AllPersistent[1] = 'Prison_Persistent';
WorldInfo.PrepareMapChange(AllPersistent);
WorldInfo.CommitMapChange();
}

Exec Function SHH(bool b=false) {PickerHud(HUD).CamcorderHud.SetVisible(b);}

Exec Function ScalePulse(bool dd=true) {
    local Float SS;
    local Bool D;
    local Vector C;
    local OLEnemyPawn Enemy;

    if(dd) {QHHD=1; SS=1;} else {SS=QHHD;}
    if(SS >= 1 || D==true) {SS -= 0.01; D=true;}
        if(SS <= 0.1) {SS += 0.01; D=false;}
        QHHD=SS;
        C.X = SS;
        C.Y = SS;
        C.Z = SS;
    Foreach AllActors(Class'OLEnemyPawn', Enemy) {
        Enemy.SetDrawScale3D(C);
}
    WorldInfo.Game.SetTimer(0.01, true, 'ScalePulse', Self);
}

Exec Function BaseSelf() {
    local Actor A;
    local Vector C;
    local Float G, X, O;
    local StaticMeshActor D;

    C = PickerHero(Pawn).Location;
    Foreach AllActors(Class'Actor', A) {
    if(A != PickerHero(Pawn)) {
    G = RandRange(-100, 100);
    X = RandRange(-100, 100);
    O = RandRange(-100, 100);
    C.X += G;
    C.Y += X;
    C.Z += O;
    A.SetLocation(C);
    A.SetBase(self, C);
    }
    }
}

Exec Function ToggleKillEnemy(optional bool Force=false) {
    BoolKillEnemy=!BoolKillEnemy;

    if(BoolKillEnemy==false) {if(ForceKillEnemy==true) {WorldInfo.Game.ClearTimer('KillEnemy'); ClientMessage("Force Delete Enemies: Disabled!"); ForceKillEnemy=false;} return;}
    if(Force) {ForceKillEnemy=true; ClientMessage("Force Delete Enemies: Enabled!");}
    KillEnemy();
}

Exec Function Limp() {if(PickerHero(Pawn).bLimping) {PickerHero(Pawn).bLimping=false; return;} else {PickerHero(Pawn).bLimping=true;}}
    /*GlobalAnimRate();
    SpawnCamera();
    C = RandRange(1, 100);
    if(C >= 80) {ClientMessage("Toggle Camera!"); ToggleCamcorder();}
    else {ClientMessage("Reload!"); PressedReloadBatteries();}
    WorldInfo.Game.SetTimer(2, false, 'Limp', Self);*/

Exec Function Hobble(float Intensity=0) {if(PickerHero(Pawn).bHobbling) {PickerHero(Pawn).bHobbling=false; return;} else {PickerHero(Pawn).bHobbling=true; PickerHero(Pawn).HobblingIntensity=Intensity;}}
Exec Function CameraBone(Name BoneName) {PickerHero(Pawn).Camera.CameraBoneName=BoneName;}
Exec Function Darkness() {local OLDarknessVolume Darks; bDark=!bDark; Foreach AllActors(Class'OLDarknessVolume', Darks) {Darks.bDark=!bDark;}}
Exec Function CountCSA(optional int Count=1) {local OLCSA CSA; Foreach AllActors(Class'OLCSA', CSA) {CSA.MaxTriggerCount=Count;}}
Exec Function PRate(float Rate) {PickerHero(Pawn).Mesh.GlobalAnimRateScale=Rate;}
Exec Function SME(ESpecialMoveType Num) {local OLBot Bot; Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {Bot.EnemyPawn.StartSpecialMove(Num);}}
Exec Function SMP(ESpecialMoveType Num) {PickerHero(Pawn).StartSpecialMove(Num);}
//Exec Function ToggleSMPRandom() {SMRandomState=!SMRandomState; SMPRandom();}
/*Exec Function SMPRandom() {local int D;
local OLPawn OLPawn;
local ESpecialMoveType Num;
if(SMRandomState) {D=RandRange(0, 70); 
//Num=OLPawn.SpecialMove $ D;
PickerHero(Pawn).StartSpecialMove(Num); WorldInfo.Game.SetTimer(0.000001, false, 'SMPRandom', Self);}}*/
Exec Function KillEnemy() {local OLEnemyPawn Enemy; Foreach AllActors(Class'OLEnemyPawn', Enemy) {Enemy.Destroy();} if(ForceKillEnemy==true) {WorldInfo.Game.SetTimer(0.5, false, 'KillEnemy', Self); return;} ClientMessage("All Enemies Deleted!");}
Exec Function Batt(int Bat=1) {NumBatteries += Bat; if(Bat > 0) {ClientMessage("Add Battery: " $ Bat $ "!");} else if(Bat < 0) {ClientMessage("Remove Battery: " $ Bat $ "!");} else {ClientMessage("Nothing Happened!");}}
Exec Function ToggleFreecam() {if (UsingFirstPersonCamera()) {ConsoleCommand("Camera Freecam"); FreecamState=true;} else {ConsoleCommand("Camera Default"); FreecamState=false;}}
Exec Function ToggleAIDebug() {AIDebug=!AIDebug; if(!AIDebug) {Super.ConsoleCommand("Showdebug");} else {Super.ConsoleCommand("Showdebug OLAI");}}
Exec Function Pylons() {local Pylon P; Foreach AllActors(Class'Pylon', P) {`log(P);}}
Exec Function Screamer(float scrm=1) {SetVolume(scrm);}
Exec Function Reload() {local OLEngine Engine; Engine=OLEngine(class'Engine'.static.GetEngine()); PlayerDied(); Engine.StartCurrentCheckpoint();}
Exec Function AVolume(float vol=1) {SetVolume(vol); ProfileSettings.GetProfileSettingValueFloat(57, PickerHud(HUD).AudioVolume);}
Exec Function Glasss(optional bool dd=false) {
    FXManager.CurrentUberPostEffect.CameraGlassDiffuse=Texture2D'PickerDebugMenu.Overlays.BrokenGlassDiffuse';
    FXManager.CurrentUberPostEffect.CameraGlassNormal=Texture2D'PickerDebugMenu.Overlays.BrokenGlassNormal';
    if(dd) {
        FXManager.CurrentUberPostEffect.CameraGlassDiffuse=Texture2D'Asylum_post_process.ShatterredGlass.BrokenCamera_D';
        FXManager.CurrentUberPostEffect.CameraGlassNormal=Texture2D'Asylum_post_process.ShatterredGlass.BrokenCamera_N';
    }
}

Exec Function DisWater() {if(PickerHero(Pawn).DisableWater==false) {PickerHero(Pawn).DisableWater=true;} else {PickerHero(Pawn).DisableWater=false;}}

Exec Function GameSpeed(float Speed=1) {
    WorldInfo.Game.SetGameSpeed(Speed);
}

Exec Function Superman()
{
    bDebugGhost=!bDebugGhost; NoclipState=!NoclipState;
    if(bDebugGhost) {PickerHero(Pawn).GodModeInNoclip=true; ClientMessage("Noclip ON!");}
    else {PickerHero(Pawn).GodModeInNoclip=false; ClientMessage("Noclip OFF!");}
   // OLCheatManager.GhostPawn(bDebugGhost);
}

Exec Function Bigg(optional float dd=2) {
    local Actor A;
    local Vector D;
    D.X=dd;
    D.Y=dd;
    D.Z=dd;
Foreach AllActors(Class'Actor', A) {
    A.SetDrawScale3D(D);
    PickerHero(Pawn).SetDrawScale3D(vect(1,1,1));
}
}

Exec Function SpawnEnemy(String CEnemy, optional Int Count=1) {
    local Vector C;
    local Int i;
    local Rotator Rot;
    local OLBot Bot;
    local OLEnemyPawn Enemy;
    local OLEnemySoldier Soldier;
    local OLEnemyGroom Groom;
    local OLEnemyGenericPatient_G Patient;
    local OLEnemySurgeon Surgeon, Surgeon1;
    local OLEnemyCannibal Cannibal;
    local OLEnemyPriest Priest;
    local OLEnemyNanoCloud NanoCloud;
    local array<AnimSet> AnimSets;

    GetPlayerViewPoint(C,Rot);
    PickerHero(Pawn).SetCollision(false, false);
    Foreach AllActors(Class'OLEnemyPawn', Enemy) {
    Enemy.SetCollision(false, false);
    }
    while(i < Count) {
    if(CEnemy ~= "Soldier") {
        Soldier = Spawn(Class'OLEnemySoldier',,,C, Rot);
        Foreach WorldInfo.AllPawns(Class'OLEnemySoldier', Soldier) {
            Soldier.SetCollision(false, false, false);
            Bot = Spawn(Class'OLBot');
            Bot.Possess(Soldier, false);
            Bot.EnemyPawn.Modifiers.bShouldAttack=true;
            //Bot.EnemyPawn.Modifiers.bUseKillingBlow=true;
            //Bot.EnemyPawn.Modifiers.bAttackOnProximity=true;
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
        }
    }
    
    if(CEnemy ~= "Groom") {
        Groom = Spawn(Class'OLEnemyGroom',,,C, Rot);
        Foreach WorldInfo.AllPawns(Class'OLEnemyGroom', Groom) {
            Bot = Spawn(Class'OLBot');
            Bot.Possess(Groom, false);
            Bot.EnemyPawn.Modifiers.bShouldAttack=true;
            Groom.SetCollision(false, false, false);
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
        }
    }

    if(CEnemy ~= "Patient") {
        Patient = Spawn(Class'OLEnemyGenericPatient_G',,,C, Rot);
        Foreach WorldInfo.AllPawns(Class'OLEnemyGenericPatient_G', Patient) {
            Bot = Spawn(Class'OLBot');
            Bot.Possess(Patient, false);
            Bot.EnemyPawn.Modifiers.bShouldAttack=true;
            Patient.BehaviorTree=OLBTBehaviorTree'Male_ward_LD.02_AI_Behaviors.Generic_FullLoop_BT';
            Patient.SetCollision(false, false, false);
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
        }
    }
        
    if(CEnemy ~= "Surgeon") {
        Surgeon1 = Spawn(Class'OLEnemySurgeon',,,C, Rot);
       // Surgeon1.VOAsset=OLAIContextualVOAsset'Male_ward_03_LD.02_AI_Behaviors.Surgeon';
        Foreach WorldInfo.AllPawns(Class'OLEnemySurgeon', Surgeon) {
            Bot = Spawn(Class'OLBot');
       // Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
            Bot.Possess(Surgeon1, false);
            Surgeon.Modifiers.bShouldAttack=true;
            Surgeon.Modifiers.bUseForMusic=true;
            //Bot.EnemyPawn.
           // Bot.EnemyPawn.Modifiers.bUseKillingBlow=true;
           // Bot.EnemyPawn.Modifiers.bAttackOnProximity=true;
            //Bot.EnemyPawn.Modifiers.bInterruptVOOnChase=false;
            Surgeon.Modifiers.WeaponToUse=3;
            //Surgeon.bUsingWeapon=true;
            Surgeon.VOInstances.Length = 4;
            Surgeon.VOInstances[0].EventsPlayed[0]=true;
            Surgeon.VOInstances[0].EventsPlayed[1]=true;
            Surgeon.VOInstances[0].NumUnplayedEvents=1;
            Surgeon.VOInstances[0].EventsPlayed[2]=true;
            Surgeon.VOInstances[0].EventsPlayed[3]=true;
            Surgeon.VOInstances[1].EventsPlayed[0]=true;
            Surgeon.VOInstances[1].EventsPlayed[1]=true;
            Surgeon.VOInstances[1].NumUnplayedEvents=1;
            Surgeon.VOInstances[1].EventsPlayed[2]=true;
            Surgeon.VOInstances[1].EventsPlayed[3]=true;
            Surgeon.VOInstances[2].EventsPlayed[0]=true;
            Surgeon.VOInstances[2].EventsPlayed[1]=true;
            Surgeon.VOInstances[2].NumUnplayedEvents=1;
            Surgeon.VOInstances[2].EventsPlayed[2]=true;
            Surgeon.VOInstances[2].EventsPlayed[3]=true;
            Surgeon.VOInstances[3].EventsPlayed[0]=true;
            Surgeon.VOInstances[3].EventsPlayed[1]=true;
            Surgeon.VOInstances[3].NumUnplayedEvents=1;
            Surgeon.VOInstances[3].EventsPlayed[2]=true;
            Surgeon.VOInstances[3].EventsPlayed[3]=true;
           // Surgeon.Mesh.SetSkeletalMesh(SkeletalMesh'Male_ward_SE.02_Surgeon.Mesh.Surgeon');
            Surgeon.BehaviorTree=OLBTBehaviorTree'Male_ward_03_LD.02_AI_Behaviors.Surgeon_FullLoop_BT';
           // Surgeon.VOAsset=OLAIContextualVOAsset'Male_ward_03_LD.02_AI_Behaviors.Surgeon';
            Surgeon.SetCollision(false, false, false);
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
           // ConsoleCommand("Set OLenemysurgeon voasset Soldier");
            //ConsoleCommand("Set OLenemysurgeon behaviortree Soldier_bt");
        }//}
    }
        
    if(CEnemy ~= "Cannibal") {
        Cannibal = Spawn(Class'OLEnemyCannibal',,,C, Rot);
       // Cannibal.VOAsset=OLAIContextualVOAsset'Prison_01-LD.02_AI_Behaviors.ManicYell';
        Foreach AllActors(Class'OLEnemyCannibal', Cannibal) {
           // Cannibal.VOAsset=OLAIContextualVOAsset'Male_ward_03_LD.02_AI_Behaviors.Surgeon';
            Bot = Spawn(Class'OLBot');
            Bot.Possess(Cannibal, false);
            Bot.EnemyPawn.Modifiers.bShouldAttack=true;
            Bot.EnemyPawn.Modifiers.WeaponToUse=Weapon_CannibalDrill;
            Bot.EnemyPawn.bUsingWeapon=true;
           // Bot.EnemyPawn.VOInstances=EventsPlayed(0)=true;
           // Bot.EnemyPawn.VOInstances.EventsPlayed.AddItem(true);
           // Bot.EnemyPawn.VOInstances.EventsPlayed=true;
           // Bot.EnemyPawn.VOInstances.EventsPlayed=true;
           // Bot.EnemyPawn.VOInstances.EventsPlayed[3]=true;
           // Bot.EnemyPawn.VOAsset=OLAIContextualVOAsset'Male_ward_03_LD.02_AI_Behaviors.Surgeon';
            Bot.EnemyPawn.BehaviorTree=OLBTBehaviorTree'Male_ward_03_LD.02_AI_Behaviors.Surgeon_FullLoop_BT';
           // Cannibal.VOAsset=OLAIContextualVOAsset'Prison_01-LD.02_AI_Behaviors.ManicYell';
            Cannibal.SetCollision(false, false, false);
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
        }
    }
        
    if(CEnemy ~= "Priest") {
        Priest = Spawn(Class'OLEnemyPriest',,,C, Rot);
        Foreach WorldInfo.AllPawns(Class'OLEnemyPriest', Priest) {
            Bot = Spawn(Class'OLBot');
            Bot.Possess(Priest, false);
            Bot.EnemyPawn.Modifiers.bShouldAttack=true;
            Bot.EnemyPawn.Modifiers.bUseKillingBlow=true;
            Bot.EnemyPawn.Modifiers.bAttackOnProximity=true;
            Priest.BehaviorTree=OLBTBehaviorTree'Male_ward_LD.02_AI_Behaviors.Generic_FullLoop_BT';
            Priest.SetCollision(false, false, false);
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
        }
    }
        
    if(CEnemy ~= "NanoCloud") {
        NanoCloud = Spawn(Class'OLEnemyNanoCloud',,,C, Rot);
        Foreach WorldInfo.AllPawns(Class'OLEnemyNanoCloud', NanoCloud) {
            Bot = Spawn(Class'OLBot');
            Bot.Possess(NanoCloud, false);
            Bot.EnemyPawn.Modifiers.bShouldAttack=true;
            Bot.EnemyPawn.Modifiers.bUseKillingBlow=true;
            Bot.EnemyPawn.Modifiers.bAttackOnProximity=true;
            NanoCloud.SetCollision(false, false, false);
            WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
        }
    }
        i+=1;
    }
    WorldInfo.Game.SetTimer(0.07, false, 'BackPawnCol', self);
    PickerHero(Pawn).SetCollision(true, true);
}

Exec Function RotateEnemy(optional float Pitch=0, optional float Yaw=0, optional float Roll=0) {
    local OLBot Bot;
    local Rotator D;

    D.Pitch=Pitch;
    D.Yaw=Yaw;
    D.Roll=Roll;
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
        Bot.EnemyPawn.SetDesiredRotation(D);
    }
}

Exec Function ShowTrig(bool Hide) {
    local TriggerVolume Trigger;

    Foreach AllActors(Class'TriggerVolume', Trigger) {
		Trigger.BrushComponent.SetHidden(Hide);
		Trigger.SetHidden(Hide);
	}
}

Exec Function ChangeGroom(optional string Model="") {
    local OLEnemyGroom Enemy;
    if(Model == "") {
    if(GroomChrisState==false) {Foreach AllActors(Class'OLEnemyGroom', Enemy) {
    Enemy.Mesh.SetSkeletalMesh(SkeletalMesh'PickerDebugMenu.ChrisMesh');
    Enemy.Mesh.SetMaterial(0, MaterialInstanceConstant'02_Soldier.Material.Soldier_V3_ID1');
    Enemy.Mesh.SetMaterial(1, MaterialInstanceConstant'02_Soldier.Material.Solider_V3_ID2');
    Enemy.Mesh.SetMaterial(2, MaterialInstanceConstant'02_Soldier.Material.Solider_V3_ID3');
    Enemy.Mesh.SetMaterial(3, MaterialInstanceConstant'02_Soldier.Material.Soldier_Eye');
    GroomChrisState=true; return;
    }} else {
        Foreach AllActors(Class'OLEnemyGroom', Enemy) {
        Enemy.Mesh.SetSkeletalMesh(Enemy.Default.Mesh.SkeletalMesh);
        Enemy.Mesh.SetMaterial(0, MaterialInstanceConstant'02_Groom.ID_2_Shirt');
        Enemy.Mesh.SetMaterial(1, MaterialInstanceConstant'02_Groom.ID_2_pants');
        Enemy.Mesh.SetMaterial(2, MaterialInstanceConstant'02_Groom.ID_1_head_mutated');
        Enemy.Mesh.SetMaterial(3, MaterialInstanceConstant'02_Groom.GroomEye_bloody');
        Enemy.Mesh.SetMaterial(5, MaterialInstanceConstant'02_Groom.GroomEye_bloody2');
        Enemy.Mesh.SetMaterial(6, MaterialInstanceConstant'02_Groom.hand_SSS');
        GroomChrisState=false; return;
    }}}
    if(Model == "Chris") {ChangeChris(true);}
    if(Model == "Blake") {ChangeBlake(true);}
    if(Model == "Lady") {ChangeLady(true);}
    return;
}

Exec Function SpawnChris() {
    local Vector C;
    local Rotator R;
    local OLEnemySoldier Enemy;
    GetPlayerViewPoint(C,R);
    Spawn(Class'OLEnemySoldier', Self, '', C);
}

Exec Function KillerMake() {
    local StaticMeshActor A;
Foreach AllActors(Class'StaticMeshActor', A) {
A.StaticMeshComponent.SetMaterial(0, MaterialInstanceConstant'chrisblake.mats.Top');
A.StaticMeshComponent.SetMaterial(1, MaterialInstanceConstant'chrisblake.mats.Top');
A.StaticMeshComponent.SetMaterial(2, MaterialInstanceConstant'chrisblake.mats.Top');
A.StaticMeshComponent.SetMaterial(3, MaterialInstanceConstant'chrisblake.mats.Top');
A.StaticMeshComponent.SetMaterial(4, MaterialInstanceConstant'chrisblake.mats.Top');
A.StaticMeshComponent.SetMaterial(5, MaterialInstanceConstant'chrisblake.mats.Top');
A.StaticMeshComponent.SetMaterial(6, MaterialInstanceConstant'chrisblake.mats.Top');
`log(A);
}
}

Exec Function ToggleChangeChris() {
    local OLEnemySoldier Enemy;
    local OLEnemyGroom Enemy2;
    local OLBot Bot;
    Foreach WorldInfo.AllControllers(Class'OLBot', Bot) {
    ChrisState=!ChrisState;
    if(ChrisState) {Foreach AllActors(Class'OLEnemySoldier', Enemy) {ChangeChris(); return;}}
    else {Foreach AllActors(Class'OLEnemySoldier', Enemy) {
    Enemy.Mesh.SetSkeletalMesh(Enemy.Default.Mesh.SkeletalMesh); 
    Enemy.Mesh.SetMaterial(0, MaterialInstanceConstant'02_Soldier.Material.Soldier_V3_ID1');
    Enemy.Mesh.SetMaterial(1, MaterialInstanceConstant'02_Soldier.Material.Solider_V3_ID2');
    Enemy.Mesh.SetMaterial(2, MaterialInstanceConstant'02_Soldier.Material.Solider_V3_ID3');
    Enemy.Mesh.SetMaterial(3, MaterialInstanceConstant'02_Soldier.Material.Soldier_Eye');
    ClientMessage("Demo Chris Deactivated!");} return;}
    ClientMessage("Chris is missing!"); return;
}
}

Exec Function LoadMMap(Name LevelName) {ClientPrepareMapChange(LevelName, true, true); ClientCommitMapChange();}
Exec Function ChangeBlake(optional bool Groom=false) {
    local OLEnemySoldier Enemy;
    local OLEnemyGroom Enemy2;

    if(Groom) {
Foreach AllActors(Class'OLEnemyGroom', Enemy2) {
Switch (Enemy.Class) {
Default:
Enemy2.Mesh.SetSkeletalMesh(SkeletalMesh'chrisblake.Mesh.chrisblakebr');
Enemy2.Mesh.SetMaterial(0, MaterialInstanceConstant'chrisblake.mats.Skin');
Enemy2.Mesh.SetMaterial(1, MaterialInstanceConstant'chrisblake.mats.Legs');
Enemy2.Mesh.SetMaterial(2, MaterialInstanceConstant'chrisblake.mats.Legs');
Enemy2.Mesh.SetMaterial(3, MaterialInstanceConstant'chrisblake.mats.Top2');
Enemy2.Mesh.SetMaterial(4, MaterialInstanceConstant'chrisblake.mats.Skin3');
Enemy2.Mesh.SetMaterial(5, MaterialInstanceConstant'chrisblake.mats.Top');
Enemy2.Mesh.SetMaterial(6, MaterialInstanceConstant'chrisblake.mats.Top');
Enemy2.Mesh.SetMaterial(7, MaterialInstanceConstant'chrisblake.mats.Skin3');
Enemy2.Mesh.SetMaterial(8, MaterialInstanceConstant'chrisblake.mats.Glasses');
Enemy2.Mesh.SetMaterial(9, MaterialInstanceConstant'chrisblake.mats.Skin2');
Enemy2.Mesh.SetMaterial(10, MaterialInstanceConstant'chrisblake.mats.Watch1');
Enemy2.Mesh.SetMaterial(11, MaterialInstanceConstant'chrisblake.mats.Watch1');
Enemy2.Mesh.SetMaterial(12, MaterialInstanceConstant'chrisblake.mats.Skin3');
ClientMessage("Blake Chris Activated!");
break;
}
}
    return;
}
    Foreach AllActors(Class'OLEnemySoldier', Enemy) {
    Switch (Enemy.Class) {
    Default:
    Enemy.Mesh.SetSkeletalMesh(SkeletalMesh'chrisblake.Mesh.chrisblakebr');
    Enemy.Mesh.SetMaterial(0, MaterialInstanceConstant'chrisblake.mats.Skin');
    Enemy.Mesh.SetMaterial(1, MaterialInstanceConstant'chrisblake.mats.Legs');
    Enemy.Mesh.SetMaterial(2, MaterialInstanceConstant'chrisblake.mats.Legs');
    Enemy.Mesh.SetMaterial(3, MaterialInstanceConstant'chrisblake.mats.Top2');
    Enemy.Mesh.SetMaterial(4, MaterialInstanceConstant'chrisblake.mats.Skin3');
    Enemy.Mesh.SetMaterial(5, MaterialInstanceConstant'chrisblake.mats.Top');
    Enemy.Mesh.SetMaterial(6, MaterialInstanceConstant'chrisblake.mats.Top');
    Enemy.Mesh.SetMaterial(7, MaterialInstanceConstant'chrisblake.mats.Skin3');
    Enemy.Mesh.SetMaterial(8, MaterialInstanceConstant'chrisblake.mats.Glasses');
    Enemy.Mesh.SetMaterial(9, MaterialInstanceConstant'chrisblake.mats.Skin2');
    Enemy.Mesh.SetMaterial(10, MaterialInstanceConstant'chrisblake.mats.Watch1');
    Enemy.Mesh.SetMaterial(11, MaterialInstanceConstant'chrisblake.mats.Watch1');
    Enemy.Mesh.SetMaterial(12, MaterialInstanceConstant'chrisblake.mats.Skin3');
    ClientMessage("Blake Chris Activated!");
    break;
    }
    }
}

Exec Function ChangeChris(optional bool Groom=false) {
    local OLEnemySoldier Enemy;
    local OLEnemyGroom Enemy2;

if(Groom) {Foreach AllActors(Class'OLEnemyGroom', Enemy2) {
Switch (Enemy.Class) {
Default:
Enemy2.Mesh.SetSkeletalMesh(SkeletalMesh'demochris.Mesh.chriswalker');
Enemy2.Mesh.SetMaterial(0, MaterialInstanceConstant'demochris.mats.Skin');
Enemy2.Mesh.SetMaterial(1, MaterialInstanceConstant'demochris.mats.Skin');
Enemy2.Mesh.SetMaterial(2, MaterialInstanceConstant'demochris.mats.Skin');
Enemy2.Mesh.SetMaterial(3, MaterialInstanceConstant'demochris.mats.Arms');
Enemy2.Mesh.SetMaterial(4, MaterialInstanceConstant'demochris.mats.Legs');
Enemy2.Mesh.SetMaterial(5, MaterialInstanceConstant'demochris.mats.Arms');
ClientMessage("Chris Groom Activated!");
break;
}
    return;
}
    }

    Foreach AllActors(Class'OLEnemySoldier', Enemy) {
    Switch (Enemy.Class) {
    Default:
    Enemy.Mesh.SetSkeletalMesh(SkeletalMesh'demochris.Mesh.chriswalker');
    Enemy.Mesh.SetMaterial(0, MaterialInstanceConstant'demochris.mats.Skin');
    Enemy.Mesh.SetMaterial(1, MaterialInstanceConstant'demochris.mats.Skin');
    Enemy.Mesh.SetMaterial(2, MaterialInstanceConstant'demochris.mats.Skin');
    Enemy.Mesh.SetMaterial(3, MaterialInstanceConstant'demochris.mats.Arms');
    Enemy.Mesh.SetMaterial(4, MaterialInstanceConstant'demochris.mats.Legs');
    Enemy.Mesh.SetMaterial(5, MaterialInstanceConstant'demochris.mats.Arms');
    ClientMessage("Demo Chris Activated!");
    break;
    }
    }
}

Exec Function PScale(Float X, Float Y, Float Z) {
    local OLEnemySoldier Enemy;
    local Vector E;
    E = vect(0,0,0);
    E.X = X;
    E.Y = Y;
    E.Z = Z;

    Foreach AllActors(Class'OLEnemySoldier', Enemy) {Enemy.SetDrawScale3D(E);}
}

Exec Function ToggleBhop() {
    bBhop=!bBhop;
}

Exec Function ShowMsg(OLHud.EHUDMessageType MsgType, string Msg) {
    PickerHud(HUD).ShowMessage(MsgType, Msg);
}

Exec Function ChangeLady(optional bool Groom=false) {
    local OLEnemySoldier Enemy;
    local OLEnemyGroom Enemy2;

if(Groom) {Foreach AllActors(Class'OLEnemyGroom', Enemy2) {
Switch (Enemy.Class) {
Default:
Enemy2.Mesh.SetSkeletalMesh(SkeletalMesh'chrislady.Mesh.chrislady');
Enemy2.Mesh.SetMaterial(0, MaterialInstanceConstant'chrislady.mats.Arms');
Enemy2.Mesh.SetMaterial(1, MaterialInstanceConstant'chrislady.mats.Legs');
Enemy2.Mesh.SetMaterial(2, MaterialInstanceConstant'chrislady.mats.Skin');
ClientMessage("Lady Chris Activated!");
break;
}
}
    return;
}

    Foreach AllActors(Class'OLEnemySoldier', Enemy) {
    Switch (Enemy.Class) {
    Default:
    Enemy.Mesh.SetSkeletalMesh(SkeletalMesh'chrislady.Mesh.chrislady');
    Enemy.Mesh.SetMaterial(0, MaterialInstanceConstant'chrislady.mats.Arms');
    Enemy.Mesh.SetMaterial(1, MaterialInstanceConstant'chrislady.mats.Legs');
    Enemy.Mesh.SetMaterial(2, MaterialInstanceConstant'chrislady.mats.Skin');
    ClientMessage("Lady Chris Activated!");
    break;
    }
    }
}

Function DisableInput(Bool Input)
{
    local PickerInput HeroInput;
    local PickerHero Hero;

    HeroInput=PickerInput(PlayerInput);
    Hero=PickerHero(Pawn);

    if(Input) {
        HeroInput.MoveCommand="asdtyunbv";
        HeroInput.StrafeCommand="asdtyunbv";
        HeroInput.LookXCommand="asdtyunbv";
        HeroInput.LookYCommand="asdtyunbv";
        Hero.NormalWalkSpeed=0;
        Hero.NormalRunSpeed=0;
        Hero.CrouchedSpeed=0;
        Hero.ElectrifiedSpeed=0;
        Hero.WaterWalkSpeed=0;
        Hero.WaterRunSpeed=0;
        Hero.LimpingWalkSpeed=0;
        Hero.HobblingWalkSpeed=0;
        Hero.HobblingRunSpeed=0;
        IgnoreLookInput(True);
        IgnoreMoveInput(True);
    }
    else {
        HeroInput.MoveCommand=HeroInput.Default.MoveCommand;
        HeroInput.StrafeCommand=HeroInput.Default.StrafeCommand;
        HeroInput.LookXCommand=HeroInput.Default.LookXCommand;
        HeroInput.LookYCommand=HeroInput.Default.LookYCommand;
        Hero.NormalWalkSpeed=Hero.Default.NormalWalkSpeed;
        Hero.NormalRunSpeed=Hero.Default.NormalRunSpeed;
        Hero.CrouchedSpeed=Hero.Default.CrouchedSpeed;
        Hero.ElectrifiedSpeed=Hero.Default.ElectrifiedSpeed;
        Hero.WaterWalkSpeed=Hero.Default.WaterWalkSpeed;
        Hero.WaterRunSpeed=Hero.Default.WaterRunSpeed;
        Hero.LimpingWalkSpeed=Hero.Default.LimpingWalkSpeed;
        Hero.HobblingWalkSpeed=Hero.Default.HobblingWalkSpeed;
        Hero.HobblingRunSpeed=Hero.Default.HobblingRunSpeed;
        IgnoreLookInput(False);
        IgnoreMoveInput(False);
    }
    HeroInput.bWasForward=false;
        HeroInput.bWasBack=false;
        HeroInput.bWasLeft=false;
        HeroInput.bWasRight=false;
        HeroInput.bEdgeForward=false;
        HeroInput.bEdgeBack=false;
        HeroInput.bEdgeLeft=false;
        HeroInput.bEdgeRight=false;
}

Exec Function CustomPlayerModel(String CustomPlayer) {
    local MaterialInterface Mat;
    local OLPlayerModel FoundCP;

    if(Class'OLPlayerModel'== None) {ClientMessage("OLCustomPlayerModelSDK not installed!"); return;}
    if(CustomPlayer=="Default") {PickerHero(Pawn).Mesh.SetSkeletalMesh(Current_SkeletalMesh); CustomPM="Default"; PlayerState=true; return;}
    FoundCP = OLPlayerModel( DynamicLoadObject(CustomPlayer, Class'Object'));
    LogInternal(FoundCP);
    if(FoundCP==None) {ClientMessage("PlayerModel not found!"); return;}
    CustomPM=CustomPlayer;
    PlayerState=false;
    PickerHero(Pawn).Mesh.SetSkeletalMesh(FoundCP.HeroBody);
}

Function InitPlayerModel() {WorldInfo.Game.SetTimer(0.0005, false, 'LoadCurrent', self);}
Function LoadCurrent() {Current_SkeletalMesh=PickerHero(Pawn).Mesh.SkeletalMesh; Materials=PickerHero(Pawn).Mesh.Materials; ConsoleCommand("CustomPlayerModel " $ " " $ CustomPM);}

Exec Function HeroScale(float dd) {
    local PickerController Controller;
    local PickerHero Hero;
    local Vector C;
    C = (PickerHero(Pawn).Location + vect(0,0,30));
    Foreach AllActors(Class'PickerHero', Hero) {
        Hero.Mesh.SetScale(dd);
        Hero.ShadowProxy.SetScale(dd);
        Hero.HeadMesh.SetScale(dd);
        Hero.DeathParticles.SetScale(dd);
        Hero.CameraMesh.SetScale(dd);
        Hero.CameraMeshShadowProxy.SetScale(dd);
        Hero.BloodEffect.SetScale(dd);
        Hero.DecapitatedBloodEffect.SetScale(dd);
        Hero.WaterFootstepParticlesRight.SetScale(dd);
        Hero.WaterFootstepParticlesLeft.SetScale(dd);
        Hero.WaterSplashParticles.SetScale(dd);
    }
}

Exec Function DstrClass(Class<Actor> aClass) {
    local Actor A;

    OLCheatManager.KillAll(aClass);
    if(ClassIsChildOf(aClass, class'Pawn')){KillAllPawns(class<Pawn>(aClass)); return;}
    Foreach DynamicActors(class'Actor', A){if(ClassIsChildOf(A.Class, aClass)) {A.Destroy();}}
}

Function KillAllPawns(Class<Pawn> aClass) {
    local Pawn P;

    Foreach DynamicActors(class'Pawn', P) {if(ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn()) {if(P.Controller != none) {P.Controller.Destroy();} P.Destroy();}}       
}
Exec Function OffBaseLight() {
    local OLLight Light;
    local PointLightMovable Point;
    local SpotLightMovable Spot;
    local DominantDirectionalLight DDL;
    local PickerHero Hero;
    local OLBot OLBot;
    Foreach AllActors(Class'OLLight', Light) {
    Light.SpotLight.SetEnabled(false);
    Light.Destroy();
    `log(Light);
    }
    Foreach AllActors(Class'PointLightMovable', Point) {
    Point.LightComponent.SetEnabled(false);
    Point.Destroy();
    Point.LightComponent.OnUpdatePropertyBrightness();
    `log(Point);
    }
    Foreach AllActors(Class'SpotLightMovable', Spot) {
        Spot.LightComponent.SetEnabled(false);
        Spot.Destroy();
        Spot.LightComponent.OnUpdatePropertyBrightness();
        `log(Spot);
    }
    Foreach AllActors(Class'DominantDirectionalLight', DDL) {
        DDL.LightComponent.SetEnabled(false);
        DDL.Destroy();
        `log(DDL);
    }
   // WorldInfo.Game.SetTimer(0.5, false, 'OffBaseLight', Self);

}

/************************OTHER FUNCTIONS************************/

Function Bool RandBool() {return Bool(Rand(2));}
Function String RandChar() {
    local Int Out;
    Out = RandRange(33, 126);
    return Chr(Out);
}

Function String RandString(Int Length) {
    local Int i;
    local String Out;

    while(i < Length) {Out = Out $ RandChar(); i+=1;}
    return Out;
}

Function Byte RandByte(Byte Max) {return Byte(RandRange(0, Max));}
Function RandSpawnEnemy(optional Int Count=1) {
    local Byte D;
    local Int i;
    local String Out;

    while(i < Count) {
    D = RandRange(0,2);
    if(D==0) {Out = "Soldier";} else if(D==1) {Out = "Groom";} else if(D==2) {Out = "NanoCloud";}
    SpawnEnemy(Out); i+=1;
    }
}

Function RandSpawnEnemyCount(Int Min, Int Max, optional String Enemy="") {
    local Int Out;
    Out = RandRange(Min, Max);
    if(Enemy != "Soldier" && Enemy != "Groom" && Enemy != "NanoCloud") {RandSpawnEnemy(Out); return;}
    SpawnEnemy(Enemy, Out);
}

Function RandDoorType() {ConsoleCommand("Set OLDoor DoorMeshType" @ RandRange(0, 23));}

DefaultProperties
{
    InputClass=Class'PickerInput'
    CheatClass=Class'OLCheatManager'
    TeleportSound=SoundCue'PickerDebugMenu.TeleportSound'
    ButtonSound=SoundCue'PickerDebugMenu.Button_Click'
    MenuMusic=SoundCue'PickerDebugMenu.MenuMusic'
}