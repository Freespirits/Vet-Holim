let cachedHandler: ((req: any, res: any) => Promise<void> | void) | null = null;

async function loadHandler() {
  if (cachedHandler) return cachedHandler;
  try {
    const mod = await import('../server/dist/vercel.js');
    cachedHandler = mod.default;
    return cachedHandler;
  } catch (err) {
    throw new Error(
      `Vercel handler not built. Run "npm install --prefix server && npm run build --prefix server" to generate server/dist. Original error: ${
        (err as Error).message
      }`
    );
  }
}

export default async function handler(req: any, res: any) {
  const loaded = await loadHandler();
  return loaded(req, res);
}
