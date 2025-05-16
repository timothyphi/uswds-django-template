import { build, context } from "esbuild";

const isWatchMode = process.argv.includes("--watch");

async function bundle() {
  try {
    const config = {
      entryPoints: ["browser/main.ts"],
      outfile: "public/js/bundle.js",
      bundle: true,
      minify: true,
      sourcemap: true,
      platform: "browser" as const,
      target: "esnext",
    };

    if (isWatchMode) {
      const ctx = await context(config);
      await ctx.watch();
      console.log("Watching for file changes...");
    } else {
      await build(config);
      console.log("Build successful!");
    }
  } catch (error) {
    console.error("Build failed:", error);
    process.exit(1);
  }
}

bundle();
