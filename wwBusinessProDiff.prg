#Include wwBusinessPro.h

*=======================================================================================
Define Class wwBusinessProDiff as Custom

	*-- Optional. Set these externally if you want to assign ref data to an instance of this object.
	cRefNo = ""
	nRefID = 0

	*-- These fields are ignored when looking for changes between toInspect and toOriginal.
	cIgnoreFields = ""

	*-- This flag will ignore white space characters at the end of values when doing comparisons.
	lIgnoreBlankCharPadding = .t.
	
	lHasChanges = .f. && See _Acces() method
	
	oChanges = .null.


	*---------------------------------------------------------------------------------------
	Procedure Init()
		
		This.CreateCollection()
			
	EndProc
	
	*---------------------------------------------------------------------------------------
	Procedure CreateCollection()

		This.oChanges = CreateObject("Collection")
		
		Return This.oChanges
	
	EndProc
	
	*---------------------------------------------------------------------------------------
	Procedure lHasChanges_Access
	
		Local llReturn

		If Vartype(This.oChanges) != "O" or IsNull(This.oChanges)
			llReturn = .f.
		Else
			llReturn = This.oChanges.Count > 0
		Endif
	
		Return llReturn
		
	Endproc
		
	*---------------------------------------------------------------------------------------
	*-- Be sure to call DiffObject() before calling this method.
	*
	*-- tnDisplayLocation:
	*-- 1 = Screen
	*-- 2 = MessageBox
	*-- 3 = Srceen and MessageBox
	*
	*-- tnDataMode:
	*-- 1 = Human Readable Text
	*-- 2 = Json
	
	Procedure DisplayChanges(tnDisplayLocation, tnDataMode)
	
		Local lcOutput, loChange

		lnDisplayLocation = Evl(tnDisplayLocation, 1)
		If lnDisplayLocation < 1 or lnDisplayLocation > 3
			lnDisplayLocation = 1
		Endif

		lnDataMode = Evl(tnDataMode, 1)
		If lnDataMode < 0 or lnDataMode > 2
			lnDateMode = WW_DATAMODE_DBF
		Endif

		lcOutput = "cRefNo:  " + This.cRefNo + "  nRefID: " + Transform(This.nRefID) + Chr(13) + Chr(13)
		
		Do Case
			Case lnDataMode = WW_DATAMODE_DBF
				For Each loChange In This.oChanges FoxObject
				
					lcOutput = lcOutput + Space(5) + loChange.Property + ;
								"  -   From: " + Transform(loChange._OriginalValue) + "  to:  " + Transform(loChange._NewValue)
					
				EndFor

			Case lnDataMode = WW_DATAMODE_SQL
				loSerializer = CreateObject("wwJsonSerializer")
				loSerializer.FormattedOutput = tlFormatted
				lcJson = loSerializer.Serialize(This.oChanges)
				lcOutput = lcOutput +  lcJson 
		Endcase
		
		If InList(lnDisplayLocation, 1, 3)
			? lcOutput
		EndIf
		
		If InList(lnDisplayLocation, 2, 3)
			MessageBox(lcOutput)
		EndIf
		
	
	Endproc
			
	
	*---------------------------------------------------------------------------------------
	Procedure DiffObject(toInspect, toOriginal)

		Local laFields[1], lcField, lnCount, lnX, luCurrentValue, luOriginalValue, lcIgnoreFields
		Local loDiff as "Empty"
		Local loDiffCollection as "Collection"

		loDiffCollection = This.CreateCollection()
		
		lcIgnoreFields = "," + Lower(Strtran(This.cIgnoreFields, " ", "")) + ","
		lnCount = AMembers(laFields, toInspect)
				
		For lnX = 1 to lnCount

			lcField = Lower(laFields[lnX])
			
			If !PemStatus(toOriginal, lcField, 5)
				Loop
			Endif
			
			luCurrentValue = GetPem(toInspect, lcField)
			luOriginalValue = GetPem(toOriginal, lcField)
			
			If VarType(luCurrentValue) != Vartype(luOriginalValue) or !(luCurrentValue == luOriginalValue)
				If VarType(luCurrentValue) = "C" and ;
					This.lIgnoreBlankCharPadding and ;
					Empty(luCurrentValue) and Empty(luOriginalValue)
					Loop
				EndIf
			
				If !Empty(This.cIgnoreFields) and ("," + lcField + ",") $ lcIgnoreFields
					Loop
				EndIf
				
				*-- If we have a Date in oData, and oOrigData was a DateTime with 00:00:00 as Time
				*-- Then we consider that the data has not changed.
				If Vartype(luCurrentValue) = 'D' and Vartype(luOriginalValue) = 'T' ;
						and luCurrentValue = Cast(luOriginalValue as Date) and ;
						(Hour(luOriginalValue) + Minute(luOriginalValue) + Sec(luOriginalValue) = 0)
					Loop
				Endif
				
				loDiff = CreateObject("Empty")
				AddProperty(loDiff, "Property", lcField)
				AddProperty(loDiff, "_NewValue", luCurrentValue)
				AddProperty(loDiff, "_OriginalValue", luOriginalValue)
				loDiffCollection.Add(loDiff)
			Endif
			
		EndFor
		
		Return loDiffCollection

	EndProc
	
	*---------------------------------------------------------------------------------------
	Procedure DiffJson(toInspect, toOriginal, tlFormatted)
	
		Local loSerializer as "wwJsonSerializer"
		Local lcJson, loDiffCollection

		loDiffCollection = This.DiffObject(toInspect, toOriginal)
		
		If loDiffCollection.Count = 0
			lcJson = ""
		Else
			loSerializer = CreateObject("wwJsonSerializer")
			loSerializer.FormattedOutput = tlFormatted
			lcJson = loSerializer.Serialize(loDiffCollection)
		Endif
		
		Return lcJson
		
	Endproc
	
EndDefine  