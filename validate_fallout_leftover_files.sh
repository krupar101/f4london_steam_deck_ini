#!/bin/bash

# 1. Define the path to check files inside it
CHECK_PATH="$HOME/.steam/steam/steamapps/common/Fallout 4"

# 2. Create a list of valid files (the paths you provided)
VALID_FILES=(
"."
"./bink2w64.dll"
"./f4se_whatsnew.txt"
"./goggame-1998527297.info"
"./GFSDK_SSAO_D3D11.win64.dll"
"./Launch Fallout - London.lnk"
"./flexExtRelease_x64.dll"
"./nvToolsExt64_1.dll"
"./Fallout4"
"./Fallout4/Fallout4Prefs.ini"
"./Low.ini"
"./steam_api64.dll"
"./F4LONDON.zip"
"./Fallout4Launcher.exe.old"
"./f4se_1_10_163.dll"
"./WinHTTP.dll"
"./CustomControlMap.txt"
"./Fallout4Launcher.exe"
"./flexRelease_x64.dll"
"./f4se_readme.txt"
"./Ultra.ini"
"./goggame-1998527297.hashdb"
"./nvdebris.txt"
"./Fallout4_Default.ini"
"./Data"
"./Data/Fallout4 - Textures9.ba2"
"./Data/DLCNukaWorld.esm"
"./Data/DLCworkshop03 - Voices_en.ba2"
"./Data/LondonWorldSpace - Geometry.csg"
"./Data/LondonWorldSpace - Textures10.ba2"
"./Data/Fallout4 - Shaders.ba2"
"./Data/DLCworkshop01.esm"
"./Data/Fallout4 - Textures2.ba2"
"./Data/Fallout4 - Textures5.ba2"
"./Data/XDI"
"./Data/XDI/LondonWorldSpace.esm.ini"
"./Data/XDI/settings.ini"
"./Data/DLCRobot - Main.ba2"
"./Data/DLCCoast - Voices_en.ba2"
"./Data/DLCNukaWorld - Main.ba2"
"./Data/Fallout4 - MeshesExtra.ba2"
"./Data/Fallout4 - Sounds.ba2"
"./Data/Fallout4 - Textures4.ba2"
"./Data/DLCworkshop03 - Main.ba2"
"./Data/LondonWorldSpace - Textures8.ba2"
"./Data/LondonWorldSpace - MeshesLOD.ba2"
"./Data/LondonWorldSpace - Meshes.ba2"
"./Data/Fallout4 - Animations.ba2"
"./Data/LondonWorldSpace - VoicesExtra.ba2"
"./Data/LondonWorldSpace - Textures1.ba2"
"./Data/LondonWorldSpace-DLCBlock.esp"
"./Data/Fallout4 - Startup.ba2"
"./Data/LondonWorldSpace - Materials.ba2"
"./Data/Fallout4 - Meshes.ba2"
"./Data/Fallout4 - Textures1.ba2"
"./Data/LondonWorldSpace - Textures13.ba2"
"./Data/LondonWorldSpace - Interface.ba2"
"./Data/DLCCoast - Geometry.csg"
"./Data/LondonWorldSpace - Textures9.ba2"
"./Data/PRKF"
"./Data/PRKF/SampleIni.ini"
"./Data/PRKF/LondonWorldSpace.ini"
"./Data/Fallout4 - Nvflex.ba2"
"./Data/Video"
"./Data/Video/Ending_Roundels02.bk2"
"./Data/Video/Ending_Thamesfolk02.bk2"
"./Data/Video/Ending_Mountbatten01.bk2"
"./Data/Video/Ending_Kiera02.bk2"
"./Data/Video/Ending_Miller03.bk2"
"./Data/Video/Ending_GauntBlack01.bk2"
"./Data/Video/Ending_Battle02.bk2"
"./Data/Video/Ending_Normans01.bk2"
"./Data/Video/Ending_GangWar02.bk2"
"./Data/Video/Ending_Tommies01.bk2"
"./Data/Video/Ending_Wayfarer02.bk2"
"./Data/Video/INTELLIGENCE.bk2"
"./Data/Video/Ending_GauntBlack02.bk2"
"./Data/Video/Ending_Jack02.bk2"
"./Data/Video/ENDURANCE.bk2"
"./Data/Video/Ending_Smythe03.bk2"
"./Data/Video/Ending_Smythe04.bk2"
"./Data/Video/Ending_GangWar03.bk2"
"./Data/Video/Ending_Eastminster03.bk2"
"./Data/Video/Intro.bk2"
"./Data/Video/Ending_Shakespeare02.bk2"
"./Data/Video/Ending_Tommies02.bk2"
"./Data/Video/Ending_Shakespeare03.bk2"
"./Data/Video/MainMenuLoop.bk2"
"./Data/Video/Endgame_MALE_A.bk2"
"./Data/Video/Endgame_FEMALE_A.bk2"
"./Data/Video/STRENGTH.bk2"
"./Data/Video/Ending_Thamesfolk01.bk2"
"./Data/Video/Ending_Smythe01.bk2"
"./Data/Video/Ending_Pistols04.bk2"
"./Data/Video/Ending_Miller02.bk2"
"./Data/Video/Ending_Tommies03.bk2"
"./Data/Video/Endgame_FEMALE_B.bk2"
"./Data/Video/Ending_Battle03.bk2"
"./Data/Video/Ending_Eastminster02.bk2"
"./Data/Video/Ending_Wayfarer05.bk2"
"./Data/Video/Ending_Eastminster01.bk2"
"./Data/Video/Ending_Gentry02.bk2"
"./Data/Video/Ending_Normans02.bk2"
"./Data/Video/Ending_Roundels03.bk2"
"./Data/Video/Ending_Brickton04.bk2"
"./Data/Video/Ending_GangWar04.bk2"
"./Data/Video/Ending_Pistols03.bk2"
"./Data/Video/Ending_Tommies05.bk2"
"./Data/Video/LUCK.bk2"
"./Data/Video/TrainIntro.bk2"
"./Data/Video/Ending_Intro.bk2"
"./Data/Video/Ending_Wayfarer03.bk2"
"./Data/Video/Ending_Pistols02.bk2"
"./Data/Video/Ending_Gentry04.bk2"
"./Data/Video/Ending_Miller01.bk2"
"./Data/Video/Ending_Archie01.bk2"
"./Data/Video/Ending_Gentry03.bk2"
"./Data/Video/Ending_Mountbatten02.bk2"
"./Data/Video/Ending_Jack01.bk2"
"./Data/Video/Ending_Smythe02.bk2"
"./Data/Video/PERCEPTION.bk2"
"./Data/Video/Ending_Battle04.bk2"
"./Data/Video/Ending_Thamesfolk03.bk2"
"./Data/Video/Ending_Shakespeare01.bk2"
"./Data/Video/Ending_Archie02.bk2"
"./Data/Video/Ending_Wayfarer01.bk2"
"./Data/Video/Ending_Wayfarer04.bk2"
"./Data/Video/Ending_Croydon01.bk2"
"./Data/Video/CHARISMA.bk2"
"./Data/Video/Ending_Brickton05.bk2"
"./Data/Video/Ending_Mountbatten03.bk2"
"./Data/Video/Ending_Gentry01.bk2"
"./Data/Video/Ending_John01.bk2"
"./Data/Video/Ending_Credits.bk2"
"./Data/Video/Ending_Conclusion01.bk2"
"./Data/Video/Ending_Kiera01.bk2"
"./Data/Video/GameIntro_V3_B.bk2"
"./Data/Video/AGILITY.bk2"
"./Data/Video/Ending_Battle01.bk2"
"./Data/Video/Ending_Boat01.bk2"
"./Data/Video/Ending_John02.bk2"
"./Data/Video/Ending_Roundels01.bk2"
"./Data/Video/Ending_Shakespeare04.bk2"
"./Data/Video/Ending_Pistols01.bk2"
"./Data/Video/Endgame_MALE_B.bk2"
"./Data/Video/Ending_NuclearBlast.bk2"
"./Data/Video/Ending_Brickton03.bk2"
"./Data/Video/Ending_GangWar01.bk2"
"./Data/Video/Ending_Brickton02.bk2"
"./Data/Video/Ending_Tommies04.bk2"
"./Data/Video/Ending_Brickton01.bk2"
"./Data/Video/Ending_Conclusion02.bk2"
"./Data/DLCworkshop01 - Textures.ba2"
"./Data/DLCRobot - Textures.ba2"
"./Data/No_Shadow_Lights.esp"
"./Data/DLCNukaWorld - Voices_en.ba2"
"./Data/DLCNukaWorld - Geometry.csg"
"./Data/DLCRobot - Voices_en.ba2"
"./Data/DLCworkshop01 - Geometry.csg"
"./Data/Fallout4 - Voices.ba2"
"./Data/DLCworkshop02.esm"
"./Data/Scripts"
"./Data/Scripts/FavoritesManager.pex"
"./Data/Scripts/ObjectMod.pex"
"./Data/Scripts/ScriptObject.pex"
"./Data/Scripts/Utility.pex"
"./Data/Scripts/Perk.pex"
"./Data/Scripts/Component.pex"
"./Data/Scripts/mq101questscript.pex"
"./Data/Scripts/Math.pex"
"./Data/Scripts/Input.pex"
"./Data/Scripts/WaterType.pex"
"./Data/Scripts/MatSwap.pex"
"./Data/Scripts/Location.pex"
"./Data/Scripts/ObjectReference.pex"
"./Data/Scripts/ConstructibleObject.pex"
"./Data/Scripts/Armor.pex"
"./Data/Scripts/ActorBase.pex"
"./Data/Scripts/EncounterZone.pex"
"./Data/Scripts/F4SE.pex"
"./Data/Scripts/Game.pex"
"./Data/Scripts/MiscObject.pex"
"./Data/Scripts/EquipSlot.pex"
"./Data/Scripts/Weapon.pex"
"./Data/Scripts/UI.pex"
"./Data/Scripts/Cell.pex"
"./Data/Scripts/Actor.pex"
"./Data/Scripts/InstanceData.pex"
"./Data/Scripts/ArmorAddon.pex"
"./Data/Scripts/Form.pex"
"./Data/Scripts/Fragments"
"./Data/Scripts/Fragments/Quests"
"./Data/Scripts/Fragments/Quests/QF_MQ101_0001ED86.pex"
"./Data/Scripts/HeadPart.pex"
"./Data/Scripts/DefaultObject.pex"
"./Data/LondonWorldSpace - Textures6.ba2"
"./Data/F4SE"
"./Data/F4SE/Plugins"
"./Data/F4SE/Plugins/PRKF.dll"
"./Data/F4SE/Plugins/XDI.dll"
"./Data/F4SE/Plugins/HighFPSPhysicsFix.ini"
"./Data/F4SE/Plugins/Buffout4.dll"
"./Data/F4SE/Plugins/ConsoleUtilF4.dll"
"./Data/F4SE/Plugins/FavoritesMenuEx.dll"
"./Data/F4SE/Plugins/FOLON_UITimer.dll"
"./Data/F4SE/Plugins/FOLON_UIMapSearchArea.dll"
"./Data/F4SE/Plugins/FOLON_UICompasSZ.dll"
"./Data/F4SE/Plugins/version-1-10-163-0.bin"
"./Data/F4SE/Plugins/Buffout4_preload.txt"
"./Data/F4SE/Plugins/Buffout4"
"./Data/F4SE/Plugins/Buffout4/third_party.txt"
"./Data/F4SE/Plugins/Buffout4/license.txt"
"./Data/F4SE/Plugins/Buffout4/config.toml"
"./Data/F4SE/Plugins/HighFPSPhysicsFix.dll"
"./Data/DLCworkshop01 - Main.ba2"
"./Data/Fallout4 - Materials.ba2"
"./Data/LondonWorldSpace - MeshesExtra.ba2"
"./Data/LondonWorldSpace - Textures2.ba2"
"./Data/Fallout4 - Textures6.ba2"
"./Data/LondonWorldSpace.esm"
"./Data/LondonWorldSpace - Sounds.ba2"
"./Data/DLCRobot.esm"
"./Data/LondonWorldSpace - Textures11.ba2"
"./Data/Fallout4 - Interface.ba2"
"./Data/DLCCoast - Textures.ba2"
"./Data/Fallout4 - Geometry.csg"
"./Data/DLCCoast - Main.ba2"
"./Data/LondonWorldSpace - Textures12.ba2"
"./Data/LondonWorldSpace - Textures7.ba2"
"./Data/DLCRobot - Geometry.csg"
"./Data/LondonWorldSpace - ClearUp.bat"
"./Data/DLCworkshop03.cdx"
"./Data/DLCworkshop02 - Textures.ba2"
"./Data/DLCworkshop03 - Geometry.csg"
"./Data/Fallout4 - Misc.ba2"
"./Data/DLCworkshop02 - Main.ba2"
"./Data/DLCworkshop01.cdx"
"./Data/DLCCoast.esm"
"./Data/Fallout4.cdx"
"./Data/Fallout4 - Textures3.ba2"
"./Data/LondonWorldSpace - Animations.ba2"
"./Data/DLCNukaWorld - Textures.ba2"
"./Data/LondonWorldSpace - Textures5.ba2"
"./Data/DLCworkshop03 - Textures.ba2"
"./Data/DLCRobot.cdx"
"./Data/LondonWorldSpace - Textures4.ba2"
"./Data/Fallout4.esm"
"./Data/LondonWorldSpace - Textures3.ba2"
"./Data/DLCworkshop03.esm"
"./Data/Fallout4 - Textures8.ba2"
"./Data/LondonWorldSpace.cdx"
"./Data/LondonWorldSpace - Misc.ba2"
"./Data/DLCNukaWorld.cdx"
"./Data/Textures"
"./Data/Textures/Interface"
"./Data/Textures/Interface/LoadingMenuBG.DDS"
"./Data/Fallout4 - Textures7.ba2"
"./Data/LondonWorldSpace - Voices.ba2"
"./Data/DLCCoast.cdx"
"./Data/LondonWorldSpace - Credits.txt"
"./f4se_loader.exe"
"./goglog.ini"
"./GFSDK_GodraysLib.x64.dll"
"./Fallout4.exe"
"./goggame-1998527297.script"
"./xSE PluginPreloader.xml"
"./Medium.ini"
"./src"
"./src/common"
"./src/common/ICriticalSection.h"
"./src/common/IThread.cpp"
"./src/common/ISingleton.h"
"./src/common/ITimer.cpp"
"./src/common/IBufferStream.h"
"./src/common/IInterlockedLong.h"
"./src/common/IDirectoryIterator.h"
"./src/common/ITimer.h"
"./src/common/IInterlockedLong.cpp"
"./src/common/IDirectoryIterator.cpp"
"./src/common/IConsole.cpp"
"./src/common/IFIFO.cpp"
"./src/common/IDebugLog.h"
"./src/common/IConsole.h"
"./src/common/IErrors.cpp"
"./src/common/ISingleton.cpp"
"./src/common/IReadWriteLock.h"
"./src/common/IRangeMap.cpp"
"./src/common/IMutex.h"
"./src/common/common_vc9.vcproj"
"./src/common/common_vc11.vcxproj"
"./src/common/IFileStream.cpp"
"./src/common/IEvent.cpp"
"./src/common/common_vc14.vcxproj"
"./src/common/IThread.h"
"./src/common/IPrefix.cpp"
"./src/common/IRangeMap.h"
"./src/common/IDatabase.cpp"
"./src/common/ITypes.h"
"./src/common/ITypes.cpp"
"./src/common/ILinkedList.h"
"./src/common/common_vc11.vcxproj.filters"
"./src/common/IMemPool.cpp"
"./src/common/IPipeClient.cpp"
"./src/common/IDataStream.cpp"
"./src/common/IFileStream.h"
"./src/common/IDebugLog.cpp"
"./src/common/IPrefix.h"
"./src/common/IMemPool.h"
"./src/common/ISegmentStream.h"
"./src/common/ITextParser.cpp"
"./src/common/IDynamicCreate.cpp"
"./src/common/common.vcxproj.filters"
"./src/common/IErrors.h"
"./src/common/common_vc14.sln"
"./src/common/IFIFO.h"
"./src/common/IMutex.cpp"
"./src/common/IDatabase.h"
"./src/common/IDataStream.h"
"./src/common/common_vc11.sln"
"./src/common/IPipeServer.cpp"
"./src/common/IPipeClient.h"
"./src/common/IDatabase.inc"
"./src/common/IArchive.cpp"
"./src/common/IPipeServer.h"
"./src/common/common_license.txt"
"./src/common/common.vcproj"
"./src/common/common.vcxproj"
"./src/common/IArchive.h"
"./src/common/IBufferStream.cpp"
"./src/common/IDynamicCreate.h"
"./src/common/common_vc14.vcxproj.filters"
"./src/common/IEvent.h"
"./src/common/ISegmentStream.cpp"
"./src/common/ITextParser.h"
"./src/common/IReadWriteLock.cpp"
"./src/f4se"
"./src/f4se/f4se_whatsnew.txt"
"./src/f4se/f4se"
"./src/f4se/f4se/GameRTTI.h"
"./src/f4se/f4se/Hooks_Scaleform.h"
"./src/f4se/f4se/NiObjects.h"
"./src/f4se/f4se/Hooks_GameData.cpp"
"./src/f4se/f4se/PapyrusUtility.cpp"
"./src/f4se/f4se/PapyrusDefaultObject.cpp"
"./src/f4se/f4se/PapyrusEncounterZone.h"
"./src/f4se/f4se/GameInput.h"
"./src/f4se/f4se/PapyrusVM.h"
"./src/f4se/f4se/NiSerialization.cpp"
"./src/f4se/f4se/NiProperties.cpp"
"./src/f4se/f4se/f4se.cpp"
"./src/f4se/f4se/GameCustomization.h"
"./src/f4se/f4se/BSParticleShaderEmitter.cpp"
"./src/f4se/f4se/NiProperties.h"
"./src/f4se/f4se/PapyrusUtility.h"
"./src/f4se/f4se/GameRTTI.cpp"
"./src/f4se/f4se/bhkWorld.h"
"./src/f4se/f4se/PapyrusInstanceData.h"
"./src/f4se/f4se/PapyrusScaleformAdapter.cpp"
"./src/f4se/f4se/PapyrusFavoritesManager.cpp"
"./src/f4se/f4se/GameMenus.h"
"./src/f4se/f4se/InputMap.h"
"./src/f4se/f4se/PapyrusUtilities.cpp"
"./src/f4se/f4se/Hooks_Gameplay.h"
"./src/f4se/f4se/PapyrusMiscObject.h"
"./src/f4se/f4se/NiTextures.h"
"./src/f4se/f4se/PapyrusMiscObject.cpp"
"./src/f4se/f4se/PapyrusObjects.cpp"
"./src/f4se/f4se/PapyrusScaleformAdapter.h"
"./src/f4se/f4se/BSSkin.cpp"
"./src/f4se/f4se/PapyrusComponent.h"
"./src/f4se/f4se/NiMaterials.h"
"./src/f4se/f4se/Serialization.cpp"
"./src/f4se/f4se/PapyrusComponent.cpp"
"./src/f4se/f4se/BSGeometry.h"
"./src/f4se/f4se/PapyrusUtilities.h"
"./src/f4se/f4se/BSGeometry.cpp"
"./src/f4se/f4se/PapyrusMath.h"
"./src/f4se/f4se/PapyrusInterfaces.cpp"
"./src/f4se/f4se/PapyrusHeadPart.h"
"./src/f4se/f4se/ScaleformValue.h"
"./src/f4se/f4se/NiTextures.cpp"
"./src/f4se/f4se/PapyrusEventsDef_Base.inl"
"./src/f4se/f4se/BSLight.h"
"./src/f4se/f4se/Hooks_SaveLoad.cpp"
"./src/f4se/f4se/GameUtilities.cpp"
"./src/f4se/f4se/InputMap.cpp"
"./src/f4se/f4se/PapyrusSerialization.h"
"./src/f4se/f4se/PapyrusF4SE.h"
"./src/f4se/f4se/PapyrusArgs.h"
"./src/f4se/f4se/PapyrusForm.cpp"
"./src/f4se/f4se/Hooks_Papyrus.h"
"./src/f4se/f4se/PapyrusScriptObject.h"
"./src/f4se/f4se/GameMemory.h"
"./src/f4se/f4se/Hooks_Gameplay.cpp"
"./src/f4se/f4se/NiNodes.cpp"
"./src/f4se/f4se/Hooks_Threads.h"
"./src/f4se/f4se/Hooks_GameData.h"
"./src/f4se/f4se/PapyrusEquipSlot.cpp"
"./src/f4se/f4se/NiNodes.h"
"./src/f4se/f4se/PapyrusObjectReference.h"
"./src/f4se/f4se/ScaleformTranslator.cpp"
"./src/f4se/f4se/GameObjects.h"
"./src/f4se/f4se/Hooks_ObScript.h"
"./src/f4se/f4se/GameAPI.cpp"
"./src/f4se/f4se/ScaleformValue.cpp"
"./src/f4se/f4se/PapyrusInput.cpp"
"./src/f4se/f4se/PapyrusMaterialSwap.cpp"
"./src/f4se/f4se/Hooks_Input.h"
"./src/f4se/f4se/GameThreads.h"
"./src/f4se/f4se/ObScript.cpp"
"./src/f4se/f4se/GameStreams.h"
"./src/f4se/f4se/Hooks_ObScript.cpp"
"./src/f4se/f4se/NiExtraData.cpp"
"./src/f4se/f4se/f4se.vcxproj"
"./src/f4se/f4se/PapyrusNativeFunctions.cpp"
"./src/f4se/f4se/Hooks_Scaleform.cpp"
"./src/f4se/f4se/ScaleformAPI.cpp"
"./src/f4se/f4se/PapyrusObjectReference.cpp"
"./src/f4se/f4se/PapyrusEncounterZone.cpp"
"./src/f4se/f4se/GameRTTI.inl"
"./src/f4se/f4se/BSLight.cpp"
"./src/f4se/f4se/PapyrusActorBase.h"
"./src/f4se/f4se/ScaleformTypes.h"
"./src/f4se/f4se/GameEvents.cpp"
"./src/f4se/f4se/GameSettings.cpp"
"./src/f4se/f4se/PapyrusSerialization.cpp"
"./src/f4se/f4se/ScaleformSerialization.h"
"./src/f4se/f4se/PapyrusNativeFunctionDef.inl"
"./src/f4se/f4se/PapyrusHeadPart.cpp"
"./src/f4se/f4se/PapyrusForm.h"
"./src/f4se/f4se/PapyrusActor.h"
"./src/f4se/f4se/Hooks_Debug.h"
"./src/f4se/f4se/GameCustomization.cpp"
"./src/f4se/f4se/Hooks_Camera.h"
"./src/f4se/f4se/ScaleformTypes.cpp"
"./src/f4se/f4se/Serialization.h"
"./src/f4se/f4se/f4se.vcxproj.filters"
"./src/f4se/f4se/PapyrusObjectMod.cpp"
"./src/f4se/f4se/Hooks_Memory.h"
"./src/f4se/f4se/GameObjects.cpp"
"./src/f4se/f4se/BSSkin.h"
"./src/f4se/f4se/Hooks_Input.cpp"
"./src/f4se/f4se/PapyrusActorBase.cpp"
"./src/f4se/f4se/GameCamera.h"
"./src/f4se/f4se/Hooks_Debug.cpp"
"./src/f4se/f4se/GameData.cpp"
"./src/f4se/f4se/PapyrusCell.h"
"./src/f4se/f4se/ObScript.h"
"./src/f4se/f4se/ScaleformCallbacks.h"
"./src/f4se/f4se/GameWorkshop.h"
"./src/f4se/f4se/PapyrusLocation.h"
"./src/f4se/f4se/CustomMenu.h"
"./src/f4se/f4se/PapyrusNativeFunctions.h"
"./src/f4se/f4se/PapyrusArmor.h"
"./src/f4se/f4se/GameExtraData.cpp"
"./src/f4se/f4se/BSCollision.cpp"
"./src/f4se/f4se/BSModelDB.cpp"
"./src/f4se/f4se/ScaleformSerialization.cpp"
"./src/f4se/f4se/PapyrusPerk.cpp"
"./src/f4se/f4se/GameTypes.cpp"
"./src/f4se/f4se/GameMessages.h"
"./src/f4se/f4se/GameForms.cpp"
"./src/f4se/f4se/PapyrusDelayFunctors.cpp"
"./src/f4se/f4se/ScaleformMovie.h"
"./src/f4se/f4se/PapyrusFavoritesManager.h"
"./src/f4se/f4se/PapyrusWaterType.h"
"./src/f4se/f4se/PapyrusArmorAddon.h"
"./src/f4se/f4se/PapyrusEquipSlot.h"
"./src/f4se/f4se/PapyrusInstanceData.cpp"
"./src/f4se/f4se/PapyrusEventsDef.inl"
"./src/f4se/f4se/ScaleformLoader.cpp"
"./src/f4se/f4se/PapyrusActor.cpp"
"./src/f4se/f4se/GameReferences.cpp"
"./src/f4se/f4se/BSParticleShaderEmitter.h"
"./src/f4se/f4se/GameThreads.cpp"
"./src/f4se/f4se/PapyrusEvents.cpp"
"./src/f4se/f4se/PapyrusInterfaces.h"
"./src/f4se/f4se/ScaleformLoader.h"
"./src/f4se/f4se/PapyrusDelayFunctorsDef.inl"
"./src/f4se/f4se/Translation.cpp"
"./src/f4se/f4se/Translation.h"
"./src/f4se/f4se/NiRTTI.cpp"
"./src/f4se/f4se/GameSettings.h"
"./src/f4se/f4se/PapyrusObjects.h"
"./src/f4se/f4se/PapyrusMaterialSwap.h"
"./src/f4se/f4se/bhkWorld.cpp"
"./src/f4se/f4se/InternalSerialization.h"
"./src/f4se/f4se/exports.def"
"./src/f4se/f4se/PapyrusConstructibleObject.h"
"./src/f4se/f4se/PapyrusArgs.cpp"
"./src/f4se/f4se/NiSerialization.h"
"./src/f4se/f4se/Hooks_Threads.cpp"
"./src/f4se/f4se/PapyrusWaterType.cpp"
"./src/f4se/f4se/GameReferences.h"
"./src/f4se/f4se/GameUtilities.h"
"./src/f4se/f4se/GameData.h"
"./src/f4se/f4se/PapyrusPerk.h"
"./src/f4se/f4se/PluginAPI.h"
"./src/f4se/f4se/GameMemory.cpp"
"./src/f4se/f4se/PapyrusGame.h"
"./src/f4se/f4se/GameFormComponents.cpp"
"./src/f4se/f4se/ScaleformTranslator.h"
"./src/f4se/f4se/PapyrusArmorAddon.cpp"
"./src/f4se/f4se/PapyrusDelayFunctorsDef_Base.inl"
"./src/f4se/f4se/PapyrusVM.cpp"
"./src/f4se/f4se/PluginManager.h"
"./src/f4se/f4se/PapyrusDefaultObject.h"
"./src/f4se/f4se/GameInput.cpp"
"./src/f4se/f4se/PapyrusF4SE.cpp"
"./src/f4se/f4se/PapyrusWeapon.h"
"./src/f4se/f4se/GameCamera.cpp"
"./src/f4se/f4se/ScaleformState.cpp"
"./src/f4se/f4se/GameFormComponents.h"
"./src/f4se/f4se/GameEvents.h"
"./src/f4se/f4se/PapyrusValue.cpp"
"./src/f4se/f4se/PapyrusUI.cpp"
"./src/f4se/f4se/PapyrusNativeFunctionDef_Base.inl"
"./src/f4se/f4se/PapyrusInput.h"
"./src/f4se/f4se/GameExtraData.h"
"./src/f4se/f4se/BSGraphics.cpp"
"./src/f4se/f4se/PapyrusUI.h"
"./src/f4se/f4se/BSModelDB.h"
"./src/f4se/f4se/NiExtraData.h"
"./src/f4se/f4se/GameAPI.h"
"./src/f4se/f4se/BSGraphics.h"
"./src/f4se/f4se/InternalSerialization.cpp"
"./src/f4se/f4se/GameWorkshop.cpp"
"./src/f4se/f4se/GameForms.h"
"./src/f4se/f4se/GameMessages.cpp"
"./src/f4se/f4se/PapyrusScriptObject.cpp"
"./src/f4se/f4se/NiTypes.cpp"
"./src/f4se/f4se/NiTypes.h"
"./src/f4se/f4se/PapyrusObjectMod.h"
"./src/f4se/f4se/Hooks_Memory.cpp"
"./src/f4se/f4se/Hooks_Camera.cpp"
"./src/f4se/f4se/PapyrusValue.h"
"./src/f4se/f4se/ScaleformMovie.cpp"
"./src/f4se/f4se/PapyrusMath.cpp"
"./src/f4se/f4se/GameTypes.h"
"./src/f4se/f4se/CustomMenu.cpp"
"./src/f4se/f4se/PapyrusGame.cpp"
"./src/f4se/f4se/PapyrusCell.cpp"
"./src/f4se/f4se/NiMaterials.cpp"
"./src/f4se/f4se/ScaleformAPI.h"
"./src/f4se/f4se/Hooks_Papyrus.cpp"
"./src/f4se/f4se/GameMenus.cpp"
"./src/f4se/f4se/Hooks_SaveLoad.h"
"./src/f4se/f4se/NiRTTI.h"
"./src/f4se/f4se/PapyrusLocation.cpp"
"./src/f4se/f4se/NiCloningProcess.h"
"./src/f4se/f4se/PapyrusArmor.cpp"
"./src/f4se/f4se/PluginManager.cpp"
"./src/f4se/f4se/PapyrusDelayFunctors.h"
"./src/f4se/f4se/PapyrusConstructibleObject.cpp"
"./src/f4se/f4se/PapyrusWeapon.cpp"
"./src/f4se/f4se/ScaleformState.h"
"./src/f4se/f4se/NiObjects.cpp"
"./src/f4se/f4se/PapyrusStruct.cpp"
"./src/f4se/f4se/GameStreams.cpp"
"./src/f4se/f4se/PapyrusStruct.h"
"./src/f4se/f4se/PapyrusEvents.h"
"./src/f4se/f4se/ScaleformCallbacks.cpp"
"./src/f4se/f4se/BSCollision.h"
"./src/f4se/f4se.sln"
"./src/f4se/f4se_readme.txt"
"./src/f4se/xbyak"
"./src/f4se/xbyak/xbyak_mnemonic.h"
"./src/f4se/xbyak/COPYRIGHT"
"./src/f4se/xbyak/xbyak.h"
"./src/f4se/xbyak/xbyak_bin2hex.h"
"./src/f4se/xbyak/xbyak_util.h"
"./src/f4se/f4se_loader_common"
"./src/f4se/f4se_loader_common/Inject.cpp"
"./src/f4se/f4se_loader_common/f4se_loader_common.vcxproj.filters"
"./src/f4se/f4se_loader_common/LoaderError.cpp"
"./src/f4se/f4se_loader_common/IdentifyEXE.h"
"./src/f4se/f4se_loader_common/f4se_loader_common.vcxproj"
"./src/f4se/f4se_loader_common/Steam.h"
"./src/f4se/f4se_loader_common/LoaderError.h"
"./src/f4se/f4se_loader_common/Steam.cpp"
"./src/f4se/f4se_loader_common/IdentifyEXE.cpp"
"./src/f4se/f4se_loader_common/Inject.h"
"./src/f4se/f4se_common"
"./src/f4se/f4se_common/f4se_version.rc"
"./src/f4se/f4se_common/Utilities.h"
"./src/f4se/f4se_common/f4se_version.h"
"./src/f4se/f4se_common/Relocation.cpp"
"./src/f4se/f4se_common/SafeWrite.cpp"
"./src/f4se/f4se_common/SafeWrite.h"
"./src/f4se/f4se_common/Relocation.h"
"./src/f4se/f4se_common/f4se_common.vcxproj"
"./src/f4se/f4se_common/Utilities.cpp"
"./src/f4se/f4se_common/BranchTrampoline.cpp"
"./src/f4se/f4se_common/BranchTrampoline.h"
"./src/f4se/f4se_common/f4se_common.vcxproj.filters"
"./src/f4se/f4se_steam_loader"
"./src/f4se/f4se_steam_loader/f4se_steam_loader.vcxproj"
"./src/f4se/f4se_steam_loader/main.cpp"
"./src/f4se/f4se_steam_loader/f4se_steam_loader.vcxproj.filters"
"./src/f4se/f4se_loader"
"./src/f4se/f4se_loader/f4se_loader.vcxproj"
"./src/f4se/f4se_loader/f4se_loader.vcxproj.filters"
"./src/f4se/f4se_loader/Options.h"
"./src/f4se/f4se_loader/Options.cpp"
"./src/f4se/f4se_loader/main.cpp"
"./msvcr110.dll"
"./Fallout4.ccc"
"./msvcp110.dll"
"./cudart64_75.dll"
"./f4se_steam_loader.dll"
"./Galaxy64.dll"
"./installer.exe-LICENCE.txt"
"./Fallout4.dxvk-cache"
"./High.ini"

)


# Convert valid files to a format that includes the full path in CHECK_PATH
for i in "${!VALID_FILES[@]}"; do
    VALID_FILES[$i]="${CHECK_PATH}/${VALID_FILES[$i]#./}"
done

# Function to check if a file exists in the valid list
is_valid_file() {
    local file="$1"
    for valid_file in "${VALID_FILES[@]}"; do
        if [ "$file" == "$valid_file" ]; then
            return 0
        fi
    done
    return 1
}

# 3. Iterate over the files in the specified directory
while IFS= read -r -d $'\0' file; do
    # Skip the root directory itself to avoid deleting it
    if [ "$file" == "$CHECK_PATH" ]; then
        continue
    fi

    # If the file is not in the valid list, remove it
    if ! is_valid_file "$file"; then
        echo "Removing: $file"
        rm -rf "$file"
    fi
done < <(find "$CHECK_PATH" -mindepth 1 -print0)

echo "Cleanup complete."
