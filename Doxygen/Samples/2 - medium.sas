/***************************************************************************************************
  @file "2 - medium.sas"
  @brief This is the brief description of the code.
  @details This is a more detailed description of what happens in the program.
  Which can go over multiple lines,
  and can have SAS code sections.
  Note: spaces in front of tags are ignored
      @author name goes here
               @date 10/11/2022
@param parm1 this is a parameter description
@param[in] parm2 this is an input parameter description
@param[out] parm3 this is an output parameter description
  @param[in,out] parm4 this is a parameter description for something that is input and output
  @returns This describes what the code returns

  You can have other text which does not have a tag in your comment, 
  and it will show in documentation too.
  ***************************************************************************************************/
proc print;
run;

/*************
A normal SAS comment wont appear since it doesnt have special tags
**************/

/** 
@details Subsequent special comment blocks will be ignored. Won't appear in the documentation.
**/