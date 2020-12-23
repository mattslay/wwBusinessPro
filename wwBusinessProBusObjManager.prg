
Define Class wwBusinessProBusObjManager as Custom

	oChildItems     = .Null.
	oParentBO       = .Null.
	oRelatedObjects = .Null.

	*-- This property is set when SaveChildItems() is called to indicated if any rows within any of the Read/Write child cursors
	*-- had any records that were changed and written to the DB during the SaveToCursor() call.
	lChildItemsHadChanges = .f.
		
	*-- Set by Dispose() method. You can use this in your classes to help get objects cleaned up in Destroy/Released
	*-- or when _Access method would want to return an object, but you don't want it to if you are Releasing the BO.
	lDisposeCalled = .f.

*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure CreateChildObject(tcItemsKey, tcCursor, tlAllowEdit)

		Local lcAlias, lcClass, lcCursor, lcErrorMessage, lcObject, lcRootName, llReturn, loObject

		* Parameters:
		* -------------------------
		* tcItemsKey - the lookup key for the dlookup.dbf business object dictionary
		* tcCursor - the local cursor to used to hold the child records
		* tcAllowEdit - indicated if changes to the local cursor should be saved (by Parent.Save())

		tcItemsKey = Alltrim(tcItemsKey)
		lcParentClass = This.oParentBO.class
		lcChildName = Alltrim(tcItemsKey)

		
		*-- Strip out the Parent class name from the passed tcItemsKey to get object name that we'll use
		*-- for the child object on the Parent.
		*-- Ex: "JobLineItems" as a passed key becomes "oLineItems" on the "Job" Parent object.
		If Upper(lcParentClass) == Left(Upper(tcItemsKey), Len(lcParentClass))
			lcObjectName = Substr(tcItemsKey, Len(lcParentClass) + 1)
		Else
			lcObjectName = tcItemsKey
		Endif

		*-- Properties to create on the ParentBO
		lcObject = 'o' + lcObjectName
		lcAlias = 'c' + lcObjectName + 'Alias'

		*-- Property Value for above cXxxxAlias
		lcCursor = Alltrim(Evl(tcCursor, 'csr' + lcChildName))

		AddProperty(This.oParentBO, lcAlias, lcCursor)

		loObject = This.oParentBO.CreateChildObject(tcItemsKey, lcCursor, tlAllowEdit)

		If IsObject(loObject)
			loObject.name = lcObject
			This.oChildItems.Add(loObject, lcObject)
			AddProperty(This.oParentBO, lcObject, loObject)
			*Store loObject To This.oParentBO.&lcObject.
			llReturn = .T.
		Else
			AddProperty(This.oParentBO, lcObject, .null.)
			lcErrorMessage = 'Error creating [' + tcItemsKey + '] child items object on Business Object ' + This.oParentBO.Name
			This.oParentBO.SetError(lcErrorMessage)
			llReturn = .F.
		Endif

		Return llReturn
	EndProc


*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure CreateRelatedObject(tcLookupKey, tcParentKey, tcBusObjKey)

		Local lcErrorMessage, lcObject, lcObjectName, lcParentClass, llReturn, loObject

		tcLookupKey = Alltrim(tcLookupKey)
		lcParentClass = This.oParentBO.class

		If Upper(lcParentClass) == Left(Upper(tcLookupKey), Len(lcParentClass))
			lcObjectName = Substr(tcLookupKey, Len(lcParentClass) + 1)
		Else
			lcObjectName = tcLookupKey
		EndIf

		tcBusObjKey = Evl(tcBusObjKey, tcLookupKey)

		loObject = CreateWWBO(tcBusObjKey, .f., This.oParentBO) && Create the Related Object

		*-- Create a reference on ParentBO that points to this Related Object
		lcObject = 'o' + lcObjectName
		AddProperty(This.oParentBO, lcObject, .null.)

		If VarType(loObject) = 'O'
			loObject.name = lcObject
			AddProperty(This.oParentBO, lcObject, loObject)
			This.oRelatedObjects.Add(loObject, lcObject)
			AddProperty(loObject, 'cFkField', tcParentKey)
			llReturn = .T.
		Else
			lcErrorMessage = 'Error creating [' + tcLookupKey + '] related object on Business Object ' + This.oParentBO.Name
			This.oParentBO.SetError(lcErrorMessage)
			llReturn = .F.
		Endif

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure Init
	
		This.oChildItems = Createobject('Collection')
		This.oRelatedObjects = Createobject('Collection')

		DoDefault()
		
	EndProc


*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure LoadChildItems
	
		Local lnReturn, loChildBO, loParentBO, lnTime

		loParentBO = This.oParentBO

		For Each loChildBO In This.oChildItems
			
			If !loChildBO.lLoadLineItems
				Loop
			Endif

			lnTime = Seconds()

			lnReturn = loChildBO.LoadLineItemsFromParentKey() && Loads cursor of child items
			loChildBO.nQueryTime = Seconds() - lnTime

		Endfor

	EndProc


*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure LoadRelatedObjects
	
		Local lcErrorMessage, lcErrorMessageHeader, lcSql, llFound, loParentBO, loRelatedObject, luValue

		loParentBO = This.oParentBO
		
		If !IsObject(This.oParentBO) or !IsObject(This.oParentBO.oData)
			Return
		Endif

		For Each loRelatedObject In This.oRelatedObjects FoxObject
		
				If !PemStatus(loRelatedObject, 'lwwBusinessPro', 5) or Empty(loRelatedObject.cFkField)
					Loop
				Endif

				luValue = GetPem(This.oParentBO.oData, loRelatedObject.cFkField)
				llFound = loRelatedObject.Get(luValue) && Loads Related object via the field in the cFkField property.

				If !llFound and !IsNullOrEmpty(luValue)
					lcMessageHeader = Proper(loParentBO.Name) + '.' + loRelatedObject.Name + ': '
					If loRelatedObject.nErrorCount = 0 && Related record was not found, but there were no errors encountered during the lookup.
						lcMessage = lcMessageHeader + 'Related Object [' + loRelatedObject.name + '] was not found by value: [' + Transform(luValue) + '].'
						This.oParentBO.SetMessage(lcMessage, 0, .t.) && .t. = tlDoNotLog
					Else && the BO had ERROR(s) attempting the loookup
						lcErrorMessage = lcMessageHeader + 'Error loading Related Business Object. Check cFkField field in Bus Obj Dictionary.'
						lcSql = Evl(loRelatedObject.oSql.cSql, loRelatedObject.cSql)
						loParentBO.SetError(lcErrorMessage, 0, lcSql) && Record error on the Parent BO, pass in SQL from Related BO.
					EndIf
				EndIf
		EndFor
		
	EndProc


*|================================================================================ 
*|wwBusinessProBusObjManager::
	*-- This method will copy Parent PK to Related PK before saving the Related objects.
	Procedure SaveRelatedBO
	
		Local loRelatedBO

		For Each loRelatedBO In This.oRelatedObjects
			If !Empty(loRelatedBO.cPKField) And !Empty(This.oParentBO.cPKField)
				Store Evaluate("This.oParentBo.oData." + This.oParentBO.cPkfield) To ("loRelatedBo.oData." + This.oParentBO.cPkfield)
				loRelatedBO.Save()
			EndIf
		EndFor
		
	EndProc 

*|================================================================================ 
*| wwBusinessProBusObjManager::
	*-- This method will push Parent PK or Parent KeyValue onto all child rows in the local working cursor, 
	*-- if they do not already have their foreign key field set yet.
	*-- Then it saves the changes back to the real table by calling SaveToCursor()
	Procedure SaveChildItems

		Local lcChildCursor, lcChildKeyValueRef, lcFKREf, lcParentKeyValue, lcPkRef, llAllSaved, lnParentPK
		Local lnSelect, loChildBO, llChildItemsHadChanges

		lnSelect = Select()
		
		llAllSaved = .t. && Initialize as true. Code below will set to false if any save attempt fails.

		For Each loChildBO In This.oChildItems

			If loChildBO.lReadWrite = .f.
				Loop
			Endif

			With loChildBO

				lcChildCursor = .cCursor

				*-- Push Parent PK onto Child FK for all rows, but only if it is not already filled in the local cursor
				If !Empty(.cFKField) And !Empty(.cParentPKField)
					lcFKREf = .cFKRef
					lnParentPK = .nParentPK
					Replace (.cFKField) With lnParentPK All In (lcChildCursor) For Empty(Evaluate(lcFKRef))
				Endif

				*-- Push Parent KeyValue onto Child KeyValue for all rows, but only if it is not already filled in the local cursor
				If !Empty(.cLookupField) And !Empty(.cParentLookupField)
					lcChildKeyValueRef = .cKeyValueRef
					lcParentKeyValue = .cParentKeyValue
					Replace (.cLookupField) With lcParentKeyValue All In (lcChildCursor) For Empty(Evaluate(lcChildKeyValueRef))
				EndIf

				*-- Save to the real table. Handles new, edits, and deletes.
				
				llSaved = .SaveToCursor()
				
				llAllSaved = llAllSaved and llSaved
				llChildItemsHadChanges = llChildItemsHadChanges or loChildBO.lHasDataChanged 

			Endwith

		EndFor
		
		This.lChildItemsHadChanges = llChildItemsHadChanges

		Select (lnSelect)

		Return llAllSaved
		
	EndProc
	
*|================================================================================ 
*| wwBusinessProBusObjManager::
*| This method is called when the Parent Save() method fails, and we had assigned a PK to the Parent during the Save(), and it
*| was then necessary to undo any assignments of the FK values that point to that PK. That PK must be cleared out since
*| the Save() failed and the PK assignment from wws_id table was rolled back.
	Procedure ClearFkValuesOnChildCursors
	
		Local lcChildCursor, lcChildKeyValueRef, lcFKREf, lcParentKeyValue, lnParentPK, lnSelect, loChildBO
		Local loDiff as 'wwBusinessProDiff'

		lnSelect = Select()
		
		loDiff = CreateWWBO('wwBusinessProDiff')

		For Each loChildBO In This.oChildItems

			If loChildBO.lReadWrite = .f. or (!Empty(loChildBO.cCursor) and Reccount(loChildBO.cCursor) = 0)
				Loop
			Endif
			
			*-- 2019-11-18: Added this check so if Child objects in this oChildItems collection have had their
			*-- ParentBO re-assigned to another Parent, then we will not change FK values in this loop. This situation
			*-- happens when Child Object are re-assigns in Parent-Child-Grandchild models.
			*-- 2020-08-26: Now using wwBusinessProDiff to do compare...
			*If !Compobj(loChildBO.oParentBO, This.oParentBO)
			*	Loop
			*Endif
			loDiff.DiffObject(loChildBO.oParentBO, This.oParentBO)
			If loDiff.lHasChanges
				Loop
			Endif
			
			
			With loChildBO

				lcChildCursor = .cCursor

				*-- Clear FK value on all rows that match the Parent PK
				If !Empty(.cFKField) And !Empty(.cParentPKField)
					lcFKREf = .cFKRef
					lnParentPK = .nParentPK
					Replace (.cFKField) With 0 All In (lcChildCursor) For Evaluate(lcFKRef) = lnParentPK
				Endif

				*-- Clear Foreign KeyValue on all rows that match Parent LookupValue
				If !Empty(.cLookupField) And !Empty(.cParentLookupField)
					lcChildKeyValueRef = .cKeyValueRef
					lcParentKeyValue = .cParentKeyValue
					Replace (.cLookupField) With "" All In (lcChildCursor) For Evaluate(lcChildKeyValueRef) = lcParentKeyValue
				EndIf

			EndWith

			Select (lnSelect)

		EndFor

	Endproc

*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure VerifyChildObjects

		*-- Verify that each child object cursor is present...
		For Each loChild in This.oChildItems

			If !Used(loChild.cCursor)
				loChild.SetError(StringFormat('Cursor [{0}] is not present.', loChild.cCursor))
				Return .f.
			Endif

		Endfor

		*-- ToDo... We could analyze even more stuff on the Child Objects to make sure they appear to be setup correctly...
	EndProc


*|================================================================================ 
*| wwBusinessProBusObjManager::
	Procedure VerifyRelatedObjects

		For each loObject in This.oRelatedObjects

			If IsNull(loObject)
				loObject.SetError(StringFormat('Related object [{0}] is null', loObject.Name))
				Return .f.
			Endif

		Endfor
	EndProc


	*---------------------------------------------------------------------------------------
	Procedure Destroy

		This.Dispose()
		
		DoDefault()
		
	EndProc

	*---------------------------------------------------------------------------------------
	Procedure Dispose

		If This.lDisposeCalled
			Return
		EndIf
		
		This.lDisposeCalled = .t.
	
		*? "Destroying Related Objects on BusObjManager..."
	
		If Type('This.oRelatedObjects') = 'O' and !IsNull(This.oRelatedObjects)
			For Each loObject in This.oRelatedObjects
				loObject.Dispose()
				loObject = .null.
			EndFor
			This.oRelatedObjects = .null.
		Endif
	
		*? "Destroying Child Objects on BusObjManager..."

		If Type('This.oChildItems') = 'O' and !IsNull(This.oChildItems)
			For Each loObject in This.oChildItems
				loObject.Dispose()			
				loObject = .null.
			EndFor
			This.oChildItems = .null.
		Endif
		
		This.oParentBO = .null.
			
	Endproc

EndDefine
 