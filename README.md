# Sitecore 8.2.7 in Docker

## Building Images
1. Download the Sitecore 8.2.7 package: https://dev.sitecore.net/~/media/EB88CA1EBDD645CA822FD067BEB74E4F.ashx
1. Download an appropriate SPE version: https://github.com/SitecorePowerShell/Console/releases/download/6.2/Sitecore.PowerShell.Extensions-6.2.scwdp.zip
1. Place both files in the sitecore-assets folder: `{repoRoot}\build\8.2.7\sitecore-assets`
1. Open a PowerShell window
1. Run `build.bat`

This should build 6 images:
- sitecore-assets
- sitecore-xm-cm
- sitecore-xm-solr
- sitecore-xm-sqldev
- sitecore-xm-spe-cm
- sitecore-xm-spe-sqldev

## Running Images
1. Update the `.env` with an appropriate location for your license file in the `LICENSE_LOCATION` variable
1. From the repo root, run `docker-compose up -d`
1. Navigate to http://cm/sitecore

Special thanks to [Michael West](https://github.com/michaellwest) for providing the meat of the build content for these images!