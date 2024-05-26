using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Verse.org/Random }
using { /Verse.org/Simulation/Tags }

raycastTag := class(tag){}

RaycastProp := class:
    Parent:creative_prop
    OutputProp:creative_prop

Raycasting := class(creative_device):
    @editable ScaleProp : creative_prop_asset = DefaultCreativePropAsset

    OnBegin<override>()<suspends>:void=
        for(I:=0..4):
            spawn. SpawnRaycastProp()
       

    SpawnRaycastProp()<suspends>:void=
        SpawnedProp := SpawnTarget(GetRandomVector3(vector3{X:=10.0,Y:=10.0, Z:=100.0}, vector3{X:=800.0,Y:=800.0, Z:=150.0}), ScaleProp)
        var PossibleProps : []creative_prop = array{}
        for(Obj: GetCreativeObjectsWithTag(raycastTag{})):
            if(Prop:= creative_prop[Obj]):
                set PossibleProps += array{Prop}
        SelectedProp:= SpawnedProp.GetClosestPropInRange(PossibleProps)
        if(Prop := SelectedProp?):
            spawn. CheckRaycastProp(RaycastProp{Parent:=SpawnedProp, OutputProp:=Prop})


    CheckRaycastProp(RaycastPropInst:RaycastProp)<suspends>:void=
            loop:
                Sleep(0.2)
                if(RaycastPropInst.OutputProp.GetTransform().Scale.X >= 2.0):
                    MaybePlayer:= RaycastPropInst.Parent.GetClosestPlayerInRange(GetPlayspace().GetPlayers())
                    if(Player:= MaybePlayer?, FC:= Player.GetFortCharacter[]):
                        FC.Damage(10.0)
                        Print("Player Hit!")
                        RaycastPropInst.Parent.Dispose()
                        break
                    
                    Print("{RaycastPropInst.OutputProp.GetTransform().Scale}")


    