#!/bin/bash

echo What is the name of the project name?
read project
echo What is the name of the Orgonization?
read org
url=https://$org.github.io
baseUrl=/$project/
repo=https://github.com/$org/$project.git

#echo Cloning Respository
#git clone $repo

echo Creating Docusaurus site
npx create-docusaurus@latest website classic

echo Cleaning up file structure
rm -r ./website/blog

rm -r ./website/docs

rm -r ./website/static/img/*

echo Copying assests
cp  -r ./assets/docs ./website/docs

cp ./assets/custom.css ./website/src/css/custom.css

cp ./assets/docusaurus.config.js ./website/docusaurus.config.js

cp -r ./assets/img ./website/static/img

rm ./website/src/components/HompageFeatures/index.js

rm ./website/src/pages/index.js

mkdir -p .github/workflows

cp ./assets/deployment.yml ./.github/workflows

#echo Splitting the README file
#python3 mdsplit.py README.md --max-level 2 --force --verbose -o website/docs

cat > website/variables.js <<EOF
const Info = {
    repo: '$repo',
    project: '$project',
    org: '$org',
    url: '$url',
    baseUrl: '$baseUrl'
};
module.exports = { Info };
EOF

cd website

echo Installing extra packages
npm install --save carbon-components @cmfcmf/docusaurus-search-local @docusaurus/theme-mermaid

yarn install

echo Building local site for testing
yarn build
npm run serve