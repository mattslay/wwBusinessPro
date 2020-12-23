#INCLUDE wwBusinessPro.h

Define Class wwBusinessProfactory as wwBusinessProAbstractFactory of wwBusinessProAbstractFactory.prg

	* Set this property to indicate the app name which is driving the BO.
	* This can be be used by the logger help record usage and/or error info.
	cAppName = ''
	
	* The Connection string to the SQL Server.
	cConnectionString = .f.
	
	* The path to the data files.
	cDataPath = .f.
	cIdTable = .f.
	cLookupKey = ''
	
	* This property is used in the error logging so the log file can show
	* which "module" in your app was using the Bus Obj.
	cModuleName = ''
	
	* This property is used in the error logging so the log file can show
	* which "user" in your app was using the Bus Obj. Can be name, id,
	* whatever. Will be stored as a string.
	cUser = ''

	* The place where user provided data tables can be found (for nDataMode = DBF mode only)
	cUserDataPath = ''
	
	* 0 = FoxPro Tables, 2 = SQL Server
	nDataMode = 0

	* A reference to a the oSql object to be used by the BO when it is created.
	oSql = .Null.

*|================================================================================ 
*| wwBusinessProfactory::
	Procedure CreateChildItems(toParent)
	
		Local lcCursor, lcLookupKey, llAllowEdit, lnTally, llBusObjManagerCreated
		Local lcBusObjKey, lcProperty, lcValue, lnAlen, lnX
		Local laChildren[1]
		Local laFields[1]
		Dimension laChildren[1]

		*-- First, find any Child Business Objects in the BO Dictionary that belong to this Parent BO
		Select  cKey,;
				cCursor,;
				lAllowEdit ;
		    From (This.cClassLookupTable) ;
		    Where Alltrim(Upper(cParent)) == Alltrim(Upper(This.cLookupKey)) ;
		          and cType = 'I' ;
		          and Deleted() = .f. ;
		    Into Array laChildren

		lnTally = _Tally

		If lnTally > 0

			toParent.CreateBusObjManager()
			llBusObjManagerCreated = .t.

			For x = 1 To lnTally && Create each Child object
				lcLookupKey = Alltrim(laChildren[x, 1])
				lcCursor = Alltrim(laChildren[x, 2])
				llAllowEdit = laChildren[x, 3]
				Debugout "Creating wwBusinessPro Child Object from dictionary: " + lcLookupKey
				toParent.oBusObjManager.CreateChildObject(lcLookupKey, lcCursor, llAllowEdit)
			Endfor

		EndIf
		
		*-- Next, find any Child objects defined in custom properties on the BO Class file.
		*-- Syntax is:  _Child_CustomerDepartments = 'CustomerDepartments, csrCustomerDepartments, .t.'
		*-- Param1 = ClassName
		*-- Param2 = Cursor
		*-- Param3 = ReadWrite
		AMembers(laFields, toParent, 0, "U")
		lnAlen = Alen(laFields)
		lnX = Ascan(laFields, "_", 1, lnAlen, 1, 4)
		If Empty(lnX)
			Return
		EndIf
		
		For x = 1 to lnAlen
			lcProperty = laFields[x]
			If StartsWith(lcProperty, ')_CHILD_')
				If !llBusObjManagerCreated
					toParent.CreateBusObjManager()
					llBusObjManagerCreated = .t.
				Endif
				lcValue = GetPem(toParent, lcProperty)
				
				lcBusObjKey = Alltrim(GetWordNum(lcValue, 1, ","))
				lcCursor = ""
				llAllowEdit = .f.
				If GetWordCount(lcValue, ",") >= 2
					lcCursor = Alltrim(GetWordNum(lcValue, 2, ","))
				Endif
				
				If GetWordCount(lcValue, ",") >= 3
					llAllowEdit = Alltrim(GetWordNum(lcValue, 3, ","))
					llAllowEdit = Evaluate(llAllowEdit)
				Endif
				
				Debugout "Creating wwBusinessPro Child Object from property: " + lcProperty
				toParent.oBusObjManager.CreateChildObject(lcBusObjKey, lcCursor, llAllowEdit)
			Endif
		EndFor
				
	EndProc


*|================================================================================ 
*| wwBusinessProfactory::
*| There are 2 ways you can define a Related Object for a Business Object.
*| 1: Add a Related Object "R" row to the Business Object Dictionary table.
*| 2: Add a property to the Business Object like: Related_Customer = '<<fk_field>>'
*| You can mix and match these two approaches in any fashion to create Related Objects.
*|---------------------------------------------------------------------------------------
	Procedure CreateRelatedObjects(toBusObj)

		Local laRelatedObjects[1], lcBusObjKey, lcLookupKey, lcParentKey, lnTally, lnAlen
		Local laFields[1], lcForeignKey, lcProperty, x, llBusObjManagerCreated, lnX

	 	*-- First, find any Related Business Objects the BO Dictionary that belong to this parent BO
		Select  cKey,;
		        cFkField,;
		        cBusObjKey ;
			From (This.cClassLookupTable) ;
		    Where Alltrim(Upper(cParent)) == Alltrim(Upper(This.cLookupKey)) ;
	          and cType = 'R' ;
	          and Deleted() = .f.;
		    Into Array laRelatedObjects

		lnTally = _Tally

		If lnTally > 0
			toBusObj.CreateBusObjManager()
			llBusObjManagerCreated = .t.

			For x = 1 To lnTally && Create each Related object

				lcLookupKey = Alltrim(laRelatedObjects[x, 1])
				lcParentKey = Alltrim(laRelatedObjects[x, 2])
				lcBusObjKey = Alltrim(laRelatedObjects[x, 3])

				Debugout "Creating wwBusinessPro Related Object from Dictionary key: " + lcLookupKey 
				toBusObj.oBusObjManager.CreateRelatedObject(lcLookupKey, lcParentKey, lcBusObjKey)

			EndFor
		EndIf
		
		*-- Next, create any Related objects defined in custom properties BO the Class.
		*-- Syntax is:  _Related_Customer = '<<fk_field>>'
		*-- Where 'Customer' is the cKey for the Business Object Dictionary Table.
		AMembers(laFields, toBusObj, 0, "U")
		lnAlen = Alen(laFields)
		lnX = Ascan(laFields, "_", 1, lnAlen, 1, 4)
		If Empty(lnX)
			Return
		EndIf
		For x = lnX to lnAlen
			lcProperty = laFields[x]
			If StartsWith(lcProperty, '_RELATED_')
				If !llBusObjManagerCreated
					toBusObj.CreateBusObjManager()
					llBusObjManagerCreated = .t.
				EndIf
				lcBusObjKey = Proper(Substr(lcProperty, 10))
				lcForeignKey = GetPem(toBusObj, lcProperty)
				Debugout "Creating wwBusinessPro Related Object from property: " + lcProperty
				toBusObj.oBusObjManager.CreateRelatedObject(lcBusObjKey, lcForeignKey, lcBusObjKey)
			Endif
		EndFor
		
	EndProc


*|================================================================================ 
*| wwBusinessProfactory::
	Procedure Make(tcToken, toParent, tlLoadChildItems, tlLoadRelatedObjects)

		Local lcDictTable, lcTable, lnRecno, loObject, loReturn, llCreatedFromDictionary
		Local llwwBusinesProObject 
		
		lcTable = Alltrim(This.cClassLookupTable)

		If Used(lcTable)
			lnRecno = Recno(lcTable)
		Else
			lnRecno = 0
		EndIf
		
		This.cLookupKey = tcToken
		This.lDisplayErrorMsg = .f.
		
		*-- Try to lookup the BO token from the BO Dictionary table, and create the BO object...
		loObject = DoDefault(tcToken)
		
		*-- If the above failed, we try to use the passed token string to create the object. 
		*-- This assumes VCX or PROCEDURE has been set in place before calling here.
		If IsNull(loObject)
			Try
				loObject = CreateObject(tcToken)
			Catch
				Try
					*-- If the above failed, we try one last attempt, by assuming the passed token is the name of the Class and that it lives
					*-- in a PRG with the same name. This allows that the PRG is in the path, but that it doesn't have to be set with a Set Procedure command.
					loObject = NewObject(tcToken, Alltrim(tcToken + '.prg'))
				Catch
				Endtry
			Endtry
		Else
			llCreatedFromDictionary = .t.
		Endif

		*-- Error: Object could not be instantiated! ---*
		If IsNull(loObject) And This.lDisplayErrorMsg
			Messagebox('Cannot instantiate object from class named [' + This.cClassName + ']. Check values in lookup table [' + Upper(This.cClassLookupTable) + '.DBF] and VCX File(s).', ;
						0 + 48, 'Application Error from wwBusinessProFactory Class:')
		Endif

		*-- Now that the object is created, let's apply values from the dictionary table to it.
		If IsObject(loObject)

			lcDictTable = This.cClassLookupTable && The Factory Lookup table for this class
			
			llwwBusinesProObject = PemStatus(loObject, "lwwBusinessPro", 5) and loObject.lwwBusinessPro = .t.

			If llwwBusinesProObject 
				loObject.cAppName = This.cAppName
				loObject.cModuleName = This.cModuleName
				loObject.cUserId = This.cUser
			Endif

			If llCreatedFromDictionary = .t. and llwwBusinesProObject 

				*-- Now, apply values from the lookup table to this BO...
				*-----------------------------------------------------------------------------------------------------
				*-- This next group of properties deals with how and where to get the data.
				*-- They can be empty in LookupTable and will be set with defaults from this wwBusinessProFactory, or
				*-- you subclass, if they are present there.

				*-- nDataMode (Where to get the data from. 0 = DBF, 2 = SqlServer, and there are more possible like HTTP, but those not supported in my implementation)
				*-- In the Factory Lookup table, set the field nDataMode to -1 to have nDataMode set by the property on this object
				*-- This allows you to switch over from DBF to Sql Server by simply changing the property here to affect all BOs.
				*-- Can also use constants WW_DATAMODE_DBF and WW_DATAMODE_SQL from wwBusiness.h
				loObject.nDataMode = Iif(&lcDictTable..nDataMode < 0, This.nDataMode, 0)

				*-- This is for SQL Server (nDataMode = 2 aka constant WW_DATAMODE_SQL):
				loObject.cConnectString = Iif(Empty(&lcDictTable..cConnStr), Alltrim(This.cConnectionString), Alltrim(&lcDictTable..cConnStr))

				*-- This is for DBF Mode (nDataMode = 0):
				loObject.cDataPath = Alltrim(&lcDictTable..cDataPath) && The path to the data file

				If Upper(Alltrim(loObject.cDataPath)) == 'USER'			&& A generic way to point to the data table if it is to be found on the users machine
					loObject.cDataPath = Alltrim(This.cUserDataPath)  && Set This.cUserDataPath in caller of this
				EndIf

				*-- These MUST be set in the Factory LookupTable for the BO lookups and CRUD operations to work properly
				loObject.cFilename = Evl(Evl(Alltrim(&lcDictTable..cFilename), Alltrim(&lcDictTable..cClassName)), Alltrim(&lcDictTable..cKey)) && The physical DBF file or Table in Sql Server
				
				loObject.cAlias = Iif(Empty(&lcDictTable..cAlias), loObject.cFilename, Alltrim(&lcDictTable..cAlias)) && What the alias is the dbf atble to be opened as
				
				If (Empty(loObject.cCursor))
					loObject.cCursor = Iif(Empty(&lcDictTable..cCursor), 'csr' + loObject.cFilename, Alltrim(&lcDictTable..cCursor)) && Name of the cursor created in LoadLineItems (for the child BO's) (same as ALias for Parent BO's)
				EndIf

				If !Empty(&lcDictTable..cPKfield)
					loObject.cPKfield = Alltrim(&lcDictTable..cPKfield) && Should be an Integer unique ID field in the table
				EndIf
				
				If !Empty(&lcDictTable..cLookupFld)
					loObject.cLookupField = Alltrim(&lcDictTable..cLookupFld) && String value lookup field for quick string-match lookups
				Endif

				*-- This is the ID table that the base wwBusiness uses to assign unique PKs.
				*-- This may or may not be used, since the PKs may be assigned by an AutoInc on the table or something.
				* loObject.cIdTable = Iif(Empty(&lcDictTable..cIdTable), Alltrim(this.cIdTable), Alltrim(&lcDictTable..cIdTable))
				If !Empty(&lcDictTable..cIdTable)
					loObject.cIdTable = Alltrim(&lcDictTable..cIdTable)
				EndIf
				
				loObject.lPreassignPK = &lcDictTable..PreAssPK

				*=== These properties will only be present on wwBusinessProItemList Child classes =================

				*-- If no PK Field (an integer) is specified, will assume that we are using cLookupField (a string) to find parent and children records
				If Empty(loObject.cPKfield) And PemStatus(loObject, 'lUseLookupFieldToFetchLineItems', 5)
					loObject.lUseLookupFieldToFetchLineItems = .T.
				Endif

				*-- This property will only be on ItemList objects, not on Parent BO objects
				If PemStatus(loObject, 'cFKField', 5) and !Empty(&lcDictTable..cFKField)
					loObject.cFKField = Alltrim(&lcDictTable..cFKField)
				Endif

				*-- This field is usually present on ItemList classes and typically controls the item sequence order of the child records
				If PemStatus(loObject, 'cOrderByFieldList', 5) and !Empty(&lcDictTable..cOrderFld)
					loObject.cOrderByFieldList = Alltrim(&lcDictTable..cOrderFld)
				EndIf

			EndIf

			lcParentText  = ""
			If PemStatus(loObject, 'oParentBO', 5)
				If IsObject(toParent) Or Isnull(toParent)
					loObject.oParentBO = toParent
				Endif
				If IsObject(toParent) And !Isnull(toParent)
					lcParentText = toParent.Class + "."
				Endif
			EndIf
			
			*-- If the object doesn't have the 'nDataMode' property, then it's not a wwBusiness class, so these next steps do not apply.
			If PemStatus(loObject, 'nDataMode', 5) 

				loObject.SetSqlObject(WWBUSINESSPRO_OSQL_REF) && <-- See wwBusinessPro.h to define what this resolves to.

				loObject.GetBlankRecord() && We need oData saturated before setting cLineItemsControlClass property. (all fields will be empty, but typed)

				*-- Line Items Control class - (optional). This field in the Dictionary Table should only be on ChildItems objects.
				*-- A LineItemsControl class provides functions, like: NewItem(), DeleteItem(), MoveItem()
				*-- which will allow you to add rows the the Child cursor and it will automatically fill in the FK value to point back to the ParentPK
				*-- You can use the wwBusinessProItemController as a baseclass for this functionality.
				*-- In the following code, when the property is set on the ChildBO, it will fire the _Assign method, which will create the ItemsControl object and
				*-- attach it to the Child object.
				*-- This object is used when a call to loOrder.oOrderItems.NewItem() is made
				If PemStatus(loObject, 'cLineItemsControlClass', 5) and &lcDictTable..cType = 'I'
					If !Empty(&lcDictTable..cCtrlClass)
						loObject.cLineItemsControlClass = Alltrim(&lcDictTable..cCtrlClass)
					Else
						loObject.cLineItemsControlClass = WWBUSINESSPRO_ITEMS_CONTROLLER_CLASS
					EndIf
					
				Endif

				*-- For Parent BOs, optionally create the Child item BO's based on passed param
				If PemStatus(loObject, 'lLoadChildItems', 5) && This property only exists on wwBusinessPro objects, not wwBusinessProItemList child objects
					loObject.lLoadChildItems = tlLoadChildItems

					If loObject.lLoadChildItems = .t.
						This.CreateChildItems(loObject)
					Endif
				EndIf

				*-- Create any Related Object BO's defined in the Class
				If PemStatus(loObject, 'lLoadRelatedObjects', 5) 
					loObject.lLoadRelatedObjects = tlLoadRelatedObjects

					If loObject.lLoadRelatedObjects = .t.
						This.CreateRelatedObjects(loObject)
					Endif
				EndIf

				If PemStatus(loObject, "AfterCreate", 5)
					loObject.AfterCreate() && A hook where you can do some last-minute stuff on the BO
				Endif
				
			Endif

			loReturn =  loObject

		Else

			loReturn = .Null.

		Endif
		
		If IsObject(loReturn)
			? "Created object: " + lcParentText + loReturn.Class
		Endif
			
		GotoRecord(lnRecno, lcTable) && Restore pointer, because some BOs created in the NewObject call, can created other objects, which can move the pointer here.

		Return loReturn
	
	EndProc


EndDefine
     