/* 
	HELPER FUNCTIONS 
	script of common procedures that can be called into any .do file
*/

	
	capture program drop create_table
	program create_table
		
		/* 
			Params 
			1 - row tab variable
			2 - column tab variable
			3 - Matrix name as string
		
		*/

		//levelsof `1' , local(rows) missing
		levelsof `2' , local(cols) 
		
		tab `1' `2', mi matcell(`3')
		
		
		//matrix rownames `3' = `rows'
		di "WERE HEREERERERER `MATRIX_NAME'"
		matrix colnames `3' = `cols'
		
	
	end
	
	capture program drop concat_varname
	program concat_varname, rclass
		args var_name char_number
		
		/*
			This function will take a string and concatenate it to a shorter 
			string. The function takes the desired number of characters as 
			a second parameter, the final string will be that many characters 
			in length.
			
			@params
				- var_name : String of the name you would like to concat
				- char_number : int representing the number of characters 
								 you would like the final string to be.
			@return - short_name
				Returns the final concatenated string in returnlist as 
				short_name. you can access this returned value by accessing the 
				return list, i.e. returnlist. 
				
				you can get the value by using r(short_name)
		*/
		
		local str_len = strlen("`var_name'")
		
		* shorten the var name for the sheet label 
		if(`str_len' > `char_number' ) {
			local concat_name = substr("`var_name'", 1, `char_number')
		}
		else{
			local concat_name = "`var_name'"
		}
		
		return local short_name `concat_name'
	
	end


	capture program drop add_rowlabels
	program define add_rowlabels
		args is_missing label_list
		
		/*
			@params 
				is_missing - as boolean; whether or not the variable we are 
							 using for row values contains missing values
		
		*/
		
		* If there are missing values we have to account for that 
		* when applying the rowlabels. Missing rows will be at the top 
		* of the table
		
		if  `is_missing'  {
			di "fired"
			local MISSING_ROWS = 1
			local CUSTOM_LABEL ""Missing" `label_list'"
		}
		else{
			di "not fired"
			local MISSING_ROWS = 0 
		}
		
		capture drop row_labels
		gen row_labels = ""
	
		local COUNT : word count "`CUSTOM_LABEL'"
		di `COUNT'
		if `is_missing' {
			local COUNT = `COUNT' + 1 
		} 
		di `COUNT'
		forvalues i = 1 / `COUNT' {
	
			local active : word `i' of `CUSTOM_LABEL'
			
			replace row_label = "`active'" if [_n] == `i'
		}
		
		* order rowlabel column as first columb 
		order row_labels
				
	end 

	

	
