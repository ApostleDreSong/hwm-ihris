#!/bin/bash

# Initialize default values
port=""
fhirPort=""
elasticPort=""
kibanaPort=""
redisPort=""
state=""

# Define a flag to check if any required argument is missing
missing_arg=false

# Parse command-line options
while getopts ":p:f:e:k:r:s:" opt; do
  case $opt in
    p)
      port="$OPTARG"
      ;;
    f)
      fhirPort="$OPTARG"
      ;;
    e)
      elasticPort="$OPTARG"
      ;;
    k)
      kibanaPort="$OPTARG"
      ;;
    r)
      redisPort="$OPTARG"
      ;;
    s)
      state="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if any required argument is missing
if [ -z "$port" ]; then
  echo "Error: Missing the 'port' argument." >&2
  missing_arg=true
fi

if [ -z "$fhirPort" ]; then
  echo "Error: Missing the 'fhirPort' argument." >&2
  missing_arg=true
fi

if [ -z "$elasticPort" ]; then
  echo "Error: Missing the 'elasticPort' argument." >&2
  missing_arg=true
fi

if [ -z "$kibanaPort" ]; then
  echo "Error: Missing the 'kibanaPort' argument." >&2
  missing_arg=true
fi

if [ -z "$redisPort" ]; then
  echo "Error: Missing the 'redisPort' argument." >&2
  missing_arg=true
fi

if [ -z "$state" ]; then
  echo "Error: Missing the 'state' argument." >&2
  missing_arg=true
fi

# Exit the script if any required argument is missing
if [ "$missing_arg" = true ]; then
  exit 1
fi


 [[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

  # nvm use '16.17.0'
  nvm use '18.0.0'
#   state='fct'

  script_directory="$(dirname "$(cd "$(dirname "$0")" && pwd -P)")"
  backend_path="$script_directory/ihris/ihris-backend"
  site_path="$script_directory/ihris/ihris-backend/$state"
#   port=3002
#   fhirPort=8083
#   elasticPort=9202
#   kibanaPort=5603
#   redisPort=6382
  fhirUrl="http://localhost:$fhirPort/fhir"
  kibanaUrl="http://localhost:$kibanaPort"
  elasticUrl="http://localhost:$elasticPort"
  redisUrl="redis://localhost:$redisPort"


  cp -f $script_directory/baseConfig.json $script_directory/ihris/ihris-backend/$state/config/
  cp -f $script_directory/locales/$state/en.json $script_directory/ihris/ihris-backend/$state/locales/
  cp -f $script_directory/terminologies/$state/Terminologies.fsh $script_directory/ihris/ihris-backend/$state/ig/input/fsh/core/
  cp -f $script_directory/parameters/$state/IhrisParameters.fsh $script_directory/ihris/ihris-backend/$state/ig/input/fsh/

  pmConf="$site_path/ecosystem.config.js"
  touch $pmConf

  # Create a template for the JavaScript object
  js_template="module.exports = {
    apps: [
      {
        name: %state%,
        script: './bin/www',
        instances: 1,
        exec_mode: 'fork',
        env: {
          NODE_ENV: 'production',
          PORT: %port%,
          fhirPort: %fhirPort%
        },
      },
    ],
  };"

  # # Replace the %PORT% placeholder with the variable's value
  js_template=$(sed -e "s/%state%/\"$state\"/g" -e "s/%port%/$port/g" -e "s/%fhirPort%/$fhirPort/g" <<< "$js_template")

  # # Use echo to write the JavaScript object to the file
  echo "$js_template" > $pmConf

  cd $backend_path
  echo "entering $backend_path"
  npm install

  cd $site_path
  echo "entering $site_path"
  npm install

  cd $site_path/ig
  echo "entering $site_path/ig"
  sushi -s .

  cd $script_directory/ihris/tools
  echo "entering $script_directory/ihris/tools"
  npm install
  node signConfig.js --key rsa_1024_priv.pem --config $site_path/ig/fsh-generated/resources/Parameters-ihris-config.json > $site_path/ig/fsh-generated/resources/Parameters-ihris-config-tmp.json && mv $site_path/ig/fsh-generated/resources/Parameters-ihris-config-tmp.json $site_path/ig/fsh-generated/resources/Parameters-ihris-config.json
  node load.js --server http://localhost:$fhirPort/fhir $site_path/ig/fsh-generated/resources/Parameters-ihris-config.json
  node load.js --server http://localhost:$fhirPort/fhir $script_directory/bundles/createCountry.json
  node load.js --server http://localhost:$fhirPort/fhir $script_directory/bundles/createState.json
  node load.js --server http://localhost:$fhirPort/fhir $script_directory/bundles/createSenDistrict.json
  node load.js --server http://localhost:$fhirPort/fhir $script_directory/bundles/createLga.json
if [ -f "$script_directory/bundles/$state/createWard.json" ]; then
  node load.js --server http://localhost:$fhirPort/fhir "$script_directory/bundles/$state/createWard.json"
else
  echo "File $script_directory/bundles/$state/createWard.json not found."
fi

if [ -f "$script_directory/bundles/$state/createFacility.json" ]; then
  node load.js --server http://localhost:$fhirPort/fhir "$script_directory/bundles/$state/createFacility.json"
else
  echo "File $script_directory/bundles/$state/createFacility.json not found."
fi

  baseConfig_file="$script_directory/ihris/ihris-backend/$state/config/baseConfig.json"

 if [ -f "$baseConfig_file" ]; then
  sed -i.bak "s|pathtosite|$site_path|g" "$baseConfig_file"
  sed -i.bak "s|pathtobackend|$backend_path|g" "$baseConfig_file"
  sed -i.bak "s|pathtofhir|$fhirUrl|g" "$baseConfig_file"
  sed -i.bak "s|pathtokibana|$kibanaUrl|g" "$baseConfig_file"
  sed -i.bak "s|pathtoelastic|$elasticUrl|g" "$baseConfig_file"
  sed -i.bak "s|pathtoredis|$redisUrl|g" "$baseConfig_file"

  echo "Path in baseConfig.json for $subdomain has been updated."

  # Remove the backup files with the .bak extension
  rm "$baseConfig_file.bak"
else
  echo "baseConfig.json file for $subdomain not found."
fi
  cd $site_path
  rm -f ./ig/fsh-generated/resources/Bundle-Country.json 
  # PM2_LOG_DATE_FORMAT='YYYY-MM-DD HH:mm:ss' pm2 start ./bin/www --name "$subdomain" -- --NODE_ENV production -- -PORT "$port"
  echo "entering $site_path"
  pm2 start ecosystem.config.js

  echo "Starting $subdomain on port $port..."
  # Print the parsed arguments
echo "fhirPort: $fhirPort"
echo "elasticPort: $elasticPort"
echo "kibanaPort: $kibanaPort"
echo "redisPort: $redisPort"
echo "state: $state"
