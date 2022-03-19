Scriptname FXCameraAttachSeasonsScript extends ObjectReference  
{Dynamically attaches a camera attach fx based on the seasons. Also has a slot to fade in an image space at the same time.}
;===============================================

import debug				; import debug.psc for acces to trace()
import game				; game.psc for access to getPlayer()
import utility			; utility.psc for access to wait()
import sound				; sound.psc for access to play()

VisualEffect Property CameraAttachFX Auto 
{Particle art to attach to camera, fog by default}
VisualEffect Property CameraAttachFX2 Auto 
{2nd Particle art to attach to camera, Autumn by default}
VisualEffect Property CameraAttachFX3 Auto 
{3rd Particle art to attach to camera, Spring/Summer by default}
sound property LoopSound auto
{specify sound fx to play, set on reference, none by default}
;ImageSpaceModifier Property CrossfadeableISM Auto
;{specify crossfaded imagespace to play, set on reference, none by default}
int instanceID ;used to store sound ref
int Property timeLimit = 180 Auto

;===============================================

	EVENT ONTRIGGERENTER(ObjectReference akActionRef)
	IF (akActionRef == getPlayer() as ObjectReference);new
		if(CameraAttachFX) ; Block added by USKP 1.2.6 because apparently not everything is using the default values.
			CameraAttachFX.Play(akActionRef, timeLimit)
	; ;		debug.trace("Triggered by player")
		EndIf
		if SeasonsOfSkyrim.GetCurrentSeason() == 4
			;if (CameraAttachFX2)
			;	CameraAttachFX2.Play(akActionRef, timeLimit)
			;endif
		elseif SeasonsOfSkyrim.GetCurrentSeason() == 2 || SeasonsOfSkyrim.GetCurrentSeason() == 3
			if (CameraAttachFX3)
				CameraAttachFX3.Play(akActionRef, timeLimit)
				Utility.Wait(0.1)
				CameraAttachFX2.Stop(akActionRef)
			endif
		elseif SeasonsOfSkyrim.GetCurrentSeason() == 1
			if (CameraAttachFX2)
				Utility.Wait(0.1)
				CameraAttachFX2.Stop(akActionRef)
			endif
		endif
		;if (CrossfadeableISM)
		;	CrossfadeableISM.ApplyCrossFade(2)
		;endif
		if (LoopSound)
			instanceID = LoopSound.Play(Self)
		endif
		;wait (27)
	endif ;new
		;goToState ("reset")
	endEvent

	EVENT OnTriggerLeave(ObjectReference akActionRef)
		IF (akActionRef == getPlayer() as ObjectReference)
			if(CameraAttachFX) ; Block added by USKP 1.2.1 because apparently not everything is using the default values.
				CameraAttachFX.Stop(akActionRef)
			EndIf
			if SeasonsOfSkyrim.GetCurrentSeason() == 4
				;if (CameraAttachFX2)
				;	CameraAttachFX2.Stop(akActionRef)
				;endif
			elseif SeasonsOfSkyrim.GetCurrentSeason() == 2 || SeasonsOfSkyrim.GetCurrentSeason() == 3
				if (CameraAttachFX3)
					CameraAttachFX3.Stop(akActionRef)
				endif
			endif
			;if (CrossfadeableISM)
			;	ImageSpaceModifier.RemoveCrossFade(3)
			;endif
			;USKP 2.0.2 - Added check for invalid sound instance.
			if (LoopSound && instanceID != 0)
				StopInstance(instanceID)
			endif
			goToState ("waiting")
		ENDIF
	ENDEVENT
	
	EVENT OnUnLoad()
		if(CameraAttachFX) ; Block added by USKP 1.2.1 because apparently not everything is using the default values.
			CameraAttachFX.Stop(GetPlayer())
		EndIf
		if SeasonsOfSkyrim.GetCurrentSeason() == 4
			;if (CameraAttachFX2)
			;	CameraAttachFX2.Stop(GetPlayer())
			;endif
		elseif SeasonsOfSkyrim.GetCurrentSeason() == 2 || SeasonsOfSkyrim.GetCurrentSeason() == 3
			if (CameraAttachFX3)
				CameraAttachFX3.Stop(GetPlayer())
			endif
		endif
		;if (CrossfadeableISM)
		;	ImageSpaceModifier.RemoveCrossFade(3)
		;endif
		;USKP 2.0.2 - Added check for invalid sound instance.
		if (LoopSound && instanceID != 0)
			StopInstance(instanceID)
		endif
		goToState ("waiting")
	ENDEVENT
