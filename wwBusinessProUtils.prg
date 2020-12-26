*-- Modify the settings in this file to match your application environment:
#INCLUDE wwBusinessPro.h

* See wwBusinesPro.prg for full change log details.
* Version 5.4.0 2020-12-26 (No changes here)
* Version 5.3.1 2020-12-23 (No changes here)
* Version 5.3.0	2020-05-26	
* Version 5.2.1	2019-11-18 (No changes here)
* Version 5.2	2019-06-26
* Version 5.1	2019-03-05

#DEFINE CR Chr(13)
#DEFINE CRCR Chr(13) + Chr(13)


*===== Setup for wwBusiness and wwBusinessPro =====================================================================
Procedure Setup_wwBusinessPro
	** Caution - Be sure your Path setting contains all the folder names where these PRGs can be found.
	
	*-- These items are from the West Wind "Client Tools" or "Web Connection" packages
	Do wwClient.prg  && This will load several West Wind prg procedure files to our environment
	Do wwJsonSerializer.prg 
	
	*-- These next two dependencies are actually loaded up by the call to wwJsonSerialier.prg
	* Do wwDotNetBridge.prg && Add some West Wind features to allow calling .Net class in VFP
	* Set Procedure To 'wwCollections.prg' Additive
	
	Do wwUtils 
	
	*-- The items are from the wwBusinessPro package
	Set Procedure To 'wwBusinessProUtils.prg' Additive
	Set Procedure To 'wwBusinessPro.prg' Additive
	Set Procedure To 'wwBusinessProItemList.prg' Additive
	Set Procedure To 'wwBusinessProItemListController.prg' Additive
	Set Procedure To 'wwBusinessProAbstractFactory.prg' Additive
	Set Procedure To 'wwBusinessProFactory.prg' Additive
	Set Procedure To 'wwBusinessProBusObjManager.prg' Additive
	Set Procedure To 'wwBusinessProSqlLogger.prg' Additive
	Set Procedure To 'wwBusinessProSql.prg' Additive
	Set Procedure To 'wwBusinessProAppObject.prg' Additive
	Set Procedure To 'wwBusinessProObjectFactory.prg' Additive
	Set Procedure To 'wwBusinessProDiff.prg' Additive
	
EndProc

*=======================================================================================
Procedure GetObjectFactory(tlDoNotDispose)

	Local loFactory as 'wwBusinessProObjectFactory' of 'wwBusinessProObjectFactory.prg'

	loFactory = CreateObject('wwBusinessProObjectFactory', tlDoNotDispose)

	Return loFactory
	
EndProc

*===============================================================================================
Procedure CreateWWBO(tcClass, tlLoadChildItems, toParent, tlLoadRelatedObjects)

	Local llDoNotDispose
	Local loObject
	Local loFactory as 'wwBusinessProObjectFactory' of 'wwBusinessProObjectFactory.prg'
	
	If Pcount() < 4
		tlLoadRelatedObjects = WWBUSINESSPRO_LOAD_RELATED_OBJECTS && Read from include file if parameter not passed
	Endif

	llDoNotDispose = .t.
	loFactory = GetObjectFactory(llDoNotDispose)
	
	loObject = loFactory.CreateWWBO(tcClass, tlLoadChildItems, toParent, tlLoadRelatedObjects)
	
	Return loObject

Endproc


*===============================================================================================
*-- tcClass is a key lookup value for wwBusinessObjects table.
Procedure CreateWWBOChild(tcClass, toParent)

	Local llCreateChildObjects, llDoNotDispose
	Local loObject
	Local loFactory as 'wwBusinessProObjectFactory' of 'wwBusinessProObjectFactory.prg'
	
	llDoNotDispose = .t.
	loFactory = GetObjectFactory(llDoNotDispose)

	llCreateChildObjects = .f.
	loObject = loFactory.CreateWWBO(tcClass, llCreateChildObjects, toParent)
	
	Return loObject 

EndProc

*===============================================================================================
* This method creates a BO, but without loading any Child or Related Objects that might be defined
* for it in the Business Object Dictionary.
*-- tcClass is a key lookup value for wwBusinessObjects table.
Procedure CreateWWBOEmpty(tcClass)

	Local llDoNotDispose
	Local loObject
	Local loFactory as 'wwBusinessProObjectFactory' of 'wwBusinessProObjectFactory'
	
	llDoNotDispose = .t.
	loFactory = GetObjectFactory(llDoNotDispose)

	loObject = loFactory.CreateWWBOEmpty(tcClass)
	
	Return loObject 

EndProc

*---------------------------------------------------------------------------------------
* Returns the cFilename (i.e. the Table) for the passed BO Dictionary Key
Procedure GetTableFromBOKey(tcKey)

	Local laTable[1], lcAlias, lcBusinessObjectDictionary 

	lcBusinessObjectDictionary = WWBUSINESSPRO_FACTORY_DICT_TABLE + '.dbf'
	
	Select Evl(cFilename, cClassName) From (lcBusinessObjectDictionary) ;
	 Where Alltrim(Lower(Evl(cClassname, cKey))) == Alltrim(Lower(tcKey));
	 Into Array laTable
	
	*-- If not found above, let's try just looking for a match on the cKey
	If _tally = 0 or Empty(laTable)
		Select Evl(cFilename, cClassName) From (lcBusinessObjectDictionary) ;
		 Where Alltrim(Lower(cKey)) == Alltrim(Lower(tcKey));
		 Into Array laTable
	EndIf
	
	*-- If still not found, try to create a object from the key, then return loObject.cFilename
	If _Tally = 0 or Empty(laTable)
		Try
			loObject = NewObject(tcKey, tcKey + ".prg")
			laTable = loObject.cFilename
		Catch
		EndTry
	Endif

	lcAlias = Alltrim(Evl(laTable, ""))
	
	Return lcAlias
			
EndProc
	

*---------------------------------------------------------------------------------------
* This method returns a "raw" business object directly from the NewObject() method. The normal
* property-loading from the Business Object Dictionary will NOT be be applied here; only the
* raw object is created and returned.
* An attempt is made to create the object using tcKey + ".prg", where it looks for a matching
* prg file to the class name. If the class lives in a VCX, you can pass the vcx lib name in the
* tcClassLib paramter as "MyLib.vcx"
Procedure CreateObjectFromBOKey(tcKey, tcClassLib)

	Local laTable[1], lcBusinessObjectDictionary, lcClass, lcLib, loReturn

	lcBusinessObjectDictionary = WWBUSINESSPRO_FACTORY_DICT_TABLE + '.dbf'

	*-- If dictionary DBF is found, use the passed tcKey as a lookup key from the DBF
	*-- to find the Class name
	If File(lcBusinessObjectDictionary)
		Select Evl(cClassname, cKey) From (lcBusinessObjectDictionary) ;
		 Where Alltrim(Lower(Evl(cclassname, ckey))) == Lower(tcKey);
		 Into Array laTable

		lcClass =	Alltrim(Evl(laTable, ''))
	Endif
	
	If Empty(lcClass)
		lcClass = tcKey
	Endif

	If File(lcClass + '.prg')
		lcLib = lcClass +	'.prg'
	Else
		lcLib = tcClassLib
	EndIf
	
	Try
		loReturn = NewObject(lcClass, lcLib, 0)
	Catch
		loReturn = .f.
	EndTry

	Return loReturn
	
Endproc

*-------------------------------------------------------
Procedure IsObject(tuReference)

	lcVarType = VarType(tuReference)
	
	If lcVarType = 'C'
		If Type(tuReference) = 'O' and !IsNull(Evaluate(tuReference))
			Return .t.
		Else
			Return .f.
		EndIf
	Else
		If lcVarType = 'O' and !IsNull(tuReference)
			Return .t.
		Else
			Return .f.
		Endif
	EndIf

EndProc

*-------------------------------------------------------
*-- See also the IsNumber() funciton in wwUtils.prg
Procedure IsString(tuReference)

	Return Vartype(tuReference) = 'C'

Endproc

*---------------------------------------------------------------------------------------
*-- Source: https://www.berezniker.com/content/pages/visual-foxpro/how-check-if-variable-integer
Procedure NumberOfDecimals(tnNumber)

	Return -AT(SET("Point"), PADL(tnNumber, 20)) % 20

Endproc

*---------------------------------------------------------------------------------------
*-- Source: https://www.berezniker.com/content/pages/visual-foxpro/how-check-if-variable-integer
Procedure IsInteger(tnNumber)

	Return NOT ( SET("Point") $ PADL(tnNumber, 20) )

Endproc

*---------------------------------------------------------------------------------------
*-- Source: https://www.berezniker.com/content/pages/visual-foxpro/how-check-if-variable-integer
Procedure IsWholeNumber(tnValue)

	Return  (tnValue% 1) = 0

EndProc

*---------------------------------------------------------------------------------------
**  Function: Compares a source string and a compare string
**            to see if source string cotnains the compare string
**    Assume:
**      Pass: lcSourceString   -  Base string to check
**            lcCompare        -  String to check for
**    Return: .T. or .F. 
*---------------------------------------------------------------------------------------
Procedure Contains(lcSourceString, lcCompare, llCaseInSensitive)

	If Empty(lcCompare)
		If Empty(lcSourceString)
			Return .T.
		Endif
		Return .F.
	Endif

	If !llCaseInSensitive
		If Lower(lcCompare) $ Lower(lcSourceString)
			Return .T.
		Endif
	Else
		If lcCompare $ lcSourceString
			Return .T.
		Endif
	Endif

	Return .F.

EndProc


*=======================================================================================
* Creates and returns a Business Object with a new, private session object.
* This functions first creates a PrivateDataSessionHost instance (a Session object), which in its Init() method will
* create an instance of the BO from the passed BO class/key reference, and that new BO
* will have its owns private DataSession as its workspace for all new cursors created by the BO.
* You can read the DataSession ID from oObject.nDataSessionID property.
Procedure ObjectPrivateDataSession(tcClassName, txParam1, txParam2, txParam3)

	Local loPrivateDataSessionHost as "PrivateDataSessionHost" of "wwBusinessProUtils.prg"
	
	If Vartype(tcClassName) != 'C'
		Return .null.
	EndIf
	
	lnParams = Pcount()

	Do Case
		Case lnParams = 1
			loPrivateDataSessionHost = CreateObject('PrivateDataSessionHost', tcClassName)
		Case lnParams = 2
			loPrivateDataSessionHost = CreateObject('PrivateDataSessionHost', tcClassName, txParam1)
		Case lnParams = 3
			loPrivateDataSessionHost = CreateObject('PrivateDataSessionHost', tcClassName, txParam1, txParam2)
		Case lnParams = 4
			loPrivateDataSessionHost = CreateObject('PrivateDataSessionHost', tcClassName, txParam1, txParam2, txParam3)
	EndCase
	
	Return loPrivateDataSessionHost.oObject

EndProc

*---------------------------------------------------------------------------------------
*-- Nulls out all the Object properties on the passed object.
*-- See this blog post for further explanation: http://www.west-wind.com/wconnect/weblog/ShowEntry.blog?id=692
Procedure DisposeObjects(toObject)

	Local loObject
	Local laMembers[1], lcMember, loMembers, lcObjectClass
	
	If VarType(toObject) != 'O' or IsNull(toObject)
		Return
	EndIf
	
	If PemStatus(toObject, "lDisposeCalled", 5)
		toObject.lDisposeCalled = .t.
	EndIf
	
	*? "Disposing attached objects: " + Alltrim(toObject.Class)
	
	lcObjectClass = Lower(toObject.BaseClass)
	
	Amembers(laMembers, toObject, 0, 'U')
	
	For Each lcMember In laMembers
		If Type('toObject.' + lcMember) = 'O' and !IsNull(toObject.&lcMember.)
			If lcObjectClass = 'form' and Lower(lcMember) = 'activecontrol'
				Loop
			Endif
			loObject = toObject.&lcMember.
			*? "   Setting " + toObject.Class + "." + lcMember + " to .null."
			If PemStatus(loObject, 'Dispose', 5)
				loObject.Dispose()
			EndIf
			toObject.&lcMember. = null
		Endif
	EndFor
	
EndProc
	

*---------------------------------------------------------------------------------------
*-- Creates a local cursor from an existing cursor, and can index the new cursor if tcIndexField is passed.
	Procedure CreateCursorFromCursor(tcNewCursor, tcSource, tcIndexField)

		Local lcTag

		Do Case
			Case Pcount() = 1
				Select * From (tcNewCursor) Into Cursor Query
				tcIndexField = ''
				tcSource = 'Query'

			*-- If 2 params are passed, treat second one as the Index field
			Case Pcount() = 2
				Select * From (tcNewCursor) Into Cursor Query
				tcIndexField = tcSource
				tcSource = 'Query'
		Endcase

		Try
			Use In &tcNewCursor
		Catch
		Endtry

		Select * From (tcSource) Into Cursor (tcNewCursor)

		If !Empty(tcIndexField)
			lcTag = GetWordNum(tcIndexField, 1)
			Index On &tcIndexField Tag &lcTag
		EndIf
		
	EndProc

*---------------------------------------------------------------------------------------
Procedure BuildIdCollection(tcCursor, tcField)

	Local lcSql, laIDs[1]
	Local loCollection as Collection

	Text To lcSql TextMerge NoShow PreText 15

		Select Distinct <<tcField>> as value from <<tcCursor>> Into array laIDs

	EndText
	
	&lcSql

	If _Tally > 0
		loCollection = ArrayToCollection(@laIDs)
	Else
		loCollection = CreateObject("Collection")
	Endif
	
	Return loCollection
	
EndProc

*---------------------------------------------------------------------------------------
*| Takes a string of Integers [like ("123,456")] or a string of strings [like "'ABC','123'"]
*| and returns a Collection of the values.
Procedure BuildIdCollectionFromIdList(tcIdList)
	
	Local lnX, laIds[1], lcIdList, lcStrings
	Local loCollection as "Collection"

	loCollection = CreateObject("Collection")

	If Empty(tcIdList)
		Return loCollection
	Endif

	lcIdList = Chrtran(tcIdList, "()", "") && Strip off parens from each end, if present.

	If StartsWith(lcIdList, "'")
		lcStrings = .t.
	Endif
	
	If Empty(lcIdList)
		Return loCollection
	Endif

	ALines(laIds, lcIdList, 4, ",")
	
	If lcStrings
		For lnX = 1 to Alen(laIDs)
			laIDs[lnX] = Substr(laIDS, 2, Len(laIDS[lnX]) - 2)
		Endfor
	Else
		For lnX = 1 to Alen(laIDs)
			laIDs[lnX] = Val(laIDs[lnX])
			If laIDs[lnX] = Int(laIDs[lnX])
				laIDs[lnX] = Int(laIDs[lnX])
			Endif
		Endfor
	Endif
	
	If Alen(laIds) = 0
		Return loCollection
	Endif

	loCollection = ArrayToCollection(@laIDs)
	
	Return loCollection		

Endproc	

*---------------------------------------------------------------------------------------
*|================================================================================ 
*| wwBusinessPro::
*
*-- Returns a string as list of comma separated values from the passed cursor name and field name.
*
*-- Hint: This list is intended for use in constructing a Sql Select statement like this:
*      "Select * from PartMaterial Where Part_id In (1,2,3,4,5)"
*
*-- The list will be wrapped in '(' and ')' unless you pass .t. to the tlNoParens parameter
*
*-- If no field name is passed, the first field in the cursor is used.
*
*-- If the cursor has no records, '-1' or '(-1)' will be returned.
*
*-- Example:
*
*-- These are the 2 data types supported:
*     Numeric values returns: (1,2,3,4,5)
*     String values returns: ('Apples', 'Oranges', 'Nuts')
*
*   Caution: If the values are strings, and contain a single quote character, you're probably gonna have problems!!
*
* If you need this data in a Collection, see the BuildIdCollectionFromIdList() method.
*---------------------------------------------------------------------------------------
Procedure BuildIdList(tcCursor, tcField, tlNoParens)

	Local lcList, lcQuote, lnSelect, luValue, lcSql, lcCursor

	lnSelect = Select()

	lcList = ''

	If !Empty(tcCursor)
		If !Used(tcCursor)
			Return lcList
		Endif
		Select (tcCursor)
	EndIf
	
	lcCursor = Alias()

	If Empty(tcField)
		tcField = Field(1)
	Endif

	If Vartype(Evaluate(tcField)) = 'C'
		lcQuote = "'"
	Else
		lcQuote = ""
	Endif

	Text To lcSql TextMerge NoShow PreText 15

		Select Distinct <<tcField>> As Value From <<lcCursor>> Into Cursor "csrIdListValues"

	EndText

	&lcSql

	Scan
		If Empty(Alltrim(Transform(value))) or ;
		   Transform(value) = '0' or ;
		   IsNull(value)
			Loop
		Endif
	
		lcList = lcList + ',' + lcQuote + Transform(value) + lcQuote
	EndScan
	
	lcList = Evl(lcList, '-1') && If no values were found
	lcList = Alltrim(lcList, 0, ',') && strip off ending comma

	If !tlNoParens
		lcList = '(' + lcList + ')'
	Endif

	Select (lnSelect)

	Return lcList
	
EndProc

*---------------------------------------------------------------------------------------
Procedure CloseCursor(tcCursor)

	If Used(tcCursor)
		Use In (tcCursor)
	EndIf
	
EndProc


*---------------------------------------------------------------------------------------
Procedure GetTempCursor()

    Return "csrTemp" + Sys(2015)

EndProc


*---------------------------------------------------------------------------------------
*-- Determines if the passed string contains one of several Operator characters within the string, but not at the beginning.
*-- Returns .f. if the string begins with or ends with one of the operators, or if one of the operators is not found within the string.
Procedure HasOperator(tcString)
	
	Local laOperators[1], lcFirstChar, lcLastChar, lcOperators, lnX

	lcOperators = '= > < ! #'
	lcFirstChar = Left(tcString, 1)
	lcLastChar = Right(tcString, 1)
	
	If lcFirstChar $ lcOperators or lcLastChar $ lcOperators
		Return .f.
	EndIf

	ALines(laOperators, lcOperators, 5, " ")

	For lnX = 1 to Alen(laOperators)
		If laOperators[lnX] $ tcString
			Return .t.
		Endif
	EndFor
	
	Return .f.

EndProc


*---------------------------------------------------------------------------------------
*-- Returns a (new) duplicate object of the passed oData object.
Procedure CopyDataObject(toObject)
 	*-- Based on http://www.berezniker.com/content/pages/visual-foxpro/shallow-copy-object

 	Local  laProps[1], lnI, lcPropName
 	Local loNewObject

 	If IsNull(toObject)
 	    Return Null
 	Endif

 	loNewObject = Createobject("Empty")

 	For lnI = 1 To Amembers(laProps, toObject, 0)
 	    lcPropName = Lower(laProps[lnI])
 	    If Type([toObject.] + lcPropName, 1) = "A"
 	        AddProperty(loNewObject, lcPropName + "[1]", Null )
 	        = Acopy(toObject.&lcPropName, loNewObject.&lcPropName)
 	    Else
 	        AddProperty(loNewObject, lcPropName, Evaluate("toObject." + lcPropName) )
 	    Endif
 	Endfor

 	Return loNewObject
 	
 EndProc


*---------------------------------------------------------------------------------------
Procedure CloseCursor(tcCursor)

	Try
		Use In &tcCursor
	Catch
	Endtry

EndProc

*---------------------------------------------------------------------------------------
Procedure ZapCursor(tcCursor)

	Local lcSafety

	If Empty(tcCursor) or Vartype(tcCursor) != "C"
		Return
	EndIf	
	
	If  Used(tcCursor)
		lcSafety = Set('Safety')
		Set Safety Off
		Zap In (tcCursor)
		Set Safety &lcSafety	
	Endif

EndProc

*---------------------------------------------------------------------------------------
*-- This method will iterate over all the properties on the passed object and
*-- trim all the leading and trailing spaces off the character fields.
Procedure AlltrimObject(toObject)

	Local laProperties[1], lcProperty, luValue, lnX

	AMembers(laProperties, toObject)

	For lnX = 1 to ALen(laProperties)
		lcProperty = laProperties[lnX]
		luValue = GetPem(toObject, lcProperty)
		If VarType(luValue) = "C"
			AddProperty(toObject, lcProperty, Alltrim(luValue))
		Endif
	EndFor
	
EndProc


*---------------------------------------------------------------------------------------
*-- tnDisplayMode: 0 = print to screen, 1 or greateer = MessageBox
Procedure PrintData(toObject, tnDisplayMode, tcCaption)

	Local laFields[1], lcValue, lnX, lcWrapper, lcField, lcLine, lcOutput

	AMembers(laFields, toObject)
	lcOutput = ""

	For lnX = 1 to Alen(laFields)

		lcWrapper = ''
		lcField = laFields[lnX]

		lcValue = Left(Transform(GetPem(toObject, lcField)), 255)

		If Vartype(GetPem(toObject, lcField)) = 'C' && Wrap text values in "" so it will look better
			lcWrapper = '"'
		EndIf
		
		lcLine = Padr(lcField, 25) + ': ' + lcWrapper + lcValue + lcWrapper + Chr(13)
		
		lcOutput = lcOutput + lcLine

	EndFor
	
	Do Case
		Case Empty(tnDisplayMode)
			? lcOutput
		Case tnDisplayMode > 0
			MessageBox(lcOutput, 0, Evl(tcCaption, ""))
		Otherwise
			
	Endcase
	
EndProc

*---------------------------------------------------------------------------------------
* Safely moves record pointer by testing for certain things like no current alias, invalid record no, etc.
Procedure GotoRecord(tnRecordNo, tcCursor)
	
	Do Case 
		Case Empty(tnRecordNo)
			Return .f.
		Case !Empty(tcCursor)
			If !Used(tcCursor)
				Return .f.
			EndIf
			If tnRecordNo <= Reccount(tcCursor)
				Goto tnRecordNo In &tcCursor
			Endif
		Otherwise
			If !Empty(Alias()) and tnRecordNo > 0 and tnRecordNo <= Reccount()
				Goto tnRecordNo
			Else
				Return .f.
			Endif
	EndCase

Endproc


	
	
*=======================================================================================
Define Class PrivateDataSessionHost As Session

	oObject = .Null.

	*---------------------------------------------------------------------------------------
	Procedure Init  (tcClassName, txParam1, txParam2, txParam3)
	
		Local lnParams
		
		If Vartype(tcClassName) != 'C'
			Return
		Endif

		lnParams = Pcount()
		
		Set Talk off

		Do Case
			Case lnParams = 1
				This.oObject = CreateWWBO(tcClassName)
			Case lnParams = 2
				This.oObject = CreateWWBO(tcClassName, txParam1)
			Case lnParams = 3
				This.oObject = CreateWWBO(tcClassName, txParam1, txParam2)
			Case lnParams = 4
				This.oObject = CreateWWBO(tcClassName, txParam1, txParam2, txParam3)
		EndCase
		
	EndProc
	
	*-------------------------------------------------------------------------------
	Procedure Destroy()
	
		This.oObject = .null.
		
		*? " Private Data Session Destroyed."

	Endproc

EndDefine  

 
 
*=======================================================================================
Define Class wwBusinessProUtils as wwBusinessPro of wwBusinessPro.prg

	*|================================================================================ 
	*| This is a maintenance method that will verify if max ID in a table is in sync with wws_id record for that table.
	*| If not, it will update the wws_id table to the highest PK used in the table to get them back in sync.
	Procedure CheckIdTable(tcTable, tcPkField)
	
		Local lnSelect, lcCursor, lcMessage, lcSql, lnReturn, lcPkField, lcTable
		
		lnSelect = Select()
		
		lcTable = Evl(tcTable, This.cFilename)
		lcPkField = Evl(tcPkField, This.cPKField)

		Text To lcSql TextMerge NoShow PreText 15
			Select Max(<<lcPKField>>) - (Select id From wws_id Where tablename = '<<lcTable>>') as [Diff] From <<lcTable>>
		EndText

		lcCursor = GetTempCursor()
		
		lnReturn = This.Query(lcSql, lcCursor)
		
		If lnReturn > 0  and !Empty(&lcCursor..Diff)
		
			Text To lcSql TextMerge NoShow PreText 15
				Update wws_id Set id = (Select Max(id) from <<lcTable>>) Where tablename = '<<lcTable>>'
			EndText
			
			This.Execute(lcSql)

		EndIf
		
		Use in (lcCursor)
		
		Select(lnSelect)
		
	EndProc
		
	
	*---------------------------------------------------------------------------------------
	Procedure SptSetupDataTable (lcAlias, lcSqlTable, lcKeyFields)
		*--------------------------------------------
		*   Set SPT kurzor updatable, field names are the same as on the server
		*--------------------------------------------
		*   lcAlias     - local cursor
		*   lcSqlTable  - table on the server
		*   lcKeyFields - list of the fields of the primary key
		*--------------------------------------------
		*
		Store "" To lcUpdatableFieldList, lcUpdateNameList

		For lnField = 1 To Afields(laFields, m.lcAlias)
			lcUpdatableFieldList = m.lcUpdatableFieldList + "," + laFields(m.lnField, 1)
			lcUpdateNameList	 = m.lcUpdateNameList + "," + laFields(m.lnField, 1) + " " + lcSqlTable + "." + laFields(m.lnField, 1)
		Endfor

		lcUpdatableFieldList = Substr(m.lcUpdatableFieldList, 2)
		lcUpdateNameList	 = Substr(m.lcUpdateNameList, 2)

		CursorSetProp("KeyFieldList"      , m.lcKeyFields, m.lcAlias)
		CursorSetProp("Tables"            , m.lcSqlTable, m.lcAlias)
		CursorSetProp("UpdatableFieldList", m.lcUpdatableFieldList, m.lcAlias)
		CursorSetProp("UpdateNameList"    , m.lcUpdateNameList, m.lcAlias)
		CursorSetProp("SendUpdates"       , .T., m.lcAlias)

		Return
		
	Endproc



EndDefine


	
