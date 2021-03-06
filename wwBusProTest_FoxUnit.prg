*-- Download FoxUnit testing UI from VFPX: https://vfpx.codeplex.com/wikipage?title=FoxUnit

#DEFINE ccPASSED 'passed.'
#DEFINE ccFAILED 'FAILED.'

*===================================================================================
Define Class wwBusinessProTest_FoxUnit as FxuTestCase OF FxuTestCase.prg

	*-- These properties should be regarded as private. Do no change. 
	oBO = .null.
	cBOClass = ''
	cTestOutput = ''
	nTestCount = 0
	nTestStartTime = 0 
	nTestTime = 0
	oErrors = null
	lLastAssertFailed = .f.
	lLastAssertPassed = .f.
	cTestCursor = 'TestCursor'


*---------------------------------------------------------------------------------------
Procedure Setup

	Local lcOutout, lnMiscMethodsTestCount, lnX
	
	Close Tables all
	
	This.MessageOut('Test: ' + This.Class + '.' + This.icCurrentTest + '()', .t.)

	This.nTestStartTime = Seconds()	

	This.oErrors = CreateObject('Collection')
	This.nTestCount = 0
	This.CloseCursor(This.cTestCursor)	

	This.CreateBO(.T.) && .T. means create any child objects also

	If Type('This.oBO.oBusObjManager') = 'O'
		llValidateProperties = This.oBO.ValidateProperties()
		This.AssertTrue(llValidateProperties, 'This.oBO.ValidateProperties() failed.')

		llVerifyChildObjects = This.oBO.oBusObjManager.VerifyChildObjects()
		This.AssertTrue(llVerifyChildObjects, 'This.oBO.oBusObjManager.VerifyChildObjects() failed.')

		llVerifyRelatedObjects = This.oBO.oBusObjManager.VerifyRelatedObjects()
		This.AssertTrue(llVerifyRelatedObjects, 'This.oBO.oBusObjManager.VerifyRelatedObjects() failed.')
	Endif

EndProc

*------------------------------------------------------------------------------------
Procedure TearDown

	Local lcMessage, lcOutput, loError

	This.nTestTime = Seconds() - This.nTestStartTime

	*-- We do not want to see an Exception object on the TestResult!!
	If Vartype(This.ioTestResult.ioExceptionInfo) = 'O'
		With This.ioTestResult.ioExceptionInfo
			This.MessageOut('Error no: ' + Transform(.inerrornumber))
			This.MessageOut('Line: ' + .iclinecontents)
			This.MessageOut('Line no: ' + Transform(.inlinenumber))
			This.MessageOut('Message: ' + .icmessage)
		EndWith
		This.AssertTrue(IsNull(This.ioTestResult.ioExceptionInfo), 'Exception thrown in test method.')
	EndIf
	
	*-- Check for errors on BO
	If Vartype(This.oBO) = 'O'
		This.AssertTrue(This.oBO.oErrors.Count = 0, 'Test Bus Obj had errors.')

		*-- Display any Errors that were set on the BO
		If This.oBO.oErrors.Count > 0
			This.MessageOut('Business Object errors: ' + Transform(This.oBO.oErrors.Count))
			This.MessageOut(This.oBO.GetErrorText())
		Endif

		*-- Display any Messages that were set on the BO
		If This.oBO.oMessages.Count > 0
			This.MessageOut('Business Object Messages: ' + Transform(This.oBO.oMessages.Count))
			This.MessageOut(This.oBO.GetMessageText())
		Endif

	Endif

	*-- Check for errors on test
	*This.AssertTrue(This.oErrors.Count = 0, 'Test had errors.')
	If This.oErrors.Count > 0
		lcOutput = 'Test Errors: ' + Transform(This.oErrors.Count)
		This.MessageOut(lcOutput, .t.)
	Endif

	*-- Print test footer summary
	This.MessageOut(' ')
	lcOutput = 'Test Complete. ' + Alltrim(Str(This.nTestCount)) + ' test(s) in ' + Alltrim(Transform(This.nTestTime)) + ' seconds'
	This.MessageOut(lcOutput, .t.)
	This.MessageOut(Replicate('*', 80), .t.)

EndProc

*--------------------------------------------------------------------------------------- 
Procedure MessageOut(tcMessage, tlNoIndent)
	
	Local lcSpacer

	lcSpacer = Space(6) && Indenting makes output look nicer
	If tlNoIndent = .t.
		lcSpacer = ''
	Endif

	If Empty(tcMessage)
		tcMessage = ''
	Endif

	tcMessage = lcSpacer + tcMessage
	? tcMessage
	DoDefault(tcMessage)
	This.cTestOutput = This.cTestOutput + tcMessage


Endproc

*------------------------------------------------------------------------------------
Procedure CreateBO(tlCreateChildren)

	This.oBO = CreateWWBO(This.cBOClass, tlCreateChildren)

	If !IsObject(This.oBO)
	 lcMessage = 'Error: No object returned from call to CreateBO() for class ' + This.cBOClass
	 This.MessageOut(lcMessage)
	 Return .f.
	EndIf

	Do Case
		Case IsNull(This.oBO)
			lcMessage = 'Error: Business Object is Null.'
			This.MessageOut(lcMessage)
			Return .f.
			
		Case This.oBO.oErrors.Count > 0
			lcMessage = 'Errors occurred when initializing Business Object.'
			This.MessageOut(lcMessage)
			This.oBO.PrintErrors()
			Return .f.
	EndCase

	This.oBO.lShowErrors = .f.
	

EndProc


*--------------------------------------------------------------------------------------- 
Procedure AssertTrue(tlResult, tcMessage)
	
	This.BeginAssert()	

	If tlResult = .t.
		This.AssertPassed()
	Else
		This.AssertFailed(tcMessage)
	EndIf
	
	llReturn = DoDefault(tlResult, tcMessage)
	
	Return llReturn
	
Endproc

*--------------------------------------------------------------------------------------- 
Procedure AssertFalse(tlResult, tcMessage)
	
	This.BeginAssert()

	If tlResult = .f.
		This.AssertPassed()
	Else
		This.AssertFailed(tcMessage)
	Endif

	llReturn = DoDefault(tlResult, tcMessage)
	
	Return llReturn

EndProc

*--------------------------------------------------------------------------------------- 
Procedure AssertFailed(tcMessage)

		tcMessage = Evl(tcMessage, '<no Assert message given>')
		This.SetError('Assert failed: ' + tcMessage)
		This.lLastAssertFailed = .t.
		This.lLastAssertPassed = .f.
		This.MessageOut(tcMessage)
		
		This.PrintErrors()

Endproc


*---------------------------------------------------------------------------------------
Procedure BeginAssert()

	This.lLastAssertFailed = .F.
	This.lLastAssertPassed = .T.
	This.nTestCount = This.nTestCount + 1

Endproc

*---------------------------------------------------------------------------------------
Procedure PrintErrors

		If Vartype(This.oBO) = 'O' and This.oBO.oErrors.count > 0
			? Replicate('-', 80)
			This.oBO.PrintErrors()
			? Replicate('-', 80)
			? ''
		Endif
Endproc

*------------------------------------------------------------------------------------
Procedure AssertPassed(tcMessage)

	tcMessage = Evl(tcMessage, 'Assert passed.')
	
	This.MessageOut(tcMessage)

EndProc

*------------------------------------------------------------------------------------------------------
Procedure TestGet(tuTestValue)

Local lcTestValue, llGetTest, llPassed, llSaveTest, llSaved, lnEndSeconds, lnErrors, lnStartSeconds
Local lcFailedSaveTestMessage, lcNotFoundMessage

	llSaved = .F.
	llPassed = .F.
 	lcFailedSaveTestMessage = ''

	If !(Vartype(tuTestValue) $ 'NC')
		Return
	Endif
	
	This.CreateBO(.t.)	
	This.oBO.ClearErrors()
	lcTestValue = Iif(Vartype(tuTestValue) = 'N', Alltrim(Str(tuTestValue)), '`' + tuTestValue + '`') 

	lcMessage = 'Calling Get(' + lcTestValue + ')... '
	
	lnStartSeconds = Seconds()
	llGetTest = This.oBO.Get(tuTestValue)
	lnEndSeconds = Seconds()
	lcTime = Alltrim(Transform(lnEndSeconds - lnStartSeconds)) + ' seconds.'
	This.MessageOut(lcMessage + lcTime)

	This.MessageOut('Get() method ' + Iif(llGetTest, ccPASSED, ccFAILED))
	lcNotFoundMessage = 'Lookup value [' + Transform(tuTestValue) + '] not found in ' + This.cBOClass + '.Get()'
	This.AssertTrue(llGetTest, lcNotFoundMessage)
	
	If !llGetTest
		Return 1
	Endif

	This.TestChildren()

	This.AssertTrue(!Empty(This.oBO.cPKField), This.cBOClass + ' class has no cPKField, therefore it cannot process the Save() method.')
	
	If Empty(This.oBO.cPKField)
		Return
	Endif
	
	If Vartype(This.oBO.PK) = 'C'
		This.MessageOut('   Note: This object has a STRING PKField [' + This.oBO.cPKField + ']')
	Endif

	If This.oBO.lFound
		Try
		 	lcMessage = 'Calling Save(.T.)... '
			lnStartSeconds = Seconds()
			If PemStatus(This.oBO, 'oBusObjManager', 5)
				lcParam = '.T.'
				llSaveTest = This.oBO.Save(.T.) && wwBusProParent classes have this method, and .T. means save children too.
			Else
				lcParam = ''
				llSaveTest = This.oBO.Save() && plain wwBusPro classes
			Endif
			lnEndSeconds = Seconds()
			lcTime = Alltrim(Transform(lnEndSeconds - lnStartSeconds)) + ' seconds.'
			This.MessageOut(lcMessage + lcTime)
			lcFailedSaveTestMessage = 'Call to ' + This.oBO.Name + '.Save(' + lcParam + ') returned .F.'
		Catch
			llSaveTest = .F.
			lcFailedSaveTestMessage = 'An error ocurred during call to ' + This.oBO.Name + '.Save(' + lcParam + ')'
		Finally
		EndTry
		
		This.AssertTrue(llSaveTest, lcFailedSaveTestMessage)
		This.MessageOut('Save(' + lcParam + ') test ' + Iif(llSaveTest, ccPASSED, ccFAILED))
		
	Else
		This.MessageOut('Save test was "NOT" performed since passed test value was not found!')
	Endif
	
	Return This.oBO.oErrors.Count = 0
	
Endproc


*-----------------------------------------------------------------------------------------------------------
Procedure TestNew()

	*-- New() test: Attempt to create a new record, save it to DB, and load it back by ID value --------------
	Local llNewTest, llGet, llSaveTest

	This.MessageOut('cIdTable: [' + Iif(Empty(This.oBO.cIdTable), 'not assigned', This.oBO.cIdTable) + ']')
	This.MessageOut('lPreassignPK: [' + Iif(This.oBO.lPreAssignPK, '.T.', '.F.') + ']')

	llNewTest = This.oBO.New(Empty(This.oBO.cIdTable))
	This.MessageOut('   .New() test ' + Iif(llNewTest, ccPASSED, ccFAILED))
	This.AssertTrue(llNewTest, 'Call to .New() method failed.')

	*-- Add a string KeyValue if one is not already set
	If !Empty(This.oBO.cLookupField) and Empty(This.oBO.KeyValue)
		This.oBO.KeyValue = Right(Sys(2015), Len(This.oBO.KeyValue))
	EndIf

	llSaveTest = This.oBO.Save()
	This.MessageOut('   .Save() test ' + Iif(llSaveTest, ccPASSED, ccFAILED))
	This.AssertTrue(llSaveTest, 'Call to Save() method failed.')

	This.MessageOut('   PK [' + this.oBO.cPKField + '] = ' + Transform(This.oBO.PK))
	If !Empty(This.oBO.cLookupField)
		This.MessageOut('   Lookup value [' + this.oBO.cLookupField + '] = ' + this.oBO.KeyValue)
	EndIf
	
	This.AssertTrue(!Empty(This.oBO.PK), 'PK value is empty')
	This.AssertTrue(This.oBO.lFound, 'lFound is .F. after call to Save.')

	*-- Make sure we can feth the record back out of the DB by its PK.
	If llSaveTest
		llGet = This.oBO.Get(This.oBO.PK)
		This.MessageOut(StringFormat('   .Get() {0} on newly created record. ', Iif(llGet, ccPASSED, ccFAILED)))
		This.AssertTrue(llGet, 'Call to Get() for newly create record failed.')
	EndIf
	
	*-- Deleted the test record so we do not leave junk records in our DB.
	If llSaveTest and llGet
		llDelete = This.oBO.Delete()
		This.AssertTrue(llDelete, 'Error deleting test record.')
	Endif

	Return llNewTest 

EndProc

*------------------------------------------------------------------------------------------------------
Procedure TestNewFromCopy()

	*-- NewFromCopy() test: Attempt to create a new Parent record with properties copied from the one we found in the Get() test
	*-- Note: Record is not Saved, only created by calling New().
	Local llNewFromCopyTest

	llNewFromCopyTest = This.oBO.NewFromCopy(Empty(This.oBO.cIdTable))
	This.MessageOut('   NewFromCopy() test ' + Iif(llNewFromCopyTest, ccPASSED, ccFAILED))
	This.MessageOut('   PK = ' + Transform(This.oBO.PK))

	This.AssertTrue(llNewFromCopyTest, This.cBOClass + '.NewFromCopyTest() method failed.')
	
	Return llNewFromCopyTest
		
EndProc



*------------------------------------------------------------------------------------------------------
Procedure TestChildren() &&toBO, tnFileItems, tnLineItems, tnLaborItems, tnMtlItems)
	
	If Vartype(This.oBO.oBusObjManager) ='O' and Vartype(This.oBO.oBusObjManager.oChildItems) = 'O'
		For Each loChild in This.oBo.oBusObjManager.oChildItems FOXOBJECT
			This.TestChild(loChild)
		Endfor
	Endif

Endproc


*----------------------------------------------------------------------------------------------------
Procedure DisplayProperties(toBo)

  Local lcMessage, lcPropertyName, lcPropVal

	*--- This will output each Property name on the object and the value (excludes native props) -----
	This.MessageOut(' ')
	This.MessageOut('*---------------------------------------------------------------------------------')
	This.MessageOut('Procedure  ' +  this.cBOClass + '_Properties')

		LOCAL ARRAY laPems[1]
		Local lnI, lcPropertyName, lcPropVal

		FOR lnI = 1 TO AMEMBERS(laPems, toBO)
		     lcPropertyName = laPems[lnI]
		     If Upper(lcPropertyName) = '_MEMBERDATA'
		      Loop
		     EndIf
			lcMessage = '   ' + Padr(lcPropertyName, 40) && Output the property name
			TRY
				lcPropVal = TRANSFORM(EVALUATE('This.oBO.' + lcPropertyName))
			CATCH
				* This occurs when a property that would normally reference an object,
				* such as parent, does not return an object reference.
				lcPropVal = [(none)]
			ENDTRY
			This.MessageOut(lcMessage + lcPropVal)
		Next

Endproc



*----------------------------------------------------------------------------------------------------
Procedure TestChild (toChild)

	Local loJob As Object
	Local llNewItemTest

	If Pcount() = 0 Or Vartype(toChild) <> 'O'
		Return .F.
	Endif

	*-- Make sure we have a cursor for the child records (note: it could be empty, but that's ok for this test.)
	If !Used(toChild.cCursor)
		This.SetError('Alias name [' + toChild.cAlias + '] is not present for Child BO.')
	Endif

	If toChild.lReadWrite = .F. && Exit out if this is not a ReadWrite cursor.
		Return
	Endif

  *-- Should be able to call ItemAdd() method on oLineItemsController...
	Try
		llNewItemTest = toChild.NewItem()
	Catch
		This.SetError('TEST ERROR MESSAGE: An error ocurred during call to ' + toChild.Name + '.NewItem()')
	Finally
	Endtry

	This.MessageOut('Child object ' + toChild.Name + Iif(llNewItemTest, ' passed', ' "<<FAILED>>"') + ' the NewItem() test.')
	
	Return (toChild.oErrors.count = 0)
	
Endproc
  
  
*--------------------------------------------------------------------------------------- 
Procedure SetError(tcMessage)

	This.oErrors.Add(tcMessage)

EndProc


*---------------------------------------------------------------------------------------
Procedure ConfirmPrimaryKeyNotEmpty()

		This.AssertTrue(This.oBO.PK > 0, 'Primary Key value on object is empty. Key Field is [' + This.oBO.cPkField + ']')

Endproc


*---------------------------------------------------------------------------------------
Procedure ConfirmEditMode()

		*-- Should now be saved with nUpdate = 1 (Edit Mode) ------------------
		This.AssertTrue(This.oBO.nUpdateMode = 1, 'nUpdateMode is not in edit mode [1]. Value is ' + Transform(This.oBo.nUpdateMode))

Endproc

*---------------------------------------------------------------------------------------
Procedure CallSaveOnBO(tlSaveChildren)

		This.MessageOut('Calling Save() method ...')
		
		lnBeforePK = This.oBO.PK
		
		This.oBO.Save(tlSaveChildren)
	
		This.ConfirmPrimaryKeyNotEmpty()
		
		If This.oBO.PK <> lnBeforePK
			This.MessageOut('   PK [' + this.oBO.cPKField + '] = ' + Transform(This.oBO.PK))
		Endif
		
		This.ConfirmEditMode()

EndProc

*---------------------------------------------------------------------------------------
Procedure CloseCursor(tcCursor)

	Try
		Use in (tcCursor)
	Catch
	EndTry
	
	This.AssertTrue(!Used(tcCursor), 'Cursor [' + tcCursor + '] was not closed as requested.')

EndProc

*---------------------------------------------------------------------------------------
Procedure TestCursor(tcCursor, tnRecords, tlDoNoShowSql)

		This.AssertTrue(tnRecords > 0, 'Return value from method is 0.')
		This.AssertTrue(Used(tcCursor), 'Cursor [' + tcCursor + '] is not present.')
		If Used(tcCursor)
			This.AssertTrue(Recno(tcCursor) = 1, 'Cursor should be on first row')
			This.AssertTrue(Reccount(tcCursor) = tnRecords, 'Record count in cursor does not match return value from called method.')
			This.MessageOut(Transform(Reccount(tcCursor)) + ' records in cursor.')
		Endif
		
		If !tlDoNoShowSql
				This.MessageOut(This.oBO.cSql)
		Endif

Endproc
	
Enddefine
*======================================================================================= 

            