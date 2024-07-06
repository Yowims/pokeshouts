const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

var checked = checkIfCsvParserIsInstalled();

if (checked) {

    const globalNodeModulesPath = execSync('npm root -g').toString().trim();

    const csv = require(path.join(globalNodeModulesPath, 'csv-parser'));

    const inputFilePath = __dirname + "\\lang.csv";
    const outputDir = path.resolve(__dirname, '../../l10n');

    const translations = {
        FR: { "@@locale": "fr" },
        EN: { "@@locale": "en" }
    };

    fs.createReadStream(inputFilePath, "utf-8")
        .pipe(csv({ separator: ";" }))
        .on('data', (row) => {
            const key = row['Key'];
            translations.FR[key] = row['FR'];
            translations.EN[key] = row['EN'];
        })
        .on('end', () => {
            if (!fs.existsSync(outputDir)) {
                fs.mkdirSync(outputDir, { recursive: true });
            }

            fs.writeFileSync(path.join(outputDir, 'app_fr.arb'), JSON.stringify(translations.FR, null, 2).replace("\r", "").replace("\n", ""));
            fs.writeFileSync(path.join(outputDir, 'app_en.arb'), JSON.stringify(translations.EN, null, 2).replace("\r", "").replace("\n", ""));

            console.log('Translation files have been generated at "' + outputDir + '". Now run \'flutter pub get\' to generate the internationalization file.');
        });

} else {
    // If not, we throw an error to tell the user the package is missing.
    console.log('csv-parser is not installed. Use the following command : "npm i -g -y csv-parser" to install it, and then rerun the script.');
    process.exit(1);
}

function checkIfCsvParserIsInstalled() {
    try {
        // Run `npm ls` command and check for the presence of csv-parser
        const result = execSync(`npm ls -g --depth=0`, { stdio: 'pipe' }).toString();
        return result.includes('csv-parser');
    } catch (error) {
        return false;
    }
}



