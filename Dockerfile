FROM mcr.microsoft.com/dotnet/core/sdk:3.0.100-alpine3.9 AS build 

# Stage 1 (Copy and restore layers from application)
WORKDIR /src
COPY *.sln ./
COPY SampleK8s/SampleK8s.csproj/ SampleK8s/

RUN dotnet restore

# Stage 2 Copy everything else and build
COPY . ./

# Stage 3 (Publish application into /app directory)
WORKDIR /src/SampleK8s

RUN dotnet publish -c Release -o /app

# Stage 3 (Generate runtime image from previous processes)
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0.0-alpine3.9
WORKDIR /app
EXPOSE 80
COPY --from=build /app .
ENTRYPOINT ["dotnet", "SampleK8s.dll"]

