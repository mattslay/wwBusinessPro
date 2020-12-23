#DEFINE ccPASSED 'passed.'
#DEFINE ccFAILED '"FAILED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"'


*=======================================================================================
Define Class wwBusinessProTestRunner as Custom

		*-- These properties can be adjusted by tester
	*lShowMessageBoxForBoErrors = .f.
	lPrintErrorsFromBoAtEndOfEachTest = .t.

	nTotalTestCount = 0
	nTotalTestTime = 0
	cCurrentTest = ''
	cTestClass = ''
	oTest = null



*---------------------------------------------------------------------------------------
Procedure TestBO(tcClass)

	This.oTest = CreateObject(tcClass + 'Test', tcClass)
	This.cTestClass = tcClass

	This.RunAllTests()

EndProc


*---------------------------------------------------------------------------------------
Procedure PrintFinalTestRunResults

	? ' '
	? '*########################################################################################'
	? '  ' + Transform(This.nTotalTestCount) + ' tests in ' + Transform(This.nTotalTestTime) +' seconds.'
	? '*########################################################################################'

Endproc

*---------------------------------------------------------------------------------------
Procedure PrintTestHeader()

	lcCurrentTest = Strtran(Lower(This.cCurrentTest), 'test_', 'Test_')

		*-- This creates a "fake" Procedure so the rest will appear in the Document View window for
		*-- easy navigation and review.
		? ''
	  ? '*================================================================================='
	  ? 'Procedure  ' +  This.cTestClass + '::' +  This.cCurrentTest
	  ? '*================================================================================='
	  ? ' '

EndProc

*---------------------------------------------------------------------------------------
Procedure PrintTestResults

	Local lcError, lnBO_Errors, x

	This.PrintTestErrors()
 
	This.PrintBoErrors()
	
	*-- If there are any errors, then create a fake Procedure definition so it will appear in Document View ----
	If This.oTest.oErrors.Count > 0
	  ? ''
	  ? 'Procedure  ' +  This.cTestClass + '::' +  This.cCurrentTest + '_Failed__<============================= FAIL'
	  ? ' '
 EndIf


EndProc

*---------------------------------------------------------------------------------------
Procedure PrintTestErrors

	*-- Display any errors from the oErrors collection on this test class.
	*-- Note: This error collection also includes all BO errmsg's.
	If This.oTest.oErrors.Count > 0
		x = 1
		? ' '
		? '[== Begin error display from test class error collection =============================]'
		For Each lcError in This.oTest.oErrors FOXOBJECT
			If !Empty(lcError)
	      ? '  Error ' + Transform(x) + ':'
				? '     ' + Evl(lcError, 'No error message recorded.')
			EndIf
			x = x + 1
		EndFor
		
		? '[== End error display from test class ==============================================]'
	Endif

Endproc

*---------------------------------------------------------------------------------------
Procedure PrintBoErrors

	*-- Display any Business Object errors (Controlled by class property ) ------------------------------
	If This.oTest.oBO.oErrors.Count > 0 and this.lPrintErrorsFromBoAtEndOfEachTest = .t.
		? ' '
		? '[== Begin error display from BO ====================================================]'
	  ? Alltrim(Str(This.oTest.oBO.oErrors.Count))+ ' Error(s) on Business Object <' + This.cTestClass + '>'
	  This.oTest.oBO.PrintErrors
		? '[== End BO error display ======================================================]'
	EndIf

EndProc



*====================================================================================
Procedure SetupTestRun(tcTestRunName)

	Public lcSpacer, lnX, lnY, lnMiscMethodsTestCount, lcOutputFile 

	lcSpacer = Space(6)
	lnMiscMethodsTestCount = 0

	??
	*Clear
	Set Talk on

	lcOutputFile = Evl(tcTestRunName, 'Test_Run_' + Dtos(Datetime()) + Sys(2015))
	lcOutputFile = lcOutputFile +  '.prg'

	Set Alternate To &lcOutputFile
	Set Alternate On

	Set TextMerge NoShow
	
	? Ttoc(Datetime())
	? ' '

EndProc

*=======================================================================================
Procedure LoadTestClasses(tcPathToTestClasses as string)

	Local laTestClasses[1], lnX

	ADir(laTestClasses, Addbs(tcPathToTestClasses) + '*.prg')
	
	For lnX = 1 to Alen(laTestClasses, 1)
		Set Procedure To (Addbs(tcPathToTestClasses) + laTestClasses[lnX, 1]) Additive
	Endfor

  ? 'Test path: ' + tcPathToTestClasses

Endproc


*=======================================================================================
Procedure EndTestRun

	This.PrintFinalTestRunResults()

	Set Alternate off
	Set Alternate to
	Modify Comm &lcOutputFile NoWait
	
EndProc


*--------------------------------------------------------------------------------------- 
Procedure RunAllTests

	Local laTestObject[1], lcExecute, lcMethod, lcType, lnX, lnTests, lnSeconds
	
	Amembers(laTestObject, This.oTest, 1, 'U')
	
	lnTests = 0
	lnSeconds = Seconds()

	For lnX = 1 To Alen(laTestObject, 1)
		lcType = laTestObject[lnX, 2]
		If lcType = 'Method'
			lcMethodName = laTestObject[lnX, 1]
			If Lower(Left(lcMethodName, 5)) = 'test_'
				This.RunTest(lcMethodName)
				lnTests = lnTests + This.oTest.nTestCount
			Endif
		Endif
	EndFor
	
	lnSeconds = Seconds() - lnSeconds

	This.nTotalTestTime = This.nTotalTestTime + lnSeconds	
	This.nTotalTestCount = This.nTotalTestCount + lnTests
	
	? ' '
	? '*<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><'
	? This.oTest.name + ': ' + Transform(lnTests) + ' tests in ' + Transform(lnSeconds) + ' seconds.'
	? '*<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><'

EndProc




*--------------------------------------------------------------------------------------- 
Procedure RunTest(tcTestName)

	This.cCurrentTest = tcTestName

	This.PrintTestHeader()
	
	This.oTest.BeginTest(This.cCurrentTest)

	lcExecute = 'This.oTest.' + tcTestName + '()'
	&lcExecute

	This.oTest.EndTest()
	
	This.PrintTestResults() && Prints out any errors.


Endproc


*=======================================================================================
Procedure TestCreationOfAllBusinessObjects

	Local lnEndSeconds, lnStartSeconds, loTest, lcBOTable
	
	lcBOTable = 'wwBusinessObjects'

	? 'Test Name: TestCreationOfAllBusinessObjects'
	If ! Used(lcBOTable)
		Select 0
		Use wwBusinessObjects
	Else
		Select (lcBOTable)
	Endif

	Scan
		? 'Processing Business Object Key: ' + cKey
		lnStartSeconds = Seconds()
		lcKey = Alltrim(cKey)
		
		llError = .f.
		loTest = .null.
		loTest = CreateWWBO(lcKey)

		Do Case
			Case IsNull(loTest)
				 ? lcKey + ' "ERROR: Busness Object is null - Could not create object from class."'

			Case IsNull(loTest.oData)
				? lcKey + ' "- Business Object created, but oData Object is null."'
		Endcase
				
		lnEndSeconds = Seconds()
		lcSeconds = lcSpacer + Alltrim(Transform(lnEndSeconds - lnStartSeconds)) + ' seconds.  '
		
		If IsObject(loTest)
			If loTest.oErrors.Count > 0
				? lcSpacer + '"****** ERROR *****************************"'
				? lcSpacer + lcKey + ' Object: ' + lcSeconds + Alltrim(Str(loTest.OErrors.Count)) + ' Error(s): '
				loTest.PrintErrors()
				*? lcSpacer + loTest.cErrorMsg
				? lcSpacer + '******************************************'
			Else
				? lcSpacer + lcKey + ' object created successfully in' + lcSeconds
			EndIf
		Else
			Loop
		Endif
		
		Try
			Select 0
			Use (loTest.cFilename) Again shared
			Use
		Catch
			? lcSpacer + '"****** ERROR ACCESSING TABLE *****************************"'
			? lcSpacer + lcKey + ' Object: Cannot USE table ' + loTest.cFileName
			? lcSpacer + '******************************************'
		Endtry

		Select (lcBOTable)
	Endscan


Endproc

EndDefine




*===================================================================================
Define Class wwBusinessProTest as FxuTestCase OF FxuTestCase.prg

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

*------------------------------------------------------------------------------------
Procedure Init(tcBOClass)

	This.cBOClass = tcBOClass
	This.Setup()

EndProc


*---------------------------------------------------------------------------------------
Procedure Setup

	This.oErrors = CreateObject('Collection')
	This.nTestCount = 0
	If !Empty(This.cBOClass)
		This.CreateBO(.T.) && .T. means create any child objects also
	Endif

Endproc


*------------------------------------------------------------------------------------
Procedure CreateBO(tlCreateChildren)

	This.oBO = CreateWWBO(This.cBOClass, tlCreateChildren)

	This.oBO.lShowErrors = .f.

	If !IsObject(This.oBO)
	 ? '   ">>>> Test Failed - No object returned from call to method CreateBO() for class ' + This.cBOClass + '"'
	 Return .f.
	EndIf

	Do Case
		Case IsNull(This.oBO)
			? '   *** Error: Business Object is Null'
			Return .f.
			
		Case This.oBO.oErrors.Count > 0
			? '"**===== The following errors occurred when initializing BO: ***============="'
			This.oBO.PrintErrors()
			Return .f.
	EndCase
	

EndProc

*------------------------------------------------------------------------------------
Procedure BeginTest(tcTestName)
	
	Local lcOutout, lnMiscMethodsTestCount, lnX

	If Empty(tcTestName)
	 tcTestName = Lower(GetWordNum(Sys(16,3), 2))
	EndIf
		
	This.nTestStartTime = Seconds()
	
	This.Setup()
	
EndProc   



*------------------------------------------------------------------------------------
Procedure EndTest

	Local lcMessage, lcOutput, loError

	This.nTestTime = Seconds() - This.nTestStartTime

	*-- Add any BO errmsg to the oErrors collection on this test instance
	For Each loError in This.oBO.oErrors FOXOBJECT
		lcMessage = loError.name + ' object ->  ' + loError.errmsg
		This.SetError(lcMessage)
	EndFor

	*-- Print test footer summary
	? ' '
	lcOutput = 'Test Complete. ' + Alltrim(Str(This.nTestCount)) + ' test(s) in ' + Alltrim(Transform(This.nTestTime)) + ' seconds'
	? lcOutput
	If This.oErrors.Count > 0
		lcOutput = '"Errors: ' + Transform(This.oErrors.Count) + ' - see results below."'
		? lcOutput
	Endif
	? Replicate('*', 80)
	This.cTestOutput = This.cTestOutput + lcOutput

EndProc




*--------------------------------------------------------------------------------------- 
Procedure AssertIsTrue(llResult, tcMessage)
	
	This.BeginAssert()	

	If llResult = .t.
		This.TestProgress(.t.)
	Else
		This.AssertFailed(tcMessage)
	EndIf

Endproc

*--------------------------------------------------------------------------------------- 
Procedure AssertIsFalse(llResult, tcMessage)
	
	This.BeginAssert()

	If llResult = .f.
		This.TestProgress(.t.)
	Else
		This.AssertFailed(tcMessage)
	Endif

EndProc

*--------------------------------------------------------------------------------------- 
Procedure AssertFailed(tcMessage)

		tcMessage = Evl(tcMessage, '<no assert message given>')
		This.TestProgress(.f.)
		This.SetError('Assert failed: ' + tcMessage)
		This.lLastAssertFailed = .t.
		This.lLastAssertPassed = .f.
		*this.PrintErrors()
		*? '"Assert failed: " '
		*?? tcMessage

Endproc


*---------------------------------------------------------------------------------------
Procedure BeginAssert()

	This.lLastAssertFailed = .F.
	This.lLastAssertPassed = .T.
	This.nTestCount = This.nTestCount + 1

Endproc

*--------------------------------------------------------------------------------------- 
Procedure PrintAbandonTestMessage()
	
	? '"Test cannot continue. No further parts of the test can be evaluated."'
	
Endproc
*---------------------------------------------------------------------------------------
Procedure PrintErrors

		If This.oBO.oErrors.count > 0
			? Replicate('-', 80)
			This.oBO.PrintErrors()
			? Replicate('-', 80)
			? ''
		Endif
Endproc

*------------------------------------------------------------------------------------
Procedure TestProgress(tlTestPassed)

	* lcOutput = Iif(tlTestPassed, '.', '[X]') 
	* ?? lcOutput 
	* This.cTestOutput = this.cTestOutput + lcOutput

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
	
	This.oBO.ClearErrors()
	lcTestValue = Iif(Vartype(tuTestValue) = 'N', Alltrim(Str(tuTestValue)), '`' + tuTestValue + '`') 

	? lcSpacer + 'Calling Get(' + lcTestValue + ')... '
	lnStartSeconds = Seconds()
	llGetTest = This.oBO.Get(tuTestValue)
	lnEndSeconds = Seconds()
	?? Alltrim(Transform(lnEndSeconds - lnStartSeconds)) + ' seconds.'

	
	? lcSpacer + 'Get() method ' + Iif(llGetTest, ccPASSED, ccFAILED)
	lcNotFoundMessage = 'Lookup value [' + Transform(tuTestValue) + '] not found in ' + This.cBOClass + '.Get()'
	This.AssertIsTrue(llGetTest, lcNotFoundMessage)
	
	If !llGetTest
		Return 1
	Endif

	This.TestChildren()

	This.AssertIsTrue(!Empty(This.oBO.cPKField), This.cBOClass + ' class has no cPKField, therefore it cannot process the Save() method.')
	
	If Empty(This.oBO.cPKField)
		Return
	Endif
	
	If Vartype(This.oBO.PK) = 'C'
		? '   Note: This object has a STRING PKField [' + This.oBO.cPKField + ']'
	Endif

	If This.oBO.lFound
		Try
		 	? lcSpacer + 'Calling Save(.T.)... '
			lnStartSeconds = Seconds()
			llSaveTest = This.oBO.Save(.T.)
			lnEndSeconds = Seconds()
			?? Alltrim(Transform(lnEndSeconds - lnStartSeconds)) + ' seconds.'
		Catch
			llSaveTest = .F.
			lcFailedSaveTestMessage = 'An error occurred during call to ' + This.oBO.Name + '.Save()'
		Finally
		EndTry
		
		This.AssertIsTrue(llSaveTest, lcFailedSaveTestMessage)
		? lcSpacer + 'Save(.T.) test ' + Iif(llSaveTest, ccPASSED, ccFAILED)
		
	Else
		? lcSpacer + 'Save() test was "NOT" performed since passed test value was not found!'
	Endif
	
	Return This.oBO.oErrors.Count = 0
	
Endproc


*------------------------------------------------------------------------------------------------------
Procedure TestNew()

	*-- New() test: Attempt to create a new record -------------------------------------------------
	*-- Note: Record is not Saved, only created by calling New().
	Local llNewTest

	? '   cIdTable: [' + Iif(Empty(This.oBO.cIdTable), 'not assigned', This.oBO.cIdTable) + ']'
	? '   lPreassignPK: [' + Iif(This.oBO.lPreAssignPK, '.T.', '.F.') + ']'

	llNewTest = This.oBO.New(Empty(This.oBO.cIdTable))
	? '   New() test ' + Iif(llNewTest, ccPASSED, ccFAILED) 
	? '   PK [' + this.oBO.cPKField + '] = ' + Transform(This.oBO.PK)
	If !Empty(This.oBO.cLookupField)
		? '   Lookup value [' + this.oBO.cLookupField + '] = ' + this.oBO.KeyValue
	Endif
	
	This.AssertIsTrue(llNewTest, This.cBOClass + '.New() method failed.')
	
	Return llNewTest 

EndProc

*------------------------------------------------------------------------------------------------------
Procedure TestNewFromCopy()

	*-- NewFromCopy() test: Attempt to create a new Parent record with properties copied from the one we found in the Get() test
	*-- Note: Record is not Saved, only created by calling New().
	Local llNewFromCopyTest

	llNewFromCopyTest = This.oBO.NewFromCopy(Empty(This.oBO.cIdTable))
	? '   NewFromCopy() test ' + Iif(llNewFromCopyTest, ccPASSED, ccFAILED)
	? '   PK = ' + Transform(This.oBO.PK)

	This.AssertIsTrue(llNewFromCopyTest, This.cBOClass + '.NewFromCopyTest() method failed.')
	
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

	*--- This will output each Property name on the object and the value (excludes native props) -----
	? ''
	? '*---------------------------------------------------------------------------------'
	? 'Procedure  ' +  this.cBOClass + '_Properties'

		LOCAL ARRAY laPems[1]
		Local lnI, lcPropertyName, lcPropVal

		FOR lnI = 1 TO AMEMBERS(laPems, toBO)
		     lcPropertyName = laPems[lnI]
		     If Upper(lcPropertyName) = '_MEMBERDATA'
		      Loop
		     EndIf
			? '   ' + Padr(lcPropertyName, 40) && Output the property name
			TRY
				lcPropVal = TRANSFORM(EVALUATE('This.oBO.' + lcPropertyName))
			CATCH
				* This occurs when a property that would normally reference an object,
				* such as parent, does not return an object reference.
				lcPropVal = [(none)]
			ENDTRY
			??  lcPropVal
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
		This.SetError('TEST ERROR MESSAGE: An error occurred during call to ' + toChild.Name + '.NewItem()')
	Finally
	Endtry

	? lcSpacer + 'Child object ' + toChild.Name + Iif(llNewItemTest, ' passed', ' "<<FAILED>>"') + ' the NewItem() test.'
	
	Return (toChild.oErrors.count = 0)
	
Endproc
  
  
*--------------------------------------------------------------------------------------- 
Procedure SetError(tcMessage)

	This.oErrors.Add(tcMessage)

EndProc


*---------------------------------------------------------------------------------------
Procedure ConfirmPrimaryKeyNotEmpty()

		This.AssertIsTrue(This.oBO.PK > 0, 'Primary Key value on object is empty. Key Field is [' + This.oBO.cPkField + ']')

Endproc


*---------------------------------------------------------------------------------------
Procedure ConfirmEditMode()

		*-- Should now be saved with nUpdate = 1 (Edit Mode) ------------------
		This.AssertIsTrue(This.oBO.nUpdateMode = 1, 'nUpdateMode is not in edit mode [1]. Value is ' + Transform(This.oBo.nUpdateMode))

Endproc

*---------------------------------------------------------------------------------------
Procedure CallSaveOnBO(tlSaveChildren)

		? 'Calling Save() method ...'
		
		lnBeforePK = This.oBO.PK
		
		This.oBO.Save(tlSaveChildren)
	
		This.ConfirmPrimaryKeyNotEmpty()
		
		If This.oBO.PK <> lnBeforePK
			? '   PK [' + this.oBO.cPKField + '] = ' + Transform(This.oBO.PK)
		Endif
		
		This.ConfirmEditMode()

Endproc


Enddefine
*======================================================================================= 

          