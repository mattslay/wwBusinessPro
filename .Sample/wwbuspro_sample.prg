*--------------------------------------------------------------------------------------------
* wwBusinessPro Data Access library for Visual FoxPro
*--------------------------------------------------------------------------------------------
*
*  Code sample for getting started with wwBusinessPro    (Rev. 2013-12-23)
*
*   To learn more about using wwBusinessPro data access library, see:
*
*   https://bitbucket.org/mattslay/wwbusinesspro/wiki/Home
*
*   and
*
*   http://mattslay.com/exploring-my-wwbusiness-extension-library for more details.
* 
*===============================================================================================
*
* Note: See wwBusinessPro.h where you can define connection string for SqlServer, and other settings.
* recompile all wwBusPro PRGs any time wwBusinessPro.h is modified.

*-- To run from the developer environment, you must setup all the Paths where the wwBusiness and
*-- wwBusinessPro files can be found:
Set Path To 'C:\Code\wwBusiness' Additive
Set Path To 'C:\Code\wwBusiness\Classes' Additive
Set Path To 'C:\Code\wwBusinessPro' Additive
Set Path To 'C:\Code\MyClasses' Additive
Set Path To 'C:\Data\MyAppData' Additive

Do Setup_wwBusinessPro in 'wwBusinessPro.prg' && This make several Set Procedure calls to load the classes.

Set Procedure To 'MyBusinessObjects.prg' Additive && This is *your* library of concrete BO classes based on wwBusinessPro classes

*-- Note ragarding MyBusinessObjects.prg: -------------
*-- You should create your own class file(s) (.prg files) for each business object/table in your app.
*-- (i.e. 'MyBusinessObjects.prg').
*-- 
*-- For Parent/Child setups:
*-- Base each Parent class off of class wwBusProParent in wwBusProParent.prg
*-- Base each Child class off of class wwBusProItemList in wwBusPusProItemList.prg

*-- In this example below, 'Job' is the concrete Parent class from your MyBusinessObjects.prg. 
*-- See/Set wwBusinessObjects.dbf for the property values that will get pushed onto this object
*-- any time it gets created by calling CreateWWBO().

*===============================================================================================
Procedure wwJobSample

Local loJob as 'Job' of 'MyBusinessObjects.prg'

loJob = CreateWWBO('Job', .T.) &&  Use the wwBusinessPro Factory procedure to return the BO from wwBusinessObjects.dbf
                               && .T. means "load Child object(s) also"

If Vartype(loJob) <> 'O'
  Messagebox('Error: No object returned from call to CreateWWBO()')
  Return .f.
Endif

*-- This Job BO has (4) child collection BO's defined on it in the wwBusinessObjects table.
*-- If you just want the Parent BO without the children objects, then do not pass a second
*-- value in the CreateWWBO() procedure above.
*-- A reference to each the child object is added to the main BO. There will be a corresponding
*-- cursor built that contains each group of child records.
*--
*--  loJob.oLineItems
*--  loJob.oFileItems
*--  loJob.oLaborItems
*--  loJob.oMtlItems

*-- Now, load a Parent record:
loJob.Get(12345) && Basic Integer based Primary Keys (wwBusiness standard behavior)
*-- or -- *
loJob.Get('4033X') && wwBusinessPro supports string-based Lookup keys / Primary Keys

*-- Example of how to work properties on the Parent BO. The properties map to fields in the Jobs.dbf table
loJob.oData.status = 'C' 

*-- Example of how to Add a new child record. It will be properly linked to the Parent Job Primary Key via
*-- the FK field on the Child BO class.
loJob.oFileItems.NewItem() && Adds a new child row and new oData object on oFileItems child object.
	
	*-- Now add the data to the child object/row:

  * Option 1: Update local cursor first, then updata oData object
  Replace description with 'File description' in (loJob.cFileItemsAlias) && Update a field in the local Child cursor.
  loJob.oFileItems.LoadFromCurrentRow() && Copies data from loJob.oFileItems.oData to the current row in .cFileItemsAlias

  * Option 2: Update oData object first, then update cursor row from oData object
  loJob.oFileItems.oData.description = 'File description'
  loJob.oFileItems.SaveToCurrentRow() && Copies data from loJob.oFileItems.oData to the current row in .cFileItemsAlias


*-- Save the main Parent BO and all rows in the Child cursors
loJob.Save(.T.) && The .T. flag means save the Parent record and *also* the child record changes

