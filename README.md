# stata_helper_functions
A few simple programs in Stata to help with data cleaning and output

#Written-by 
John Mezzanotte

#Usage 
Call in the helper_functions.do file into your main analysis script. 

```
  do "do\helper_functions.do"
```


#create_table 
This function will create a matrix using the results of the tab command. This function uses ``` tab <var1> <var2>, mat(<matname>)```
to create the matrix. This function will automatically assign row and column names to the matrix. You can access the matrix using: 
```matrix dir```
	
		@Params 
			1 - row tab variable
			2 - column tab variable
			3 - Matrix name as string
		
# Usage of create_table 
```
create_table var by_var "matrix_name"
matrix list matrix_name

```




#concat_varnames 
This function will take a string and concatenate it to a shorter string. The function takes the number of characters you would like to reduce the string to as the second parameter. The first parameter is the string you would like to concatenate. The concatenated value is 
returned under the name r(short_name) accessable in the return list. 
			
			@params
				- var_name : String of the name you would like to concat
				- char_number : int representing the number of characters 
								 you would like the final string to be.
			@return - short_name
				Returns the final concatenated string in returnlist as 
				short_name. you can access this returned value by accessing the 
				return list, i.e. returnlist. 
				
				you can get the value by using r(short_name)

# Usage of concat_varnames 
```
  concat_varname "`var'" 18
  
  local short_string "`r(short_name)'"
  
  di "`short_string'"
  
```

#add_rowlabels
Often I will preserve a dataset, then clear the data, and use svmat to the save the contents of a matrix to a dataset. For example: 

```	
	preserve 
		clear 
		svmat matrix_name, names(col)
	restore
```

This will save the matrix as a dataset and use the colnames of the matrix as the variable names. However, this does not capture the row names of the matrix. To add rownames to the dataset I created this method. You simply provide the fuction 1 or 0 value to indicate if the variable contains missing values and a list of strings to use as the row labels. Note the list of strings to be used as the row labels must be in the same order as the rows of the matrix or else the data will not line up correctly. I'll demonstrate how I deal with this in a code example below. If there are missing values in the variable the function will insert a missing row in the dataset. 

	
		@params 
			is_missing - as boolean; whether or not the variable we are using for row values contains missing values
		

# Usage of the add_rowlabels Function 

The first thing I do is ensure that the label list will align with the dataset values. If I have create a matrix using the create_table function from this package, I will take that same variable used in the create_table command (the one used for the rows) and run this operation: 

```
	levelsof <var>, local(LABELS)
	foreach lab in `LABELS' {
		concat_varname "`lab'" 10
		local temp = subinstr("`r(short_name)'", " ", "_", .)
		global LABEL_LIST $LABEL_LIST `temp'
	}
	
```
This will process all the row labels values and place them in a list for you to supply to the add_row_labels command. You can add the rows like this: 

```
preserve 
		
			clear 
			svmat `MATRIX_NAME', names(col)
			
			// determining if we have a row for missing. This needs to 
			// take place before we add row labels. 
			matnames `MATRIX_NAME' 
			di `r(r)'
			local is_missing = 0 
			
			/* 
				:r1 is what the row name will be in the return list from 
				matnames if there is a missing row in the matrix and the 
				variable type is a string. If the variable type is numeric 
				and there is a missing the return name will be :. in the list
			*/
			
			foreach row in `r(r)'{
				local x  = strtrim("`row'")
				if "`x'" == ":r1" {
					local is_missing = 1
				}
			}
			
			di "$LABEL_LIST"
			add_rowlabels `is_missing' "$LABEL_LIST"
			
		
		restore
	


```





