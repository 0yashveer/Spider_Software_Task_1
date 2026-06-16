# Process of Completion 

1. Started with deploying the backend, frontend and db locally
2. Then loaded db, backend and frontend on different containers manually and conneted them on same network.
3. Then made a seperate docker files to make and run containers together
4. Created a compose file to create and run all the containers together

 # 
 Then major issue faced was the port mapping and getting the continers to run the same network.
 #

 # Steps to run the application
1. Run the docker files independentely along with the db
2. or, run the compose.yml

# Ports and Services
1. Backend-8080, DB-5432, Frontend-80
2. Network - "app-net"

   DB-Postgres
   NGINX-WebServer

#
The go source files are converted to static files which are used by vite in frontend to serve the user

Migrations are handeled via creation of schema migration ,the once already downloaded are skipped rest are downloaded
