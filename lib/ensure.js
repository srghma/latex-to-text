import fs from 'fs';

export function ensureFileExists(filePath) {
  try {
    fs.accessSync(filePath, fs.constants.F_OK);
  } catch (err) {
    fs.writeFileSync(filePath, '', 'utf8'); // Create an empty file
  }
}

// Ensure a directory exists, creating it if it doesn't
export function ensureDirectoryExists(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}
