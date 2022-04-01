#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["tanzu-yugabyte-reader/tanzu-yugabyte-reader.csproj", "tanzu-yugabyte-reader/"]
RUN dotnet restore "tanzu-yugabyte-reader/tanzu-yugabyte-reader.csproj"
COPY . .
WORKDIR "/src/tanzu-yugabyte-reader"
RUN dotnet build "tanzu-yugabyte-reader.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "tanzu-yugabyte-reader.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "tanzu-yugabyte-reader.dll"]