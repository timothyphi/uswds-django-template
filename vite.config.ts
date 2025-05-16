import { defineConfig } from 'vite';

export default defineConfig({
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