import { defineConfig } from 'vite';

export default defineConfig({
  publicDir: false,
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