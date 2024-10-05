import crypto from 'crypto';
import { translate } from '@vitalets/google-translate-api';
import fs from 'fs';
import { JsonlDB } from '@alcalzone/jsonl-db';
import { HttpProxyAgent } from 'http-proxy-agent';
import { translateText, translateDocs } from 'puppeteer-google-translate';
import * as R from 'ramda';
import { ensureFileExists, ensureDirectoryExists } from './ensure.js'

// Read proxies from file
function readProxies(filePath) {
  const data = fs.readFileSync(filePath, 'utf8');
  return data
    .split('\n')
    .filter(line => !line.startsWith('Free proxies from free-proxy-list.net') && !line.startsWith('Updated at'))
    .map(proxy => proxy.trim())
    .filter(proxy => proxy.length > 0);  // Remove any empty lines
}

// Ensure the cache file and directories exist
const homeDir = process.env.HOME;
const cacheDir = `${homeDir}/projects/latex-to-text`;
const cachePath = `${cacheDir}/google-translate-with-cache.json`;
const proxiesPath = `${cacheDir}/proxies.txt`;
const badProxiesDbPath = `${cacheDir}/bad_proxies.txt`;

// Ensure directories and files exist
ensureDirectoryExists(cacheDir);
ensureFileExists(cachePath);
ensureFileExists(proxiesPath);
ensureFileExists(badProxiesDbPath);

// Read proxies and bad proxies
const allProxies = readProxies(proxiesPath);
const badProxies = R.uniq(fs.readFileSync(badProxiesDbPath, 'utf8').split('\n').map(proxy => proxy.trim()).filter(proxy => proxy.length > 0))
let proxies = [null, ...R.difference(allProxies, badProxies)]

function getProxy() {
  if (proxies.length === 0) { throw new Error('All proxies failed or no text returned.') }
  return proxies[0]
}

function invalidateProxy(proxy) {
  if (proxy) { fs.appendFileSync(badProxiesDbPath, `${proxy}\n`); }
  proxies = R.difference(proxies, [proxy])
}

// Generate a random User-Agent string
function randomUserAgent() {
  const userAgents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0) Gecko/20100101 Firefox/89.0',
    'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.4 Mobile/15E148 Safari/604.1'
  ];
  return userAgents[Math.floor(Math.random() * userAgents.length)];
}

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

function hashInput(input) {
  return crypto.createHash('sha256').update(input).digest('hex');
}

async function translateWithProxy(input, from, to, proxies) {
  const maybeProxy = getProxy()

  if (!maybeProxy) {
    try {
      const response = await translate(input, {
        from,
        to,
      });
      console.log(response)
      return response.text
    } catch (error) {
      console.error(error)
      if (error.name === 'TooManyRequestsError') {
        console.warn(`Proxy ${maybeProxy} encountered rate limiting. Marking as bad proxy. ${error}`);
        invalidateProxy(maybeProxy)
        return
      } else {
        throw error;
      }
    }
  }

  const agent = new HttpProxyAgent(`http://${maybeProxy}`);

  try {
    console.log(`trying ${input}`)
    const response = await translate(input, {
      from,
      to,
      fetchOptions: {
        headers: {
          'User-Agent': randomUserAgent(),
        },
        agent
      },
    });
    console.log(response)
    return response.text
  } catch (error) {
    console.error(error)
    if (error.name === 'TooManyRequestsError' || error.name === 'ProxyAuthenticationRequiredError' || error.name === 'BadGatewayError' || error.name === 'FetchError' || error.name === 'ServiceUnavailableError') {
      console.warn(`Proxy ${maybeProxy} encountered rate limiting. Marking as bad proxy. ${error}`);
      invalidateProxy(maybeProxy)
    } else {
      throw error;
    }
  }
}

export async function dbTranslate({ db, input, from, to }) {
  const inputHash = hashInput(input.trim());
  const cacheKey = [from, to, inputHash].filter(x => x).join('|');

  // console.log(db)
  if (await db.has(cacheKey)) {
    return await db.get(cacheKey);
  }

  // <h3 class="oBOnKe">Translation result</h3>
  // const translatedText = await translateText(input, { from, to, timeout: 11110000, headless: false })

  const translatedText = await translateDocs(filepath, { from, to, timeout: 11110000, headless: false })

  // const translatedText = await translateWithProxy(input, from, to, proxies);

  await db.set(cacheKey, translatedText);

  return translatedText;
}
