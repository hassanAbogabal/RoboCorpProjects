*** Settings ***
Documentation       Order robots from the RobotSpareBin Industries Inc.
...                 Save the order Html receipt as a PDF file .
...                 Save the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt
...                 Creates ZIP archive of the receipts and the images 
Library    RPA.HTTP
Library    RPA.Browser.Selenium  auto_close=${False}
Library    RPA.PDF
Library    RPA.Desktop
#Library    RPA.Excel.Files
Library    RPA.Tables
Library    RPA.Archive
Library    RPA.Dialogs
Library    RPA.Robocorp.Vault
#Library    RPA.Robocloud.Secrets


*** Tasks ***
Order robot from RobotSpareBin Industries Inc
   
   Download the orders file
   open the robot order website
   #Closing the annoying model  
   #Previwe the robot
   #Submit the order 
   #Store the receipt as PDF file
   #Take a screenshot of the robot



   #Fill the robot form 
   #close the browser
   #Create a zip File of the receipt 
   #close the browser

   







*** Keywords ***
open the robot order website
    ${Sec_url}=    Get Secret    URL
    Log    ${Sec_url}[URL]
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order  
    Maximize Browser Window

Closing the annoying model
    Click Button    OK
    #Wait And Click Button    OK
Fill the robot form to one order
    [Arguments]    ${Orders}
    Select From List By Value   head   ${Orders}[Head]
    Select Radio Button    body    ${Orders}[Body]
    Input Text   class:form-control    ${Orders}[Legs]  
    #${x}=     Get Element Attribute    class:form-control    id    #another solution to type number of legs
    #Input Text    id:${x}    3
    #Log    ${x}
    Input Text    address    ${Orders}[Address]



Download the orders file
    Add heading    Please Enter URL of Oreder CSV File.. 
    Add Text Input    Url    placeholder=URL:   
    ${URL} =    Run dialog
    Log    ${URL.Url}
    Download    ${URL.Url}    overwrite=True    target_file=${OUTPUT_DIR}${/}orders.csv

Previwe the robot
    Click Button    preview


Submit the order
    #Submit Form
    Click Button    order

Store the receipt as PDF file
  [Arguments]    ${Orders}
  Wait Until Element Is Visible    id:receipt
  ${receipt_result_html}=    Get Element Attribute    id:receipt    outerHTML
  Html To Pdf    ${receipt_result_html}    ${OUTPUT_DIR}${/}PDF${/}${Orders}[Order number].pdf

Take a screenshot of the robot
  [Arguments]    ${Orders}
  Screenshot    id:robot-preview-image    ${OUTPUT_DIR}${/}IMG${/}${Orders}[Order number].png
  ${files}=   Create List 
  ...    ${OUTPUT_DIR}${/}IMG${/}${Orders}[Order number].png
  Add Files To Pdf    files=${files}    target_document=${OUTPUT_DIR}${/}PDF${/}${Orders}[Order number].pdf    append= True
  #Add Files To Pdf    #target_document=${OUTPUT_DIR}${/}receipt_result.pdf
  #Save Figures As Images    source_path=${OUTPUT_DIR}${/}receipt_result.pdf    images_folder=${OUTPUT_DIR}${/}Robot.png    pages=${1}    file_prefix=${OUTPUT_DIR}${/}robot_result.pdf
  #Save Figure As Image    figure=${OUTPUT_DIR}${/}receipt_result.pdf    images_folder=${OUTPUT_DIR}${/}Robot.png    



Order another Robot
   Click Button    order-another
   

Fill the robot form 
    #Open Workbook    ${OUTPUT_DIR}${/}orders.csv
    ${Orders}=   Read table from CSV   path=${OUTPUT_DIR}${/}orders.csv   header=True
    #Close Workbook
    FOR    ${Order}    IN    @{Orders}
        #Set Selenium Timeout    30 seconds
        Closing the annoying model
        Fill the robot form to one order    ${Order}
        Previwe the robot
        Wait Until Keyword Succeeds    10x    3s    Submit the order
        #${condtion}=  Element Should Not Be Visible    class:alert alert-danger
        #Log    ${Condtion}
        #IF    ${Condtion} == None
        #    Submit the order
        #ELSE
        #    Submit the order
        #END
        #Submit the order
        Store the receipt as PDF file    ${Order}
        Take a screenshot of the robot    ${Order}
        Order another Robot

        #Set Selenium Timeout    30 seconds
    END
Create a zip File of the receipt
    ${Zip_file_name}=   Set Variable      ${OUTPUT_DIR}${/}PDFs.zip
    Archive Folder With Zip    ${OUTPUT_DIR}${/}PDF${/}    ${Zip_file_name}

close the browser
    Close Browser





  
