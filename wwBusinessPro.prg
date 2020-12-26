* Version 5.4.0         2020-12-26  1. CalculateValue() method: Added (With Buffering = .t.) expression so it will correctly
*                                      calculate values from local cached values in the cursor.
*
* Version 5.3.1         2020-12-23  1. wwBusinessPro.prg: Updated ZapCursorAndCompareCursor() method to test if "_original" cursor needs to be created.
*                                   2. Moved repo from BitBucket (Mercurial) to GitHub (git)
*
* Version 5.3.0			2020-05-26	1. wwBusinessPro.Get() method: fixed a bug when passing tcAlternateLookupFilter parameter.
*                                   2. wwBusinessProUtils.prg: Added Procedure NumberOfDecimals(tnNumber)
*                                                              Added Procedure IsInteger(tnNumber)
*                                                              Added Procedure IsWholeNumber(tnValue)
*                                                              Added Procedure CloseCursor(tcCursor)
*                                                              Added Procedure GotoRecord(tnRecordNo, tcCursor)
*                                                              Renamed Procedure from BeginsWith() to StartsWith()
*                                    3. Moved ZapCursor() from wwBusinessPro class to wwBusinessProUtils.prg
*                                    4. Many other small tweaks to add error handling, null or empty parameters passed, etc.
*
*
* Version 5.2.1			2019-11-18	1. wwBusiness Object Manager class:
*										In the .ClearFkValuesOnChildCursors method, added check so if Child objects in this oChildItems collection have had their
*										ParentBO re-assigned to another Parent, then we will not change FK values in this loop. This situation
*										happens when Child Object are re-assigns in Parent-Child-Grandchild models.
*
* Version 5.2			2019-06-26	1. Converted Item List from using Array to a Collection to match with latest release of wwBusiness from West Wind.
*									2. Added new property cNewFromCopyExclusionList
*									3. Added code in SaveToCursor() to keep record pointer in the correct place during Scan.
*									4. Added new param tnIgnorePK to CheckIfKeyValueIsAvailable.
*
* Version 5.1			2019-03-05	1. Refactored several hard-coded references to "goApp" to use constant WWBUSINESSPRO_APPLICATION_OBJECT
*									2. Refactored processing of special properties _Child_XXXX and _Releated_XXXX in
*									   wwBusinessProfactory.CreateRelatedObjects() and wwBusinessProfactory.CreateRelatedObjects().
*									3. Removed methods BeginTransaction(), Commit() and Rollback() in wwBusinessProSql class since these have now
*									   been added to wwSql class.
*									4. Moved methods Alltrim() and PrintData() from wwBusinessPro class to functions AlltrimObject() and PrintData() in
*									   wwBusinessProUtils.
*									5. wwBusinessPro.Log() now uses oSql_wws_id object to write log entry so it will be outside of any Transaction if errors
*									   are being logged from wwBusinessPro.Save()
*									6. Class wwBusinessProParent has been removed. All methods and properties from that class have now been moved into
*									   wwBusinessPro. wwBusinessPro is now to be viewed as a "Parent" capable class when Child Items and/or Releated Objects
*									   are defined on it, or regarded as a simple single record BO when no Child/Related objects are defined.
*						
* Version 5.0			2019-02-15	1. Revised to base off of new wwBusinessObject prg classes from West-Wind Web Connect and Client Tools ver 7.0
*									   (wwBusiness was previously in a VCX, but West Wind convert it to PRG and changed class named.
*									2. wwBusinessProUtils.prg:  Added new class wwBusinessProDiff designed to compare oData with oOrigData to indicate if any
*									   data has changed since loaded.
*									3. wwBusinessProSql: added new property lMapVarChar which is used to call CURSORSETPROP("MapVarchar", .t., 0) in init method.
*									4.  wwBusinessPro: Added new property lWriteActivityToScreen which can be enabled to write certain activity throughout the
*									   framework to the FoxPro screen surface.
*									5. wwBusinessProParent.Save(): Updated Tracker logging to indicate if Parent was changed and/or if Children were changed when
*									   Save() was called.
*									6. wwBusinessPropObjManager: Added new property lChildItemsHadChanges to indicate if any of the ReadWrite Child
*									   cursors had any new or changed records when Save was called.
*									7. wwBusinessProParent: Add new properties cInsertAction and cUpdateAction for use in in Tack
*									8. wwBusinessPro.h: Added new constants WWBUSINESSPRO_UPDATE_ACTION, WWBUSINESSPRO_UPDATE_ACTION, and WWBUSINESSPRO_USE_TRACKER_LOGGING
*									9. wwBusinessProParent: Refactored Save() method; Extracted code to 3 new methods: LogEdits(), ScreenLogEdits(), and Rollback()
*
* Version 4.3			2019-01-29	1. Updated many methods by add missing Local var declarations that should have been present
*									   as a matter of good VFP coding practice.
*									2. wwBusinessProItemList: added checks for IsNull() on several of the XXX_Access() methods which could error out
*									   in some use cases, especially when properties are being referenced during the destroy, release, or dispose events.
*									3. wwBusinessProItemList: Replace a few Try/Catch constructs with other strategies of checking and handling to avoid
*									   lazy and gratuitous uses of Try/Catch statements.
*									4. wwBusinessProItemList: Deleted redundant definitions of Destroy() and Dispose() methods which were already present
*									   in the wwBusinessPro base class.
*									5. wwBusinessProUtils.prg:	In the DisposeObjects() function, added check for property lDisposeCalled on the passed toObject
*									   and will now set that property to true before it begins to call Dispose() and null out each object.
*	
* Version 4.2			2017-09-24  1. wwBusinessPro class: Fixed CreateWwsRecord() method to use goApp.oSql_wws_id for creating
*									   new wws_id records so it will be seen in when CreateNewID() is called the first time after a
*									   new wws_id record has been created for a new table being added to the DB.
*									2. Fix record movement in wwBusinessProItemListController by handling padding on child records
*									   when there are spaces on the end of the FK in local cursor.
*									3. Added new properties cVersion and cReleaseDate
*
* Version 4.1			2017-05-08  1. CreateNewId() method will now use goApp.oSql_wws_id instance of wwSql to create new ID/PK.
*									   This was done so that CreateNewID() would not be trapped inside of a Transaction which, if
*                                      rolled back, can leave the wws_id table out of sync with the highest PK assigned so far.
*                                      You need to assign goApp.oSql_wws_id in your bootstrap method.		
*
* Version 4.0           2017-02-10  It's just time to bump up the version number to 4.0 due to so many changes since Ver 3.0
*                                   Too many to list. Review commits if you really must know.
*
* Version 3.0			2016-06-12	Many refactorings since last version number assigned. Too many to list. Review commits if you really must know.
* Version 2.1			2015-12-21  Added wwBusinessProAppObject class and prg
* Version 2.0			2015-07-28	Lots of changes over the past year or so. Too many to document. See commit log
*									at https://bitbucket.org/mattslay/wwbusinesspro/commits/all for all the various changes.

* Version 1.5			2014-06-11	Added Support for managing DataSessions among Business Objects.
*									See: http://www.west-wind.com/wwThreads/default_frames.asp?Thread=4320VIHZP&MsgId=4370FPW56
* Version 1.4.1			2014-04-22	Added code to LoadFromCursor() to select This.cCursor before creating aRows array.
* Version 1.4			2014-04-22	Added nCount, aRows, Clear() and LoadFromCursor(), Item() methods from wwItemList.
*									Updated CalculateValues() method with code from wwBusinessProItemList
* Version 1.3			2014-04-20	SaveToCursor() now sets nUpdateMode to 1 (Edit) before calling Save()
* Version 1.2			2014-04-16	Delete() now sets nUpdateMode to 2.
*									Added RegExp.fll setup
*									Added IsObject() and IsString() Functions
* Version 1.1			2012-04-20	Added calls in Setup_wwBusinessPro proc to setup wwBusinessPro resources
* Version 1.0			2012-04-17	Initial version
*---------------------------------------------------------------------------------------


*-- Modify the settings in this file to match your application environment:
#INCLUDE wwBusinessPro.h

#DEFINE cc_LineItemChanges "One or more Child records were changed." && May or may not be used depending on tlChildItemsHadChanges



*=========================================================================================
*  This is the main wwBusinessPro class which is based on the wwBusinessObject class from
*  West-Wind Web Connection or West Wind Client Tools.
*=========================================================================================

Define Class wwBusinessPro as wwBusinessObject of wwBusinessObject.prg
	
	cVersion = '5.3.0'
	cReleaseDate = '2020-05-26'
	
	
	* A flag that can be used to display a messagebox if the passed key/lookup value was not found.
	* Function is not implemented, but this flag could be used to help handle it.
	lComplain                       = .f.

	* Set this property to indicate the app name which is driving the BO.
	* This can be be used by the logger help record usage and/or error info.
	cAppName              = ''

	* Specify the fields to show in the Browse cursor. Separate each value with a comma. This is a 
	* field list for a Select statement, and can be any valid code as such, as it will just be
	* eval'd into a Select statement. Do not include the "Select" word.
	cBrowseFieldList      = ''

	* (Set internally) by the PrepareSqlCommandParts() method based on the value that is passed
	* into that method for the alias name where the results should be stored.
	cCursor               = ''

	* (Optional) The name of your form to call to edit the current Parent
	* record. The primary or key value of the current Parent will be passed
	* in. You must handle the passed param and the entire edit form. See
	* DoEditForm() method.
	cEditFormName                   = ''

	*-- These properties are used when logging Insert and Update transactions to the Tracker table
	*-- in the LogEdits() method. See also: lTrackAddOrEdit and cTrackerKey properties.
	cInsertAction = WWBUSINESSPRO_INSERT_ACTION
	cUpdateAction = WWBUSINESSPRO_UPDATE_ACTION
	cDeleteAction = WWBUSINESSPRO_DELETE_ACTION
	
	* (Set internally) by the PrepareSqlCommandParts() method from the
	* value is passed into that method for this parameter. This is stored
	* to preserves the parameters that were used to build the results cursor.
	cFieldList            = ''

	* Set this string to use a filter criteria along with the Lookup value. Only supported in the
	* LoadByRef() method. May be added to other Load() methods later.
	cFilter               = ''

	* Use this property if you need a user-friendly name to refer to you class when displaying
	* messages to your user. ie. a class named "PurchaseOrder" could use cFriendlyName = "Purchase Order" 
	cFriendlyClassName	= ''

	* (Set internally) by the PrepareSqlCommandParts() method. This
	* indicates which table/cursor was used to build the results cursor.
	cFromAlias            = ''

	* This is the list of fields that will be shown from the History table (Tracker table)
	cHistoryFields = "[User], [When], [Form], [Action], [ref1], [ref2], [ref3], [ref4], [ref5], [json]"

	* This property assigns the table name for the ID/PK values assigned to new records
	cIdTable = "wws_id"

	* (Set internally) by the PrepareSqlCommandParts() method. This is used
	* to build the SQL clause to pull the records. Ex: "Into csrItems'
	cIntoCursor           = ''

	* Returns "Table.Field" for the KeyValue. Applies to string-based lookups when cLookup is used.
	cKeyValueRef          = ''

	* cLoggerClass is the class used nu the Log() methods to write errors to the log table
	cLoggerClass = 'wwBusinessProSqlLogger'

	* (Optional) The field name from the Parent table that can be used to
	* lookup up a record by a string value. See the cPKField property for
	* Integer based lookup column specifier.
	cLookupField          = ''

	* (Optional) The form to be called to do find a parent record by way of
	* some kind of form that you might design. Must return a LookupField or
	* a PK value that will be handled accordingly.
	cLookupForm           = ''

	* (Optional) The token to be passed into the lookup for so it will know
	* what record type to do a lookup form.
	cLookupFormKey        = ''

	* (Set internally) by the PrepareSqlCommandParts() method from the
	* value passed into that method for the Parent-Child PF/PK matching
	* that is used to build the results cursor. String lookups use the
	* cLookupField value, and Int lookups use cFKField value.
	cMatchField           = ''

	* This property is used in the Error and Message logging so the log
	* file can record which "module" in your app was using the Bus Obj.
	cModuleName           = ''

	* This string property defines the field exclusion list used by the NewForomCopy() method.
	* IMPORTANT: Do not include any spaces in the list.
	cNewFromCopyExclusionList = 'Created_at,Updated_at'
	
	* This is the "Type" field in Tracker that is used to find all history records for this object
	cTrackerKey = '' && Usually the same as the Class name. See Init().

	* (Set internally) by the PrepareSqlCommandParts() method. This is used
	* to build the SQL clause to pull the records. Ex: "Order By '
	cOrderBy              = ''

	* This string indicates the fields to be used used in the 'Order By xxx' clause in
	* the cSQL command. Typically an integer field named 'Order', 'Item',
	* 'Seq', etc but could be column numbers like '1,4,5
	cOrderByFieldList     = ''

	cPKRef                = 'Returns "Table.Field" for the cursor name and PK field. Applies when cPKField is used for integer PK lookups.'

	* (Set internally) by the PrepareSqlCommandParts() method. This string
	* is used to build the SQL clause by providing a "ReadWrite" clause to
	* be used to create an updateable local cursor.
	cReadWrite            = ''

	* The SQL Command built by the PrepareSqlCommand() method. This is the
	* SQL string that will be executed to pull in the record(s).
	cSqlCommand           = ''

	* (Optional) This property is used in the Error and Message logging so
	* the log file can record which "User" in your app was using the Bus
	* Obj. It is a string value and can be an ID (as a string) or a User
	* name.
	cUserId               = ''

	* (Set internally) by the PrepareSqlCommandParts() method. This will
	* store the Where clause of the Parent-Child matching that is used to
	* build the results cursor. Ex: 'Job.PK = JobItems.JobFK'.  Note: the
	* word 'Where' is NOT included.
	cWhereClause          = ''

	* Returns the Lookup String value from the oData object based on the cLookupField property.
	KeyValue              = ''

	* This property is defined so it can be determined if an object is based on the wwBusinessPro base class.
	lwwBusinessPro = .t.

	* (Set internally) by the PrepareSqlCommandParts() method. This indicates the passed property value for
	* keeping the local cursor open vs. closing it after fetching the child records. Only applies to DBF mode.
	lCloseCursor          = .f.

	*-- Set by Dispose() method. You can use this in your classes to help get objects cleaned up in Destroy/Released
	*-- or when _Access method would want to return an object, but you don't want it to if you are Releasing the BO.
	lDisposeCalled 		= .f.

	* This indicates if oData is different than oOrigData since the record was read from DB.
	* For wwwBusinessProItemList, the SaveToCursor() will set this property to indicate if *any* record(s)
	* in the local cursor were modified relative to each respective oOrigData, or if records were added or deleted.
	* See lHasDataChanged_Access() method in wwBusiness and override in wwBusinessProItemList.
	lHasDataChanged 	= .f.

	* Indicates if there are any Errors in the oErrors collection.
	lHasErrors 			= .f.

	* Indicates if there are any Messages in the oMessages collection.
	lHasMessages 		= .f.

	* Indicates if there are any Validation Errors in the oValidationErrors collection.
	lHasValidationErrors = .f.

	* Indicates if an EXACT match is required when doing string-based
	* KeyValue lookups. Otherwise, partial matches can be return which
	* would be the first record found in the table.
	lExactMatch           = .f.

	* If .t., any call to Query will attempt to convert the Sql string
	* from VFP format to Sql Sever T-Sql syntax.
	*== CAUTION: This Sql Fixing is not perfect, so you are better off making sure
	*== you Sql statement is properly formatted for Sql Server. However, this will
	*== deal with many common VFP to Sql Server conversions.
	lFixSql               = .t.

	* (Set internally) Indicates if the last call to the Get() method
	* actually found the requested record.
	lFound                = .f.

	* If you enable error logging, a record will be created in the error
	* log table for each Error that occurs any of the Bus Objects. Errors
	* are usually related to bad SQL statements or failed
	* Insert/Update/Delete statements or other data access failures.
	lLogErrors            = .t.

	* A flag to indicate if you want fetch child records for each Child BO when fetching the Parent BO.
	lLoadRelatedObjects   = .t.

	* A flag to indicate if you want fetch child records for each Child BO when fetching the Parent BO.
	lLoadChildItems       = .t.

	* A flag to indicate if Messages added to oMessages collection should
	* be written to the Log file in the database.
	lLogMessages          = .t.

	* A flag to indicate if the GetNextRecord() method increments by the cLookupField instead of cPkField.
	lNavigateByLookupField = .t.

	* If cIdTable is being used to assign PK values, this flag determines if the PK value is to be assigned
	* immediately when the New() method is called. Otherwise the PK value will be assigned during the Save()
	* method, right before saving to DB.
	lPreassignPK          = .f.

	* (Set internally) by the PrepareSqlCommandParts(). This is indicates indicates if the "ReadWrite"
	* parameter flag was passed into the method to create an updateable local cursor. Relevant only to
	* ItemLists, not Parent objects.
	lReadWrite            = .f.

	lSaving               = .f.

	*-- Shall it set the DataSession before using the oSql object to make a query?
	*-- See: http://www.west-wind.com/wwThreads/default_frames.asp?Thread=4320VIHZP&MsgId=4370FPW56
	lSetDataSession = .t.

	* If field is defined as Nullable in DB, then the oData property for this field will be set to .null. for 
	* New(), GetBlankRecord(), Load(), LoadBase(), Get() method calls.
	* This only applies to numbers and date/datetimes; not strings.
	lSetNullableFieldsNull = .t.

	* A flag to indicate if you want a dialog box to display each Error
	* message that gets set in calls to SetError() method.
	lShowErrors           = .t.

	* A flag to indicate if you want a dialog box to display each Message
	* that gets set by calls to SetMessage() method.
	lShowMessages         = .f.

	* If you want to connect the BO to a local cursor instead of a hard DBF file, open the cursor/alias
	* locally, set cFilename to the name of the cursor, then set this property to true. This is mostly
	* useful to do a Get() from a local lookup cursor rather than hitting the the Sql Server over and over
	* to read a single lookup that you do not plan to Save() back to the DB. It provides sort of a caching capability
	* to read from the local cursor rather than hitting Sql Server over and over for values from a lookup table.
	lTableIsLocalCursor = .f.

	*-- Controls logging of Insert and Update transactions to the Tracker table.
	*-- See also: cInsertAction, cUpdateAction, and cTrackerKey
	lTrackAddOrEdit = WWBUSINESSPRO_USE_TRACKER_LOGGING

	* If this flag is set, the child records will be matched by using the cLookupField property instead of the
	* PK property. Eventually, try to move everything to PK based matching.
	lUseLookupFieldToFetchLineItems = .f.

	* This is a property from wwBusiness that is .f. by default in the base class, but
	* it is defaulted to .t. here in wwBusinessPro. We never want to save a data record unless
	* the Validate() methods for its concrete class returns .t.
	lValidateOnSave = .t.

	* A flag to write certain activity messages to the raw VFP screen. Helpful to see what's going in this framework.
	lWriteActivityToScreen = .f.

	* Holds a count of oData objects loaded into the aRows array, if LoadFromCursor() 
	* is called, or the wwBusinessProItemList.lLoadItemsIntoCollection is set to .t.
	nCount = 0

	*-- The DataSessionID into which all queries will place their results.
	nDataSessionID = 1

	* A numeric error number property than could be used to process errors.
	* There is no native use of this property, but you can make use of it needed.
	nError			= 0

	* A running total of the number of errors that have occurred on this object since it was instantiated.
	nErrorCount		= 0

	*-- Length of time last query took.
	nQueryTime		= 0

	* Returns the number of records in the cCursor cursor (Uses nRecordCount_Access() method).
	nRecordCount 	= 0

	* This property reports the total length of time it took to save all the records in
	* in the local cursor back to the DB. Useful for performance study.
	nSaveToCursorTime = 0

	*-- oBlankRecord stores a blank oData object that can be used. Also used by GetBlankRecord() method.
	*	oBlankRecord = .null.
	*-- This object manages Child items and Related Objects.
	oBusObjManager 	= .Null.

	* A collection of Error messages logged by the BO data access activity.
	oErrors         = .Null.
	oExceptions     = .Null.

	* A reference to a form that may be using the BO. When set, you can access the form to manipulate, refresh, etc.
	oForm			= .Null.

	* A collection of messages that the BOs can populate during usage to record events or info such as 
	* failed validation, missing lookups, etc.
	oMessages       = .Null.

	* Returns the PK value from the oData object based on the cPKField property.
	PK              = 0

	* If LoadFromCursor() is called, or the wwBusinessProItemList.lLoadItemsIntoCollection is set to .t.
	oRows = .null.

	*-- This is a Thor helper property for IntellisenceX to work in the IDE.
	oBusObjManager_Def = '{wwBusinessProBusObjManager, wwBusinessProBusObjManager.prg}'
	
	*-- When saving creating a New() record, this collection is used to null out any fields empty properties
	*-- on oData that are nullable in the database. See lSetNullableFieldsNull property for more details.
	oNullableFields = .Null.

*|================================================================================ 
*| wwBusinessPro::
*| When oSql is accessed, this method will set the nDataSession property on oSql to DataSession of this BO object.
*| This is required so any cursors created by the wwSql object will be scoped to the correct DataSession.
	Procedure oSql_Access()
	
		If This.lDisposeCalled
			Return This.oSql
		EndIf
			
		If This.lSetDataSession and IsObject(This.oSql)
			This.oSql.nDataSessionID = This.nDataSessionID
		EndIf
		
		Return This.oSql
		
	EndProc
	

*|================================================================================ 
*| wwBusinessPro::
	Procedure AddValidationError(tcMessage)
	
		DoDefault(tcMessage)
		
		If Type('This.oParentBO') = 'O'
			This.oParentBO.AddValidationError(tcMessage)
		EndIf
	
	EndProc
	
	
*|================================================================================ 
*| wwBusinessPro::
	* This is called by the wwBusinessProFactory.Make() method after the BO and all 
	* its children are created. This is your chance to do any last-minute adjustments
	* to the class after it's created.
	Procedure AfterCreate()
	
		If Empty(This.cFilename)
			This.cFilename = This.Class
		Endif

		If Empty(This.cCursor)
			This.cCursor = 'csr' + Proper(This.cFilename)
		EndIf
		
		This.cNewFromCopyExclusionList = This.cNewFromCopyExclusionList && Do this to trigger the _Assign() method. 

	EndProc

*|================================================================================ 
*| wwBusinessPro::
	Procedure AfterGet
	
		*-- This is a stub method where you can add code in your subclass to be called after the Get() method is completed.
		*-- Note: This method will be called regardless of whether Get() found the requested item or not.
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
*	tlDataChanged is passed from SaveBase() to indicate if any values on oData had changed and whether any
*   data changes were actualyl sent to database.	
	Procedure AfterSave(tlDataChanged)
	

		*-- This is a stub method where you can add code in your subclass to be called after the Save() method is completed.
		*-- Note: This method will only be called if the Save() method returned .t.
	
	Endproc


*|================================================================================ 
*| wwBusinessPro::
	Procedure AfterDelete
	
		*-- This is a stub method where you can add code in your subclass to be called after the Delete() method is completed.
		*-- Note: This method will only be called if the Delete() method returned .t.
	
	Endproc


*|================================================================================ 
*| wwBusinessPro::
	Procedure cNewFromCopyExclusionList_Assign(tcValue)

		This.cNewFromCopyExclusionList = Evl(tcValue, "")
		This.cNewFromCopyExclusionList = Lower(This.cNewFromCopyExclusionList)
		This.cNewFromCopyExclusionList = Strtran(This.cNewFromCopyExclusionList, " ", "")
		This.cNewFromCopyExclusionList = Strtran(This.cNewFromCopyExclusionList, ",,", ",")
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
*| Return record count in This.cCursor.  Does not count deleted records.
	Procedure nRecordCount_Access()
	
		Local laReccount[1]

		If !Empty(This.cCursor) and Used(This.cCursor)
			Select Count(*) From (This.cCursor) Where Deleted() = .f. Into Array laReccount
			Return laReccount
		Else
			Return 0
		Endif
	
	Endproc
*|================================================================================ 
*| wwBusinessPro::
	Procedure BeforeDelete()

	EndProc



*|================================================================================ 
*| wwBusinessPro::
	Procedure BeforeSave()

		*-- Override this method in your classes. This method is called by wwBusinessPro
		*-- at the very top of the Save() method to give you a chance to do any last minute
		*-- work before saving the record.
		
		*-- In you method, return false if you want to cancel the Save().

	EndProc
	

*|================================================================================ 
*| wwBusinessPro::
	Procedure cFromAlias_Access
	
		This.cFromAlias = Iif(This.nDataMode = 0, This.cAlias, This.cfilename)

		Return This.cFromAlias
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure cKeyValueRef_Access
	
		If !Empty(This.cCursor) And !Empty(This.cLookupField)
			Return This.cCursor + '.' + This.cLookupField
		Else
			Return ''
		EndIf
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| Resets / clears all properties and objects related to oErrors, oExceptions, and oValidationErrors
	Procedure ClearErrors
	
		If This.lSaving = .t.
			Return
		Else
			DoDefault()
		EndIf
		
		This.nErrorCount = 0
		This.nError = 0
		This.lError = .f.
		This.cErrormsg = ''
		This.oErrors = CreateObject('Collection')
		This.oExceptions = CreateObject('Collection')
		This.oValidationErrors = .null.
		
		*-- Clear errors on Child and Related BOs also...
		If IsObject(This.oBusObjManager)
			If IsObject(This.oBusObjManager.oChildItems)
				For each loChildBO in This.oBusObjManager.oChildItems FOXOBJECT
					loChildBO.ClearErrors()
				Endfor
			Endif
			If IsObject(This.oBusObjManager.oRelatedObjects)
				For each loRelatedBO in This.oBusObjManager.oRelatedObjects FOXOBJECT
				  If PemStatus(loRelatedBO, 'ClearErrors', 5)
						loRelatedBO.ClearErrors()
				  Endif
				Endfor
			Endif
		Endif
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure cPKRef_Access
	
		Local lcAlias

		If !Empty(This.cCursor) and Used(This.cCursor)
			lcAlias = This.cCursor
		Else
			lcAlias = This.cAlias
		Endif

		This.cPKRef = lcAlias + '.' + This.cPKField

		Return This.cPKRef
		
	EndProc



*|================================================================================ 
*| wwBusinessPro::
*| This wrapper around the base wwBusinessObject method will handle creating child objects with the
*| additional settings and functionality that wwBusinessPro adds to child item lists.
	Procedure CreateChildObject(tcItemsClass, tcAlias, tlAllowEdit)
		
		Local loChildObject

		If Pcount() = 1
			*-- Call base method if only one parameter was passed.
			loChildObject = DoDefault(tcItemsClass)
		Else
			*-- Call custom wwBusinessPro for child object creation.
			loChildObject = This.CreateChildObjectForParent(tcItemsClass, tcAlias, tlAllowEdit)
		Endif

		Return loChildObject
			
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
*| Creates child object and set oParentBO as well as some other properties like:
*| cCursor, lReadWrite, and also creates and assigns oLineItemsControl object.
	Procedure CreateChildObjectForParent(tcItemsClass, tcAlias, tlAllowEdit)

		Local loItemsObject As Object
		Local lcErrorMessage As String
		*:Global oEx

		If Empty(tcItemsClass)
			lcErrorMessage = 'Warning: Passed value for parameter [tcItemsClass] is blank.'
		Endif

		If Empty(tcAlias)
			lcErrorMessage = 'Warning: Passed value for parameter [tcAlias] is blank.'
		Endif

		If !Empty(lcErrorMessage)
			lcErrorMessage = lcErrorMessage + CRLF + 'From ' + This.Class + '.CreateChildObjectForParent() of object : ' + Proper(This.Name)
			This.SetError(lcErrorMessage)
			Return .Null.
		Endif

		Try
			loItemsObject = CreateWWBOChild(tcItemsClass, This) && See wwBusinessProUtils.prg for this function.
		Catch To oEx
			lcErrorMessage = StringFormat("BO: {0}. Proc: {1}(). Message: {2}", tcItemsClass,  oEx.Procedure, oEx.Message)
			WWBUSINESSPRO_GENERIC_BUS_OBJ.LogError(lcErrorMessage )
			This.SetError('Error creating class ' + tcItemsClass + ' in ' + This.Name + '.CreateChildObjectForParent()')
			This.SetError(lcErrorMessage)
			loItemsObject = .Null.
		Endtry

		*-- Here is the primary reason we did an override on the base method:
		*-- To set some important properties on the ChildBO that tell it the Cursor name to use, 
		*-- and to initialize a LineItemsContol on the ChilBO for adding/deleting line items to the Child cursor.
		If IsObject(loItemsObject)
			This.CreateChildObject(loItemsObject) && Will call the base wwBusinessObject method.
			loItemsObject.oParentBO = This
			loItemsObject.cCursor = tcAlias
			loItemsObject.lReadWrite = tlAllowEdit
			loItemsObject.SetupItemsControl()
			Return loItemsObject
		Else
			Return .Null.
		Endif

	EndProc

*|================================================================================ 
*| wwBusinessPro::
	Procedure CreateBusObjManager
	
		Local loBusObjManager As 'wwBusinessProBusObjManager'

		If IsObject(This.oBusObjManager)
			Return
		EndIf

		loBusObjManager = Createobject('wwBusinessProBusObjManager')
		loBusObjManager.oParentBO = This
		
		This.oBusObjManager = loBusObjManager
		
	EndProc




*|================================================================================ 
*| wwBusinessPro::
	Procedure CreateCursorFromTable(tcTableName, tcCursor, tcIndexField, tcWhereClause)

		Local lcSql, lnReturn, lnSelect
		
		If Empty(tcTableName) or Vartype(tcTableName) != 'C'
			Return -1
		Endif

		lnSelect = Select()

		tcCursor = Evl(tcCursor, tcTableName)

		lcSql = 'Select * From ' + tcTableName
		
		If !Empty(tcWhereClause)
			lcSql = lcSql + ' Where ' + tcWhereClause
		Endif

		lnReturn = This.Query(lcSql, tcCursor, .f., tcIndexField)
		
		If Empty(Order(tcCursor)) and !Empty(tcIndexField)
			This.IndexCursor(tcIndexField)
		Endif

		Select(lnSelect)

		Return lnReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure CreateNewId(tcTableName)

		Local lcSql, lnId, lnMaxID, lnReturn, lnInsertResult, lnSelect, lcFilename
		Local loSql
		
		lnSelect = Select()
		
		*-- See: http://support.west-wind.com/Message4I40DBI7I.wwt#3QS181J1I
		
		Select 0 && We need to be in a work area where there are no tables/cursors open so we will not
				 && get conflict between local variables and field names.  Trust me, this caused me problems one day!!!  2013-04-29

		*-- [2017-05-08] Temporarily switch oSql (See notes on oSql_wws_id property in wwBusinessProAppObject.)
		loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT 
		If IsObject(loAppObject) and PemStatus(loAppObject, "oSql_wws_id", 5) and IsObject(loAppObject.oSql_wws_id) 
			loSql = This.oSql
			This.oSql = loAppObject.oSql_wws_id
		Endif
		
		lcFilename = This.cFilename
		
		*-- Handle passed-in table name to override default table name
		If !Empty(tcTableName)
			This.cFilename = Alltrim(tcTableName)
		Endif

		lnId = DoDefault()
				
		*-- [2017-05-08] Switch oSql back
		If !IsNullOrEmpty(loSql)
			This.oSql = loSql
			loSql = .null.
		Endif
	
		*-- If error, then let's check to ensure that this table name exists in the ID table.
		If lnId <= 0
			lcSql = StringFormat("Select * From {0} Where TableName = '{1}'", This.cIdTable, This.cFilename)
			lnReturn = This.Query(lcSql)
			
			*-- If tablename is not in id table, then lets add it, and we'll need to determine the next value 
			*-- by looking at the highest id that has been used in the actual table.
			If lnReturn = 0
				lnInsertResult = This.CreateWwsRecord()
				
				If lnInsertResult = .t.
					lnID = This.CreateNewID()
					If lnID > 0
						lnReturn = 1
					Endif
				Endif

			Endif
					
			If lnReturn <= 0
				This.SetError(StringFormat("WARNING: Table name [{0}] not found in ID table [{1}]. It must present to assign PK.", This.cFilename, This.cIdTable))
			Endif

		EndIf

		This.cFilename = lcFilename
		
		Select(lnSelect)
		
		Return Int(lnId)
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure CreateWwsRecord
	
		Local lcCheckSql, lcSql, lnReturn, lnMaxId, llReturn
		Local loSql as wwBusinessProSql of wwBusinessProSql.prg
		Local loAppObject as wwBusinessProAppObject of wwBusinessProAppObject.prg

		lcCheckSql = "Select * From wws_id Where Tablename = '" + This.cFilename + "'"

		lnReturn = This.Query(lcCheckSql)
		
		*-- [2017-09-16] Temporarily switch oSql (See notes on oSql_wws_id property in wwBusinessProAppObject.) 
		loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT
		If IsObject(loAppObject.oSql_wws_id)
			loSql = This.oSql
			This.oSql = loAppObject.oSql_wws_id
		Endif

		If lnReturn = 0

			This.Query('Select Max(' + This.cPKField + ') As _max_id From ' + This.cFilename)

			lnMaxId = Nvl(_max_id, 0)

			Text To lcSql TextMerge NoShow PreText 15
			
				Insert Into wws_id (tablename, id) Values ('<<This.cFilename>>', <<lnMaxId>>)
				
			EndText

			This.Execute(lcSql)

			lnReturn = This.Query(lcCheckSql)

			llReturn = (lnReturn > 0)

		Else
		
			llReturn = .t. && Already present
			
		EndIf
		
		*-- [2017-09-16] Switch oSql back
		If !IsNullOrEmpty(loSql)
			This.oSql = loSql
			loSql = .null.
		Endif
		
		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*|  wwBusiness wwSql does not expect spaces between then field names of this property, so this _Assign method will strip out any spaces.
	Procedure cSkipFieldsForUpdates_Assign(tcSkipFieldsForUpdates)

		This.cSkipFieldsForUpdates = Strtran(tcSkipFieldsForUpdates, ' ', '')
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| This is a direct SQL Delete call to the DB, with no buffering and transaction scope. 
	Procedure Delete(tuPk)

		Local lnSelect, llReturn, lnResult, luPK

		lnSelect = Select()

		llReturn = This.BeforeDelete()

		Select (lnSelect)

		luPK = Evl(tuPK, This.PK)

		If llReturn
			*-- Must use local method if working with a string PK, otherwise use default wwBusiness method.
			If Vartype(luPK) = "C"
			    lnResult = This.oSql.ExecuteNonQuery(TextMerge("Delete From <<This.cFilename>> Where <<This.cPKField>> = '<<luPK>>'"))
			    llReturn = (lnResult >= 0)
			Else
				llReturn = DoDefault(luPk)
			Endif
		Endif

		Select (lnSelect)

		If llReturn
			This.AfterDelete()
		Endif

		Select (lnSelect)
		
		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*|---------------------------------------------------------------------------------------
*! Deletes all child records from oLineItems collection/cursor and deletes the Parent record.
*! Children are deleted from the local cursor and DB, then Parent is deleted. No buffering and
*! no Sql Transaction scope, so this is real deleting. Use with caution.
	Procedure DeleteParentAndLineItems(tlSilent as Boolean)

		Local lcLineItemsAlias, lnConfirmDelete, llChildrenDeleted, llParentDeleted
		Local lcAction, lnDeletedPK, lnPK, luDeletedKeyValue, luKeyValue
		
		If tlSilent
			lnConfirmDelete = 6
		Else 
			lnConfirmDelete = Messagebox('Are you sure you want to delete this Parent and all Line Items?' + Chr(13) + Chr(13) + ;
										 'Warning!! These changes cannot be reversed.', 4 + 16, 'Notice: Cannot undo or revert!!!')
		Endif 

		If lnConfirmDelete = 6
			
			lcLineItemsAlias = This.oLineItems.cCursor

			If !Empty(lcLineItemsAlias) And Used(lcLineItemsAlias)
				
				*-- Delete child records in local cursor, then SaveToCursor() which will them from the DB
				Delete All In (lcLineItemsAlias)
				llChildrenDeleted = This.oLineItems.SaveToCursor()
				
				*-- Now delete Parent record...
				If llChildrenDeleted 
					*-- Need to copy these values now for logging purposes, before we call Delete()
					lnDeletedPK = This.PK
					luDeletedKeyValue = This.KeyValue
					llParentDeleted = This.Delete() && Delete Parent
				EndIf
				
			Endif

			*-- Write Tracker entry to record deletion of this record.
			If llChildrenDeleted and llParentDeleted and Type([WWBUSINESSPRO_TRACKER_OBJECT]) = "O"
				*-- Store current values so we can restore them after logging
				lnPK = This.PK
				luKeyValue = This.KeyValue
				
				*-- Set values to that which we copied above from the deleted record.
				This.PK = lnDeletedPK
				This.KeyValue = luDeletedKeyValue
				
				*-- Log the deletion event
				lcAction = This.cDeleteAction
				WWBUSINESSPRO_TRACKER_OBJECT.WWBUSINESSPRO_TRACKER_METHOD(This, lcAction)
				
				*-- Restore back these properties
				This.PK = lnPK
				This.KeyValue = luKeyValue
				
			Endif

		EndIf
		
		Return llChildrenDeleted and llParentDeleted 
		
	EndProc
	
		
*|================================================================================ 
*| wwBusinessPro::
*| You should add a call to Dispose() on each BO you create for use in any methods, so that it can be fully released by the Destroy method.
*| See this blog post for further explanation: http://www.west-wind.com/wconnect/weblog/ShowEntry.blog?id=692
	Procedure Dispose()
	
		If This.lDisposeCalled
			Return
		EndIf
		
		This.lDisposeCalled = .t.
	
		DisposeObjects(This) && From wwBusinessProUtils.prg

	Endproc



*|================================================================================ 
*| wwBusinessPro::
*| Note: You should manually call Dispose() on all created BOs, so that Destroy() can fully release them.
*| See this blog post for further explanation: http://www.west-wind.com/wconnect/weblog/ShowEntry.blog?id=692
	Procedure Destroy
	
		*? " Destroying " + This.Class
		
		This.Dispose()
		
		DoDefault()
		
		*? "Destroyed " + This.class

	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| Note: Validation Errors on oValidataionErrors collection are different that Errors on oErrors collection
*---------------------------------------------------------------------------------------
	Procedure DisplayErrors(tcTitle)
	
		Local lcErrorMsg, lcErrorText

		lcErrorText = This.GetErrorText()

		If Len(lcErrorText) > 0
			Messagebox(lcErrorText, 16, Evl(tcTitle, 'Error'))
		EndIf
		
	EndProc

*|================================================================================ 
*| wwBusinessPro::
*| The method contains (working) sample code that you can override if you to implement a similar approach
*| to launching an "Edit" form in your app.
	Procedure DoEditForm(tuPassedValue)

		Local luValue

		If Empty(This.cEditFormName)
			Return .f.
		Else
			luValue = Evl(tuPassedValue, This.PK)
			Do Form (This.cEditFormName) With luValue
		Endif

	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| The method contains (working) sample code that you can override if you to implement a similar approach
*| to launching a "Lookup" form in your app.
	Procedure DoLookupForm
	
		Local luLookup, llCloseForm
		
		If !Empty(This.cLookupForm) And !Empty(This.cLookupFormKey)
			llCloseForm = .t.
			Do Form (This.cLookupForm) With 'MODAL', (This.cLookupFormKey), llCloseForm To luLookup
			Return luLookup
		Else
			Messagebox('Lookup feature not supported for this object.', 0, 'Notice:')
			This.GetBlankRecord()
			Return .f.
		Endif
	
	Endproc


*|================================================================================ 
*| wwBusinessPro::
	Procedure Find(tcFilter)

		Local llReturn, lnSelect, lcFilter

		lnSelect = Select()

		lcFilter = This.FixSql(tcFilter, .t.)

		llReturn = DoDefault(lcFilter)
	
		If llReturn = .f.
			This.GetBlankRecord()
		Else
			This.nUpdateMode = WW_UPDATERECORD && Edit Mode. See this thread: http://www.west-wind.com/wwThreads/default.asp?Thread=2UV0N8FWZ&MsgId=2UV0N8FX0
		EndIf

		This.LoadRelatedData()

		Select (lnSelect)

		This.lFound = llReturn

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure FixOrderByForSqlServer(tcOrderBy)

		Local lcField, lcFieldSet, lcFixedOrderBy, lcOrder, lcOrderBy, llAddOrderBy, llAddSpace, llAddTab
		Local lnX

		If 'order by' $ Lower(tcOrderBy)
			llAddOrderBy = .t.
		Endif

		If Left(tcOrderBy, 1) = Chr(32)
			llAddSpace = .t.
		Endif

		If Left(tcOrderBy, 1) = Chr(9)
			llAddTab = .t.
		Endif

		lcOrderBy = Alltrim(tcOrderBy, 1, ' ', Chr(9))
		lcOrderBy = Strtran(lcOrderBy, 'order by ', '', 1, 999, 1)

		lcFixedOrderBy = ''

		*-- Convert each:  "Table.Field DESC"   to:   "[Table].[Field] DESC"
		For lnX = 1 To Getwordcount(lcOrderBy, ',')
			lcFieldSet = GetWordNum(lcOrderBy, lnX, ',')
			lcField = GetWordNum(lcFieldSet, 1)
			lcField = Strtran(lcField, '.', '].[')
			lcOrder = GetWordNum(lcFieldSet, 2) && ASC/DESC - This might or might not be present.
			lcFixedOrderBy = lcFixedOrderBy + ', [' + lcField + '] ' + lcOrder
		Endfor

		lcOrderBy = Alltrim(lcFixedOrderBy, ',')

		If llAddOrderBy = .t.
			lcOrderBy = 'Order By ' + lcOrderBy
		Endif

		If llAddSpace = .t.
			lcOrderBy = ' ' + lcOrderBy
		Endif

		If llAddTab = .t.
			lcOrderBy = Chr(9) + lcOrderBy
		Endif

		Return lcOrderBy
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure FixSql(tcSql, tlRemoveAlltrim)

		*-- This method converts FoxPro SQL statements to Sql Server SQL statements.
		*-- For any SQL statements that are written as VFP SQL Selects, when run against Sql Server they 
		*-- will need a little work to adjust them to the correct syntax.

		*-- Here's the plan of attack:
		* This code splits the SQL statement at the "Order By" clause (if present).
		* Sql before the Order By is handled slightly differently than that within the Order By, due to ASC/DESC.

		*-- See other ways to handle this here:
		*--  http://www.west-wind.com/wwThreads/default.asp?Thread=2PP17MHZ0&MsgId=2PR1FFRHX
		*--  http://fox.wikis.com/wc.dll?Wiki~VFPSQL-TSQL-Mapping~VFP

		Local lcPattern, lcSqlStartingWithOrderBy, lcSqlUpToOrderBy, lnOrderBy
		
		If Empty(tcSql)
			Return tcSql
		Endif

		tcSql = Alltrim(tcSql, 0, Chr(10), Chr(13), Chr(9), Chr(32))

		tcSql = Strtran(tcSql, Chr(9), ' ') && Convert any tabs to spaces

		*-- This will strip out a FoxPro comment pattern of "*--" to a Sql Server comment pattern of "--"
		If This.nDataMode = 2
			tcSql = Strtran(tcSql, "*--", "--")
		Endif

		lcSqlUpToOrderBy = tcSql
		lcSqlStartingWithOrderBy = ''

		If This.nDataMode = 2

			lnOrderBy = Atc('order by', tcSql)

			If lnOrderBy > 0
				lcSqlUpToOrderBy = Left(tcSql, lnOrderBy - 1)
				lcSqlStartingWithOrderBy = Substr(tcSql, lnOrderBy)
				If ! ('[' $ lcSqlStartingWithOrderBy) && If any are present, we assume it has already been fixed
					lcSqlStartingWithOrderBy = This.FixOrderByForSqlServer(lcSqlStartingWithOrderBy)
				Endif
			Endif

			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, 'atc(', 'CharIndex(', 1, 999, 1)
			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, 'nvl(', 'IsNull(', 1, 999, 1)
			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, '==', '=', 1, 999, 1)
			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, 'substr(', 'SubString(', 1, 999, 1)

			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, '.t.', '1', 1, 999, 1)
			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, '.f.', '0', 1, 999, 1)
			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, ' as N(', ' as Numeric(', 1, 999, 1)
			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, ' as C(', ' as Char(', 1, 999, 1)


			*-- Temporarily convert "group by" to "group_by" so it will not get touched by the FixSqlField call which
			*-- converts "group" to "[group]"
			lcSqlUpToOrderBy = Strtran(lcSqlUpToOrderBy, "group by", "group_by", 1, 99, 1)
			
			*-- Look for fields with these names and add brackets around them:
			lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'group')
			lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'order')
			lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'desc')
			lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'view')
			lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'user')
			lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'key')

			*-- Convert "group_by" back to "group by"
			lcSqlUpToOrderBy = Strtran(lcSqlUpToOrderBy, "group_by", "group by", 1, 99, 1)


			If !(' case ' $ Lower(lcSqlUpToOrderBy))
				lcSqlUpToOrderBy  = This.FixSqlField(lcSqlUpToOrderBy, 'when')
			Endif

			lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, ' ReadWrite', '', 1, 999, 1) && Strip this out. Sql Server queries are automatically ReadWrite.

			*If tlRemoveAlltrim
				lcSqlUpToOrderBy  = Strtran(lcSqlUpToOrderBy, 'Alltrim', 'Rtrim', 1, 999, 1)
			*Endif

			*-- This is no longer need if using Sql Server 2012 or newer because it now has the IIF() function.
			*-- Change VFP Iif() calls to T-Sql Case / End structure
			*-- RegExp() is from Craig Boyd's RegExp fll. It must be registered in the the app boot strapper.
			*lcPattern =  '[iI][iI][fF]\(([^,]*),([^,]*),([^\)]*)\)'
			*lcSqlUpToOrderBy  = RegExp(lcSqlUpToOrderBy, lcPattern, 1, ' case when \1 then \2 else \3 end ')

		Endif

		Return lcSqlUpToOrderBy + lcSqlStartingWithOrderBy 
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure FixSqlField(tcSql, tcFieldRef)

		*-- When using Sql Server, it is necessary to wrap certain field names in [ ].

		 tcSql = Strtran(tcSql, '.' + tcFieldRef + ' ', '.[' + tcFieldRef + '] ', 1, 999, 1) && converts ".order " to  ".[order] "
		 tcSql = Strtran(tcSql, '.' + tcFieldRef + ',', '.[' + tcFieldRef + '],', 1, 999, 1) && converts ".order," to  ".[order],"
		 tcSql = Strtran(tcSql, '.' + tcFieldRef + ')', '.[' + tcFieldRef + '])', 1, 999, 1) && converts ".order)" to  ".[order])"

		 tcSql = Strtran(tcSql, ',' + tcFieldRef + ' ', ',[' + tcFieldRef + '] ', 1, 999, 1) && converts ",order " to ",[order] "
		 tcSql = Strtran(tcSql, ',' + tcFieldRef + '.', ',[' + tcFieldRef + '].', 1, 999, 1) && converts ",order " to ",[order] "
		 tcSql = Strtran(tcSql, ',' + tcFieldRef + ')', ',[' + tcFieldRef + '])', 1, 999, 1) && converts ",order)" to ",[order])"

		 tcSql = Strtran(tcSql, ' ' + tcFieldRef + ',', ' [' + tcFieldRef + '],', 1, 999, 1) && converts " order," to " [order],"
		 tcSql = Strtran(tcSql, ' ' + tcFieldRef + '.', ' [' + tcFieldRef + '].', 1, 999, 1) && converts " order," to " [order]."
		 tcSql = Strtran(tcSql, ' ' + tcFieldRef + ')', ' [' + tcFieldRef + '])', 1, 999, 1) && converts " order)" to " [order])"
		 tcSql = Strtran(tcSql, ' ' + tcFieldRef + ' ', ' [' + tcFieldRef + '])', 1, 999, 1) && converts " order)" to " [order])"

		 *tcSql = Strtran(tcSql, ' as ' + tcFieldRef, ' as [' + tcFieldRef + ']', 1, 999, 1) && converts " as order" to " as [order]"
		 *tcSql = Strtran(tcSql, ' by ' + tcFieldRef, ' by [' + tcFieldRef + ']', 1, 999, 1) && converts " by order" to " by [order]

		 Return tcSql
		 
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	*-- Created 2009 Late July: This method will accept either a PK Integer that maps to This.cPKField or,
	*-- or a String value that maps to This.cLookupField.
	*-- Integer PKs are passed the native Load(tnPK)
	*-- String lookups call my custom LoadByRef(tcRef), which then calls the native ww Find() method.
	*-- This gives a common lookup method that can be used for either Integer PK or a  String Reference number that maps
	*-- to the cLookupField.
	*--
	*-- You can also pass an alternate match field in parameter tcAlternateLookupFilter
	*-- or, you can pass a "field = value" or "field = [value]" in tcAlternateLookupFilter
	*-- If the later option is used in tcAlternateLookupFilter, then parameter tuLookup is not used.
	*
	*
	* -- Examples:
	* ----------------------------------------------------------------------------------------------------------
	* 
	* Get(12345)                          A numeric lookup against *cPKField* field
	* Get(12345, 'some_numeric_field')    A numeric lookup against passed field name. 
	*
	* Get('ABC-123')                      A string lookup against *cPKField* field (cPKField must be Char datatype)
	*                                     A string lookup against *cLookupField* field (cLookupField must be a Char datatype)
	*
	* Get('ABC-123', 'some_string_field') A string value lookup against a passed field name
	*
	* Get('ABC-%', 'some_string_field')    Wildcard matching on a string value against a specified field (tcAlternateLookupFilter)
	*
	* ie: Get('some_field = 12345')       A custom Where clause was passed in.
	* ie: Get('some_field = "ABC-123"')
	* ie: Get('some_field >= "ABC-123" and some_field <= "ABC-999'')
	* ie: Get("some_field >= 'ABC-123' and other_field = 456789")
	
	Procedure Get(tuLookup, tcAlternateLookupFilter)

		Local lcFieldList, lcPassedType, llResult, lnSelect, lnTime, lcFilter

		lcPassedType = Vartype(tuLookup)

		lnSelect = Select()

		This.ClearErrors()

		If IsNullOrEmpty(tuLookup)
			This.HandleEmptyLookup()
			Return .f.
		Endif

		lnTime = Seconds()
		
		Do Case
		
			* A custom Where clause can be passed as parameter tuLookup. (Do not include "Where" in the passed expression.
			* In this case, the clause must be suitable syntax for the current data mode (DBF mode vs Sql Server mode)
			* Note: This can be any complete clause.
			* ie: Get("some_field = 12345")
			* ie: Get("some_field = 'ABC-123'")
			* ie: Get("some_field >= 'ABC-123' and some_field <= 'ABC-999'")
			* ie: Get("some_field >= 'ABC-123' and other_field = 456789")
			Case lcPassedType = 'C' and HasOperator(tuLookup)
				llResult = This.Find(tuLookup)

			* A string is passed in parameter tcAlternateLookupFilter which specifies which field tuLookup will match against.
			Case !Empty(tcAlternateLookupFilter) and Vartype(tcAlternateLookupFilter) = 'C'
			
				Do Case 
				
					* A numeric lookup against passed field name.
					* ie: Get(12345, 'some_numeric_field')
					Case lcPassedType = 'N'
						If This.nDataMode = 0
							lcFilter = tcAlternateLookupFilter + ' = ' + Alltrim(Str(tcAlternateLookupFilter))
						Else && For Sql Server, wrap in brackets, just in case it's a reserverd word

							If !('[' $ tcAlternateLookupFilter) and GetWordCount(tcAlternateLookupFilter) = 1
								lcFilter =  Strtran(tcAlternateLookupFilter, '.', '].[')
								lcFilter =  '[' + lcFilter + ']'
							Else
								lcFilter = tcAlternateLookupFilter
							EndIf
							
							lcFilter = lcFilter + ' = ' + Alltrim(Transform(tuLookup))
						Endif
						llResult = This.LoadBase(lcFilter)
						
					* Wildcard matching on a string value against a specified field (tcAlternateLookupFilter)
					* ie: Get('ABC%', 'some_string_field')
					Case lcPassedType = 'C' and ('%' $ tuLookup)

						If This.nDataMode = 0
							lcFilter = Strtran(tuLookup, '%', '*')
							lcFilter = [Like('] + lcFilter + [', ] + tcAlternateLookupFilter + [)]
						Else
							lcFilter = tcAlternateLookupFilter + [ Like '] + tuLookup + [']
						Endif
						llResult = This.Find(lcFilter)

					* A string value lookup against a passed field name
					* ie: Get('ABC-123', 'some_string_field')
					* In this method, we build the Where clause differently based on DBF mode vs Sql Server mode
					Case lcPassedType = 'C' 
						If This.nDataMode = 0
							lcFilter = 'Alltrim(' + tcAlternateLookupFilter + [) == '] + Alltrim(tuLookup) + [']
						Else
							If !('[' $ tcAlternateLookupFilter) and GetWordCount(tcAlternateLookupFilter) = 1
								tcAlternateLookupFilter = Strtran(tcAlternateLookupFilter, '.', '].[')
							Endif
							lcFilter = '[' + tcAlternateLookupFilter + "] = '" + Alltrim(tuLookup) + [']
						Endif
						llResult = This.Find(lcFilter)
				Endcase

			*  A numeric lookup against PK field name specified in This.cPKField property
			*    ie: Get(12345)
		    *  A string lookup against PK field name specified in This.cPKField property
		    *    ie: Get('ABC-123')	
			Case (lcPassedType = 'N' or (lcPassedType = 'C' and Empty(This.cLookupField))) && and Empty(tcAlternateLookupFilter)
				llResult = This.Load(tuLookup)

			* Call the DoLookupForm() if '?' is passed into tuLookup ----
			Case lcPassedType = 'C' And Alltrim(tuLookup) = '?'
				tuLookup = This.DoLookupForm()
				llResult = This.Get(tuLookup)
				Return llResult				

			* A String lookup against the field specified in This.cLookup property
			* ie: Get('ABC-123')
			*     Get('5150A%')  Performs a partial match lookup
			Case lcPassedType = 'C' and !Empty(This.cLookupField) && and Empty(tcAlternateLookupFilter) 
				llResult = This.LoadByRef(Alltrim(tuLookup))
				
			Otherwise
				llResult = This.GetBlankRecord()

		EndCase
		
		This.AfterGet()

		Select (lnSelect)
		
		This.nQueryTime = Seconds() - lnTime
		
		Return This.lFound

	EndProc


	*---------------------------------------------------------------------------------------
	Procedure HandleEmptyLookup()
	
		Local lnSelect

		lnSelect = Select()
	
		This.GetBlankRecord()
		This.AfterGet()
		This.nQueryTime = 0
		
		Select(lnselect)
			
	Endproc

*|================================================================================ 
*| wwBusinessPro::
	Procedure GetAll(tcFilter, tcOrderBy, tcCursor, tcFieldList)

		Local lcFieldList, lcOrderByClause, lcSourceAlias, lcSql, lcWhereClause, lnReturn, lnSelect
		Local lcCursor

		lnSelect = Select()

		If !Empty(tcFieldList)
			lcFieldList = tcFieldList
		Else
			lcFieldList = Iif(!Empty(This.cBrowseFieldList), This.cBrowseFieldList, '*')
		EndIf

		lcSourceAlias = This.cFilename

		If !Empty(tcFilter)
			lcWhereClause = 'Where ' + Alltrim(tcFilter)
		Else
			lcWhereClause = ''
		EndIf

		If !Empty(tcOrderBy)
			lcOrderByClause = 'Order By ' + Alltrim(tcOrderBy)
		Else
			lcOrderByClause = ''
		EndIf

		Text To lcSql TextMerge NoShow PreText 15

		   Select <<lcFieldList>>
		   	From <<lcSourceAlias>>
		         <<lcWhereClause>>
		         <<lcOrderByClause>>

		EndText
		
		lcCursor = Evl(tcCursor, This.cCursor)

		lnReturn =  This.Query(lcSql, lcCursor)

		Select (lnSelect)

		Return lnReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	*-- This method is called by various wwBusiness methods any time PK = 0 or KeyValue is an empty string.
	*-- May also be called by the app in other ways too
	Procedure GetBlankRecord
		
		Local llReturn, lnSelect

*!*			If !IsNull(This.oBlankRecord)
*!*				This.oData = This.oBlankRecord
*!*				This.lFound = .f.
*!*				Return .t.
*!*			EndIf
*!*		
		This.lFound = .f.
		*This.oBlankRecord = CopyDataObject(This.oData)

		If !Empty(This.cFileName)
			lnSelect = Select()

			llReturn = DoDefault()
			
			If This.lSetNullableFieldsNull
				This.CaptureNullableFields()
				This.SetNullableFields()
			Endif
			
			*-- 2009-08-13: I added this part, so that if we are in DBF mode, we will move the pointer in the Parent table to eof()
			If llReturn And This.nDataMode = 0
				Goto Bottom In (This.cAlias)
				If !Eof(This.cAlias)
					Skip 1 In (This.cAlias)
				Endif
			Endif

			This.nUpdateMode = WW_NEWRECORD
	
			This.LoadRelatedData()
			
			Select (lnSelect)

		Endif

		Return llReturn
		
	EndProc

*|================================================================================ 
*| wwBusinessPro::
*| Scans the field definitions of passed cursor and records the fields names which are nullable.
*| Field names are stored into This.oNullableFields. If oNullable is already defined, it does nothing.
	Procedure CaptureNullableFields(tcCursor)

		Local lcField, llNullable, lnX, lcCursor
		Local laFields[1]
		Local lcDataType, lcFieldTypesToCapture
		
		lcFieldTypesToCapture = "DTBFIN" && See help file for what each one is.
		
		lcCursor = Evl(tcCursor, Alias())
		
		If IsNull(This.oNullableFields) and Used(lcCursor)
			This.oNullableFields = CreateObject("Collection")
			AFields(laFields, lcCursor)
			
			For lnX = 1 To (Alen(laFields) / 18)
				llNullable = laFields(lnX, 5)
				lcDataType = laFields(lnX, 2)
				If llNullable and lcDataType $ lcFieldTypesToCapture
					lcField = laFields(lnX, 1)
					This.oNullableFields.Add(lcField)
				Endif
			EndFor
		Endif

	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
*| Sets all nullable fields on oData to .null. Nullable field names are captured into oNullableFields in CaptureNullableFields() method.
*| Called by LoadBase() method if lSetNullableFieldsNull is .t.
*| You can manually called this method if you want to, even if lSetNullableFieldsNull is .f.

	Procedure SetNullableFields()	
			
		Local lcField, luValue

		If IsNull(This.oNullableFields) or IsNull(This.oData)
			Return
		EndIf
		
		For Each lcField In This.oNullableFields FoxObject
			luValue = This.oData.&lcField.
			If Empty(luValue)
				Store .null. To ("This.oData." + lcField)
			Endif
		Endfor
		
	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
	Procedure GetBrowseList(tcFilter, tcOrderBy, tcAlias, tcFieldList)

		*-- You can override this method to create a customized results cursor. If not, it will
		*-- call off to the GetAll() method.

		Return This.GetAll(tcFilter, tcOrderBy, tcAlias, tcFieldList)
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GetErrorText
	
		Local laProps[1], lcOutput, lnX, lnCount
		Local lcErrorText, CRLF
		Local loError

		lnCount = 1
		lcErrorText = ''
		CRLF = Chr(13) + Chr(10)

		If IsObject(This.oErrors) and This.oErrors.Count > 0

			lcErrorText = 'Error list for: ' + This.Name + CRLF

			For Each loError In This.oErrors FoxObject

				Amembers(laProps, loError)
				lcErrorText = lcErrorText + '  --- Error ' + Transform(lnCount) + ' ------------------------------------------------' + CRLF

				For lnX = 1 To Alen(laProps)
					lcErrorText = lcErrorText + '  ' + laProps[lnX] + ': ' + Transform(Getpem(loError, laProps[lnX])) + CRLF
				Endfor

				lnCount = lnCount + 1

			Endfor

		Endif

		Return lcErrorText
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GetFirstRecord(tcFilter)

		Local lcFilter, lcCurrent, lcLookupField, lcPKField, lcSql, lnCurrent, lnReturn, lnSelect
		Local llReturn

		lcFilter = Evl(tcFilter, '1=1')

		lnSelect = Select()
		lcPKField = This.cPKfield
		lcLookupField = This.cLookupField

		If !Empty(This.cLookupField)

			Text To lcSql TextMerge NoShow PreText 15

			    Select  Top 1 <<lcLookupField>> as maxvalue
			        From <<This.cFilename>>
			        Where <<lcFilter>>
			        Order by <<lcLookupField>>

			EndText
		Else

			Text To lcSql TextMerge NoShow PreText 15

		    Select  Top 1 <<lcPKfield>> as maxvalue
		        From <<This.cFilename>>
		        Where <<lcFilter>>
		        Order by <<lcPKField>>

			EndText
		Endif

		lnReturn = This.Query(lcSql)

		If lnReturn = 1
			llReturn = This.Get(maxvalue)
		Else
			This.GetBlankRecord()
			llReturn = .f.
		Endif

		Select (lnSelect)

		Return llReturn
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GetLastRecord(tcFilter)

		Local lcFilter, lcCurrent, lcLookupField, lcPKField, lcSql, lnCurrent, lnReturn, lnSelect
		Local llReturn

		lcFilter = Evl(tcFilter, '1=1')
		lcPKField = This.cPKfield

		lnSelect = Select()

		Text To lcSql TextMerge NoShow PreText 15

			Select  Top 1 <<lcPKfield>> as maxvalue
				From <<This.cFilename>>
				Where <<lcFilter>>
				Order by <<lcPKField>> Desc

		EndText

		lnReturn = This.Query(lcSql)

		If lnReturn = 1
			llReturn = This.Get(maxvalue)
		Else
			This.GetBlankRecord()
			llReturn = .f.
		Endif

		Select (lnSelect)

		Return llReturn
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GetValidationErrorsText

		Local lcValidationErrors

		If IsObject(This.oValidationErrors) and This.oValidationErrors.Count > 0
			lcValidationErrors = This.oValidationErrors.ToString()
			Return lcValidationErrors
		Else
			Return ""
		Endif
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
	Procedure GetMessageText
	
		Local laProps[1], lcOutput, lnX, lnCount
		Local lcText, CRLF
		Local loMessage

		lnCount = 1
		lcText = ''
		CRLF = Chr(13) + Chr(10)

		If IsObject(This.oMessages) and This.oMessages.Count > 0

			lcText = 'Message list for: ' + This.Name + CRLF

			For Each loMessage In This.oMessages FoxObject

				Amembers(laProps, loMessage)
				lcText = lcText + '  --- Message ' + Transform(lnCount) + ' ------------------------------------------------' + CRLF

				For lnX = 1 To Alen(laProps)
					lcText = lcText + '  ' + laProps[lnX] + ': ' + Transform(Getpem(loMessage, laProps[lnX])) + CRLF
				Endfor

				lnCount = lnCount + 1

			Endfor

		EndIf

		Return lcText
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GetNextRecord(tcFilter, tnDirection)

		* Pass -1 to move to previous record
		Local lcFilter, lcAscDesc, lcCurrent, lcDirection, lcLookupField, lcPKField, lcSql
		Local lnCurrent, lnReturn, lnSelect
		Local llReturn

		lcFilter = Iif(Empty(tcFilter), '', ' and ' + tcFilter)

		lcDirection = Iif(Vartype(tnDirection) = 'N' and tnDirection = -1, '<', '>')
		lcAscDesc = Iif(lcDirection = '<', 'DESC', 'ASC')

		lnSelect = Select()

		lcPKField = This.cPKfield

		If !Empty(This.cLookupField) and This.lNavigateByLookupField
			lcLookupField = This.cLookupField
			lcCurrent = This.KeyValue

			Text To lcSql TextMerge NoShow PreText 15

			    Select Top 1 <<lcLookupField>> as nextvalue
			        From <<This.cFilename>>
			        Where <<lcLookupField>> <<lcDirection>> '<<lcCurrent>>' <<lcFilter>>
                    Order by <<lcLookupField>> <<lcAscDesc>>
	        
			EndText
			
	        *Order by <<lcPKField>> Desc
			
		Else
			lnCurrent = This.PK

			Text To lcSql TextMerge NoShow PreText 15

			    Select Top 1 <<lcPKField>> as nextvalue
			        From <<This.cFilename>>
			        Where <<lcPKField>> <<lcDirection>> <<lnCurrent>> <<lcFilter>>
			        Order by <<lcPKField>> <<lcAscDesc>>

			EndText
			Endif

		lnReturn = This.Query(lcSql)

		If lnReturn = 1
			llReturn = This.Get(nextvalue)
		Else
			This.GetBlankRecord()
			llReturn = .f.
		Endif

		Select (lnSelect)

		Return llReturn
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GetPreviousRecord(tcFilter)

		Local llReturn

		llReturn = This.GetNextRecord(tcFilter, -1) && passing -1 navigates to previous record

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure Goto(tnPK)

		Local lcCursor, lcLocateString, lnSelect

		lcCursor = This.cCursor

		If Used(lcCursor) And Vartype(tnPK) = 'N'
			lcLocateString = This.cPKField + ' = ' + Transform(tnPK)
			lnSelect = Select()

			Select (This.cCursor)
			Locate For &lcLocateString
			This.LoadFromCurrentRow() && Update oData object

			Select (lnSelect)
		Endif
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure GotoTop
	
		If Used(This.cCursor)
			Goto Top In (This.cCursor)
			This.LoadFromCurrentRow()
		Else
			Return .f.
		Endif
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*-- This method will index the local cursor.
*-- This method is called by the Query method, if an index expression was passed into that method.
	Procedure IndexCursor(tcIndexExpression, tlDescending)

		Local lcDeleted, lcSafety, lcIndexExpression, lcDescending, llReturn
		
		If Empty(tcIndexExpression)
			Return .t.
		Endif

		lcIndexExpression = Chrtran(tcIndexExpression, '[]', '')

		llReturn = .t.
		
		lcDescending = Iif(tlDescending, 'Descending', '')

		If !Empty(lcIndexExpression)
			lcDeleted = Set('Deleted')
			lcSafety = Set('Safety')
			Set Deleted Off
			Set Safety Off
			
			If This.lWriteActivityToScreen
				? "Indexing Cursor " + Alias() + ":  " + tcIndexExpression
			Endif
			
			Try
				Index On &lcIndexExpression Tag &lcIndexExpression &lcDescending
			Catch
				Try
					Index On &lcIndexExpression Tag ChildOrder &lcDescending
				Catch
					This.SetError('Error indexing local cursor for expression: ' + lcIndexExpression)
					llReturn = .f.
				Endtry
			Endtry

			Set Deleted &lcDeleted
			Set Safety &lcSafety
			
		EndIf
		
		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure Init(tcFilename, tcPKField)
	
		This.nDataSessionID = Set("DataSession") && See: http://www.west-wind.com/wwThreads/default_frames.asp?Thread=4320VIHZP&MsgId=4370FPW56

		This.ResetErrorsExceptionsMessages()

		This.cFilename = Evl(tcFilename, Evl(This.cFilename, ''))
		This.cPKField = Evl(tcPKField, Evl(This.cPKfield, ''))
		This.cAlias = Evl(This.cAlias, JustStem(This.cFilename))

		This.cTrackerKey = Evl(This.cTrackerKey, This.class)

		DoDefault()
				
	EndProc

*|================================================================================ 
*| wwBusinessPro::
	Procedure ResetErrorsExceptionsMessages()
	
		This.oErrors = CreateObject('Collection')
		This.oExceptions = CreateObject('Collection')
		This.oMessages = CreateObject('Collection')
		This.oValidationErrors = CreateObject("wwValidationErrors")
		
	Endproc

*|================================================================================ 
*| wwBusinessPro::
	Procedure KeyValue_Access
	
		Local lcReturn

		If Type("This.oData." + This.cLookupField) != "U"
			lcReturn = GetPem(This.oData, This.cLookupField)
		Else
			lcReturn = ""
		Endif
			
		Return Alltrim(lcReturn)
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure KeyValue_Assign(tKeyValue)

		*Push the passed value onto oData in the KeyValue field
		If !Empty(This.cLookupField)
			AddProperty(This.oData, This.cLookupField, tKeyValue)
		Endif

		This.KeyValue = tKeyValue
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| This is a total replacement of the base wwBusiness LoadBase() method.
*| lnLookupType is received for compatibility with wwBusiness, but is not used.
*| It will add brackets around the fields in the Order By clause if you are in Sql Server mode
*| Can pass a int or a string, as long as it matches the data type of the cPkField defined for the BO class.
	Procedure Load(tuPK, lnLookupType)

		Local lcFilter, llFound, llReturn

		*-- A passed tuPK of empty string, 0, .null., or any date type besides "N" or "C" will load an empty record
		IF !InList(Vartype(tuPK), "N", "C") or IsNullOrEmpty(tuPK)
			llReturn = This.GetBlankRecord()
		Else
	      	If This.nDataMode = 0
				If VarType(tuPK) = "C"     		
			      	lcFilter = StringFormat("{0} = '{1}'", This.cPKField, tuPK)
			      Else
			      	lcFilter = StringFormat("{0} = {1}", This.cPKField, tuPK)
				EndIf
			Else && Sql Server: Wrap cPKField in brackets in case it is a reserved word in Sql Server
				Private pnPk
				pnPk = tuPK
		      	lcFilter = StringFormat("[{0}] = ?pnPk", This.cPKField)
	      	EndIf
	      	
			llReturn = This.LoadBase(lcFilter)
		EndIf
		
		*-- Note: This.lFound will be set by one of the above method calls.

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| This is a total replacement of the base wwBusiness LoadBase() method.
*| This allows you to pass in a cursor name in addition to the normal filter.
*| It will add brackets around the fields in the Order By clause if you are in Sql Server mode
	Procedure LoadBase(tcFilter, tcFieldList, tcCursor, tlRebuildCursorFromScratch)

		Local lcFilter, lcOrderBy, lcSql, lnOrderBy, lnReturn, lnSelect 

 		lnSelect = Select()

		If Empty(tcFieldList)
			tcFieldList = '*'
		Endif

		lcSql = 'Select ' + tcFieldList + ' From ' + This.cFilename + ' Where ' + tcFilter

		If This.nDataMode = 2
			lnOrderBy = Atc(' order by ', lcSql)
			If lnOrderBy > 0
				lcOrderBy = This.FixOrderByForSqlServer(Substr(lcSql, lnOrderBy))
				lcSql = Left(lcSql, lnOrderBy - 1) + lcOrderBy
			Endif
		EndIf

		lcSql = This.FixSql(lcSql, .t.)

		lnReturn = This.Query(lcSql, tcCursor, tlRebuildCursorFromScratch)
		
		If lnReturn <= 0
			This.GetBlankRecord()
		Else

			Scatter Name This.oData Memo

			If This.lSetNullableFieldsNull
				This.CaptureNullableFields()
				This.SetNullableFields()
			Endif		
			
			If This.lCompareUpdates
				Scatter Name This.oOrigData Memo
			EndIf
			
			This.nUpdateMode = 1 && Edit Mode
		Endif

		This.lFound = !IsNullOrEmpty(This.PK) Or !IsNullOrEmpty(This.KeyValue)
		
		This.LoadRelatedData() && There may or may not be and Child or Related object, but we call anyway.
		
		Select(lnSelect)

		Return (lnReturn > 0)
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure LoadByRef(tcLookupString, tcLookupField)
	
	Local lcFilter, lcLookupField, llReturn, lnSelect, lcOperator
	
	lnSelect = Select()
	
	lcLookupField = Iif(Pcount() >= 2 And Vartype(tcLookupField) = 'C', tcLookupField, This.cLookupField)
	
	If Pcount() = 0 Or Empty(tcLookupString) Or Empty(lcLookupField)
		This.GetBlankRecord()
		llReturn = .f.
	Else
	*-- Create the Filter string that the base class Find() method needs.
	*-- Can also pull in additional filter set on cAdditionalFilter.
	*-- This lookup will return the first match, and may be a partial match based that could
	*-- be affected by Set Exact On.
	
		If '%' $ tcLookupString
			lcOperator = ' LIKE '
		Else
			lcOperator = ' = '
		Endif
	
		lcFilter = lcLookupField + lcOperator + ['] + Alltrim(tcLookupString) + ['] + ;
			Iif(!Empty(This.cFilter), ' AND ' + This.cFilter, '')
	
		llReturn = This.Find(lcFilter)
	
		If llReturn And This.lExactMatch = .t. and !(Alltrim(This.KeyValue) == Alltrim(tcLookupString)) and !('%' $ tcLookupString)
			*-- Need to look again for the exact match since we landed on a partial match with first attempt.
			lcFilter = Alltrim(lcLookupField) + " == '" + Alltrim(tcLookupString) + "'" + ;
				Iif(!Empty(This.cFilter), ' AND ' + This.cFilter, '')
			llReturn = This.Find(lcFilter)
		Endif
	
		This.lFound = llReturn
	
	Endif
	
	Select (lnSelect)
	
	Return llReturn
	
	Endproc
	

*|================================================================================ 
*| wwBusinessPro::
	Procedure LoadFromCurrentRow(tlCallGet, tlDoNotUpdateOrigData)

		Local lcCursor, lnSelect, lnRecno
		Local loRelatedObject

		lcCursor = This.cCursor

		If Used(lcCursor)

			lnSelect = Select()
			Select (lcCursor)
			lnRecno = Recno()
			
			If IsObject(This.oData)
				Scatter Name This.oData Memo Additive 
			Else
				Scatter Name This.oData Memo
			EndIf
			
			This.nUpdateMode = 1 && Set into Edit Mode. IN Save() method, it will switch to New if record does not already
								 && exist in database.

			If !tlDoNotUpdateOrigData
				This.LoadOrigDataForCurrentRow()
			Endif
		
			If tlCallGet = .t.
				If !Empty(This.cPKField)
					This.Get(This.PK)
				Else
					This.Get(This.KeyValue)
				Endif
			Else
				This.Update() && Added 2010-02-09
				*-- Load any Related Objects, based on FK values for the current oData object
				If IsObject(This.oBusObjManager) and This.lLoadRelatedObjects = .t.
					This.oBusObjManager.LoadRelatedObjects()
				EndIf
			EndIf
			
			*-- Let's just makes sure record pointer is back to where it was when this method was called.
			GotoRecord(lnRecno, lcCursor)
	
			Select (lnSelect)

		EndIf
		
	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
*| If using lCompareUpdates, this method will load oOrigData from corresponding row in XXXXX_Original cursor.
	Procedure LoadOrigDataForCurrentRow()
	
		Local lcOriginalCursor, lcWhere, lcWhereClause, lnSelect

		lnSelect = Select()
		lcOriginalCursor = This.cCursor + "_original"

		*-- If we are using lCompareUpdates, we also need to load up oOrigData from its cursor
		If This.lCompareUpdates and Used(lcOriginalCursor)
			If Vartype(This.PK) = 'C'
				lcWhereClause = This.cPKfield + "= '{0}'"
			Else
				lcWhereClause = This.cPKfield + "= {0}"
			Endif			
		
			*-- Get the original record with matching PK and scatter it to oOrigData
			lcWhere = StringFormat(lcWhereClause, This.PK)
			Select(lcOriginalCursor)
			Locate For &lcWhere
			If !IsNull(This.oOrigData)
				Scatter Name This.oOrigData Memo Additive
			Else
				Scatter Name This.oOrigData Memo
			Endif
		EndIf

		Select (lnSelect)
			
	Endproc
	
*|================================================================================ 
*| wwBusinessPro::
*| Reloads oData by calling Get(), but does not load Child Items or Related Items.
*| Parameter tlLoadRelatedItems can force to reload Related Objects.
	Procedure Reload(tlLoadRelatedObjects)
		
		Local llLoadChildItems, llLoadRelatedObjects

		*-- Store some current settings so we can restore then after we doour work
		llLoadChildItems = This.lLoadChildItems
		llLoadRelatedObjects = This.lLoadRelatedObjects
		
		This.lLoadChildItems = .f.
		This.lLoadRelatedObjects = tlLoadRelatedObjects
		
		This.Get(This.PK)
		
		*-- Restore original settings
		This.lLoadChildItems = llLoadChildItems 
		This.lLoadRelatedObjects = llLoadRelatedObjects
		
	Endproc

*|================================================================================ 
*| wwBusinessPro::
*| This method uses oBusObjManager to load any Child Cursors and Related Objects to the Parent.
	Procedure LoadRelatedData()

		Local lnSelect

		If IsObject(This.oBusObjManager)

			lnSelect = Select()
			
			*-- Load any Related object records
			If  This.lLoadRelatedObjects = .t.
				This.oBusObjManager.LoadRelatedObjects()
			Endif

			*-- Load any Child records/cursors
			If This.lLoadChildItems = .t.
				This.oBusObjManager.LoadChildItems()
			Endif

			Select (lnSelect)

		Endif
		
	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
	Procedure LogError(tcMessage, tcSql)
		
		Local llReturn

		llReturn = This.Log(tcMessage, "ERROR", tcSql)

		If This.lShowErrors
			MessageBox(tcMessage)
		EndIf
		
		Return llReturn
		
	
	EndProc
	
	*|================================================================================ 
	*| wwBusinessPro::
	Procedure LogMessage(tcMessage, tcSql)
	
		This.Log(tcMessage, "MESSAGE", tcSql)

		If This.lShowMessages
			MessageBox(tcMessage)
		Endif
	
	EndProc

	*|=========================================================================================================
	*| wwBusinessPro::Log(tcMessage, tcType, tcSql)
	*|---------------------------------------------------------------------------------------------------------
	*| This method will write a log entry to the log table with passed tcMessage, tcType, and tcSql, along with
	*| many other helpful pieces of information about the state and settings of the Business Object.
	*| This method is automatically called by the SetError() method any time a SQL error occurs in the Query() method
	*| and the failed tcSql will be passed in as well.
	*|-----------------------------------------------------------------------------------------------------------
	Procedure Log(tcMessage, tcType, tcSql)

		Local llReturn
		Local loAppObject as wwBusinessProAppObject of wwBusinessProAppObject.prg
		Local loLogger as 'wwBusinessProSqlLogger' && If you Logger class is not named this, you can adjust
		Local loError

		*#Alias loLogger.oData = BusObjLog

		If Empty(tcMessage)
			Return
		EndIf
		
		loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT
		loAppConfigObject = WWBUSINESSPRO_APP_CONFIG_OBJECT
		
		If IsObject(loAppConfigObject)
			If loAppConfigObject.lSqlLog = .f.
				Return
			EndIf
		Else
			If This.lLogErrors = .f.
				Return
			Endif
		EndIf
		
		If Empty(This.cLoggerClass)
			Return
		EndIf
		
		*-- Dump oData values to Json, if oData is present and defined.
		*-- Will be added to passed tcMessage when written to log table .msg field.
		If IsObject(This.oData)
			loSerializer = CreateObject("wwJsonSerializer")
			loSerializer.FormattedOutput = .t.
			lcJson = loSerializer.Serialize(This.oData)
		Else
			lcJson = ""
		Endif

		loLogger = CreateWWBO(This.cLoggerClass)
		
		If !IsObject(loLogger)
			MessageBox("Error creating Logger object from class named: " + This.cLoggerClass)
			Return
		Endif

		If IsObject(This.oSql)
			* Look for previous error that could have occurred if Log Table is not present...
			If "1526:208" $ This.oSql.cErrorMsg and Lower(GetWordNum(This.oSql.cSql, 3)) = Lower(loLogger.cfilename)
				MessageBox("Bus Obj Logging is enabled, but log table [" + loLogger.cfilename + "] is not " + ;
									"present in the Sql Server database.")
				Return
			Endif
		Endif

		With loLogger
			.nDataMode = This.nDataMode
			If This.nDataMode = WW_DATAMODE_SQL
				If PemStatus(loAppObject, "oSql_wws_id", 5) and IsObject(loAppObject.oSql_wws_id) 
					.SetSqlObject(loAppObject.oSql_wws_id)
				Else
					.SetSqlObject(This.oSql)
				Endif
			Endif
			.lLogErrors = .f.
			If Empty(.cIdTable)
				.cSkipFieldsForUpdates = .cSkipFieldsForUpdates + ',' + .cPKField && This one could be set to AutoInc on the DBF/Sql Server.
			Endif
			.New(.t.)
		EndWith

		If Vartype(loLogger.oData) = "O"
			With loLogger.oData
				.user_id = Transform(This.cUserId) && Use Transform just in case it is set as an Integer.
				.msg = tcMessage + Chr(13) + lcJson
				.class = This.Class
				.obj_name = This.Name
				.error_code = This.nError
				.app_name = This.cAppName
				.mod_name = This.cModuleName
				.log_type = Evl(tcType, "")
				.sql = Evl(tcSql, "")
			EndWith
			llReturn = loLogger.Save()
		Else
			llReturn = .f.
		Endif
	
		*-- If we had any errors on the logger, then copy those error messages to this objects oError collection
		If !llReturn
			For Each loError in loLogger.oErrors FoxObject
				This.oErrors.Add(loError)
				This.nErrorCount = This.nErrorCount + 1
			EndFor
		Endif

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure New(tlNoNewPk)

		Local lcPKField, llReturn, llAssignId

		*-- Only assign PK at this time if these conditions are met:
		*  cIdTable is specified
		*  lPreassignPK is set true
		*  tlNoNewPk was not passed as .t.

		llAssignId = !Empty(This.cIdTable) And This.lPreassignPK And !tlNoNewPk

		llReturn = DoDefault(!llAssignId)

		This.lFound = .f.

		*-- Make sure new BO has a PK value assigned, if it is supposed to be preassigng one.
		If llAssignId = .t. And Empty(This.PK)
			This.SetError('PK value should be assigned but it is empty.')
		Endif

		If llReturn
			This.SetDefaultsForNewRecord()
		Endif

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure NewFromCopy(tlNoNewPk)

		*-- This method creates a new record, with the values coming from the current oData
		Local luPk, llReturn, lcFieldsToExclude
		Local loCopyOfData

		loCopyOfData = CopyObject(This.oData) && From wwUtil library

		llReturn = This.New(tlNoNewPk)

		If llReturn and IsObject(loCopyOfData)
			luPk = This.PK && Store the PK that was assigned by New() se we can re-apply it after CopyObjectProperties

			lcFieldsToExclude = This.cNewFromCopyExclusionList
			CopyObjectProperties(loCopyOfData, This.oData, .f., .f., lcFieldsToExclude)  && From wwUtil library
			
			If IsObject(This.oBusObjManager)
				This.oBusObjManager.LoadRelatedObjects()
			Endif

			This.PK = luPK && Use the new PK from the New() call above
			This.KeyValue = '' && Blank out the Lookup string. No way we can re-use it again!

		EndIf

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure Open(tcFile, tcAlias, tlForceReconnect)

		Local lcAlias, llReturn

		* If Empty(This.cFilename)
		* 	Return .t.
		* Endif

		If This.nDatamode = 0 And !File(This.cDataPath + This.cfilename + '.dbf') and !This.lTableIsLocalCursor
			This.SetError('DBF file ' + This.cDataPath +  This.cfilename + '.dbf cannot be located.')
			Return .f.
		EndIf

		If This.lTableIsLocalCursor and !Used(This.cFilename)
			This.SetError('No local cursor named ' + This.cFilename + ' is in use.')
			Return .f.
		EndIf

		If Empty(This.cAlias)
			This.cAlias = Evl(tcAlias, Juststem(Evl(tcFile, This.cfilename)))
		Endif

		lcAlias = Evl(tcAlias, This.cAlias)

		If Empty(This.cCursor)
			This.cCursor = 'csr' + lcAlias
		Endif

		Try
			llReturn = DoDefault(tcFile, lcAlias, tlForceReconnect)
		Catch
			This.SetError('An error occurred when calling the Open() method in the Business Object named [' + This.Name + ']' + Chr(13) + Chr(13) + ;
				  		  'The requested table [' + This.cFilename + '] or alias [' + This.cAlias + '] could be opened properly.')
			llReturn = .f.
		Endtry

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure oValidationErrors_Access
	
		Local loValidationErrors

		loValidationErrors = .null.
		
		If This.lDisposeCalled
			Return .null.
		Endif

		Try
			loValidationErrors = DoDefault()
		Catch
		EndTry
		
		Return loValidationErrors
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure PK_Access
	
		Local lcPkRef, luReturn

		If Type("This.oData." + This.cPKfield) != "U"
			luReturn = GetPem(This.oData, This.cPKfield)
		Else
			luReturn = 0
		Endif
			
		Return luReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure PK_Assign(tuPK)

		*Push the passed value onto oData in the PK field
		AddProperty(This.oData, This.cPKfield, tuPK)

		This.PK = tuPK
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure PrepareSqlCommand
	
 		Local lcSql
 
		Text To lcSql PreText 15 NoShow TextMerge 

		     Select <<This.cFieldList>>
		         From <<This.cFromAlias>>
		         Where <<This.cWhereClause>>
		         <<This.cOrderBy>>

		Endtext

		*-- Notice that "Into Cursor Blah" is not part of this Sql command above!!
		*-- This is handled in the LoadLintItemsBase() and Query() methods
		*-- The reason is so the records will go into a temp cursor first, then
		*-- pulled into the final cursor using the "Safe Select" technique

		This.cSql = lcSql && This is the Sql command fired by the Query method

		Return lcSql
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure PrepareSqlCommandParts(tuParentKeyOrRef, tcMatchField, tcFieldList, tcOrderByFieldList, tcCursor, tlReadWrite, ltcloseCursor)

		*-- This method will populate the properties that a SQL call will need based on the passed params.
		*-- The following properties are set on the object instance, and can be used by any other methods.
		* This.cFieldList
		* This.cMatchField
		* This.cCursor     --> The local cursor name that the records will be pulled into
		* This.cWhereClause
		* This.cIntoCursor --> An "Into Cursor xxxx" clause (nDataMode=0 only)
		* This.cOrderBy
		* This.cOrderByFieldList
		* This.cReadWrite  --> A "ReadWrite" clause (nDataMode=0 only)

		Local lcMatchField, lcOrderBy

 		This.cSql = ''

		*-- Format the fields to select ---
		This.cFieldList = Iif(Empty(tcFieldList), Iif(Empty(This.cFieldList), '*', This.cFieldList), tcFieldList)

		*-- DBF mode needs to use cAlias, whereas SQL Server mode needs to use the cFilename property for the FROM clause
		This.cFromAlias = Iif(This.nDataMode = 0, This.cAlias, This.cfilename)

		*-- Build the cWhereClause -------------
		*-- Note the cWhereClause does NOT include the WHERE word, you need to include that in your SQL

		Do Case

			Case Vartype(tuParentKeyOrRef) = 'N'
				lcMatchField = Evl(tcMatchField, This.cPKField)
				If This.nDataMode = 2
					lcMatchField = '[' + lcMatchField + ']'
				Endif

				This.cWhereClause = lcMatchField + ' = '  + Transform(tuParentKeyOrRef)

			Case Vartype(tuParentKeyOrRef) = 'C'
				lcMatchField = Evl(tcMatchField, This.cLookupField)
				If This.nDataMode = 2
					lcMatchField = '[' + lcMatchField + ']'
				Endif

				This.cWhereClause = This.cMatchField + "== '" + Alltrim(tuParentKeyOrRef) + "'"

			Otherwise
				This.cWhereClause = ''

		Endcase

		*-- If PK=0 or if KeyValue is an empty string, we are want an empty cursor, so make a '0=1' where clause, which will not return any recs
		If Empty(tuParentKeyOrRef)
			This.cWhereClause = '0 = 1'
		EndIf

		*-- Determine the cursor name and build the "Into Cursor blah" clause
		This.cCursor = Evl(tcCursor, Evl(This.cCursor, 'Query'))

		If This.nDataMode = 0 And !Empty(This.cCursor)
			This.cIntoCursor = 'Into Cursor ' + Alltrim(This.cCursor)
		Else
			This.cIntoCursor = ''
		Endif

		*-- Handle ReadWrite option (generally used by the ItemList sublclasses only) -----------------------------------------------------------
		*-- Provides and option for creating the cursor in ReadWrite mode for direct cursor editing, then can be saved back
		This.lReadWrite = tlReadWrite
		If This.lReadWrite = .t. && and This.nDataMode = 0
			This.cReadWrite = 'ReadWrite'
		Else
			This.cReadWrite = ''
		Endif

		*-- Build the OrderBy clause. Note, this may resolve to an empty string, meaning no Order clause is to be used --------
		This.cOrderByFieldList = Evl(tcOrderByFieldList, This.cOrderByFieldList)

		If !Empty(This.cOrderByFieldList)
			*-- The OrderByField list may contain multiple fields, separated by commas, and each field may also include a
			*-- table name prefix with a dot. Each field may also include a ASC or DESC.

			If '.' $ This.cOrderByFieldList or Val(This.cOrderByFieldList) > 0
				lcOrderBy = This.cOrderByFieldList && User field list as-is
			Else
				lcOrderBy = Alltrim(This.cAlias) + '.' + Alltrim(This.cOrderByFieldList) && Add table name to front
			EndIf

			If This.nDataMode = 2 and !('[' $ lcOrderBy) && If doesn't include brackets, add them around each field
				lcOrderBy = This.FixOrderByForSqlServer(lcOrderBy)
			EndIf

			This.cOrderBy = 'Order By ' + lcOrderBy

		Else
			This.cOrderBy = ''
		Endif

		*==== Test certain values and complain if any are incomplete or invalid ====================
		If Empty(This.cFromAlias)
			Messagebox('Property [cFromAlias] evaluates to an empty string on ItemList object named: ' + This.Name)
			Return .f.
		Endif

		If Empty(This.cFromAlias) And This.nDataMode = 0
			Messagebox('Property [cCursor] evaluates to an empty string on ItemList object named: ' + This.Name)
			Return .f.
		Endif

		This.PrepareSqlCommand()

		Return .t.
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure PrintErrors
	
		? This.GetErrorText()
		
	EndProc



*|================================================================================ 
*| wwBusinessPro::
*| By default, wwBusinessObject returns 0 even if there was an error in the Sql command.
*| wwBusinessPro will return -1 if there was en error in the Sql command. You can see the
*| oErrors collection for more details about the error.
	Procedure Execute(tcSql)
			
		Local llBeforeError, lnReturn
		Local loAppObject as wwBusinessProAppObject of wwBusinessProAppObject.prg
		
		loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT
		loAppObject.cCurrentBOClass = This.Class
		
		llBeforeError = This.lError
		This.lError = .f. && Clear it out so we make this next call with a clear lError flag

		lnReturn = DoDefault(tcSql) && Cursor will live in This.cSqlCursor following this call
		
		If This.lError = .t.
			lnReturn = -1
			This.LogError("Error in Execute method.", tcSql)
		Endif

		This.lError = llBeforeError && Set it back
		
		Return lnReturn
			
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*| This is a wrapper around wwSql.ExecuteStoredProcedure() which uses the "Safe Select" pattern
*| to build/rebuild a cursor without destroying the original cursor.
	Procedure ExecuteStoredProcedure(tcSql, tcCursor, tlRebuildCursorFromScratch, tcIndexExpression)

		Local lcCursor, lcCursorForCompare, lcSafety, llReturn
		Local lcErrorMessage, lnReturn
		
		*-- Can also index the cursor on passed field name.

		*-- Parameters:
		*
		* tcCursor - The resulting cursor to use create (will attempt to do a "Safe Select" into this cursor
		*            if it already exists. However, the schema of the current Select must match the existing schema.
		* tlRebuildCursorFromScratch - (Optional) Pass .t. if you want to blow away the existing cursor and create it from scratch.
		* tcIndexField - (Optional) The field name to index resulting cursor on.		

		This.lError = .f. && Clear it out so we make this next call with a clear lError flag
		
		llReturn = This.oSql.ExecuteStoredProcedure(tcSql, This.cSqlCursor)
	
		*-- If any errors, return error value
		If !llReturn
			This.lError = .t.
			lcErrorMessage = Evl(This.cErrorMsg, "") + " " + Evl(This.oSql.cErrorMsg, "")
			This.SetError(lcErrorMessage)
			Return -1
		Endif

		lnReturn = Reccount()
		
		If Empty(tcCursor)
			If !Empty(tcIndexExpression)
				This.IndexCursor(tcIndexExpression)
			Endif
			Return lnReturn
		EndIf
		
		This.AfterQueryOrStoredProc(tcCursor, tlRebuildCursorFromScratch, tcIndexExpression, lnReturn)
		
		Return lnReturn
			
	EndProc
	


*|================================================================================ 
*| wwBusinessPro::
*| By default, wwBusiness returns 0 even if there was an error in the Sql command.
*| wwBusinessPro will return -1 if there was en error in the sql command. You can see the
*| oErrors collection for more details about the error.
	Procedure Query(tcSql, tcCursor, tlRebuildCursorFromScratch, tcIndexExpression)

		*-- Can also index the cursor on passed field name.

		*-- Parameters:
		*
		* tcCursor - The resulting cursor to create. This will attempt to do a "Safe Select" into this cursor
		*            if it already exists. However, the schema of the query being called by this must match the schema of the existing cursor.
		* tlRebuildCursorFromScratch - (Optional) Pass .t. if you want to blow away the existing cursor and create it from scratch.
		* tcIndexExpression - (Optional) The index expression to use/create after the cursor is built.

		Local lcCursor, lcError, lcSafety, lcSql, llBeforeError, lnReturn, lnSelect, lcCurrentBOClass
		Local loException
		Local loAppObject as wwBusinessProAppObject of wwBusinessProAppObject.prg
		
		lnSelect = Select()
		lnReturn = -1
		lcSql = Alltrim(tcSql, 0, Chr(10), Chr(13), Chr(9), Chr(32))

		*-- [2015-12-14 M. Slay] This will strip out a FoxPro comment pattern of "*--" to a Sql Server comment pattern of "--"
		If This.nDataMode = 2
			tcSql = Strtran(tcSql, "*--", "--")
		Endif

		If This.lFixSql = .t.
			lcSql = This.FixSql(lcSql) && Fix up the Sql in case it need to be converted from VFP Sql to T-Sql syntax
		EndIf
		
		Try
			llBeforeError = This.lError
			This.lError = .f. && Clear it out so we make this next call with a clear lError flag

			loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT
			lcCurrentBOClass = loAppObject.cCurrentBOClass
			loAppObject.cCurrentBOClass = This.Class
			lnReturn = DoDefault(lcSql) && Cursor will live in This.cSqlCursor following this call
			loAppObject.cCurrentBOClass = lcCurrentBOClass
			
			If This.lError = .t.
				lnReturn = -1
			Endif

			This.lError = llBeforeError

		Catch To loException && SQL Satement could fail in above call if it has errors in the SQL statment

			AddProperty(loException, 'cSql', lcSql) && Capture the SQL command that was issued.

			This.oExceptions.Add(loException)

			If Type('This.oParentBO') = 'O'
				loException.UserValue = 'Exception in child item class'
				This.oParentBO.oExceptions.Add(loException)
			Endif

			lcError = 'Method: ' + This.Class + '.' + loException.Procedure + '(): ' + loException.Message
			This.SetError(lcError, loException.ErrorNo)
			lnReturn = -1
		Endtry

		*-- This is the above lcSql with the cursor name added to it to show 
		*-- what effectively happens after the Safe Select cursor is rebuilt.
		If ' INTO ' $ Upper(tcSql)
			This.cSqlCommand = tcSql
		Else
			If !Used(This.cSqlCursor)&& or This.nErrorCount > 0
				Select (lnSelect)
				lnReturn = -1
			Endif
			This.cSqlCommand = This.cSql + ' ' + This.cIntoCursor + ' ' + This.cReadWrite
		Endif

		*-- If any errors, return error value
		If lnReturn < 0
			Return lnReturn
		Endif

		*-- If no specific cursor was specified, results will live in This.cSqlCursor, and we return out from here.
		*-- So we check if an index field was passed, and we'll index and then return out of here.
		If Empty(tcCursor)
			If !Empty(tcIndexExpression)
				This.IndexCursor(tcIndexExpression)
			Endif
			Return lnReturn
		EndIf

		If lnReturn > 1000
			If This.lWriteActivityToScreen
				? ">1000 " + This.Class
				*? lcSql
			Endif
		Endif
	
		This.AfterQueryOrStoredProc(tcCursor, tlRebuildCursorFromScratch, tcIndexExpression)	

		Return lnReturn
		
	EndProc

*|================================================================================ 
*| wwBusinessPro::
	Procedure AfterQueryOrStoredProc(tcCursor, tlRebuildCursorFromScratch, tcIndexExpression, tnRecords)
	
		*-- If no specific cursor was specified, results will live in This.cSqlCursor, and we return out from here.
		*-- So we check if tcIndexExpression was passed, and we'll index and then return out of here.

	
		*-- Build the requested local cursor name, or, if it already exists, pull in records into the existing cursor.
		*-- This area manages "Safe Select" type of cursor, when a specified tcCursor name is passed in
		*-- We will also index the cursor, if specified in tcIndexExpression.
		Local lcCursor, lcCursorForCompare

		lcCursor = Evl(tcCursor, This.cCursor)
					
		If !Empty(lcCursor) and StartsWith(lcCursor, "csrTemp")
			tlRebuildCursorFromScratch = .t.
		Endif

		If !Used(lcCursor) Or tlRebuildCursorFromScratch
		
			Select * From (This.cSqlCursor) Into Cursor (lcCursor) Readwrite NoFilter

			*This.IndexCursor(tcIndexExpression)

		Else && Otherwise, perform a "Safe Select" with Zap and Insert from This.cSqlCursor.
		* See: http://weblogs.foxite.com/andykramek/2005/03/19/using-a-safe-select-to-preserve-your-grid/
	
			ZapCursor(lcCursor)
			Insert Into (lcCursor) Select * From (This.cSqlCursor)
			Goto Top in (lcCursor)

		EndIf
		
		Use In (This.cSqlCursor) && Close the temp cursor that was used by the Query() method

		*-- Create a copy of the original values, so they can be used from comparison during Save() or any other needs.
		If This.lReadWrite and This.lCompareUpdates
			lcCursorForCompare = tcCursor + "_original"
			Select * From (lcCursor) Into Cursor (lcCursorForCompare) ReadWrite
		EndIf
	
		Select (lcCursor)
		
		If !Empty(tcIndexExpression) and !(Alltrim(Upper(StrTran(tcIndexExpression, " ", ""))) == Key())
			This.IndexCursor(tcIndexExpression)
		Endif
				
	Endproc


*|================================================================================ 
*| wwBusinessPro::
	Procedure ZapCursorAndCompareCursor(tcCursor)

		Local lcCursorForCompare

		ZapCursor(tcCursor)

		lcCursorForCompare = tcCursor + "_original"
		
		If Used(lcCursorForCompare) Or ;
		 	(This.lReadWrite and This.lCompareUpdates)
			Select * From (tcCursor) Where 0 = 1 Into Cursor (lcCursorForCompare) ReadWrite
		Endif
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
*| This method is called by the Save() method if lValidateOnSave is .t.
*| You need to define an override method on each BO class with this method name, and in that method,
*| call DoDefault() to make this base method fire, then add your validation logic in the BO method
*| to call This.AddValidationError("Blah, blah") for each validation error in the BO.
*| This method sets oValidationErrors collection to .null. and any subsequent calls to oValidationErrors will trigger
*| oValidationErrors_Access() which will create a new instance of wwValidationErrors collection.
*| See DisplayValidationErrors() method to display these errors in a dialog box.
	Procedure Validate
	
		This.oValidationErrors = .null.
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
	Procedure ValidateCharacterField(tcFieldName, tnMaxLength, tlAllTrim, tlAddValidationError)
	
		Local lcPropertyref, llValid

		If Empty(tcFieldName) or Empty(tnMaxLength)
			Return .f.
		Endif
	
		lcPropertyref = "This.oData." + tcFieldName

		If tlAlltrim
			Store Alltrim(GetPem(This.oData, tcFieldName)) To &lcPropertyRef
		Endif

		llValid = (Len(GetPem(This.oData, tcFieldName)) <= tnMaxLength)
		
		If !llValid and tlAddValidationError
			This.AddValidationError(TextMerge("Max allowed length of [<<tcFieldName>>] field is <<tnMaxLength>> characters."))
		EndIf
		
		Return llValid
	
	Endproc

*|*=======================================================================================
*| Compares oData with oOrigData using wwBusinessProDiff class to determine if any properties have changed.
*| This comparison will ignore any fields listed in cSkipFieldsForUpdates.
*| There is property on wwBusinessPro for lHasDataChanged, but this method does not forcibly
*| write to that property, so you have to apply this result to This.lHasDataChanged yourself
*| depending on your needs or architecture.
	Procedure HasDataChanged()

		Local llDataChanged
		Local loDiff as "wwBusinessProDiff"
		Local loDiffCollection as "Collection"
		
		llDataChanged = .t.  && Assume .t., then set false only after we compare oData with oOrigData

		*-- Get a Diff so we can log the changes on oData
		If VarType(This.oData) = 'O' and VarType(This.oOrigData) = 'O'
			loDiff = CreateObject("wwBusinessProDiff")
			loDiff.cIgnoreFields = "," + Alltrim(This.cSkipFieldsForUpdates) + ","
			loDiffCollection = loDiff.DiffObject(This.oData, This.oOrigData)
			If loDiffCollection.Count = 0
				llDataChanged = .f.
			Endif
		EndIf
		
		This.lHasDataChanged = llDataChanged
		
		Return llDataChanged
		
	Endproc
		

*|================================================================================ 
*| By Default, a full Get() call is made to reload the BO and all Children from DB after Save() has finished. 
*| Pass .t. for the tlDoNotRequery parameter if you want to prevent Get() from being called after saving.
*| wwBusinessPro::
	Procedure Save(tlSaveChildObjects, tlDoNotRequery, tlSaveRelatedObjects)

		Local llAllSaved, llChildItemsHadChanges, llChildSaveResult, llDoNotCallAfterSave
		Local llSaveResult, llRelatedSaveResult, llWorkingWithNewRecord, lnBeforeSavePK, lnSelect
		Local llParentBo

		lnSelect = Select()

		llWorkingWithNewRecord = (This.nUpdateMode = WW_NEWRECORD)
		lnBeforeSavePK = This.PK
		llDoNotCallAfterSave = .t.  && Do not want to call AfterSave() from SaveBase(). We will call
									&& AfterSave() near the very end of this method.
		llChildSaveResult = .t.  && Default to .t., will set false below if any save errors.
		llRelatedSaveResult = .t. && Default to .t., will set false below if any save errors.

		llParentBo = Type("This.oBusObjManager.oChildItems") = "O"
		
		If This.nDatamode = WW_DATAMODE_SQL
			This.oSql.BeginTransaction()
		EndIf 
		
		If This.lWriteActivityToScreen
			If llParentBo
				lcMessage = "Saving Parent record "
			Else
				lcMessage = "Saving record "
			EndIf
			If This.lWriteActivityToScreen
				? lcMessage + This.cFriendlyClassName + " " + This.KeyValue
			Endif
		EndIf
		
		llSaveResult = This.SaveBase(llDoNotCallAfterSave)

		If !This.lHasDataChanged and This.lWriteActivityToScreen
			? "  >   No changes to data on this object."
		EndIf
		
		This.lSaving = .t.
		
		*-- Save any Child cursor rows from their local cursors back to the real tables in the DB.
		If tlSaveChildObjects and IsObject(This.oBusObjManager)
			llChildSaveResult = This.oBusObjManager.SaveChildItems()
			llChildItemsHadChanges = This.oBusObjManager.lChildItemsHadChanges
		Endif
		
		*-- Save any Related Objects.
		If tlSaveRelatedObjects and IsObject(This.oBusObjManager)
			llRelatedSaveResult = This.oBusObjManager.SaveRelatedBO()
		EndIf
		
		*-- Commit changes to DB or Roll Back if we had errors during any of the Save calls.
		If llSaveResult and llChildSaveResult and llRelatedSaveResult
			If This.nDatamode = WW_DATAMODE_SQL
				This.oSql.Commit()
			EndIf
			This.LogEdits(llWorkingWithNewRecord, llChildItemsHadChanges)
			This.ScreenLogEdits(llWorkingWithNewRecord, This.lHasDataChanged, llChildItemsHadChanges)
			llAllSaved = .t.
		Else
			This.RollBack(lnBeforeSavePK)
			llAllSaved = .f.
		Endif

		If !tlDoNotRequery and llSaveResult and llChildSaveResult and llRelatedSaveResult && pass in .t. to prevent requery after saving
			*-- Note: We do not want to call a Get() if there were save errors, because it will blow away local changes
			*-- on the oData object if we fetch from data table.
			*-- So, the caller of this Save() method needs to test return value from here, and fix data if .f., then call Save()
			*- again after fixing issues to ensure all data in current edit session gets written to table.
			This.Get(This.PK) && Re-fetch Parent and any children records from DB.
							  && We really want a fresh pull from the DB because now that we've done our Save(), let's be sure we
							  && are pulling back a copy of what's in the DB to freshen up our local Parent BO, Related BOs, and all
							  && Child cursors.
		EndIf

		This.lSaving = .f.
		
		If llAllSaved and This.lHasDataChanged
			This.AfterSave()
		Endif
		
		Select(lnSelect)

		Return llAllSaved
		
	EndProc
	


*|================================================================================ 
*| wwBusinessPro::
*| Saves from the oData object to the actual data table. After saving, if there is a local supporting cursor,
*| data is scattered from oData to current row in cursor.
*| This method is called by the Save() method of both wwBusinessPro (Typically a Parent class), and by the
*| wwBusinessProItemList.Save() method.

	Procedure SaveBase(tlDoNotCallAfterSave)

		Local lcPKField, llReturn, lnNewPK, lnRecords, lnSelect, llPkAssigned, llValidated, llHasDataChanged

		lnSelect = Select()
		
		llReturn = This.BeforeSave()
		
		If !IsObject(This.oData) or Empty(This.cFilename) or !llReturn
			Select(lnSelect)
			Return .f.
		EndIf

		*-- If using cIdTable to assign PK's, we'll assign the PK now if it is not already assigned.
		*-- Note: see the lPreAssignPK property if you want the PK assigned during the New() or NewItem() method call.
		*-- If cIdTable is blank, then no PK will be assigned here at, so you better make sure the database is setup
		*-- to auto-assign a PK.
		If Empty(This.PK) and !Empty(This.cIdTable)
			lnNewPK = This.CreateNewId()
			This.PK = lnNewPK
			This.nUpdateMode = 2 && 2 = New record.
			
			*-- The PK shouldn't be empty at this point...
			If IsNullOrEmpty(This.PK) And Not(This.cPkField $ This.cSkipFieldsForUpdates)
				This.SetError('Primary Key value required before saving to database. It is currently empty or could not be assigned.')
				Return .f.
			EndIf
			
			llPkAssigned = .t.
		Endif		
		
		If This.lSetNullableFieldsNull
			This.SetNullableFields() && Handles oData values for any Nullable fields on DB table.
		Endif

		This.oValidationErrors = .null.
		
		llValidated = .f.
		
		If This.lValidateOnSave
			llValidated = This.Validate()
			If !llValidated
				Return .f.
			Endif
		Endif
		
		llHasDataChanged = This.HasDataChanged()
				
		*-- Under certain circumstances, if oData has not changed, then we do not continue any further;
		*-- since no data changed, no need to send Update command to Database.
		If This.lCompareUpdates and !llHasDataChanged and (llValidated or !This.lValidateOnSave)
				If !tlDoNotCallAfterSave
					This.AfterSave(llHasDataChanged)
				Endif
				Return .t.
		Endif

		If PemStatus(This.oData, 'created_at', 5) and This.nUpdateMode = WW_NEWRECORD and IsNullOrEmpty(This.oData.created_at) && (Only if new record)
			This.oData.created_at = Datetime()
		Endif

		If PemStatus(This.oData, 'updated_at', 5) and This.nUpdateMode = WW_UPDATERECORD && Editing record
			This.oData.updated_at = Datetime()
		EndIf
		
		RemoveProperty(This.oData, '__CINSPECTORKEY') && This property is added by tool Object Inspector, so we need to remove it.

		llReturn = wwBusinessObject::Save()
		
		Select(lnSelect)
				
		If llReturn = .t.
			This.lFound = .t.
		Else
			This.LogError(This.oSql.cErrorMsg, This.oSql.cSql)
			If llPkAssigned
				This.PK = 0 && Clear it out if it was blank before and we assigned one above
			Endif
		Endif

		*-- For DBF Mode:
		*-- In the case where we just saved a new record and the table uses an AutoInc PK field,
		*-- we need to update the oData object since the PK value will have just now been assigned.
		*-- For DBF tables, this relies on the fact that the DoDefault() method has left the record pointer
		*-- on the newly created record, so we can just do a Scatter command to get the assigned PK.
		If This.nDataMode = 0 and llReturn && Native DBF
			Select (This.cCursor)
			Scatter Name This.oData Memo Additive
		EndIf
		
		*-- For Sql Server mode:
		*-- We want to update the local cursor row to match the values on oData that were saved to the DB.
		*-- In the case where you're saving a new record, make sure the object has a unique PK assigned to
		*-- oData before saving, or else you will need to wrap this code to somehow get the PK that gets 
		*-- assigned from Sql Server. I.e. See the CreateNewID() method, or use some other technique.
		If This.nDataMode = 2 && Sql Server mode
			If Used(This.cCursor) and Reccount(This.cCursor) > 0 and !Eof(This.cCursor)
				This.SaveToCurrentRow()
			EndIf
		EndIf

		If llReturn
			This.UpdateOriginalDataCursor()
			If !tlDoNotCallAfterSave && This parameter is passed as .t. when wwBusPro class is calling Save()
				This.AfterSave(llHasDataChanged)
			Endif
		Endif
		
		Select(lnSelect)
		
		Return llReturn
		
	EndProc
	
	*---------------------------------------------------------------------------------------
	*-- If we're using lCompareUpdates we'll have an XXXX_Original cursor, so we need to update the corresponding row in that
	*-- cursor to be up to date with the latest changes that we've written to the database.
	Procedure UpdateOriginalDataCursor()
	
			Local lcOriginalCursor, lcWhere, lcWhereClause, lnSelect

			lnSelect = Select()
			
			lcOriginalCursor = This.cCursor + "_original"

			*-- If we are using lCompareUpdates, we also need to load up oOrigData from its cursor
			If This.lCompareUpdates and Used(lcOriginalCursor)
				If Vartype(This.PK) = 'C'
					lcWhereClause = This.cPKfield + "= '{0}'"
				Else
					lcWhereClause = This.cPKfield + "= {0}"
				Endif			
			
				*-- Get the original record with matching PK and scatter it to oOrigData
				lcWhere = StringFormat(lcWhereClause, This.PK)
				Select(lcOriginalCursor)
				Locate For &lcWhere
				If Found()
					Gather Name This.oData Memo
					Scatter Name This.oOrigData Memo Additive
				Endif
			EndIf
			
			Select (lnSelect)

	Endproc


*|================================================================================ 
*| wwBusinessPro::
*| Positions the cCursor to the correct record based on PK, then copies from oData to current row in cursor.
	Procedure UpdateCursor
	
		Local llReturn

		llReturn = This.LocateCursor()
		
		If llReturn
			This.SaveToCurrentRow()
		EndIf
		
		Return llReturn
	
	Endproc



*|================================================================================ 
*| wwBusinessPro::
*| Positions pointer in This.cCursor to the record which matches the PK of the current oData object.
	Procedure LocateCursor

		Local lcPkField, lcCursor, lnSelect, llReturn

		lcCursor = This.cCursor
		lcPkField = This.cPKField

		If Used(lcCursor)

			lnSelect = Select()
			Select (lcCursor)

			Locate for &lcPkField = This.PK
			llReturn = Found()
			
			Select (lnSelect)

		EndIf
		
		Return llReturn
	
	Endproc
	

*|================================================================================ 
*| wwBusinessPro::
*| Copies data values from This.oData to the current row in the supporting local cursor.
*| Will add a new row by calling NewItem() if cursor is empty.
	Procedure SaveToCurrentRow
	
		Local lcCursor, lnSelect

		lcCursor = This.cCursor

		If Used(lcCursor)

			lnSelect = Select()
			Select (lcCursor)

			Gather Name This.oData Memo

			Select (lnSelect)

		Endif
		
	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
*| Scatters data from current row in cCursor to oData, then calls Save() method.
	Procedure SaveFromCurrentRow()

		Local llReturn

		This.LoadFromCurrentRow()
		
		llReturn = This.Save()
		
		Return llReturn
	
	Endproc
	

*|================================================================================ 
*| wwBusinessPro::
*| This is a total override of the base wwBusinessChildCollection.SaveToCursor() method.
*| It works over the local cCursor to save changes in each row back to the DB.
*| Note: The llCollectionHoldsClass and llUseTransaction parameters are received for compatibility, but are not used.
*| This method scans over all the rows in the local cCursor and calls the Save() method, which, for Child Item classes,
*| the Save() method is actually overridden in the base class to call the SaveBase() method in this class.
	Procedure SaveToCursor(llCollectionHoldsClass, llUseTransaction))

		Local lcDeleted, lcOriginalCursor, lcWhereClause, llCallSave, llReturn, lnRecNo, lnSeconds, lnSelect
		Local llLoadRelatedObjects
		Local laNonDeletedRecordIsPresent[1], lcWhereClause
		Local llHasDataChanged, llHaveAnyChildRecordsChanged, lnSaveCount, lnDeleteCount
		Local lcPkField, lcWhereClauseTemplate, lnRecno, lcMessage

		This.SetError()

		If !This.lReadWrite or (!Empty(This.cCursor) and !Used(This.cCursor))
			Return .f.
		EndIf
		
		llReturn = This.ValidateProperties()

		If !llReturn
			Return .f.
		EndIf		
		
		This.lHasDataChanged = .f. && Start out with .f., will set .t. below if any records have in cursor have changed,
		
		If This.lWriteActivityToScreen
			? "Saving to DB: " + This.cFriendlyClassName + " from cursor [" + This.cCursor + "]"
		EndIf

		lnSelect = Select()
		llHaveAnyChildRecordsChanged = .f.
		lnDeleteCount = 0
		lnSaveCount = 0

		If !Empty(This.cCursor) and Used(This.cCursor) && If cCursor property is empty or not used, we will work on the current active cursor.
			Select (This.cCursor)
		EndIf
		
		If RecCount() = 0
			If This.lWriteActivityToScreen
				? "   >  No records to save in cursor: " + Alias()
			EndIf
			Return
		EndIf
		
		lnRecNo = Recno()
		lcDeleted = Set("Deleted")
		Set Deleted Off  && We need this off so we can see deleted records in the local cursor,
						 && so we can delete from the real table.
		
		lnSeconds = Seconds()
		
		lcPkField = This.cPKfield
		
		If Vartype(This.PK) = "C"
			lcWhereClauseTemplate = lcPkField + "= '{0}'"
		Else
			lcWhereClauseTemplate = lcPKfield + "= {0}"
		Endif	
		
		*-- Need to delete any Deleted() records first...
		Scan For Deleted() and !Empty(&lcPkField)
			lcWhereClause = StringFormat(lcWhereClauseTemplate, id)

			*-- If there is a non-deleted copy of the deleted record in the cursor, then don't delete, because the saving of the
			*-- non-delete record with write it back anyway.
			Select * From (This.cCursor) Where &lcWhereClause and Deleted() = .f. Into Array laNonDeletedRecordIsPresent
			If _Tally = 0
				This.LoadFromCurrentRow() && Load up oData & oOrigData objects for current row. Will also load any Related Objects.
				lnRecno = Recno() && We store current Recno and restore below, in case call to .Delete() moves the record pointer.
				llReturn = llReturn And This.Delete() && Delete any child records from the real table that have been deleted from the local cursor.
				GotoRecord(lnRecno)
				If llReturn
					lnDeleteCount = lnDeleteCount + 1
				Endif
			Endif
		EndScan

		*-- Now save any remaining (non-deleted) or new records...
		Scan For Deleted() = .f.
			This.LoadFromCurrentRow() && Load up oData & oOrigData objects for current row. Will also load any Related Objects.

			llHasDataChanged = This.HasDataChanged() && Compare oData with oOrigData for current record
			llHaveAnyChildRecordsChanged = llHaveAnyChildRecordsChanged or llHasDataChanged
			
			If This.lCompareUpdates and !llHasDataChanged
				llCallSave = .f. && No need to call Save() method if data has not changed
			Else
				llCallSave = .t.
			Endif
			
			*-- Note: If the PK values are pre-assigned when adding new records, we have no way of knowing whether each row in this cursor
			*-- is a new or existing record.
			*-- So, by setting nUpdateMode to Edit here, it will force the Save() method in wwBusinessPro and wwBusiness to 
			*-- do a lookup by PK from the target table to determine if a record with this ID already exists and it will
			*-- determine if an Update or an Insert is needed.
			If llCallSave 
				This.nUpdateMode = 1 && Set it to Edit mode. See notes above.
				lnRecno = Recno() && We store current Recno and restore below, in case call to .Save() moves the record pointer.
				llReturn = llReturn And This.Save() && Save record. Will also handle creating new DB record for each new row in local cursor
				GotoRecord(lnRecno)
				If llReturn
					lnSaveCount = lnSaveCount + 1
				Endif
			EndIf
		
		EndScan
		
		If This.lWriteActivityToScreen
			If !Empty(lnDeleteCount) or !Empty(lnSaveCount)
				lcMessage =  "   > " + Transform(lnDeleteCount) + " records deleted.  " + Transform(lnSaveCount) + " records added or updated."
			Else
				lcMessage = "   > No records changed."
			EndIf
			If This.lWriteActivityToScreen
				? lcMessage
			Endif
		Endif
		
		This.lHasDataChanged = llHaveAnyChildRecordsChanged
		
		This.nSaveToCursorTime = Seconds() - lnSeconds

		*-- Restore record pointer to original location
		GotoRecord(lnRecNo)

		This.LoadFromCurrentRow()

		Set Deleted &lcDeleted

		Select (lnSelect)

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*-- This method is called by the New() and NewItem() methods after they create a new oData, then this
*-- method is called so you can set any default values. You'll need to override this method in each of your
*-- business objects if needed.
	Procedure SetDefaultsForNewRecord

	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure CheckIfKeyValueIsAvailable(tcKeyValue, tnIgnorePK)

		Local lcSql, lnReturn, lcIgnore

		lnSelect = Select()

		If !Empty(tnIgnorePK)
			lcIgnore = " and " + This.cPKField + " != " + Transform(tnIgnorePK)
		Else
			lcIgnore = ""
		EndIf
		
		Text To lcSql TextMerge NoShow PreText 15

		   Select <<This.cLookupField>>
		       From <<This.cFromAlias>>
		       Where Alltrim(<<This.cLookupField>>) == '<<Alltrim(tcKeyValue)>>'
		             <<lcIgnore>>

		Endtext

		lnReturn = This.Query(lcSql)

		Select(lnSelect)

		Return (lnReturn = 0)
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure cKeyValueRef_Access
	
		If !Empty(This.cCursor) And !Empty(This.cLookupField)
			Return This.cCursor + '.' + This.cLookupField
		Else
			Return ''
		EndIf
		
	EndProc
	
	

*|================================================================================ 
*| wwBusinessPro::
	Procedure SetError(tcErrorMsg, tnErrorNo, tcSql)

		Local lcAssertMessage, lcErrorMessage, lcMessage, lcMessagePrefix, lcPrefix, lcSql, lnErrorRows
		Local lnPcount, x, y, laErrors
		Local lcJson, lnErrorColumns
		Local loSerializer
		Local loError as 'Empty'

		*-- Base wwBusiness.Load() may have called this method with the following strings, which 
		*-- wwBusinessPro does not regard as hard "errors", but rather as messages, so,
		*-- we'll ignore them.

		This.nError = 0

		*-- Do not log error is message contains any of these text fragments:
		If Pcount() = 0 or InList(Evl(tcErrorMsg, 'XXXXXX'), ;
							'Load failed - no key passed.', ;
							'GetRecord - Record not found.', ;
							'No match found.')
			Return
		Endif

		*-- To allow the user account used by wwBusiness Connection String to run Stored Procedures:
		*-- In Sql Server, select the Database and go to Security->Schema->dbo. and double-click dbo... then click on Permission tab->(blue font) View database permission and
		*-- scroll down to the field "Execute" click checkbox in the Grant column.
		If Lower("The EXECUTE permission was denied on the object") $ Lower((Evl(tcErrorMsg, 'XXXXXX')))
			MessageBox(tcErrorMsg + Chr(13) + Chr(13) + "You need to grant Execute permissions in Sql Server for this user account so wwBusiness can run stored procedures.")
			
		Endif

		lnPcount = Pcount()

		tnErrorNo = Evl(tnErrorNo, 0)
		This.nError = tnErrorNo

		If lnPcount > 0

			If IsObject(This.oSql)
				lcSql = This.oSql.cSql
			Else
				lcSql = This.cSql
			EndIf

			lcSql = Evl(tcSql, lcSql) && Used pass in Sql clause if passed
			
			*-- This is some special handling that will capture the oData values for certain common error messages
			*-- that may come back from Sql Server.
			*-- We add an additional separate log entry to help troubleshoot these errors.
			If !Empty(tcErrorMsg)
				If Lower("String or binary data would be truncated") $ Lower(tcErrorMsg) or ;
				   Lower("The INSERT statement conflicted with the FOREIGN KEY constraint") $ Lower(tcErrorMsg) or ;
				   Lower("Violation of PRIMARY KEY constraint") $ Lower(tcErrorMsg)
					loSerializer = CreateWWBO("wwJsonSerializer")
					If IsObject(loSerializer)
						lcJson = loSerializer.Serialize(This.oData)
						lcJson = loSerializer.FormatJson(lcJson)
						lcMessage = tcErrorMsg + Chr(13) + ;
									"Class: " + This.Class + Chr(13) + ;
									"Sql: " + Evl(lcSql, "") + Chr(13) + ;
									"oData: " +  Chr(13) + lcJson
						This.LogError(lcMessage)
					Else
						This.LogError("Error: Could not create wwJsonSerializer object from wwBusinessPro.SetError() method.")
					Endif
					
				EndIf
			Endif

			This.nErrorCount = This.nErrorCount + 1
			
			*-- If this is a Child BO (wwBusinessProItemList class), then record an error on the Parent BO also.
			If Type('This.oParentBO') = 'O'
				lcPrefix = 'Child BO [' + Proper(This.Name) + '] on ParentBO [' + Proper(This.oParentBO.Name) + ']  - Error: '
				This.oParentBO.Seterror(lcPrefix + tcErrorMsg, tnErrorNo, lcSql)
			Endif

			lcMessagePrefix = 'Object Name: ' + Proper(This.Name) + '    Object Class: ' + This.Class
			lcMessage = ' [Error code: ' + Alltrim(Str(This.nError)) + ']  ' + tcErrorMsg
			lcAssertMessage = 'Bus Obj Error:' + Chr(13) + ;
								lcMessagePrefix + Chr(13) + ;
								tcErrorMsg

			*-- If the passed error matches the current error on oSql, then assume that this call was made by a failure
			*-- in the call to the Query(). So, the Query() method only reports 1 error message from oSql, but there
			*-- might be more than 1 error on the oSql.aError, so, let's handle them all instead of just the single one passed.
			If IsObject(This.oSql) and tcErrorMsg = This.oSql.cErrorMsg and !Empty(This.oSql.cErrorMsg)
				lnErrorRows = Alen(This.oSql.aErrors, 1)
				lnErrorColumns = Alen(This.oSql.aErrors, 2)
				Dimension laErrors[lnErrorRows, lnErrorColumns]
				Acopy(This.oSql.aErrors, laErrors) && Need a copy now, because calls to Log() below will clear out the current error array.
				For x = 1 to lnErrorRows
					loError = Createobject('Empty')
					*-- Columns 2 & 3 may contain helpful info, so let's log both strings
					lcErrorMessage = ''
					For y = 2 to Min(lnErrorColumns, 3)
						lcErrorMessage = lcErrorMessage + Evl(laErrors[x, y], '') + Chr(13)
						If This.lLogErrors
							*If y = 2 or (y = 3 and Atc(laErrors[x, 3], laErrors[x, 2]) = 0)
								This.LogError('[' + Transform(x) + ']: ' + laErrors[x, y], lcSql)
							*Endif
						EndIf
					Endfor
					AddProperty(loError, 'ErrMsg', lcErrorMessage)
					AddProperty(loError, 'Class', This.Class)
					AddProperty(loError, 'Name', This.Name)
					AddProperty(loError, 'ErrNo', This.nError)
					AddProperty(loError, 'Sql', lcSql)
					AddProperty(loError, 'aErrArray', laErrors)
					This.oErrors.Add(loError)
					This.cErrorMsg = lcErrorMessage
				EndFor
			Else
				If This.lLogErrors
					This.LogError(tcErrorMsg, lcSql)
				EndIf
				loError = Createobject('Empty')
				AddProperty(loError, 'ErrMsg', tcErrorMsg)
				AddProperty(loError, 'Class', This.Class)
				AddProperty(loError, 'Name', This.Name)
				AddProperty(loError, 'ErrNo', This.nError)
				AddProperty(loError, 'Sql', lcSql)
				*AddProperty(loError, 'aErrArray', This.oSql.aErrors)   && This.oSql is null if we got to this point. Can't reference it!!

				This.oErrors.Add(loError)
				This.cErrorMsg = tcErrorMsg
			Endif

			*-- Display error in a dialog box, if lShowErrors is enabled.
			*-- If this BO has a ParentBO, then use ParentBO setting, otherwise use local
			If Type("This.oParentBO") = "O"
				If This.oParentBO.lShowErrors = .t.
					This.DisplayErrors()
				Endif
			Else
				If This.lShowErrors = .t.
					This.DisplayErrors()
				Endif
			EndIf

			This.lError = .t.

		Endif
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure SetMessage(tcMessage, tnCode, tlDoNotLog)

		Local loMessage As Empty
		Local loMessages As Collection

		loMessages = This.oMessages
		loMessage = CreateObject('Empty')

		AddProperty(loMessage, 'cMessage', Evl(tcMessage, ''))
		AddProperty(loMessage, 'nCode', Evl(tnCode, 0))
		AddProperty(loMessage, 'dWhen', Datetime())
		AddProperty(loMessage, 'cObjectClass', This.Class)

		loMessages.Add(loMessage)

		If This.lLogMessages and !tlDoNotLog
			*-- Passing '_' to Log() method so it won't record Sql Select statement as it usually does not apply 
			*-- when a Message is being logged.
			This.Log('Code No: ' + Transform(Evl(tnCode, 0)) + ': ' + tcMessage, 'MESSAGE', '_')
		EndIf
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
*-- A method stub for your subclass code to perform any calculations needed when a new record or record set is loaded.
*-- This method is called by wwBusinessPro.LoadFromCurrentRow()
*-- Also note that LoadFromCurrentRow() is called by wwBusinessProItemList.AfterLoadLineItems()
	Procedure Update

		*-- Be sure to wrap your subclass code to restore the current alias to the original alias to prevent any problems.
		*-- And, if working with a child cursor, be sure to restore the record pointer to the same place it was.

		*-- i.e.:

		* lnSelect = Select()

		* << Your code here >>

		* Select (lnSelect)
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure ValidateProperties

		Local llReturn

		llReturn = .t.

		If Empty(This.cPKfield)
			This.SetError('Cannot save child records. Property [cPKfield] cannot be empty.  Object: ' + This.Name)
			llReturn = .f.
		Endif

		*-- We cannot assume it's an error if the BO is now marked as ReadWrite ----
		* If !This.lReadWrite
		* 	This.SetError('Cannot save these records as this cursor is not marked as lReadWrite = .t.  Object: ' + This.Name)
		* 	llReturn = .f.
		* Endif

		If Empty(This.cFilename)
			This.SetError('Property cFilename is empty, but should contain the table name to store these records. Object: ' + This.Name)
			llReturn = .f.
		Endif

		If Empty(This.cCursor)
			This.SetError('Property cCursor is empty, but should contain the local cursor name with the records to save. Object: ' + This.Name)
			llReturn = .f.
		Endif

		Return llReturn
		
	EndProc


*|================================================================================ 
*| wwBusinessPro::
	Procedure CalculateValue(tcSelectClause)

		Local lcSql, lcWhereClause, lnReturn, lnSelect, laTemp[1]

		*-- Runs a SQL statement against the local cCursor records to calculate and return a single value from 
		*-- the query. The passed clause is usually a sum, min, max, etc. 
		*-- Note: This runs against the local cCursor, regardless of whether the permanent data is stored in a DBF table
		*-- or in Sql Server.
		
		*-- Example:  CalculateValue('Sum(qty * price)')

		If Empty(tcSelectClause) Or Empty(This.cCursor) Or !Used(This.cCursor)
			lnReturn = 0
		Else
			If Type('This.oParentBO.oData') = 'O'
				lcWhereClause = ' Where ' + This.cFKField + ' = ' + Transform(This.oParentBO.PK)
			Else
				lcWhereClause = ''
			Endif

			Text To lcSql TextMerge NoShow PreText 15
	
			    	Select <<Alltrim(tcSelectClause)>> 
			    	From <<This.cCursor>> With (Buffering = .t.)
			        <<lcWhereClause>>
			        Into Array laTemp 

			EndText
			
			&lcSql
			
			lnReturn = Nvl(laTemp, 0)
			
		Endif

		Return Nvl(lnReturn, 0)
		
	EndProc

*|================================================================================
*| wwBusinessPro:: 
	Procedure ClearSqlParameters()
	
		This.oSql.AddParameter("CLEAR")

	Endproc


*===========================================================================================================================
*===========================================================================================================================
*===========================================================================================================================
*-- The following methods were copied from wwBusinessChildCollection class of wwBusinessObject from West Wind, Version 7.0,
*-- with slight modfications as needed to work with the a local cursor, and other Parent interaction designed into wwBusinessPro.
*-- wwBusinessProItemList is primarily designed to work in a cursor-based manner (not with
*-- arrays like the wItemList class in that ver of wwBusiness was designed to do), but, these selected methods from the original
*-- wwItemList class give access to some of the the array-based functionality of the original wwItemList.
*-- Note: If wwBusinessChildCollection code for these methods changes in the wwBusiness framework, updates here may be necessary.
*===========================================================================================================================
*===========================================================================================================================
*===========================================================================================================================

*|================================================================================
*| wwBusinessPro:: (from wwBusinessChildCollection class)
	Procedure oRows_Access
	
		If Isnull(This.oRows)
			This.oRows = Createobject("Collection")
		Endif
		Return This.oRows
		
	Endproc

*|================================================================================
*| wwBusinessPro:: (from wwBusinessChildCollection class)
	Procedure nCount_Access()
	
		Return This.oRows.Count
		
	EndFunc

*|================================================================================
*| wwBusinessPro:: (from wwBusinessChildCollection class)
*| Blanks out the local cCursor and the oRows collection.
	Procedure Clear()
	
		Local loRows as Collection

		This.GetBlankRecord()
		This.LoadLineItems(-1)
		loRows = This.oRows.Remove(-1) && Remove all items from collection

	Endproc

*|================================================================================
*| wwBusinessPro:: (from wwBusinessChildCollection class)
*| Adds passed object to the oRows collection, but does not add it to the local cCursor.
	Procedure Add(loItem)

		This.oRows.Add(loItem)

	Endproc

*|================================================================================
*| wwBusinessPro:: (from wwBusinessChildCollection class)
	Procedure Item(lnIndex)

		If lnIndex < 1 Or lnIndex > This.nCount
			Return .Null.
		Endif

		Return This.oRows.Item(lnIndex)
		
	Endproc


*|================================================================================
*| wwBusinessPro:: (from wwBusinessChildCollection class)
	Procedure LoadFromCursor(tlLoadBusinessObjects)

		Local lnSelect, lnX

		lnSelect = Select()
		
		This.oRows.Remove(-1) 
		
		Scan
			If tlLoadBusinessObjects
				loItem = Createobject(This.Class)
				lcPk = loItem.cPkField
				loItem.Load( Evaluate(lcPk) )
			Else
				Scatter Name loItem Memo
			Endif
			This.oRows.Add(loItem)
		Endscan

		Select(lnSelect)

		Return This.oRows.Count
		
	EndProc
	

*|================================================================================ 
*| wwBusinessPro::
*|
*| Note: Validation Errors on oValidataionErrors collection are different that Errors on oErrors collection
*---------------------------------------------------------------------------------------
	Procedure DisplayValidationErrors
	
		Local lcValidationErrors

		If IsObject(This.oValidationErrors) and This.oValidationErrors.Count > 0
			lcValidationErrors = This.oValidationErrors.ToString()
			MessageBox(lcValidationErrors, 64, "Validation Errors:")
		Endif
	
	Endproc

	
*|================================================================================ 
*| wwBusinessPro::
	Procedure lHasValidationErrors_Access
	
		If IsObject(This.oValidationErrors) and This.oValidationErrors.Count > 0
			Return .t.
		Else
			Return .f.		
		Endif
	
	Endproc

*|================================================================================ 
*| wwBusinessPro::
	Procedure lHasErrors_Access
	
		If IsObject(This.oErrors) and This.oErrors.Count > 0
			Return .t.
		Else
			Return .f.		
		Endif
	
	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
	Procedure lHasMessages_Access
	
		If IsObject(This.oMessages) and This.oMessages.Count > 0
			Return .t.
		Else
			Return .f.		
		Endif
	
	EndProc

*|================================================================================ 
*| wwBusinessPro::
	Procedure Track(tcAction, tuRef1, tuRef2, tuRef3, tuRef4, tuRef5)
	
		If Type([WWBUSINESSPRO_TRACKER_OBJECT]) = 'O'
			WWBUSINESSPRO_TRACKER_OBJECT.WWBUSINESSPRO_TRACKER_METHOD(This, tcAction, tuRef1, tuRef2, tuRef3, tuRef4, tuRef5)
		Endif
		
	EndProc
	
*|================================================================================ 
*| wwBusinessPro::
	Procedure SetLoggingProperty(tcProperty, tcValue)

		AddProperty(This, tcProperty, tcValue)
		
		If IsObject(This.oBusObjManager)
			For Each loObject in This.oBusObjManager.oChildItems
				AddProperty(loObject, tcProperty, tcValue)
			Endfor

			For Each loObject in This.oBusObjManager.oRelatedObjects
				AddProperty(loObject, tcProperty, tcValue)
			Endfor
		EndIf
		
	EndProc
	
	
*|================================================================================ 
*| wwBusinessPro::
*| This method queries <<This.cHistoryFields>> table for <<This.cHistoryFields>> fields based on
*| a match of [Type] = '<<This.cTrackerKey>>' and [Key] = <<This.PK>> with an Order By clause of
*| Order by [when], [id].
*| So, you can see there are some class properties used to configure some parts of this query,
*| But the Where clause and the Order By clause are depended on certain specific field names in the table.
*| See comments below to code for a Create Table command that contains the presumed fields in the Where/Order By clauses,
*| along with some other fields that were present in a model Tracker tracker table used by the original author
*| of wwBusinessPro.

	Procedure GetHistory(tcCursor)
	
		Local lcSql, lnReturn, lnSelect

		lnSelect = Select()

		Text To lcSql TextMerge NoShow PreText 15

			Select <<This.cHistoryFields>>
				From WWBUSINESSPRO_TRACKER_TABLE
				Where [Type] = '<<This.cTrackerKey>>' and [Key] = <<This.PK>>
				Order by [when], [id]

		EndText

		lnReturn = This.Query(lcSQL, tcCursor)

		Select(lnSelect)

		Return lnReturn
		
		
		*!* T-SQL code below can be used to create a Tracker table with fields required for the above query.
		*!* This table will include the presumed fields in the Where/Order By clauses of the query above
		*!* along with some other fields that were present in a model Tracker tracker table used by the original author
		*!* of wwBusinessPro.
		
		*!*						
		*!*				/****** Object:  Table [dbo].[Tracker]    Script Date: 01/04/2019 3:13:56 PM ******/
		*!*				SET ANSI_NULLS ON
		*!*				GO

		*!*				SET QUOTED_IDENTIFIER ON
		*!*				GO

		*!*				CREATE TABLE [dbo].[Tracker](
		*!*					[id] [int] NOT NULL,
		*!*					[userkey] [int] NOT NULL,
		*!*					[user] [char](3) NOT NULL,
		*!*					[when] [datetime] NULL,
		*!*					[app] [varchar](50) NOT NULL,
		*!*					[action] [varchar](50) NOT NULL,
		*!*					[key] [int] NOT NULL,
		*!*					[KeyValue] [varchar](50) NULL,
		*!*					[ref1] [varchar](50) NOT NULL,
		*!*					[ref2] [varchar](50) NOT NULL,
		*!*					[ref3] [varchar](50) NOT NULL,
		*!*					[ref4] [varchar](50) NOT NULL,
		*!*					[ref5] [varchar](50) NOT NULL,
		*!*					[form] [varchar](50) NOT NULL,
		*!*					[type] [varchar](50) NULL,
		*!*				 CONSTRAINT [PK_tracker] PRIMARY KEY NONCLUSTERED 
		*!*				(
		*!*					[id] ASC
		*!*				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		*!*				) ON [PRIMARY]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_id]  DEFAULT ((0)) FOR [id]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_userkey]  DEFAULT ((0)) FOR [userkey]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_user]  DEFAULT ('') FOR [user]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_app]  DEFAULT ('') FOR [app]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_action]  DEFAULT ('') FOR [action]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_key]  DEFAULT ((0)) FOR [key]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_ref1]  DEFAULT ('') FOR [ref1]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_ref2]  DEFAULT ('') FOR [ref2]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_ref3]  DEFAULT ('') FOR [ref3]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_ref4]  DEFAULT ('') FOR [ref4]
		*!*				GO

		*!*				ALTER TABLE [dbo].[Tracker] ADD  CONSTRAINT [Dflt_tracker_ref5]  DEFAULT ('') FOR [ref5]
		*!*				GO
		
		
	Endproc

	
*|================================================================================ 
*| wwBusinessPro::
	Procedure RefreshForm()
	
		If IsObject(This.oForm)
			This.oForm.Refresh()
		Endif
	
	Endproc
		
		
*|================================================================================ 
*| wwBusinessPro::
	Procedure cFriendlyClassName_Access
	
		Return Evl(This.cFriendlyClassName, This.Class)
	
	Endproc
	
*|================================================================================ 
*| wwBusinessPro::
	Procedure RollBack(tnBeforeSavePK)
	
		*-- If Parent PK was Empty before Parent Save() was called, we must set it back to Empty on Parent BO and any Child Cursors
		*-- since we are rolling back. We cannot keep the currently assigned PK value since changes were rolled back from all tables
		*-- including the the wws_id table which gave Parent this PK value since it didn't already have one.
		If Empty(tnBeforeSavePK)
			If VarType(This.oBusObjManager) = "O"
				This.oBusObjManager.ClearFkValuesOnChildCursors()
			Endif
			This.PK = 0
			This.SaveToCurrentRow()
		Endif
		If This.nDatamode = 2
			This.oSql.RollBack()
		EndIf
		If This.lWriteActivityToScreen
			? "*** ROLLBACK: Data failed validation, or error saving Parent or Children to DB. ***"
		Endif

	Endproc

*|================================================================================ 
*| wwBusinessPro::
*| Screen output to explain what did and/or not change, if enabled.
	Procedure ScreenLogEdits(tlWorkingWithNewRecord, tlParentDataChanged, tlChildItemsHadChanges)
	
		If This.lWriteActivityToScreen
			If !tlParentDataChanged and !tlChildItemsHadChanges
				If This.lWriteActivityToScreen
					? "No changes to data. Therefore, no data was written to the database."
				Endif
			Else
				*-- Output about to Parent...
				If tlWorkingWithNewRecord and This.lWriteActivityToScreen
						? "New Parent record was written to database."
				Else
					If tlParentDataChanged and This.lWriteActivityToScreen
						? "Parent data was changed. Data saved to database."
					EndIf
				Endif
				*- Output about Child items, if any had changes
				If tlChildItemsHadChanges and This.lWriteActivityToScreen
					? cc_LineItemChanges
				EndIf
			Endif
		EndIf	
				
	Endproc

*|================================================================================ 
*| wwBusinessPro::
	Procedure LogEdits(tlWorkingWithNewRecord, tlChildItemsHadChanges)

		Local lcSaveAction, lcRef1, lcInsertAction, lcUpdateAction
		
		lcInsertAction = This.cInsertAction
		lcUpdateAction = This.cUpdateAction

		*-- Write an entry to the Tracker log to record this transaction...
		If This.lTrackAddOrEdit and Type([WWBUSINESSPRO_TRACKER_OBJECT]) = "O"
			If tlWorkingWithNewRecord
				lcSaveAction = lcInsertAction
			Else
				If This.lHasDataChanged or tlChildItemsHadChanges
					lcSaveAction = lcUpdateAction
				Else
					lcSaveAction = ""
				Endif				
			EndIf
			
			If !Empty(lcSaveAction) or tlChildItemsHadChanges
				lcRef1 = Iif(tlChildItemsHadChanges, cc_LineItemChanges, "")
				WWBUSINESSPRO_TRACKER_OBJECT.WWBUSINESSPRO_TRACKER_METHOD(This, lcSaveAction, lcRef1)
			Endif
		EndIf
		
	Endproc
			
			
	
EndDefine


                                                                                                                                                        