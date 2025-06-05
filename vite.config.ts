import { defineConfig } from "vite";

export default defineConfig({
  publicDir: false,

  build: {
    outDir: "public/js",
    emptyOutDir: false,
    sourcemap: true,
    minify: "esbuild",

    rollupOptions: {
      input: "browser/main.ts",
      output: {
        entryFileNames: "bundle.js",
      },
    },
  },
});