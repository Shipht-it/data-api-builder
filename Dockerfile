# Use SDK 8.0 for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src
COPY [".", "./"]
RUN dotnet restore "./src/Service/Azure.DataApiBuilder.Service.csproj"
RUN dotnet publish "./src/Service/Azure.DataApiBuilder.Service.csproj" -c Release -f net8.0 -o /app/publish /p:UseAppHost=false

# Use ASP.NET Core 8.0 runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app
COPY --from=build /app/publish .
# Copy the configuration file
COPY ["src/dab-config.json", "./"]
ENV ASPNETCORE_URLS=http://+:5000
ENTRYPOINT ["dotnet", "Azure.DataApiBuilder.Service.dll"]