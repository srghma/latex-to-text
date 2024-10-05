import crypto from 'crypto';
import { translate } from '@vitalets/google-translate-api';
import fs from 'fs';
import { JsonlDB } from '@alcalzone/jsonl-db';
import { HttpProxyAgent } from 'http-proxy-agent';
import { translateText, translateDocs } from 'puppeteer-google-translate';
import { ensureFileExists, ensureDirectoryExists } from './ensure.js'
import * as R from 'ramda';

// Ensure the cache file and directories exist
const homeDir = process.env.HOME;
const cacheDir = `${homeDir}/projects/latex-to-text`;
const cachePath = `${cacheDir}/google-translate-docs-with-cache.json`;

// Ensure directories and files exist
ensureDirectoryExists(cacheDir);
ensureFileExists(cachePath);

export async function withDb(callback) {
  const db = new JsonlDB(cachePath);
  await db.open();
  try {
    await callback(db);
  } finally {
    console.log('closing db')
    await db.close();
  }
}

export async function dbTranslate({ db, filepath, from, to }) {
  const cacheKey = [from, to, filepath].filter(x => x).join('|');

  if (await db.has(cacheKey)) {
    return await db.get(cacheKey);
  }

  const translatedText = await translateDocs(filepath, { from, to, timeout: 11110000, headless: false })

  await db.set(cacheKey, translatedText);

  return translatedText;
}
