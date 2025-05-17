import { defineConfig } from 'vite';

export default defineConfig({

  /* We don't want vite to serve static files in development.*/
  publicDir: false,
  /* if so, it'll copy the files from `./public` to `oudDir` (below) */

  build: {
    lib: {
      entry: 'browser/main.ts',
      name: 'BrowserBundle',
      fileName: () => 'bundle.js',
      formats: ['es'],
    },
    outDir: 'public/js',
    emptyOutDir: false,
    watch: {},
  }
});