# ---- Base Image ----
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine as base
WORKDIR /usr/src/app
RUN mkdir -p RulesEngine AppInspector
#
# ---- Test & Build ----
# run linters, setup and tests
FROM base AS build
RUN apk add --update --no-cache git && \
git clone https://github.com/microsoft/ApplicationInspector.git source && \
cd source && dotnet build -c Release

# # ---- Release ----
FROM base AS release
COPY --from=build /usr/src/app/source/RulesEngine/bin/Release/netcoreapp3.0 ./RulesEngine
COPY --from=build /usr/src/app/source/AppInspector/bin/Release/netcoreapp3.0 ./AppInspector
COPY --from=build /usr/src/app/source/AppInspector/bin/Release/*.nupkg .

