*=======================================================================================
*-- Note: wwBusinessProItemList is *NOT* based on West Wind wwBusinessChildCollection at all.
*-- It is a total re-write to include various features envisioned by
*-- the author (Matt Slay) to have an ItemList class that works intimately
*-- with a Parent record, and a local VFP cursor to allow editing of records in code or
*-- in UI controls which support cursors.
*=======================================================================================

* See wwBusinesPro.prg for full change log details.
* Version 5.2.1 2019-11-18 (No changes here)
* Version 5.2	2019-06-26
* Version 5.1	2019-03-05


Define Class wwBusinessProItemList as wwBusinessPro of wwBusinessPro.prg

	*---------------------------------------------------------------------------------------
	* Note: To add any Related Objects that you want to load from LoadFromCurrentRow()
	* add a property like this to you subclass of this class:
	* _Related_Customer = 'cust_id'
	*---------------------------------------------------------------------------------------

	* The foreign field name of the child cursor that relates to the Parent
	* PK. This is intended to be an Integer column.
	cFKField               = ''

	* Returns "Table.Field" string of the Child table and FK field on the
	* child table that matches up to the PK on the Parent. Only present if
	* integer keys are used between the Parent and Child.
	cFKRef                 = ''

	* (Optional) If this property is set, it will be used to index the
	* LineItems to specified order. If not specified, the indexing defaults
	* to the  cOrderBy field that is passed into the LoadLineItemsBase() method.
	cIndexExpression       = ''

	* (Optional) Set this class name to create an object reference to a
	* ItemsControl object that has methods to Add, Delete, Move, etc. line
	* items to this ItemList class.
	cLineItemsControlClass = ''

	* The alias name of the Parent table.
	cParentAlias           = ''
	cFkField             = ''

	* Return the string value of the KeyValue from the Parent BO.
	cParentKeyValue        = ''
	cParentKeyValueRef     = ''

	* Returns the field name of the KeyValue Lookup field (a string) on the Parent table.
	cParentLookupField     = ''
	cParentLookupRef       = ''

	* Returns the field name of the primary key field on the Parent table.
	cParentPKField         = ''

	* Returns "Table.Field" pointing to the Parent PK table and field.
	cParentPKRef           = ''

	* Returns the FK value of the current oData object (the current child
	* line item). This will represent the Parent PK value.
	FK                     = 0

	*-- Set by Dispose() method. You can use this in your classes to help get objects cleaned up in Destroy/Released
	*-- or when _Access method would want to return an object, but you don't want it to if you are Releasing the BO.
	lDisposeCalled = .f.

	* Set this property to .T. to use the oLineItems collection as the
	* Parent for this ItemList (rather than the main Parent BO). Allows
	* this ItemList to be a child to the oLineItems child collection,
	* essentially creating Part-Child-Grandchild structure.
	lLineItemsIsParent     = .F.

	* This flag determines if the rows in the results cursor will also be loaded into
	* the oRows collection. This is not necessary, unless you
	* want an object collection to work with in addition to the cursor that
	* is created. (Can be slow on large record sets.)
	lLoadItemsIntoCollection    = .F.

	* A property that can be used by the ChildManager class to skip over
	* this this BO from loading its child rows. You can always call the
	* LoadLineItems() method directly to bypass this flag.
	lLoadLineItems         = .T.

	* Return the integer PK value from the Parent BO.
	nParentPK              = ''

	* (See description of cLineItemsControlClass property for explanation).
	* This object will be created and assigned here when by CreateWWBO()
	oLineItemsControl      = .Null.

	* (Set internally) Gives a reference to the Parent BO that created this LineItems class.
	oParentBO              = .Null.
	

*|================================================================================ 
*| wwBusinessProItemList::
*| This is a method wrapper so that this child items class can call directly to
*| SaveBase(), and skips over the higher-level Save() method code of the wwBusinessPro class,
*| which would cause additional tracking and logic that does not apply to records in a
*| child item cursor.
	Procedure Save
	
		Return This.SaveBase()

	Endproc

*|================================================================================ 
*| wwBusinessProItemList::
Procedure cCursor_Assign(tcCursor)

	This.cCursor = tcCursor
	
	If IsObject(This.oLineItemsControl)
		This.oLineItemsControl.cChildAlias = tcCursor
		This.oLineItemsControl.SetDerivedProperties()
	Endif

Endproc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cFKRef_Access
	
		If Empty(This.cCursor) or Empty(This.cFKfield)
			This.cFKRef = ""
		Else
			This.cFKRef = Alltrim(This.cCursor) + '.' + Alltrim(This.cFKfield)
		Endif

		Return This.cFKRef
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cLineItemsControlClass_Assign(tcLineItemsControlClass)

		This.CreateLineItemsControlObject(tcLineItemsControlClass)
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentAlias_Access
		
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentAlias = This.oParentBO.cCursor
		Else
			This.cParentAlias = ''
		Endif

		Return This.cParentAlias
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentKeyValueRef_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentKeyValueRef = Alltrim(This.oParentBO.cCursor) + '.' + Alltrim(This.oParentBO.cLookupField)
		Else
			This.cParentKeyValueRef = ''
		Endif

		Return This.cParentKeyValueRef
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentKeyValue_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentKeyValue = This.oParentBO.KeyValue
		Else
			This.cParentKeyValue = ''
		Endif

		Return This.cParentKeyValue
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentLookupField_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentLookupField = This.oParentBO.cLookupField
		Else
			This.cParentLookupField = ''
		Endif

		Return This.cParentLookupField
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentLookupRef_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentLookupRef = This.cParentAlias + '.' + This.cParentLookupField
		Else
			This.cParentLookupRef = ''
		Endif

		Return This.cParentLookupRef
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentPKField_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentPKField = This.oParentBO.cPKField
		Else
			This.cParentPKField = ''
		Endif

		Return This.cParentPKField
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure cParentPKRef_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.cParentPKRef = Alltrim(This.oParentBO.cCursor) + '.' + Alltrim(This.oParentBO.cPKfield)
		Else
			This.cParentPKRef = ''
		Endif

		Return This.cParentPkRef
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure CreateLineItemsControlObject(tcLineItemsControlClass)
	
		Local llReturn
		
		If !Empty(tcLineItemsControlClass)

			This.cLineItemsControlClass = tcLineItemsControlClass
			This.oLineItemsControl = .Null.

			Try
				This.oLineItemsControl = CreateObject(tcLineItemsControlClass, This) && Notice that we pass in a reference to this ChildBO

				This.oLineItemsControl.lAssignPK = This.lPreassignPK		&& Determines if PKs are assigned from the cIdTable table when the record
																			&& Record is added to the local cursor when NewItem() is called.
																			&& If PK is not set in NewItem(), it will be added in the Save() method
																			&& as long as cIdTable property specifies the name of the wws_id table
																			&& which tracks and assigns the next PK for each table it manages.
				llReturn = .t.
			Catch
				This.SetError('Error creating Line Items Control class [' + tcLineItemsControlClass + ']')
				llReturn = .f.
			EndTry

		EndIf
		
		If IsObject(This.oLineItemsControl)
			This.SetupItemsControl()
		Endif

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
*| Deletes the current row from the cCursor
*| Note: Does not presently remove the object from oRows collection, if used.
	Procedure DeleteItem
	
		If !Used(This.cCursor)
			This.SetError(StringFormat('Cursor [{0}] is not present.', This.cCursor))
			Return .f.
		Endif
		
		Try
			This.oLineItemsControl.DeleteItem()
		Catch
			This.SetError('Error calling [This.oLineItemsControl.DeleteItem()].')
		Finally
		EndTry
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure FK_Access
	
		Local lcFKRef, luReturn

		If Type("This.oData." + This.cFKField) != "U"
			luReturn = GetPem(This.oData, This.cFKField)
		Else
			luReturn = .null.
		Endif

		Return luReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetChildWhereClause(tlGetParentValueFromParentCursor)

		*-- If tlGetParentValueFromParentCursor is .t., Parent value will come from the local parent cursor,
		*-- otherwise Parent value will come from This.oParentBO.
		*-- Examples of the 2 possible cases:
		*--   Parent PK is coming from Parent BO oData:  ChildFKField = [ParentPK or ParentKeyValue] from Parent.oData
		*--   Parent PK is coming from a cursor of Parent records:  ChildFKField = [ParentPKField or ParentKeyValueField] from Parent Cursor
		Local lcChildFKDataType, lcWhereClause, luParentValue

		lcChildFKDataType = This.GetFKDataType()

		This.cMatchField = Evl(This.cMatchField, This.cFKField)

		luParentValue = This.GetParentValue(tlGetParentValueFromParentCursor)

		Do Case

			Case lcChildFKDataType = 'N'
				lcWhereClause = This.cMatchField + ' = '  + Transform(luParentValue)

			Case lcChildFKDataType = 'C'

				lcWhereClause = This.cMatchField + [ == '] + luParentValue + [']

			Otherwise
				lcWhereClause = ''

		EndCase
		

		Return lcWhereClause
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetChildWhereClauseFromParentBO
	
		Local lcChildFKDataType, lcWhereClause

		*-- The string returned here is for use in the Where clause of a SQL Select statement.
		*-- It would fetch all child records relative to the parent PK/Lookup field.

		lcWhereClause = This.GetChildWhereClause() && Parent Values comes from Parent BO

		Return lcWhereClause
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetChildWhereClauseFromParentCursor
	
		Local lcWhereClause

		*-- Parent value will come from local cursor of parent records

		lcWhereClause = This.GetChildWhereClause(.t.) && Parent value comes from current row in Parent cursor

		Return lcWhereClause
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetFKDataType
		
		Local luValue
			
		If !IsNull(This.oData) and !Empty(This.cFKField)
			luValue = GetPem(This.oData, This.cFKField)
			Return Vartype(luValue)
		Else
			Return 'U'
		EndIf
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	*-- Return a string showing "ChildCursor.cFKField = ParentCursor.[PKField | LookupField]"
	*-- This shows how the Child cursor relates to the parent table.
	Procedure GetParentChildRelationship

		Local lcChildFKDataType, lcParentChildRelationship

		lcChildFKDataType = This.GetFKDataType()
		lcParentChildRelationship = ''

		Do Case

			Case lcChildFKDataType == 'N'
				If !Empty(This.cParentPKRef)
					lcParentChildRelationship = This.cFKRef + ' = ' + This.cParentPKRef
				Endif

			Case lcChildFKDataType  == 'C'
				If !Empty(This.cParentLookupRef)
					lcParentChildRelationship = This.cFKRef + ' = ' + This.cParentLookupRef
				Endif

		Endcase

		Return lcParentChildRelationship
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetParentValue(tlGetParentValueFromParentCursor)

		Local lcChildFKDataType, luParentValue

		lcChildFKDataType = This.GetFKDataType()

		Do Case

			Case lcChildFKDataType = 'N'
				If IsNullOrEmpty(This.oParentBO)
					Return 0
				Endif
				If tlGetParentValueFromParentCursor
					luParentValue = Evaluate(This.cParentPKRef)
				Else
					luParentValue = This.oParentBO.PK
				Endif

			Case lcChildFKDataType = 'C'
				If IsNullOrEmpty(This.oParentBO)
					Return ''
				Endif
				If tlGetParentValueFromParentCursor
					luParentValue = Evaluate(This.cParentKeyValueRef)
				Else
					luParentValue = This.oParentBO.KeyValue
				Endif

			Otherwise
				luParentValue = ''

		Endcase

		Return luParentValue
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetParentValueFromParentBO
	
		Return This.GetParentValue()
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetParentValueFromParentCursor
	
		Return This.GetParentValue(.t.)
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure LoadLineItems(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, tlCloseCursor, tcSql)

		Local lnReturn

		lnReturn = This.LoadLineItemsBase(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, tlCloseCursor, tcSql)

		Return lnReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure LoadLineItemsBase(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, tlCloseCursor, tcSql)

		*-- Notes:
		*-- 1. You can create a ReadWrite cursor with tlReadWrite and that cursor can be then modified,
		*--    then pulled back into this ItemList object with LoadFromCursor() and then saved back to disk with SaveToCursor().
		*--    This should make it pretty much like working with the tcCursor like any free table.
		*-- 2. You can pass in a SQL string to use, or we'll build a default one here from the passed params

		Local lcSql, llSqlCommandReady, lnReturn, lnSelect

		lnSelect = Select()
		
		*-- This Sql command is good for both DBF mode and Sql Server mode
		*-- (The PrepareSqlCommandParts() call above will make sure cIntoCursor and cReadWrite will be empty for SqlServer mode)
		If IsString(tcSql) Or (IsString(tuParentKeyOrRef) And Upper(Left(tuParentKeyOrRef, 6)) == 'SELECT')  && If SQL command was passed in...(Check 2 ways)

			lcSql = Iif(IsString(tcSql), tcSql, tuParentKeyOrRef)

		Else && Send the passed params to a setup method so that the needed classes properties will be populated, and we can use them in our Sql
	
			llSqlCommandReady = This.PrepareSqlCommandParts(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, tlCloseCursor)
			This.cCursor = Evl(tcCursor, This.cCursor)

			If !llSqlCommandReady
				This.Clear()
				Return -1
			Else
				lcSql = This.cSql
			Endif
		EndIf
		
		lcCursor = Evl(tcCursor, This.cCursor)

		If IsObject(This.oSql)
			This.oSql.cSkipFieldsForUpdates = This.cSkipFieldsForUpdates
		Endif

		If Used(This.cSqlCursor)
			Use in (This.cSqlCursor)
		Endif

		lnReturn = This.Query(lcSql, lcCursor, .f., This.cOrderByFieldList)
		
		This.AfterLoadLineItems(lnReturn)

		Select (lnSelect)

		Return lnReturn
		
	EndProc
	
*|================================================================================ 
*| wwBusinessProItemList::
*| Moves pointer to first row in This.cCursor and 
*| loads oData object by calling LoadFromCurrentRow() to sync up with first row in cursor, which
*| also causes it to load any Related Objects that are defined on this class.	
	Procedure AfterLoadLineItems(tnReturn, tcCursor)
	
		Local lcCursor

		This.lHasDataChanged = .f.
		lcCursor = Evl(tcCursor, This.cCursor)
		
		If tnReturn >= 0

			If This.lLoadItemsIntoCollection
				This.LoadFromCursor()
			Endif

			If Used(lcCursor)
				Goto Top In (lcCursor)
			EndIf
			
			This.LoadFromCurrentRow() && Also triggers the Update() method.
			
		Else
			This.Clear()
		EndIf
		
	Endproc


*|================================================================================ 
*| wwBusinessProItemList::
*| This method uses the Parent PK to call LoadLineItems which will load all the Child cursors with 
*| the related child records.
	Procedure LoadLineItemsFromParentKey()
	
		Local lcChildFKDataType, lnReturn, luParentIdOrKey

		lcChildFKDataType = This.GetFKDataType()

		Do Case

			Case lcChildFKDataType = 'N'
				luParentIdOrKey = This.nParentPK

			Case lcChildFKDataType = 'C'
				luParentIdOrKey = This.cParentKeyValue

			Otherwise
				*-- Note, usually a cFkField is used to load children from Parent PK, however,
				*-- in some cases, LoadLineItems may be overridden with some other criteria, so we're
				*-- going to pass in Parent PK value, and let the developer have there way if no cFkField is specified.
				luParentIdOrKey = This.nParentPK
				*This.Seterror('cFKField is not configured correctly on Child BO.')
				*Return - 1

		Endcase

		lnReturn = This.LoadLineItems(luParentIdOrKey, '', '', '', This.cCursor, This.lReadWrite)

		Return lnReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure MoveItem(lnSkipCount)

		If !Used(This.cCursor)
			This.SetError(StringFormat('Cursor [{0}] is not present.', This.cCursor))
			Return .f.
		Endif

		Try
			This.oLineItemsControl.MoveItem(lnSkipCount)
		Catch
			This.SetError('Error calling [This.oLineItemsControl.MoveItem()]')
		Finally
		EndTry
		
	EndProc
	

*|================================================================================ 
*| wwBusinessProItemList::
	Procedure GetNextItemOrder()

		Local lnReturn
		
		lnReturn = 0
		
		If !Used(This.cCursor)
			This.SetError(StringFormat('Cursor [{0}] is not present.', This.cCursor))
			Return .f.
		Endif

		Try
			lnReturn = This.oLineItemsControl.GetNextItemOrder()
		Catch
			This.SetError('Error calling [This.oLineItemsControl.GetNextItemOrder()]')
		Finally
		EndTry
		
		Return lnReturn

	EndProc	


*|================================================================================ 
*| wwBusinessProItemList::
	*-- This method is a wrapper around the NewItem() method on the oLineItemsController. 
	*-- When calling oLineItemsController.NewItem(), it may pre-assign PK to the new record
	*-- based on cIdTable and lPreassignPK property.
	Procedure NewItem
	
		Local llReturn, llShouldHaveIdAssigned, lcMessage
		
		llReturn = .t.
		
		If !Used(This.cCursor)
			This.LoadLineItemsFromParentKey() && Try calling this to create the item list cursor.
		Endif

		If !Used(This.cCursor)
			This.SetError(StringFormat('Cursor [{0}] is not present.', This.cCursor))
			Return .f.
		Endif

		Try
			llReturn = This.oLineItemsControl.NewItem()
		Catch to oEx
			lcMessage = "Proc:" + oEx.Procedure + "  Message: " + oEx.Message
			This.SetError('Error in call to [This.oLineItemsControl.NewItem()]. ' + lcMessage)
			
			llReturn = .f.
		Finally
		Endtry

		*-- A PK should be assigned if:
		*  cIdTable is specified
		*  lPreassignPK is set true
		llShouldHaveIdAssigned = !Empty(This.cIdTable) and This.lPreassignPK

		*-- Make sure new BO has a PK value assigned, if it is supposed to be pre-assigng one.
		If llShouldHaveIdAssigned and Empty(This.PK)
				This.SetError('PK value should ne assigned for new record, but it is empty!!')
				llReturn = .f.
		EndIf

		Return llReturn

	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure nParentPK_Access
	
		If IsObject(This.oParentBO) and !IsNull(This.oParentBO)
			This.nParentPK = This.oParentBO.PK
		Else
			This.nParentPK = 0
		Endif

		Return This.nParentPK
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure oParentBO_Assign(toParentBO)
	
		If IsObject(toParentBO)
			This.oParentBO = toParentBO
			This.cParentAlias = toParentBO.cCursor
			This.cParentPKField = toParentBO.cPkField
			This.cParentLookupField = toParentBO.cLookupField
		Else
			This.oParentBO = .null.
			This.cParentAlias = ""
			This.cParentPKField = ""
			This.cParentLookupField = ""
		Endif
		
		This.SetupItemsControl()
	
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure PrepareSqlCommandParts(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, ltcloseCursor)
	
		Local llReturn

		llReturn = DoDefault(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, ltcloseCursor)

		*-- The DoDefault() code from parent class is geared to Parent BO's, and most all of it is good for this child class too,
		*-- however, we do need to override the cMatchField and cWhereClause to properly handle child recordsets relative to parent.

		If IsNull(This.oData)
			Return
		Endif
		
		This.cMatchField = Alltrim(Evl(tcMatchField, This.cFKField))
		lcMatchFieldDataType = Type('This.oData.' + This.cMatchField)
		
		*-- Ensure that Parent.FK data type matches Child.FK data type, but test this data type between
		*-- parent and child match up. Parent value could be null, which does not necessarily indicate an error condition.
		If lcMatchFieldDataType $ "CN" and VarType(tuParentKeyOrRef) != lcMatchFieldDataType
			This.SetError('Data type mismatch on passed lookup value in BO class: ' + This.Name)
			Return .f.
		Endif
		
		lcParentKeyOrRefDataType = VarType(tuParentKeyOrRef)
		
		Do Case

			Case lcParentKeyOrRefDataType = 'N'
				This.cWhereClause = This.cMatchField + ' = '  + Transform(tuParentKeyOrRef)

			Case lcParentKeyOrRefDataType = 'C'
				This.cWhereClause = This.cMatchField + [ == '] + Alltrim(tuParentKeyOrRef) + [']

			Otherwise
				This.cWhereClause = '0 = 1'

		EndCase

		This.cWhereClause = This.FixSql(This.cWhereClause, .t.)

		This.PrepareSqlCommand()

		If Empty(This.cMatchField)
			This.SetError('Property [cMatchField] evaluates to an empty string on ItemList object named: ' + This.Name)
		Endif

		If Empty(This.cWhereClause)
			This.SetError('Property [cWhereClause] evaluates to an empty string on ItemList object named: ' + This.Name)
		Endif

		Return llReturn
		
	EndProc

*|================================================================================ 
*| wwBusinessProItemList::
	Procedure Renumber
	
		If !Used(This.cCursor)
			This.SetError(StringFormat('Cursor [{0}] is not present.', This.cCursor))
			Return .f.
		Endif

		Try
			This.oLineItemsControl.Renumber()
		Catch
			This.SetError('Error calling [This.oLineItemsControl.Renumber()].')
		Finally
		EndTry
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure SetupItemsControl
	
		If IsObject(This.oLineItemsControl)

			This.oLineItemsControl.oParentBO = This.oParentBO
			This.oLineItemsControl.oChildBO = This
			This.oLineItemsControl.SetDerivedProperties()

*!*				With This.oLineItemsControl

*!*					.oChildBO = This
*!*					.cChildAlias = This.cCursor
*!*					.cChildPKField = This.cPKfield
*!*					*.cChildLookupField = this.cLookupField   && Not used!!!
*!*					.cChildFKField = This.cFkField
*!*					.cChildOrderField = This.cOrderByFieldList

*!*					.cParentAlias = This.cParentAlias
*!*					.cParentPKField = This.cParentPKField
*!*					.cParentLookupField = This.cParentLookupField

*!*					.SetDerivedProperties()

*!*				Endwith

		EndIf
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemList::
	Procedure ValidateProperties
	
		Local llReturn

		llReturn = .t.

		llReturn = DoDefault()

		If Empty(This.cCursor)
			This.SetError('Property [.cCursor] is empty.  Object: ' + This.Name)
			llReturn = .F.
		EndIf

		Return llReturn
		
	EndProc

*|================================================================================ 
*| wwBusinessPro::
	Procedure lHasDataChanged_Access()
	
		Return This.lHasDataChanged
	
	EndProc
	
EndDefine     