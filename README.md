# voting-app-devops
![](architecture.excalidraw.png)
La aplicación comprende varios componentes esenciales: 
- Una aplicación web front-end en Python [python:3.11], 
- Un backend .NET [dotnet/sdk:7.0] [dotnet/runtime:7.0]
- Un servidor Redis para votos [redis:alpine], 
- Una base de datos PostgreSQL [postgres:15-alpine] respaldada por un volumen Docker, 
- y Una aplicación web Node.js [Node 18] que muestra los resultados de la votación en tiempo real.