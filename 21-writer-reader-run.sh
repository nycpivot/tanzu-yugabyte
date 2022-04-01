kubectl get svc -A | grep yb-tserver-service

read -p "External Url: " external_url

cd tanzu-yugabyte/src/tanzu-yugabyte-dotnet

rm Dockerfile-writer
cat <<EOF | tee Dockerfile-writer
FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["tanzu-yugabyte-writer/tanzu-yugabyte-writer.csproj", "tanzu-yugabyte-writer/"]
RUN dotnet restore "tanzu-yugabyte-writer/tanzu-yugabyte-writer.csproj"
COPY . .
WORKDIR "/src/tanzu-yugabyte-writer"
RUN dotnet build "tanzu-yugabyte-writer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "tanzu-yugabyte-writer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "tanzu-yugabyte-writer.dll", "${external_url}", "yugabyte", "yugabyte"]
EOF

rm Dockerfile-reader
cat <<EOF | tee Dockerfile-reader
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
ENTRYPOINT ["dotnet", "tanzu-yugabyte-reader.dll", "${external_url}", "yugabyte", "yugabyte"]
EOF

docker build -t tanzu-yugabyte-writer -f Dockerfile-writer
docker build -t tanzu-yugabyte-reader -f Dockerfile-reader

docker run -it tanzu-yugabyte-writer