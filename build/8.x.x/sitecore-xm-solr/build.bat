docker build . -t sitecore-xm-solr:8.2.7-nanoserver-1809 --build-arg BUILD_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2019 --build-arg BASE_IMAGE=sitecore-openjdk:8-nanoserver-1809