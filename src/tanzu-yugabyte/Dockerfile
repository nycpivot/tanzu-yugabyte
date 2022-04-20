#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Tanzu.Yugabyte.Api/Tanzu.Yugabyte.Api.csproj", "Tanzu.Yugabyte.Api/"]
RUN dotnet restore "Tanzu.Yugabyte.Api/Tanzu.Yugabyte.Api.csproj"
COPY . .
WORKDIR "/src/Tanzu.Yugabyte.Api"
RUN dotnet build "Tanzu.Yugabyte.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Tanzu.Yugabyte.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Tanzu.Yugabyte.Api.dll"]