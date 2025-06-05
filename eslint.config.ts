import globals from "globals";
import pluginJs from "@eslint/js";
import pluginTsEsLint from "typescript-eslint";
import pluginSecurity from "eslint-plugin-security";
import pluginImport from "eslint-plugin-import";
import stylistic from "@stylistic/eslint-plugin";
import gitignore from "eslint-config-flat-gitignore";
import { Linter } from "eslint";

const config: Linter.Config[] = [
  { files: ["**/*.ts"] },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  pluginSecurity.configs.recommended,
  ...(pluginTsEsLint.configs.recommended as Linter.Config[]),
  gitignore(),
  stylistic.configs.customize({
    indent: 2,
    quotes: "double",
    semi: true,
    commaDangle: "always-multiline",
  }),
  {
    plugins: {
      import: pluginImport,
    },
    rules: {
      "import/no-cycle": ["error", { maxDepth: Infinity }],
    },
    settings: {
      "import/resolver": {
        typescript: {
          alwaysTryTypes: true,
          project: "./tsconfig.json",
        },
      },
    },
  },
];

export default config;
