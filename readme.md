# wwBusinessPro
Version 5.3.0 [2020-05-26]

## Features
----
**wwBusinessPro** is a wrapper library around the popular wwBusiness data-access library from West Wind Technolgies.

The base wwBusiness library from West Wind is an ORM-like data access library for Visual FoxPro that has been around for years which allows you to read and write data from tables in an object oriented way. It supports both native FoxPro dbf tables, and SQL Server.

**wwBusinessPro** adds some additonal functionalities that help with Parent-Child mappings that are often used in CRUD applications. Such as:

* Support for string based lookups as primary keys.
* Support for one or more sets of Child records per each Parent record.
* Saving the Parent Primary Key into the Child Foreign Key during the Save() operation
* Adds methods for Ordering and Reordering Child records to control the display order.
* DBF table-based Business Object definitions for Parent and Child tables. See http://mattslay.com/table-based-definition-of-parent-child-relationships-in-wwbusinesspro/


## Licensing
----
**wwBusinessPro** library is a free, open source project which extends the base wwBusiness framework. You will need to purchase a license for the main wwBusiness library to use with **wwBusinessPro**. You can get wwBusiness as part of the Web Connection or Client Tools package at the West Wind web site.  See http://www.west-wind.com

## Resources
----
**Resources to help you use wwBusiness and wwBusinessPro:**

* Start here: http://mattslay.com/west-wind-client-tools-for-vfp/
* Then here: http://mattslay.com/exploring-my-wwbusiness-extension-library/
* And here: http://mattslay.com/wwbusinesspro-setup-instructions/

**Basic help with wwBusiness:**

* Getting Started with wwBusiness (PDF): http://cullytechnologies.com/presentations/wwbusiness/cully\_technologies\_wwbusiness\_presentation.pdf
* Full wwBusiness Documentation: https://webconnection.west-wind.com/docs/_0gz17u8f4.htm


## Change Log
----
**Version 5.3.0 - [2020-05-26]**
1. wwBusinessPro.Get() method: fixed a bug when passing tcAlternateLookupFilter parameter.
2. wwBusinessProUtils.prg: 
> * Added Procedure NumberOfDecimals(tnNumber)
> * Added Procedure IsInteger(tnNumber)
> * Added Procedure IsWholeNumber(tnValue)
> * Added Procedure CloseCursor(tcCursor)
> * Added Procedure GotoRecord(tnRecordNo, tcCursor)
> * Renamed Procedure from BeginsWith() to StartsWith()


3. Moved ZapCursor() from wwBusinessPro class to wwBusinessProUtils.prg
4. Many other small tweaks to add error handling, null or empty parameters passed, etc.

**Version 5.2.1 - [2019-11-18]**

1. Added check to wwBusinessProBusObjManager.ClearFkValuesOnChildCursors() so that if Child objects in the oChildItems collection have had their ParentBO re-assigned to another Parent, then we will not change FK values in this loop. This situation	happens when Child Object are re-assigns in Parent-Child-Grandchild models.


**Version 5.2 - [2019-06-26]**

1. Converted Item List from using Array to a Collection to match with latest release of wwBusiness from West Wind.
2. Added new property cNewFromCopyExclusionList
3. Added code in SaveToCursor() to keep record pointer in the correct place during Scan.
4. Added new param tnIgnorePK to CheckIfKeyValueIsAvailable.

**Ver 5.1. - [2019-03-05]**

1. Refactored several hard-coded references to "goApp" to use constant WWBUSINESSPRO_APPLICATION_OBJECT
2. Refactored processing of special properties _Child_XXXX and _Releated_XXXX in  wwBusinessProfactory.CreateRelatedObjects() and wwBusinessProfactory.CreateRelatedObjects().
3. Removed methods BeginTransaction(), Commit() and Rollback() in wwBusinessProSql class since these have now been added to wwSql class.
4. Moved methods Alltrim() and PrintData() from wwBusinessPro class to functions AlltrimObject() and PrintData() in wwBusinessProUtils.
5. wwBusinessPro.Log() now uses oSql_wws_id object to write log entry so it will be outside of any Transaction if errors are being logged from wwBusinessPro.Save()
6. Class wwBusinessProParent has been removed. All methods and properties from that class have now been moved into wwBusinessPro. wwBusinessPro is now to be viewed as a "Parent" capable class when Child Items and/or Releated Objects
are defined on it, or regarded as a simple single record BO when no Child/Related objects are defined.


**Version 5.0 - [2019-02-15]**

1. Revised to base off of new wwBusinessObject prg classes from West-Wind Web Connect and Client Tools ver 7.0 (wwBusiness was previously in a VCX, but West Wind convert it to PRG and changed class named.
2. wwBusinessProUtils.prg:  Added new class wwBusinessProDiff designed to compare oData with oOrigData to indicate if any data has changed since loaded.
3. wwBusinessProSql: added new property lMapVarChar which is used to call CURSORSETPROP("MapVarchar", .t., 0) in init method.
4. wwBusinessPro: Added new property lWriteActivityToScreen which can be enabled to write certain activity throughout the framework to the FoxPro screen surface.
5. wwBusinessProParent.Save(): Updated Tracker logging to indicate if Parent was changed and/or if Children were changed when Save() was called.
6. wwBusinessPropObjManager: Added new property lChildItemsHadChanges to indicate if any of the ReadWrite Child cursors had any new or changed records when Save was called.
7. wwBusinessProParent: Add new properties cInsertAction and cUpdateAction for use in in Tacker
8. wwBusinessPro.h: Added new constants WWBUSINESSPRO_UPDATE_ACTION, WWBUSINESSPRO_UPDATE_ACTION, and WWBUSINESSPRO_USE_TRACKER_LOGGING
9. wwBusinessProParent: Refactored Save() method; Extracted code to 3 new methods: LogEdits(), ScreenLogEdits(), and Rollback()


**...**
**Changes from initial version to version 5 ommitted due to space...**

 **Version 1.0	- [2012-04-17]**
 1. Initial version