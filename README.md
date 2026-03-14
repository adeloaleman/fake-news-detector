# Supervised Machine Learning for Fake News Detection

Visit our wiki to learn more about this project:  
https://wiki.sinfrontera.net/view/Supervised_Machine_Learning_for_Fake_News_Detection

Try the Fake News Detector Web App:  
https://fake-news-detector.sinfrontera.net


## In this project we created a Supervised Machine Learning Model for Fake News Detection based on three algorithms

- Naive Bayes
- Support Vector Machine
- Gradient Boosting (XGBoost)


## This repository

Apart from the Web app, this repository also contains an **R library** that we created to package the Machine Learning models.
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

**https://fake-news-detector.sinfrontera.net**

This web application allows users to easily interact with the Machine Learning models.
Users can determine whether a news article is **fake** or **reliable** by entering its text into an input field.

The text is processed by the Machine Learning models on the backend, and the result is returned to the client.

The web application was built using **:contentReference[oaicite:1]{index=1}**, an R package that allows developers to build interactive web applications directly from R.


## Model accuracy

The Machine Learning model created using the **Gradient Boosting algorithm** achieved an accuracy of:

**78.86%**


## Definition of Fake News used in this project

In this project, fake news is defined as:

> "Deliberately distorted information that secretly leaked into the communication process in order to deceive and manipulate."  
> — Vladimir Bitman

Therefore, the Machine Learning models in this project are designed to detect **fake news articles that were deliberately created to deceive and manipulate**.