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

