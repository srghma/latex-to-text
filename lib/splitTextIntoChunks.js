export function splitTextIntoChunks(text, maxSize) {
  const chunks = [];
  let currentChunk = '';
  const lines = text.split('\n');
  for (const line of lines) {
    if ((currentChunk.length + line.length + 1) > maxSize) {
      chunks.push(currentChunk);
      currentChunk = line;
    } else {
      currentChunk += (currentChunk ? '\n' : '') + line;
    }
  }
  if (currentChunk) {
    chunks.push(currentChunk);
  }
  return chunks;
}
