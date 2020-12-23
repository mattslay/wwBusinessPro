*-- Change these constants to match the paths or settings of your network, server, and app details
#DEFINE WWBUSINESSPRO_FACTORY_DICT_TABLE		'wwBusinessObjects'
#DEFINE WWBUSINESSPRO_ITEMS_CONTROLLER_CLASS	'wwBusinessProItemListController'
#DEFINE WWBUSINESSPRO_ID_TABLE					''
#DEFINE WWBUSINESSPRO_MAIN_DATA_PATH			'F:\ShareName\DataFolder\'
#DEFINE WWBUSINESSPRO_USER_DATA_PATH			'C:\Program Files\MyApp\Data\'
#DEFINE WWBUSINESSPRO_LOAD_RELATED_OBJECTS		.T.

*-- Change these constants to match the references to object that must be defined for use by wwBusinessPro library
*-- There must be a global object defined and you must define mappings here for each constant to a supporting
*-- object or property.
#DEFINE WWBUSINESSPRO_APPLICATION_OBJECT		goApp
#DEFINE WWBUSINESSPRO_GENERIC_BUS_OBJ			goApp.oBO
#DEFINE WWBUSINESSPRO_APP_CONFIG_OBJECT			goApp.oConfig
#DEFINE WWBUSINESSPRO_APP_NAME					goApp.oConfig.app_name
#DEFINE WWBUSINESSPRO_APP_USER					goApp.oUser.oData.emp_name
#DEFINE WWBUSINESSPRO_APP_MODULE				goApp.cCurrentModule
#DEFINE WWBUSINESSPRO_SQL_CONN_STRING			goApp.oConfig.connstring
#DEFINE WWBUSINESSPRO_OSQL_REF					goApp.oSql

*-- These constants are used for the Tracker logging of app/user activity
#DEFINE WWBUSINESSPRO_USE_TRACKER_LOGGING		.T.
#DEFINE WWBUSINESSPRO_TRACKER_OBJECT			goApp.oTracker
#DEFINE WWBUSINESSPRO_TRACKER_METHOD			Track
#DEFINE WWBUSINESSPRO_TRACKER_TABLE				Tracker
#DEFINE WWBUSINESSPRO_INSERT_ACTION				"Record_Added"
#DEFINE WWBUSINESSPRO_UPDATE_ACTION				"Record_Edited"
#DEFINE WWBUSINESSPRO_DELETE_ACTION				"Record_Deleted"


#DEFINE WWBUSINESSPRO_DO_NOT_DISPOSE			.T.

*-- Example Sql Connection String: 'driver=SQL Server; database=MyDb; server=MyServerName\sqlexpress; Trusted Connection=Yes'


*-- HELPFUL CONSTANTS FOR GENERAL FOXPRO CODING --------------------------
#DEFINE MESSAGEBOX_YES 6
#DEFINE MESSAGEBOX_NO 7

*--- DO NOT CHANGE THESE CONSTANT VALUES -------------------------------------------------------------------------------

#DEFINE WW_SAVE_CHILD_ITEMS_TRUE .T.
#DEFINE WW_SAVE_CHILD_ITEMS_FALSE .F.

#DEFINE WW_DO_NOT_REQUERY_CHILD_ITEMS_TRUE .T.
#DEFINE WW_DO_NOT_REQUERY_CHILD_ITEMS_FALSE .F.

#DEFINE WW_UPDATERECORD 1
#DEFINE WW_NEWRECORD 2
#DEFINE WW_DATAMODE_DBF 0
#DEFINE WW_DATAMODE_SQL 2
