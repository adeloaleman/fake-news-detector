#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  
  
  
  #create_readData_file<-"/srv/shiny-server/myapp/readData.txt"
  create_readData_file<-"./readData.txt"
  
  
  
  #xgbalgorithm_file_path<-"/srv/shiny-server/myapp/xgboost.R"
  #nbalgorithm_file_path<-"/srv/shiny-server/myapp/nbase.R"
  #svgalgorithm_file_path<-"/srv/shiny-server/myapp/sv.R"
  
  
  xgbalgorithm_file_path<-"./xgboost.r"
  nbalgorithm_file_path<-"./nbase.r"
  svgalgorithm_file_path<-"./sv.r"
  
  
  
  
  #xgbcreate_Result_file<- "/srv/shiny-server/myapp/result-xgboost.txt"
  #nbcreate_Result_file<- "/srv/shiny-server/myapp/result-nbase.txt"
  #svcreate_Result_file<- "/srv/shiny-server/myapp/result-sv.txt"
  
  xgbcreate_Result_file<- "./result-xgboost.txt"
  nbcreate_Result_file<- "./result-nbase.txt"
  svcreate_Result_file<- "./result-sv.txt"
  
  
  
  #on submit button condition
  observeEvent(input$submit, {
    
    # Esta variable al defini con el fin porque estoy quitando «input$nbase» fron the ui.R
    # Luego sustitui «input$nbase» por «variable_nbase» en todo el codigo
    # Fue la forma mas facil que encontre para quitar «input$nbase»
    # Si quiero colocar input$nbase lo que tengo que hacer es sustituir «variable_nbase» por «input$nbase» y comentar esta variable
    variable_nbase = FALSE
    
    # if input text and no file upload and none of the algorithms selected 
    
    if((!(input$xgboost) &&  !(variable_nbase) && !(input$svm)) && (input$text =="" && is.null(input$file1)) )
    {
      showModal(modalDialog(
        title = "Error",
        "You have to enter the text of a news article into the corresponding input field",
        easyClose = TRUE
      ))
      
    }
    # elseif  only no of the algorithms selected  
    else if((!(input$xgboost) &&  !(variable_nbase) && !(input$svm)))
    {
      showModal(modalDialog(
        title = "Error",
        "Please! select at least one algorithm",
        easyClose = TRUE
      )) 
      
    }
    # elseif only input text and no file upload
    else if((input$text =="" && is.null(input$file1))) 
    {
      showModal(modalDialog(
        title = "Error",
        "Either File is not uploaded or text field is empty",
        easyClose = TRUE
      )) 
      
    }
    # check if text input is filled
    
    else if(input$text!="" ){
      
      #save input-text into readData.txt
      
      sink(create_readData_file)
      cat(input$text)
      sink()
      
      text<-readtext(create_readData_file)
      
      texto<-paste('
                   <div style="padding: 5px; float: left; width: 100%; margin-top: -10px; margin-top: 30px">
                   <div style="background-color: white; font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                   <div style="background-color: white; color: black; height: 40px; font-weight: bold">
                   <p style="padding: 0px; margin-left: 0px; font-size: 20px;">
                   Input Text
                   </p>
                   </div>
                   <table style="border-collapse: separate; border-spacing: 20px 2em;">
                   ',text,'
                   <br/>
                   <br/>
                   <br/>
                   </table>
                   </div>
                   </div>
                   ')
      
      
      warning<-paste('
                     <div style="padding: 5px; float: left; width: 100%; margin-top: -10px; margin-top: 30px">
                     <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                     <div style="background-color: rgb(189,183,107); color: white; height: 40px; font-weight: bold">
                     <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                     Important
                     
                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-area-chart" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                     
                     </p>
                     </div>
                     <table style="padding: 5px; border-collapse: separate; border-spacing: 0.5px 1.5em; margin-left: 10px">
                     <tr style="margin-top: 100px;">
                     <td style="margin-top: 100px;">

                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-check" style="color: black; font-size: 18px; float: right; margin-right: 7px; margin-top: 7px;" height="1em" width="1em"></i>

                     
                     </td>
                     <td>The results shown above were calculated from a Supervised Machine Learning Model built from a dataset of 60,000 news articles.</td>
                     </tr>
                     <tr>
                     <td>
                     
                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-check" style="color: black; font-size: 18px; float: right; margin-right: 7px; margin-top: 7px;" height="1em" width="1em"></i>

                     </td>
                     <td>The best accuracy was obtained with the Gradient Boosting (XGBoost) algorithm. We got 78% accuracy. Therefore, keep in mind that the most reliable result is the one returned by that algorithm.</td>
                     </tr>
                     <tr>
                     <td>

                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-check" style="color: black; font-size: 18px; float: right; margin-right: 7px; margin-top: 7px;" height="1em" width="1em"></i>

                     </td>
                     <td>It is very important to notice that a complete News Article must be entered so the models are able to work correctly. You cannot input only a sentence and expect our models to validate if that sentence is true or fake.</td>
                     </tr>
                     <tr style="margin-top: 100px;">
                     <td style="margin-top: 100px;">

                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-check" style="color: black; font-size: 18px; float: right; margin-right: 7px; margin-top: -2px;" height="1em" width="1em"></i>

                     </td>
                     <td>Also notice that the definition of Fake News used in this project is: <p style="color:blue">Deliberately distorted information that secretly leaked into the communication process in order to deceive and manipulate (Vladmir Bitman). Therefore, our Machine Learning Models are only able to detect this kind of Fake News.</p></td>
                     </tr>
                     <tr style="margin-top: 100px;">
                     <td style="margin-top: 100px;">

                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-check" style="color: black; font-size: 18px; float: right; margin-right: 7px; margin-top: -2px;" height="1em" width="1em"></i>

                     </td>
                     <td>You can test the application using some News Articles from a very unreliable source, such as: <a href="https://dailyworldupdate.us">https://dailyworldupdate.us</a>
                     <p> Or you can try some reliable News Articles from: <a href="http://m.cnn.com/en">http://m.cnn.com/en</a></p></td>
                     </tr>
                     <tr style="margin-top: 100px;">
                     <td style="margin-top: 100px;">

                     <meta name="viewport" content="width=device-width, initial-scale=1">
                     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                     <i class="fa fa-check" style="color: black; font-size: 18px; float: right; margin-right: 7px; margin-top: 7px;" height="1em" width="1em"></i>

                     </td>
                     <td>Visit our <a href="http://perso.sinfronteras.ws/index.php?title=Supervised_Machine_Learning_for_Fake_News_Detection">Website</a> to know more about this project.</td>
                     </tr>
                     </table>
                     </div>
                     </div>
                     ')
      
      
      
      if(input$xgboost && variable_nbase && input$svm){
        print ("xgboost and Naive Bayes and Support Vector Machine")
        
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          
          color_xgb<-"The news article is FAKE"
        } 
        
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          #color_nb<-"<h1 style='color:green;'>"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')
          
          
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          str2<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(resultado, warning, str1, str2, str3,texto,"</h4>", sep = '<br/>'))
        })
        
        
        
      }
      else if(input$xgboost && !(variable_nbase) && !(input$svm)){
        print ("xgboost")
        
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          color_xgb<-"The news article is FAKE"
        } 
        
        #this section is for shwing data from result.txt 
        
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')
          
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))
          
        })
        
        showModal(modalDialog(
          title = "XGBoost result",
          paste("The news article is",res_xgb),
          easyClose = TRUE
        )) 
      }
      
      else if(variable_nbase && !(input$xgboost) && !(input$svm)){
        print("Naive Bayes")
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        output$content <- renderUI({
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }		 
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')            
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1, "<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
          
        })
        
        showModal(modalDialog(
          title = "Naive Bayes result",
          
          paste("The news article is",res_nb),
          easyClose = TRUE
        ))
      }
      else if(input$svm && !(variable_nbase) && !(input$xgboost)){
        print("Support Vector")
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        showModal(modalDialog(
          title = "Support Vector Machine result",
          
          paste("The news article is",res_svm),
          easyClose = TRUE
        ))
      }
      else if(input$xgboost && variable_nbase){
        print("xgboost and Naive Bayes")
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        text<-readtext(create_readData_file)
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable"
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          #color_xgb<-"<h1 style='color:red;'>"
          color_xgb<-"The news article is FAKE"
        } 
        
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          #color_nb<-"<h1 style='color:green;'>"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }
          
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }            
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          str2<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')         
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1, str2,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        
        
      }
      else if(input$xgboost && input$svm){
        print("xgboost and svm")
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          #color_xgb<-"<h1 style='color:red;'>"
          color_xgb<-"The news article is FAKE"
        } 
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1,str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        
      }
      else if(variable_nbase && input$svm){
        print("Naive Bayes and Support Vector Machine")
        
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          #color_nb<-"<h1 style='color:green;'>"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }		 
          
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          str2<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste( str2,str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        
      }
      
      
    } 
    #else if closed
    #check if file is uploaded 
    # provided with input-text is empty 
    # and submit button is clicked
    else if(!(is.null(input$file1))){
      
      req(input$file1)
      file.copy(input$file1$datapath,create_readData_file, overwrite = TRUE)
      
      
      if(input$xgboost && variable_nbase && input$svm){
        print ("xgboost and Naive Bayesand Support Vector Machine")
        
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          #color_xgb<-"<h1 style='color:red;'>"
          color_xgb<-"The news article is FAKE"
        } 
        
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          #color_nb<-"<h1 style='color:green;'>"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }          
          
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }            
          
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          str2<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1, str2,str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        
        
        
      }
      
      else if(input$xgboost && !(variable_nbase) && !(input$svm)){
        print ("xgboost")
        
        
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_xgb$text==0)
        {
          res_xgb="<h1>TRUE</h1>" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          color_xgb<-"The news article is FAKE"
        } 
        
        #this section is for shwing data from result.txt 
        
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }          
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')        
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        showModal(modalDialog(
          title = "XGBoost result",
          paste("The news article is",res_xgb),
          easyClose = TRUE
        )) 
      }
      
      
      
      
      else if(variable_nbase && !(input$xgboost) && !(input$svm)){
        print("Naive Bayes")
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        output$content <- renderUI({
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')         
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1, "<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        showModal(modalDialog(
          title = "Naive Bayes result",
          
          paste("The news article is",res_nb),
          easyClose = TRUE
        ))
      }
      else if(input$svm && !(variable_nbase) && !(input$xgboost)){
        print("Support Vector")
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        showModal(modalDialog(
          title = "Support Vector Machine result",
          
          paste("The news article is",res_svm),
          easyClose = TRUE
        ))
      }
      else if(input$xgboost && variable_nbase){
        print("xgboost and Naive Bayes")
        
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        text<-readtext(create_readData_file)
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          #color_xgb<-"<h1 style='color:red;'>"
          color_xgb<-"The news article is FAKE"
        } 
        
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          #color_nb<-"<h1 style='color:green;'>"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }          
          
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }            
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          str2<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')         
          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1, str2,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
          
        })
        
      }
      
      else if(input$xgboost && input$svm){
        print("xgboost and Support Vector Machine")
        #xgboost
        source(xgbalgorithm_file_path)
        #after script is run it saves result into result
        result_File<- xgbcreate_Result_file
        resultant_xgb<-readtext(result_File)
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        
        
        if (resultant_xgb$text==0)
        {
          res_xgb="Reliable" 
          color_xgb<-"The news article is RELIABLE"
        }
        else if(resultant_xgb$text==1)
        {
          res_xgb="Fake"
          #color_xgb<-"<h1 style='color:red;'>"
          color_xgb<-"The news article is FAKE"
        } 
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_xgb == "Reliable"){
            color_font_xgb = "blue"
          } else {
            color_font_xgb = "red"
          }          
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          str1<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>XGBoost: <span style='font-size:18px; color:",color_font_xgb,"'>",color_xgb,"</span></p><br/>")
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-size: 15px; font-weight: bold">
                           XGBoost:
                           </td>
                           <td style="color: ',color_font_xgb,'"> ',color_xgb,' </td>
                           <td style="font-weight: bold"> (best result) </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')
          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste(str1,str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
        })
        
        
      }
      else if(variable_nbase && input$svm){
        print("Naive Bayes and Support Vector machine")
        #nbayes
        source(nbalgorithm_file_path)
        result_File<- nbcreate_Result_file
        resultant_nb<-readtext(result_File)
        
        #svm
        source(svgalgorithm_file_path)
        result_File<- svcreate_Result_file
        resultant_svm<-readtext(result_File)
        text<-readtext(create_readData_file)
        if (resultant_nb$text==0)
        {
          res_nb="Reliable"
          #color_nb<-"<h1 style='color:green;'>"
          color_nb<-"The news article is RELIABLE"
        }
        else if(resultant_nb$text==1)
        {
          res_nb="Fake"
          color_nb<-"The news article is FAKE"
        }
        
        if (resultant_svm$text==0)
        {
          res_svm="Reliable"
          color_svm<-"The news article is RELIABLE"
        }
        else if(resultant_svm$text==1)
        {
          res_svm="Fake"
          color_svm<-"The news article is FAKE"
        }
        
        output$content <- renderUI({
          
          if (res_svm == "Reliable"){
            color_font_svm = "blue"
          } else {
            color_font_svm = "red"
          }
          
          if (res_nb == "Reliable"){
            color_font_nb = "blue"
          } else {
            color_font_nb = "red"
          }		 
          
          str3<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Support Vector Machine: <span style='font-size:18px; color:",color_font_svm,"'>",color_svm,"</span></p><br/>")
          str2<-paste("<p style='font-size:25px; color:black; font-weight:bold; font-style:italic;'>Naive Bayes: <span style='font-size:18px; color:",color_font_nb,"'>",color_nb,"</span></p><br/>")
          
          
          
          resultado<-paste('
                           <div style="padding: 5px; float: left; width: 100%; margin-top: -10px;">
                           <div style="background-color: rgb(223,224,230); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; color: black; font-weight: normal; margin-top: 5px;">
                           <div style="background-color: rgb(29, 161, 242); color: white; height: 40px; font-weight: bold">
                           <p style="padding: 5px; margin-left: 17px; font-size: 20px;">
                           Results
                           <meta name="viewport" content="width=device-width, initial-scale=1">
                           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                           <i class="fa fa-gears" style="color: black; font-size: 25px; float: right; margin-right: 7px;"></i>
                           </p>
                           </div>
                           <table style="padding: 5px; border-collapse: separate; border-spacing: 20px 2em;">
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           SVM:
                           </td>
                           <td style="color: ',color_font_svm,'"> ',color_svm,' </td>
                           </tr>
                           <tr style="margin-top: 100px; font-size: 15px">
                           <td style="margin-top: 100px; font-weight: bold">
                           Naive Bayes:
                           </td>
                           <td style="color: ',color_font_nb,'"> ',color_nb,' </td>
                           </tr>
                           </table>
                           </div>
                           </div>
                           ')          
          
          
          
          HTML(paste(resultado, warning, texto))
          # HTML(paste( str2,str3,"<h1>Input Text:</h1><h4>",text,"</h4>", sep = '<br/>'))              
          })
		
		
      }
      
    }
  })
  
  
  
  
})
