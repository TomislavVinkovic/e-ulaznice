# e-bazeni
A system for easy entrance ticket management

E-bazeni is an open source project designed to help with managing membership tickets for public objects.
The project consists of a flutter application and a ASP.NET Core back-end application.
I created it to help a local city pool manage its entry tickets. The application made that process easier and cheaper since they no longer have to create card tickets for every user. It can also detect duplicate entries, so the costumers cannot just pass the phone trough the fence to a friend once they entered.
With little modification, this project can easily be used in most applications where there is a need for membership management(ex. gym memberships)
The project is not fully completed, however it is in a usable state.
The comments are in Croatian, but I will update them to English in the near future

Some of the features included in this project are: 
- JWT and Identity authentication and authorization
- Role management
- An API using the respoitory pattern (for the most part)
- Mailkit E-mail confirmation service
- Usage of GETX in the Flutter client
- Usage of Secure Storage in the Flutter client (for faster Log-in)

# How to setup the project?
- # Flutter app
  - You need to configure the _**apiURL**_ variable inside the _apiservice.dart_ file located in _lib/services_. That variable is the base url of your server(ex www.website.com)
- # Asp.NET CORE Web application:
  - # appsettings.json
    - The secret variable inside JWTConfig must be any random 32 character string using alphabetical characters. This string is very important as it encrypts all your jwt tokens.
    - All variables inside EmailConfiguration. The smtp server and the port are specified by your E-mail provider. SMTP Username and Password are the E-mail and password you are         going to use. Sender name is the name of the person sending the message(ex. Admin). The Sender Email should be the same as the SMTP Username
 - # Hosting
   - If you are going to host the app on a localhost machine be sure to use Kestrel instead of IIS express.
   ![image](https://user-images.githubusercontent.com/62397682/133119199-9cefb94b-c417-4717-a71a-2815ed348b12.png)
   - To easily access the app on a remote device you can use ngrok. Follow this guide to set it all up: https://www.jerriepelser.com/blog/using-ngrok-with-aspnet-core/
