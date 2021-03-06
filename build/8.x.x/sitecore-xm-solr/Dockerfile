# escape=`
ARG BUILD_IMAGE
ARG BASE_IMAGE

FROM $BUILD_IMAGE as builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install JAVA
ENV JAVA_HOME C:\\ojdkbuild
ENV JAVA_VERSION 8u161
ENV JAVA_OJDKBUILD_VERSION 1.8.0.161-1
ENV JAVA_OJDKBUILD_ZIP java-1.8.0-openjdk-1.8.0.161-1.b14.ojdkbuild.windows.x86_64.zip

RUN setx /M PATH ('{0}\bin;{1}' -f $env:JAVA_HOME, $env:PATH); `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    $url = ('https://github.com/ojdkbuild/ojdkbuild/releases/download/{0}/{1}' -f $env:JAVA_OJDKBUILD_VERSION, $env:JAVA_OJDKBUILD_ZIP); `
    Invoke-WebRequest -Uri $url -OutFile 'ojdkbuild.zip'; `
    Expand-Archive ojdkbuild.zip -DestinationPath C:\; `
    Move-Item -Path ('C:\{0}' -f ($env:JAVA_OJDKBUILD_ZIP -Replace '.zip$', '')) -Destination $env:JAVA_HOME; `
    Remove-Item ojdkbuild.zip -Force;
    
# Install Solr
ARG SOLR_VERSION=6.6.3
RUN Invoke-WebRequest -Uri ('http://archive.apache.org/dist/lucene/solr/{0}/solr-{0}.zip' -f $env:SOLR_VERSION) -OutFile /solr.zip; `
    Expand-Archive -Path /solr.zip -DestinationPath /temp; `
    Move-Item -Path "C:/temp/solr-*" -Destination c:\solr;

# Install Adding Sitecore XML Schema for Solr
RUN Remove-Item  'c:/solr/server/solr/configsets/basic_configs/conf/solrconfig.xml' -Force;
RUN Remove-Item  'c:/solr/server/solr/configsets/basic_configs/conf/managed-schema' -Force;
COPY solrconfig.xml 'c:/solr/server/solr/configsets/basic_configs/conf'
COPY schema.xml 'c:/solr/server/solr/configsets/basic_configs/conf'

ARG CORE_NAMES='sitecore_core_index,sitecore_master_index,sitecore_web_index'

# Copy the clean cores for later use
RUN New-Item -Path 'C:\\clean' -ItemType Directory | Out-Null; `
    Copy-Item -Path 'C:\\solr\\server\\solr\\*' -Destination 'C:\\clean' -Force -Recurse; `
    $env:CORE_NAMES -split ',' | ForEach-Object { `
        $name = $_.Trim(); `
        Copy-Item -Path 'C:\\clean\\configsets\\basic_configs\\conf' -Destination ('C:\\clean\\{0}\\conf' -f $name) -Recurse -Force; `
        New-Item -Path ('C:\\clean\\{0}\\core.properties' -f $name) -ItemType File | Out-Null; `
        New-Item -Path ('C:\\clean\\{0}\\data' -f $name) -ItemType Directory | Out-Null; `
    }; `
    Remove-Item -Path 'C:\\clean\\README.txt'; `
    Remove-Item -Path 'C:\\clean\\configsets' -Recurse;

FROM $BASE_IMAGE

USER ContainerAdministrator

COPY --from=builder /solr /solr
COPY --from=builder /clean /clean
COPY --from=builder /windows/system32/find.exe /windows/system32/

RUN MKDIR c:\\data

ENV SOLR_HOME=c:/data

EXPOSE 8983

COPY Boot.cmd .

CMD Boot.cmd c:\\solr 8983 c:\\clean c:\\data
