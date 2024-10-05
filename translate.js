#!/usr/bin/env node

import fs from 'fs'
import csv from 'csv-parser';
import * as XLSX from 'xlsx';
import * as R from 'ramda';
// import { withDb, dbTranslate } from './lib/translate-with-cache'
import { withDb, dbTranslate } from './lib/translate-doc-with-cache.js'
import { splitTextIntoChunks } from './lib/splitTextIntoChunks.js'
import yargs from 'yargs/yargs'
import { hideBin } from 'yargs/helpers'
import crypto from 'crypto';

function hashInput(input) {
  return crypto.createHash('sha256').update(input).digest('hex');
}

const argv = yargs(hideBin(process.argv))
  // .command('', 'make a get HTTP request', function (yargs, helpOrVersionSet) {
  //   return yargs.option('url', {
  //     alias: 'u',
  //     default: 'http://yargs.js.org/'
  //   })
  // })
  .boolean('makeods')
  .default('makeods', false)
  .describe('makeods', 'Make translate.ods')
  .option('fileoutput', {
    alias: 'fo',
    describe: '--file and --output separated with | character, incompative with --text, --file, --output',
    type: 'string',
  })
  .option('output', {
    alias: 'o',
    describe: 'Path to the output file where translated text will be saved',
    type: 'string',
  })
  .option('file', {
    alias: 'f',
    describe: 'Path to the input file containing text to translate',
    type: 'string',
  })
  .option('output', {
    alias: 'o',
    describe: 'Path to the output file where translated text will be saved',
    type: 'string',
  })
  .option('text', {
    alias: 't',
    describe: 'Text to translate (ignored if --file is provided)',
    type: 'string',
  })
  .option('from', {
    alias: 'F',
    describe: 'From language (default: auto)',
    type: 'string',
    default: 'auto',
  })
  .option('to', {
    alias: 'T',
    describe: 'To language (default: en)',
    type: 'string',
    default: 'en',
  })
  .check((argv) => {
    if (argv.fileoutput) {
      if (argv.file || argv.output || argv.text) {
        throw new Error('--fileoutput is incompatible with --file, --output, or --text.');
      }
    } else {
      if (!argv.text && !argv.file) {
        throw new Error('You must provide either --text or --file.');
      }
    }
    return true;
  })
  .help()
  .argv;

const MAX_CHUNK_SIZE = 5000; // Maximum chunk size in characters

async function translateInChunksSplitByNewline({ db, inputText, from, to }) {
  // console.log(chunks)
  // console.log(chunks.map(x => x.length))

  const translatedChunks = [];

  for (const chunk of chunks) {
    const text = await dbTranslate({
      db,
      input: chunk,
      from,
      to,
    })
    translatedChunks.push(text);
  }

  // Merge the translated chunks back into a single string
  const translatedText = translatedChunks.join('\n');

  return translatedText
}

function writeOutput({ translatedText, maybeOutputPath }) {
  if (maybeOutputPath) {
    fs.writeFileSync(maybeOutputPath, translatedText, 'utf8');
    console.log(`Translated text saved to ${maybeOutputPath}`);
  } else {
    console.log(`Translated Text: ${translatedText}`);
  }
}

function writeChunksToExcel(chunksAndHash, outputFile) {
  // const worksheet = XLSX.utils.aoa_to_sheet(chunksAndHash.map(({ hash, chunk }) => [hash, chunk]));
  const worksheet = XLSX.utils.aoa_to_sheet(chunksAndHash.map(x => [x]))
  const workbook = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Chunks')
  XLSX.writeFile(workbook, outputFile)
}

async function parseCSV(filePath) {
  const data = {};
  return new Promise((resolve, reject) => {
    fs.createReadStream(filePath)
      .pipe(csv(['text', 'translation']))
      .on('data', (row) => {
        const { text, translation } = row
        data[text] = translation
      })
      .on('end', () => resolve(data))
      .on('error', reject);
  });
}

const makeods = true // if true then THIS IS STEP ONE

async function main(db) {
  try {
    if (argv.fileoutput) {
      // Handle fileoutput case
      const toTranslateList = fs.readFileSync(argv.fileoutput, 'utf8')
        .trim()
        .split('\n')
        .map(line => line.trim())
        .filter(line => line.length > 0)
        .map(line => {
          const [inputFile, outputFile] = line.split('|').map(x => x.trim()).filter(x => x.length > 0);
          if (!inputFile || !outputFile) { throw new Error(`Invalid input or output file pair: ${line}`) }
          return { inputFile, outputFile };
        });

      if (argv.makeods) {
        let allSentences = []
        for (const { inputFile, outputFile } of toTranslateList) {
          const inputText = fs.readFileSync(inputFile, 'utf8');
          const sentences = inputText.split('\n')
          allSentences.push(...R.uniq(sentences.map(x => x.trim()).filter(x => x)))
        }
        allSentences = R.uniq(allSentences).sort()
        // console.log(allSentences)
        writeChunksToExcel(allSentences, '/home/srghma/projects/latex-to-text/translate.xlsx')

        // libreoffice --headless --convert-to ods /home/srghma/projects/latex-to-text/translate.xlsx
      } else {
        const csvDataHashToTranslation = await parseCSV('/home/srghma/projects/latex-to-text/translate - Chunks.csv');
        // console.log(csvDataHashToTranslation)
        for (const { inputFile, outputFile } of toTranslateList) {
          const inputText = fs.readFileSync(inputFile, 'utf8');
          const sentences = inputText.split('\n')
          const translatedText = sentences.map(sentence => {
            if (!sentence.trim()) {
              return { sentence, translation: sentence }
            }
            let translation = csvDataHashToTranslation[sentence.trim()]
            if (!translation) {
              console.log(sentence)
              throw new Error('no sentence')
            }
            // €20 € -> €20€
            translation = translation.replace(/€\d+\s€/g, (match) => match.replace(/\s/, ''));
            return translation
          }).join('\n')
          writeOutput({ translatedText, maybeOutputPath: outputFile })
        }
      }

      // const translatedText = await dbTranslate({
      //   db,
      //   filepath: inputFile,
      //   from: argv.from,
      //   to: argv.to,
      // })
      // writeOutput({ translatedText, maybeOutputPath: outputFile })
      // const translatedText = await translateInChunksSplitByNewline({
      //   db,
      //   inputText,
      //   from,
      //   to,
      // })
    } else {
      let inputText;
      if (argv.file) {
        inputText = fs.readFileSync(argv.file, 'utf8');
      } else {
        inputText = argv.text;
      }

      const translatedText = await translateInChunksSplitByNewline({
        db,
        inputText,
        from,
        to,
      })
      writeOutput({ translatedText, maybeOutputPath: argv.output })
    }
  } catch (error) {
    console.error('Error translating text:', error);
  }
}

withDb(main);
