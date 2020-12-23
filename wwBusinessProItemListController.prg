Define Class wwBusinessProItemListController as Custom

	* The table alias that contains record to be re-arranged.
	cChildAlias                     = ''
	cChildFK                        = '(Set by this class in SetDerivedProperties method)'
	cChildFKField                   = ''
	cChildLookup                    = '(Set by this class in SetDerivedProperties method)'
	* (Optional) - This is a string-based FK field that maps back to the cLookupField of the parent.
	cChildLookupField               = ''
	cChildOrder                     = '(Set by this class in SetDerivedProperties method)'
	* The field name that contains the sequence or order number.
	cChildOrderField                = ''
	cChildPK                        = '(Set by this class in SetDerivedProperties method)'
	cChildPKField                   = 'id'  && Default is "id". Change if your DB uses a diff field name for Primary Key
	* An expression to be evaluated for display to the user to show info
	* about the current line item. Used  when  asking for a delete
	* confirmation. This should be a string expression with table.field
	* references as needed.
	cHintString                     = ''
	* You can set this on each subclass, but the intended approach is that
	* you assign this.oParentBO to the Parent Object, and this object will
	* read the cParentAlias from the BO.
	cParentAlias                    = ''
	cParentChildRelationship        = '(Set by this class in SetDerivedProperties method)'
	cParentLookup                   = ''
	cParentLookupField              = ''
	cParentPK                       = '(Set by this class in SetDerivedProperties method)'
	* You can set this on each subclass, but the intended approach is that
	* you assign this.oParentBO to the Parent Object, and this object will
	* read the cParentPKField from the BO.
	cParentPKField                  = 'id'  && Default is "id". Change if your DB uses a diff field name for Primary Key
	* This property will tell the class to assign a PK to each new child
	* record that is created.
	lAssignPK                       = .F.
	* A flag to indicate if the user must confirm the delete record action.
	* Will pop up a dialog box showing the result of the cHintString
	* property to show user which record is about to be deleted.
	lConfirmDeleteRequired          = .F.
	* A flag to indicate if the user elected to delete the record (when and
	* itemDelete method was fired).
	lDeleteConfirmed                = .F.
	* Set this value to .T. if you want the ItemAdd() method to use the
	* PK/KeyValue from the current row in the Parent Cursor, or .F. if you
	* want to use the Parent PK/KeyValue from the oParentBO.
	lGetParentValueFromParentCursor = .F.
	* A flag to indicate if the this class should move the child record
	* pointer to the next adjacent record after a record has been deleted.
	* Used in the itemDelete() method.
	lMoveChildPointerAfterDelete    = .T.
	* Determines if a PK values will be assigned from cIdTable immediately
	* when a record is added to the local child cursor. Otherwise, it will
	* be added during the Save method.
	lPreassignPK                    = .F.
	* A flag set by the SetDerivedProperties() method to indicate if all
	* the required fields relating to the Parent, Child, Order, PK, FK,
	* etc. are present. All must be present before this control can work
	* properly.
	lReady                          = .F.
	* The increment amount to be used on the order field when new records
	* are added.
	nOrderIncrement                 = 1
	oChildBO                        = .null.
	oParentBO                       = .null.
	oPreviousRow					= .null.

*|================================================================================ 
*| wwBusinessProItemController::
	Procedure AssignPK
		Local lcAlias, lcPKField, lnNewPK

		lcPKField = This.cChildPKField
		lcAlias = This.cChildAlias

		lnNewPK = This.oChildBO.CreateNewID()

		Replace (lcPKField) With lnNewPK In (lcAlias) && Assigns a PK to the current row from the cIdTable.
		AddProperty(This.oChildBO.oData, lcPKField, lnNewPK) && Need to keep oData in sync too

		Return (lnNewPK > 0)
	EndProc



*|================================================================================ 
*| wwBusinessProItemController::
	*------------------------------------------------------------------------------------------------------
	* Returns the maximum sequence or order number used on the passed table and field pair.
	* Example: pass in the Parent PK or the Child FK, since they are the same value
	*------------------------------------------------------------------------------------------------------
 	Procedure GetMaxItemOrder
 	
		Local laMaxSeq[1], lcChildAlias, lcChildOrderField, lcCriteria
		
		If Empty(This.cChildOrderField)
			Return 0
		Endif

		lcChildOrderField = This.cChildOrderField
		lcChildAlias = This.cChildAlias
		lcCriteria = Evl(This.GetParentChildMatchCriteria(), '.t.')
		
		If !Empty(lcCriteria)
			lcCriteria = 'Where ' + lcCriteria
		Endif

		  Select Max(&lcChildOrderField) As MaxSeq ;
		      From (lcChildAlias) ;
		      &lcCriteria ;
		      Into Array laMaxSeq

		Return Nvl(laMaxSeq, 0)
		
	EndProc
 

*|================================================================================ 
*| wwBusinessProItemController::
	*-- This method will return the next item number to be used when adding a new child record.
	Procedure GetNextItemOrder

		Local lnMaxItemOrder, lnNextItemOrder

		 lnMaxItemOrder = This.GetMaxItemOrder()

		 If lnMaxItemOrder >= 0  && Above will return -1 if something was wrong
		  lnNextItemOrder = lnMaxItemOrder + This.nOrderIncrement
		 Else
		  lnNextItemOrder = lnMaxItemOrder
		 Endif

		 Return lnNextItemOrder
		 
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	*-- Returns a string that can be evaled to see the Child FK Field and the value from either
	*-- the ParentBO or Parent Cursor, based on class property lGetParentValueFromParentCursor.
	*-- Returns a string like:  "ParentId = 1234"  or "ParentId = '1234'"
	*-- You will need to add the cursor name of the child cursor to the beginning, as this method only returns the child fk field name.
	Procedure GetParentChildMatchCriteria

		Local lcCriteria

		If This.lGetParentValueFromParentCursor
			lcCriteria = This.oChildBO.GetChildWhereClauseFromParentCursor()
		Else
			If IsObject(This.oChildBO) and IsObject(This.oParentBO)
				lcCriteria = This.oChildBO.GetChildWhereClauseFromParentBO()
			Else
				lcCriteria = ''
			Endif
		Endif

		Return lcCriteria
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure GetParentValue
		Local luParentValue

		If This.lGetParentValueFromParentCursor
			luParentValue = This.oChildBO.GetParentValueFromParentCursor()
		Else
			luParentValue = This.oChildBO.GetParentValueFromParentBO()
		Endif

		Return luParentValue
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure Init(toChildBO)

		Local lcErrorMessage, llSilent

		If IsObject(toChildBO)
			This.oChildBO = toChildBO
		Endif

		This.oPreviousRow = CreateObject('Empty')
		
		llSilent = Pcount() > 0 && Will suppress "cHintString missing" message if params were passed in

		This.SetDerivedProperties()

		*-- If user must confirm deletes, then developer must populate the cHintString property!
		If This.lConfirmDeleteRequired And Empty(This.cHintString) And llSilent = .F.
			lcErrorMessage = 'PCControl [' + This.Name + '] needs cHintString reference. Notify programmer.'
			This.oChildBO.SetError(lcErrorMessage)
			Messagebox(lcErrorMessage, 0, 'Notice:')
		Endif

		DoDefault()
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure NewItem

		Local llChildFKFieldError, llChildOrderFieldError, lnNextItemOrder, lnSelect
		Local luParentValue, lcFilter, llAssignPkError, llPkAssigned

		lnSelect = Select()

		luParentValue = This.oChildBO.GetParentValue(This.lGetParentValueFromParentCursor)

		Select(This.oChildBO.cCursor)
		lcFilter = Set('Filter') && Current child cursor may be filtered. Need to clear this for now, then restore it at the end.

		Set Filter to
		
		*-- Store a copy of the current row to This.oPreviousRow
		Scatter Name This.oPreviousRow Memo Additive

		Append Blank
		
		This.oChildBO.LoadFromCurrentRow() && This will get us a fresh oData object.

		*-- Assign the record order value (if used on this BO) ------------------------------
		If !Empty(This.oChildBO.cOrderByFieldList)
			lnNextItemOrder = This.GetNextItemOrder()
			Try
				*-- This is just setting a value on the oData object.
				AddProperty(This.oChildBO.oData, This.oChildBO.cOrderByFieldList, lnNextItemOrder)
			Catch
				This.oChildBO.SetError('Error Setting value on field [' + This.oChildBO.cOrderByFieldList + '] in cursor ' + Alias())
				llChildOrderFieldError = .t.
			EndTry
		EndIf
		
		*-- Assign the FK value on the child BO record order value (if used on this BO) ------------------------------
		If !Empty(This.oChildBO.cFKField)
			Try
				AddProperty(This.oChildBO.oData, This.oChildBO.cFKField, luParentValue)
			Catch
				This.oChildBO.SetError('Error setting value on field [' + This.oChildBO.cFKField + ']  in cursor ' + Alias())
				llChildFKFieldError = .t.
			EndTry
		Endif

		*-- Assign the PK value (if This.lAssignPK is set to true) -------------------------------
		If This.lAssignPK
			llPkAssigned = This.AssignPK()
			If !llPkAssigned
				llAssignPkError = .t.
			Endif
		Endif

		*-- At this point, there are two hook calls that will be made which provide opportunities to prepare the new
		*-- oData object...
		*--   1. This.AfterNewItem() (could exist as an override method on the concrete class)
		*--   2. This.oChildBO.SetDefaultsForNewRecord()

		llAfterNewItemResult = This.AfterNewItem() && See note above

		This.oChildBO.SetDefaultsForNewRecord() && See note above

		*-- Now we scatter oData to the new cursor row.
		*-- (All calls in 1 and 2 above should only touch oData, and not the cursor because any cursor
		*-- changes would be overridden by this scatter from oData.)
		This.oChildBO.SaveToCurrentRow()
		
		Set Filter To &lcFilter In (This.oChildBO.cCursor)

		Select (lnSelect)

		If llChildFKFieldError Or llChildOrderFieldError or !llAfterNewItemResult Or llAssignPkError
			Return .f.
		Else
			Return .t.
		EndIf
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure AfterNewItem

	EndProc


	*|================================================================================
	*| wwBusinessProItemController::
	*-- Note: All Parent/Child/FK/PK/Order properties must be set on this object to make it work.
	Procedure DeleteItem

		*-- wwToDo 2009-08-23: Add a test here on this.lReady and abort if this control is not setup properly

		*-- Ask user to confirm delete action -----------------------
		If This.lConfirmDeleteRequired = .T.
			If !Empty(This.cHintString) And Vartype(Evaluate(This.cHintString)) = 'C'
				lcHintString = Evaluate(This.cHintString)
				lcHintString = Iif(Empty(lcHintString), 'Blank Item', lcHintString)
				lnConfirmDelete = Messagebox(lcHintString + Chr(13) + Chr(13), 4, 'Delete this item?')
			Else
				lnConfirmDelete = Messagebox('Cannot create Delete request. cHinstring setting required in DeleteItem()method. Notify programmer. ', 16, 'Error in method DeleteItem():')
			Endif
		Endif

		*-- Delete record and update table -------------------------------------
		If !This.lConfirmDeleteRequired Or lnConfirmDelete = 6
			This.lDeleteConfirmed = .T.
			lnDeletedItemOrder = .null.
			
			If !Empty(This.cChildOrder)
				lnDeletedItemOrder = Evaluate(This.cChildOrder) && Capture now, use in MoveChildPointer() method
			EndIf
			
			Delete Next 1 In (This.cChildAlias)
			
			If This.lMoveChildPointerAfterDelete and !IsNull(lnDeletedItemOrder)
				This.MoveChildPointer(lnDeletedItemOrder)
			Else
				This.lDeleteConfirmed = .F. && Will indicate Indicates if the user confirmed the Delete
			EndIf
		Endif

		Return This.lDeleteConfirmed

	Endproc


*|================================================================================ 
*| wwBusinessProItemController.MoveItem(lnSkipCount)
*|================================================================================ 
*-- Moves the current record in cursor up or down by passing a positive or negative number.
*-- Amount to move can be more than 1 if needed, but this is unlikely.
*---------------------------------------------------------------------------------------
* lnSkipCount:   -1 for Move Up
*		 	     +1 for Move Down
*---------------------------------------------------------------------------------------
	Procedure MoveItem(lnSkipCount)

		Local lcWatchOut, lcMatchCriteria, lcField , ln1, ln2, lnRecno, lnSelect

		lnSelect = Select()
		lcWatchOut = Iif(lnSkipCount = -1, 'bof()', 'eof()') && direction to watch out for
		lcMatchCriteria = Evl(This.GetParentChildMatchCriteria(), ".t.")

		Select(This.cChildAlias)
		lcField = GetWordNum(lcMatchCriteria, 1)

		If Vartype(Evaluate(lcField)) = 'C'
			lcMatchCriteria = StrTran(lcMatchCriteria, lcField, 'Alltrim(' + lcField + ')')
		Endif

		lnRecno = Recno()

		ln1 = Evaluate(This.cChildOrder)
		
		If Not &lcWatchOut
			Skip lnSkipCount
			If &lcMatchCriteria and !Eof() and !Bof()
				ln2 = Evaluate(This.cChildOrder)
				Replace (This.cChildOrderField) With ln1
				GotoRecord(lnRecno)
				Replace (This.cChildOrderField) With ln2
			Endif
		Endif

		Goto Recno() && A trick to make everything freshen up
		Scatter Name This.oChildBO.oData Fields (This.cChildOrderField) Additive && Need to keep oData in sync too

		Select (lnSelect)
		
	EndProc

*|================================================================================ 
*| wwBusinessProItemController::
	*-- This method is intended to be used to move the child table pointer after a record has been deleted
	*-- from it. It attempts to move to the next child record based on the ChildOrderField. If there
	*-- is not a next one, then it looks for the one right before the one that was deleted..
	*--
	*-- Parameters:
	*--  tnOrder  - Pass in the order number that was deleted.
	Procedure MoveChildPointer(tnOrder)

		Local lcChildAlias, lcChildOrderField, lcLocateDown, lcLocateUp, lcParentChildMatchCriteria, lcSql
		Local lnRecno
		Local laRecno[1]

		If This.lReady

			lcChildAlias = This.cChildAlias
			lcChildOrderField = This.cChildOrderField
			*lcLocateDown = This.cParentChildRelationship + ' And ' + This.cChildOrder + '>' + Alltrim(Str(tnOrder))
			lcParentChildMatchCriteria = Evl(This.oChildBO.oLineItemsControl.GetParentChildMatchCriteria(), ".t.")
			lcLocateDown = lcParentChildMatchCriteria  + ' And ' + This.cChildOrder + ' > ' + Alltrim(Str(tnOrder))
			
			lcLocateUp = Strtran(lcLocateDown, '>', '<')

			*-- Pull line items that are AFTER this one ---
			Select Recno() As Recno ;
				From (lcChildAlias) ;
				Where &lcLocateDown ;
				Order By &lcChildOrderField ;
				Into Array laRecno


			*-- If none found, then pull line items BEFORE this one ---
			If _Tally = 0
			
				Select Recno() As Recno ;
						From (lcChildAlias) ;
						Where &lcLocateUp ;
						Order By &lcChildOrderField Desc ;
						Into Array laRecno
			EndIf
			
			*-- If we got some records from either of the above, then GOTO the first record in the set,
			*-- otherwise, we just won't move the pointer at all
			If _Tally > 0
				lnRecno = laRecno[1]
				GotoRecord(lnRecno, lcChildAlias)
			Endif

		EndIf
	
	Endproc


*|================================================================================ 
*| wwBusinessProItemController::
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
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure oChildBO_Assign(toChildBO)

		If IsObject(toChildBO)
			This.oChildBO = toChildBO
			This.cChildAlias = Alltrim(toChildBO.cCursor)
			This.cChildPKField = Alltrim(toChildBO.cPkField)
			This.cChildFKField = Alltrim(toChildBO.cFkField)
			This.cChildOrderField = Alltrim(toChildBO.cOrderByFieldList)
		Else
			This.oChildBO = .null.
			This.cChildAlias = ""
			This.cChildPKField = ""
			This.cChildFKField = ""
			This.cChildOrderField = ""
		Endif
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure oParentBO_Access
	
		Return This.oChildBO.oParentBO
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	Procedure Renumber
	
		Local laTemp[1], lcChildAlias, lcChildOrderField, lcChildPkField, lcCriteria, lnRecno
		Local lnSelect, lnX

		If Empty(This.cChildOrderField)
			Return
		Endif
		
		lnSelect = Select()
		lnRecno = Recno()
		
		lcChildOrderField = This.cChildOrderField
		lcChildPkField = This.cChildPKField
		lcChildAlias = This.cChildAlias
		lcCriteria = Evl(This.GetParentChildMatchCriteria(), '.t.')
		
		Select Recno() From (lcChildAlias) Where &lcCriteria Order By &lcChildOrderField Into Array laTemp
		
		If _Tally = 0
			Return
		EndIf
	
		Select(lcChildAlias)
		
		For lnX = 1 to Alen(laTemp)
			Replace &lcChildOrderField With	lnX * This.nOrderIncrement For Recno() = laTemp[lnX] in (lcChildAlias)
		Endfor

		GotoRecord(lnRecno, lcChildAlias)

		Scatter Name This.oChildBO.oData Fields &lcChildOrderField Additive && Need to update oData with new value

		Select(lnSelect)
		
	EndProc


*|================================================================================ 
*| wwBusinessProItemController::
	*==========================================================================================
	*-- This will initialize the derived properties of this class.
	*-- It will test for blanks and only fill the ones for which all the required data is present.
	*-- Finally, will set a flag to indicate if everything is ready to go. 
	*-- Nothing can be missing or it won't work and will set the lReady flag to .F.
	*------------------------------------------------------------------------------------------------------------
	Procedure SetDerivedProperties

		*-- Note: cChildLookupField and cParentLookupField are optional, so process them, but do not complain if not present.
		*-- These properties need to be set by the developer at Init() or in property values of the class or subclass.

		Local lcChildAlias, lcChildFKField, lcChildOrderField, lcChildPKField, lcParentAlias
		Local lcParentChildMatchCriteria, lcParentLookupField, lcParentPKField
		Local lcParentChildMatchCriteria 

		If Empty(This.cChildAlias) and IsObject(This.oChildBO)
			This.cChildAlias = This.oChildBO.cCursor
		EndIf
		
		lcChildAlias = Alltrim(This.cChildAlias)
		lcChildPKField = Alltrim(This.cChildPKField)
		lcChildFKField = Alltrim(This.cChildFKField)
		lcChildOrderField = Alltrim(This.cChildOrderField)

		lcParentAlias = Alltrim(This.cParentAlias)
		lcParentPKField = Alltrim(This.cParentPKField)
		lcParentLookupField = Alltrim(This.cParentLookupField)

		*-- These next properties are derived from the above.
		*-- We'll work through them, but some may come out blank if 
		*-- the required dependency properties are not initialized.

		*-- Set cChildPK Property:  Primary Key of child alias
		If !Empty(lcChildAlias) And !Empty(lcChildPKField)
			This.cChildPK = lcChildAlias + '.' + lcChildPKField
		Else
			This.cChildPK = ''
		Endif

		*-- Set cChildFK Property:  Foreign Key of child alias
		If !Empty(lcChildAlias) And !Empty(lcChildFKField)
			This.cChildFK = lcChildAlias + '.' + lcChildFKField
		Else
			This.cChildFK = ''
		Endif

		*-- Set cChildOrder Property:  The ordering field of the child alias
		If !Empty(lcChildAlias) And !Empty(lcChildOrderField)
			This.cChildOrder = lcChildAlias + '.' + lcChildOrderField
		Else
			This.cChildOrder = ''
		Endif

		*-- Set cParentPK Property:  Primary Key of parent table
		If !Empty(lcParentAlias) And !Empty(lcParentPKField)
			This.cParentPK = lcParentAlias + '.' + lcParentPKField
		Else
			This.cParentPK = ''
		Endif

		*-- Set cParentLookup Property: (Optional) A string-based unique Key field on the parent table
		If !Empty(lcParentAlias) And !Empty(lcParentLookupField)
			This.cParentLookup = lcParentAlias + '.' + lcParentLookupField
		Else
			This.cParentLookup = ''
		Endif

		*-- Set cParentChildRelationship Property
		lcParentChildMatchCriteria = This.GetParentChildMatchCriteria()
		
		If !Empty(lcParentChildMatchCriteria)
			This.cParentChildRelationship = lcChildAlias + '.' + lcParentChildMatchCriteria && Ex: ChildCursor.ChildFKField = [ParentPK or ParentKeyValue]
		Else
			This.cParentChildRelationship = ''
		Endif
		
		This.lReady = .t.
		
	EndProc


EndDefine
   