import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    lib: {
      entry: 'browser/main.ts',
      name: 'MyBundle',
      fileName: () => 'bundle.js',
      formats: ['es'],
    },
    outDir: 'public/js',
    emptyOutDir: false,
    watch: {},
  }
});