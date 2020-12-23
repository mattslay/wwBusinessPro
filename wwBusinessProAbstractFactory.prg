*-- This class originally came from from Kevin McNeish's Abstract Factory class.
*-- Original source: http://download.microsoft.com/download/vfox60/Install/6.0/W9X2K/EN-US/Oakleaf.zip
*-- It has been extracted from VCX to PRG, and extended for use in wwBusinessPro by Matt Slay
*=======================================================================================

Define Class wwBusinessProAbstractFactory As Custom

	* Contains the name of the default class lookup table.
	cClassLookupTable = ''
	cClassName        = ''
	cLibHost          = ''

	* The library (vcx) where the target class comes from.
	cLibrary          = ''

	* If TRUE, the abstract class will display an error message if a class ;
	* could not be instantiated OR its key located in the specified table.
	lDisplayErrorMsg  = .T.

	Procedure Copyright

		*=======================================================================================
		*-- This class originally came from from Kevin McNeish's Abstract Factory class.
		*-- Original source: http://download.microsoft.com/download/vfox60/Install/6.0/W9X2K/EN-US/Oakleaf.zip
		*-- It has been extracted from VCX to PRG, and extended for use in wwBusinessPro by Matt Slay
		*=======================================================================================

		*|================================================================================
		*| wwBusinessProAbstractFactory::
		*  Class.............: CAbstractFactory
		*  Author............: Kevin McNeish
		*  Project...........: VFP Codebook for Mere Mortals
		*  Created...........: 04/26/1998  22:14:32
		*  Copyright.........: (c) 1998 Oak Leaf Enterprises Solution Design, Inc.
		*  Major change list.:
		*|================================================================================
		
	Endproc


	*|================================================================================
	*| wwBusinessProAbstractFactory::
	*---------------------- Location Section ------------------------
	*   Class:   CAbstractFactory
	*   Method:  GetClassName()
	*----------------------- Usage Section --------------------------
	*)  Description:
	*)		Uses the token specified in the tcToken parameter
	*)		as a key into the class lookup table. If the record
	*)		was successfully located, the method returns the
	*)		name of the corresponding concrete class.
	Procedure GetClassName(tcToken)

		*   Scope:      Public
		*   Parameters: None
		*$  Usage:      CAbstractFactory.LoadClassLookupTable()
		*$
		*   Returns:  Character - Name of the concrete class
		*--------------------- Maintenance Section ----------------------
		*   Change Log:
		*       CREATED 04/24/98 - Kevin McNeish
		******************************************************************
		*			Oak Leaf Enterprises Solution Design, Inc.
		******************************************************************(tcToken)

		Local lcClassName, llCloseClassTable, lcClassLibs, lcLibrary, lcClassName

		lcClassName = ''
		lcClassTable = Alltrim(This.cClassLookupTable)

		If !Used(lcClassTable)
			This.LoadClassLookupTable()
		Endif

		If !Used(lcClassTable)
			Return ''
		Endif


		*------------------------------------------
		*--- Use the specified token to locate the
		*--- Concrete class name
		*------------------------------------------

		lnSelect = Select()

		Select (lcClassTable)
		*-- First, attempt a lookup by dict key cKey
		Locate For Upper(Alltrim(cKey)) == Upper(Alltrim(tcToken)) And Deleted() = .F.
		
		*-- Second, attempt a lookup by cClassName
		If !Found()
			Locate For Upper(Alltrim(cClassName)) == Upper(Alltrim(tcToken)) And Deleted() = .F.
		Endif
		
		
		*Seek(Upper(tcToken), lcClassTable, 'cKey')
		If Found()
			lcClassName = Alltr(Eval(lcClassTable + '.cClassName'))
			This.cClassName = Evl(lcClassName, Alltrim(tcToken))

			lcLibrary = Alltr(Eval(lcClassTable + '.cLibrary'))
			
			If Empty(lcLibrary)
				This.cLibrary = Evl(Alltrim(cClassName), Alltrim(tcToken)) + '.prg'
			Else
				This.cLibrary = lcLibrary
			Endif

			lcLibHost = Alltr(Eval(lcClassTable + '.cLibHost'))
			This.cLibHost = lcLibHost

			llReturn = .T.
			*!*		*-----------------------------------------------------------------
			*!*		*--- If a library name and file name have been specified,
			*!*		*--- 1. Check if the class is already SET
			*!*		*--- 2. If not, SET CLASSLIB TO <classname> IN <filename> ADDITIVE
			*!*		*-----------------------------------------------------------------
			*!*		lcClassLibs = UPPER(SET('CLASSLIB'))
			*!*		IF NOT EMPTY(lcLibrary) AND NOT EMPTY(lcLibHost)
			*!*			*--------------------------
			*!*			*--- External class Library
			*!*			*--------------------------
			*!*			IF NOT UPPER(lcLibrary) + '.VCX' $ lcClassLibs
			*!*				SET CLASSLIB TO (lcLibrary) IN (lcLibHost) ADDITIVE
			*!*			ENDIF
			*!*		ELSE
			*!*			*--------------------------
			*!*			*--- Internal class Library
			*!*			*--------------------------
			*!*			IF NOT UPPER(lcLibrary) + '.VCX' $ lcClassLibs
			*!*				SET CLASSLIB TO (lcLibrary) ADDITIVE
			*!*			ENDIF
			*!*		ENDIF
		Else
			*--- Error: Specified Class key could not be found! ---*
			If This.lDisplayErrorMsg
				Messagebox('The call to create an Object using this Object Factory has failed.' + Chr(13) + Chr(13) + ;
					'No record found in lookup table [' + Upper(lcClassTable) + '.DBF] for the passed token [' + Upper(tcToken) + '].', ;
					0 + 48, 'Application Error from Factory Class ' + This.Name + ':')
			Endif

			llReturn = .F.
		Endif

		Select(lnSelect)

		Return llReturn
	Endproc


	*|================================================================================
	*| wwBusinessProAbstractFactory::
	Procedure Init
	
		Local lcSaveAlias

		If Not Empty(This.cClassLookupTable)
			lnSelect = Select()
			This.LoadClassLookupTable()
			Select (lnSelect)
		EndIf
		
	Endproc


	*|================================================================================
	*| wwBusinessProAbstractFactory::
	*---------------------- Location Section ------------------------
	*   Class:   CAbstractFactory
	*   Method:  LoadClassLookupTable()
	*----------------------- Usage Section --------------------------
	*)  Description:
	*)		Loads the class lookup table specified in the
	*)		cClassLookupTable property
	Procedure LoadClassLookupTable

		*   Scope:      Public
		*   Parameters: None
		*$  Usage:      CAbstractFactory.LoadClassLookupTable()
		*$
		*   Returns:  Logical .T. by default
		*--------------------- Maintenance Section ----------------------
		*   Change Log:
		*       CREATED 04/24/98 - Kevin McNeish
		******************************************************************
		*			Oak Leaf Enterprises Solution Design, Inc.
		******************************************************************
		lcTable = Juststem(This.cClassLookupTable)

		If Not Used(lcTable) And !Empty(lcTable)
			If File(lcTable + '.dbf')
				Use (lcTable) In 0
			Else
				If This.lDisplayErrorMsg
					Messagebox('wwFactory Lookup table not found: [' + lcTable + '.dbf]', 0 + 48, 'Error:')
				Endif
			Endif
		Endif
	Endproc


	*|================================================================================
	*| wwBusinessProAbstractFactory::
	*---------------------- Location Section ------------------------
	*   Class:   CAbstractFactory
	*   Method:  GetClassName()
	*----------------------- Usage Section --------------------------
	*)  Description:
	*)		Uses the token specified in the tcToken parameter
	*)		as a key into the class lookup table. If the record
	*)		was successfully located, the method returns the
	*)		name of the corresponding concrete class.
	Procedure Make(tcToken)

		*   Scope:      Public
		*   Parameters: None
		*$  Usage:      CAbstractFactory.LoadClassLookupTable()
		*$
		*   Returns:  Character - Name of the concrete class
		*--------------------- Maintenance Section ----------------------
		*   Change Log:
		*       CREATED 04/24/98 - Kevin McNeish
		******************************************************************
		*			Oak Leaf Enterprises Solution Design, Inc.
		******************************************************************(tcToken)

		Local llReturn, loObject, laError

		loObject = .Null.

		*-- Get the Concrete Class Name from the passed Token
		llReturn = This.GetClassName(tcToken)

		*-- Instantiate an object from the Concrete class.
		*-- We really want to use CreateObject() and "Set Procedure XXXX Additive" approach for performance reasons.
		*-- NewObject() is used below as a last-effort attempt because of performance.
		*-- See these two posts which explain why CreateObject() is faster than NewObject():
		*--   http://mattslay.com/foxpro-newobject-fast-here-slow-there/
		*--   http://www.west-wind.com/wconnect/weblog/ShowEntry.blog?id=553
		
		*? This.cClassName, This.cLibrary
		
		If llReturn
			Try
				*Set Procedure To (This.cLibrary) Additive
				loObject = CreateObject(This.cClassName)
			Catch
				Try
					loObject = CreateObject(tcToken)
				Catch
					If !Empty(This.cLibrary)
						Try
							loObject = NewObject(This.cClassName, This.cLibrary)
							*? "NewObject called on class: " + This.cClassName
						Catch
						Endtry
					EndIf
				Catch
				EndTry
			Endtry
		EndIf
		
		Return loObject
		
	Endproc


	*|================================================================================
	*| wwBusinessProAbstractFactory::
	*---------------------- Location Section ------------------------
	*   Class:   CAbstractFactory
	*   Method:  SetClassLookupTable()
	*----------------------- Usage Section --------------------------
	*)  Description:
	*)		Sets the specified abstract factory lookup table.
	*)		If a different lookup table is currently in use it is unloaded.
	Procedure SetClassLookupTable

		*   Scope:      Public
		*   Parameters:
		*		tcLookupTableName - Name of the class lookup table.
		*$  Usage:      CAbstractFactory.SetClassLookupTable(<TableName>)
		*$
		*   Returns:  Logical .T. by default
		*--------------------- Maintenance Section ----------------------
		*   Change Log:
		*       CREATED 04/24/98 - Kevin McNeish
		******************************************************************
		*			Oak Leaf Enterprises Solution Design, Inc.
		******************************************************************(tcLookupTableName)
		*--------------------------------------------
		*--- If an existing lookup table is currently
		*--- loaded, unload it
		*--------------------------------------------
		This.UnloadClassLookupTable()

		*----------------------------------
		*--- Set the new class lookup table
		*----------------------------------
		This.cClassLookupTable = tcLookupTableName
	Endproc


	*|================================================================================
	*| wwBusinessProAbstractFactory::
	*---------------------- Location Section ------------------------
	*   Class:   CAbstractFactory
	*   Method:  UnloadClassLookupTable()
	*----------------------- Usage Section --------------------------
	*)  Description:
	*)		Unloads the class lookup table specified in the
	*)		cClassLookupTable property
	Procedure UnloadClassLookupTable

		*   Scope:      Public
		*   Parameters: None
		*$  Usage:      CAbstractFactory.UnloadClassLookupTable()
		*$
		*   Returns:  Logical .T. by default
		*--------------------- Maintenance Section ----------------------
		*   Change Log:
		*       CREATED 04/24/98 - Kevin McNeish
		******************************************************************
		*			Oak Leaf Enterprises Solution Design, Inc.
		******************************************************************
		Local lcSaveAlias
		If Not Empty(This.cClassLookupTable) And Used(This.cClassLookupTable)
			lcSaveAlias = Alias()
			Select (This.cClassLookupTable)
			Use
			If Not Empty(lcSaveAlias) And ;
					NOT Upper(lcSaveAlias) == Upper(This.cClassLookupTable)
				Select (lcSaveAlias)
			Endif
		Endif
	Endproc


Enddefine
