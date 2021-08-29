class PickerSpotLight extends SpotLightMovable
	placeable;

Function OnTurn(bool sd) {
LightComponent.SetEnabled(sd);
}

Function SetBrightness(float f) {
	LightComponent.SetLightProperties(f);
    LightComponent.UpdateColorAndBrightness();
}

Function SetColor(byte ir, byte ig, byte ib, byte ia) {
	local color c;
	
	c.R = ir;
	c.G = ig;
	c.B = ib;
	c.A = ia;

	LightComponent.SetLightProperties(,c); 
    LightComponent.UpdateColorAndBrightness();
}

//default 1024.0
Function SetRadius(float r) {
	SpotLightComponent(LightComponent).Radius = r;
}

//default 2.0
Function SetFallOffExponent(float e) {
	SpotLightComponent(LightComponent).FalloffExponent = e;
}

//default 2.0
Function SetShadowFalloffExponent(float e) {
	SpotLightComponent(LightComponent).ShadowFalloffExponent = e;
}

//default 1.1
Function SetShadowRadiusMultiplier(float f) {
	SpotLightComponent(LightComponent).ShadowRadiusMultiplier = f;
}

Function SetCastDynamicShadows(bool b) {
	LightComponent.CastDynamicShadows = b;
}

DefaultProperties
{
	BoundsScale=500
    bNoDelete = false
	CastShadows=FALSE
	CastStaticShadows=FALSE
	CastDynamicShadows=TRUE
	bForceDynamicLight=TRUE
	UseDirectLightMap=FALSE
	bAllowPreShadow=TRUE
	LightingChannels(BSP=True,Static=True,Dynamic=True)
    bCollideActors = false
	bCollideWorld = false
}