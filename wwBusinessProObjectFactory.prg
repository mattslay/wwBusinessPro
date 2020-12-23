#INCLUDE wwBusinessPro.h

*-- The main usefullness of this class is that it has code and properties that will call the Dispose() method
*-- on any object that it creates once this object instance is destoryed. All of the BO classes in wwBusinessPro
*-- have a Dispose() method to clean up when object references they are disposed, and this class will invoke
*-- that Dispose() method fo all objects created throught this class in the the CreateWWBO(), CreateWWEmptyBO(),
*-- and CreateWWChildBO() methods.
Define Class wwBusinessProObjectFactory as Custom

	lDispose = .t.
	oObjects = .null.
	
	*---------------------------------------------------------------------------------------
	Procedure Init(tlDoNotDispose)
	
		If tlDoNotDispose
			This.lDispose = .f.
		EndIf
		
		This.oObjects = CreateObject("Collection")
	
	Endproc
	
	*---------------------------------------------------------------------------------------
	Procedure TrackObject(toObject)
	
		This.oObjects.Add(toObject)
	
	EndProc
	
	*---------------------------------------------------------------------------------------
	Procedure Destroy
	
		Local loObject
	
		If !This.lDispose
			Return
		Endif
	
		For Each loObject in This.oObjects FOXOBJECT
		
			If Vartype(loObject) = 'O' and !IsNull(loObject) and PemStatus(loObject, 'Dispose', 5)
				*? loObject.Class + " disposed."
				loObject.Dispose()
			Endif
			
		Endfor
		
	Endproc

	*---------------------------------------------------------------------------------------
	*-- tcClass is a key lookup value for wwBusinessObjects table.
	Procedure CreateWWBO(tcClass, tlLoadChildItems, toParent, tlLoadRelatedObjects)

		*-- Note: This function uses many constant values from wwBusinessPro.h file that you must correctly assign
		*-- before this code will work to create a Business Object from the wwBusinessObjects dictionary table.
		Local lnSelect, loObject
		Local lcLogMessage, lcParentClass
		Local loFactory as wwBusinessProFactory of wwBusinessProFactory.prg
		Local loAppObject as wwBusinessProAppObject of wwBusinessProAppObject.prg

		If Empty(tcClass)
			Return .f.
		Endif

		If Pcount() < 4
			tlLoadRelatedObjects = WWBUSINESSPRO_LOAD_RELATED_OBJECTS && Read from include file if parameter not passed
		Endif

		lnSelect = Select()

		loFactory = CreateObject('wwBusinessProFactory') && Create my Factory Object that is designed to instantiate WestWind Web Client BO's.
		loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT

		*-- Set properties here if you want to override the values in the wwBusinessProFactory class, before it creates the object
		*-- These Factory values will only be used if the corresponding field from the wwBusinessObject dictionary dbf is empty
		*-- See wwBusinessPro.h for where to set the constants
		With loFactory
			.cClassLookupTable =  WWBUSINESSPRO_FACTORY_DICT_TABLE && Must be in path. Class does not handle a path.
			.cUserDataPath = Addbs(WWBUSINESSPRO_USER_DATA_PATH) && The place where user provided data tables can be found (Temp hack for DBF mode only)
			.cConnectionString = WWBUSINESSPRO_SQL_CONN_STRING && See wwBusinessPro.h
			.cDataPath = Addbs(WWBUSINESSPRO_MAIN_DATA_PATH)  && Not presently used for anything
			.cIdTable = WWBUSINESSPRO_ID_TABLE
			.oSql = WWBUSINESSPRO_OSQL_REF
			
			*-- If using an Application Configuration Object, then set certain properties in the Factory from the App Config object. See wwBusinessPro.h
			If VarType(WWBUSINESSPRO_APP_CONFIG_OBJECT) = 'O' and WWBUSINESSPRO_APP_CONFIG_OBJECT.lSqlServer = .t.
				.nDataMode = WW_DATAMODE_SQL
			EndIf
			
			.cAppName = Nvl(WWBUSINESSPRO_APP_NAME, '')  && Set App name onto BO for logging purposes.  See wwBusinessPro.h
			.cModuleName = Nvl(WWBUSINESSPRO_APP_MODULE, '')

			Try
				.cUser = WWBUSINESSPRO_APP_USER		&& Set User name onto BO for logging purposes.  See wwBusinessPro.h
			Catch
			Endtry
				
			*-- Create a log message...
			If IsObject(toParent)
				lcParentClass = ":Parent:" + toParent.Class
			Else
				lcParentClass = ""
			Endif
			lcLogMessage = "Creating BO:" + tcClass + lcParentClass
			
			If IsObject(loAppObject.oSql)
				loAppObject.oSql.LogExecuteCall(lcLogMessage, 0, .t.)
			Endif

			*-- Create the Business Object by the requested key. This will also create Child Bus Objects and Related
			*-- Bus Objects, depending on passed values.
			loObject = .Make(tcClass, toParent, tlLoadChildItems, tlLoadRelatedObjects) && Will use the Lookup Table to determine exact object class to create,

		Endwith

		If IsObject(loObject)
			This.TrackObject(loObject)
		
			Try
				loObject.SetLoggingProperty('lLogErrors', WWBUSINESSPRO_APP_CONFIG_OBJECT.lSqlLog)		&& Log SQL Server query errors?
			Catch
			Endtry

			If Type('loObject.oBusObjManager') = 'O' and loObject.oBusObjManager.oChildItems.Count > 0
				loObject.GetBlankRecord() && Call this to create empty child cursors
			EndIf
		Else
			loAppObject.LogError("Error creating BO from passed key '" + tcClass + "'. Ensure PRG or VCX is included in Project.")
		Endif
		
		Select (lnSelect)
		
		Return loObject

	EndProc

	*===============================================================================================
	Procedure CreateWWBOChild(tcClass, toParent)

		*-- tcClass is a key lookup value for wwBusinessObjects table.

		Local llCreateChildObjects
		Local loObject

		llCreateChildObjects = .f.
		loObject = CreateWWBO(tcClass, llCreateChildObjects, toParent)
		
		Return loObject 

	EndProc

	*===============================================================================================
	* This method creates a BO, but without loading any Child or Related Objects that might be defined
	* for it in the Business Object Dictionary.
	Procedure CreateWWBOEmpty(tcClass)

		*-- tcClass is a key lookup value for wwBusinessObjects table.

		Local llCreateChildObjects, llCreateRelatedObjects
		Local loObject
	
		llCreateChildObjects = .f.
		llCreateRelatedObjects = .f.
		loObject = CreateWWBO(tcClass, llCreateChildObjects, .null., llCreateRelatedObjects)
		
		Return loObject 

	EndProc

Enddefine

