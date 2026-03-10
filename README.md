# Supervised Machine Learning for Fake News Detection

Visit our wiki to learn more about this project:  
http://wiki.sinfronteras.ws/view/Supervised_Machine_Learning_for_Fake_News_Detection

Try the Fake News Detector Web App:  
http://fakenewsdetector.sinfronteras.ws


## In this project we created a Supervised Machine Learning Model for Fake News Detection based on three algorithms

- Naive Bayes
- Support Vector Machine
- Gradient Boosting (XGBoost)


## This repository

This repository contains an **R library** we created to package the Machine Learning models built.  
The package contains three functions:

- `modelNB()`
- `modelSVM()`
- `modelXGBoost()`

These functions take a **news article as input** and, using the trained models, return an authenticity tag:

- **fake (1)**
- **reliable (0)**

Function descriptions:

- **`modelNB()`**  
  Based on the Naive Bayes model.

- **`modelSVM()`**  
  Based on the Support Vector Machine model.

- **`modelXGBoost()`**  
  Based on the Extreme Gradient Boosting model.


## Web application

Along with this repository, another result of this project is the web application:

**http://fakenewsdetector.sinfronteras.ws**

This web application allows users to interact easily with the Machine Learning models.  
Users can determine whether a news article is **fake or reliable** by entering the text into an input field.

The text is processed by the Machine Learning models on the backend and the result is returned to the client.

The web application was built using **:contentReference[oaicite:1]{index=1}**, an R package that allows developers to build interactive web applications directly from R.


## Model accuracy

The Machine Learning model created using the **Gradient Boosting algorithm** achieved an accuracy of:

**78.86%**

This repository also reports the accuracy obtained for all the models developed.


## Definition of Fake News used in this project

In this project, fake news is defined as:

> "Deliberately distorted information that secretly leaked into the communication process in order to deceive and manipulate."  
> — Vladimir Bitman

Therefore, the Machine Learning models in this project are designed to detect **fake news articles that were deliberately created to deceive and manipulate**.