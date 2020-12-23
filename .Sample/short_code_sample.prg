
loJob = CreateWWBO('Job', .T.) && .T. means load Child records also

loJob.Get(12345) && Load a Parent record by Integer Key value
 *-- or -- 
loJob.Get('4033X') && Load a Parent record by String Key value

loJob.oData.status = 'C' && Change a property on the Parent BO

loJob.oFileItems.NewItem() && Add a new child record. Will be linked to the Parent via FK field.
Replace description with 'File description' in (loJob.cFileItemsAlias) && Update a field in the local Child cursor.

loJob.Save(.T.) && Save the main Parent BO and all rows in the Child cursors





